% Continuum Mechanics 2 2/2020 (Christopher Adnel)

%% Cleanning Up Previous Results

clear all
close all
clc

%% User Input & Settings

filename = "hollowed_square.txt";   % Boundary Geometry File Input
inner_domain_resolution = 250;  % Inner Domain Solution Resolution
Mu = 4e6;                       % Material Property Mu
T = 134400;                       % Torsion Acting on The Domain

warning('off','all');           % Surpress Warnings for MATLAB Built-in Functions

%% Opening Boundary Geometry File

fprintf("Reading Boundary Geometry Input File (%s)\n",filename);
[n,xbi,xbe,ybi,ybe,xm,ym,lm,nx,ny,C] = boundaryfileopen(filename);

%% Boundary Element Method

% Calculating Inner Boundaries Area
fprintf("Calculating Inner Boundaries Area ...\n")
Area_Ci = zeros(max(C)-1,1);
for i = 1 : max(C)-1
    xmi = [];
    ymi = [];
    xbii = [];
    xbei = [];
    ybii = [];
    ybei = [];
    ni = 0;
    counter = 1;
    for j = 1:n
        if C(j) == i+1
            xmi(counter,1) = xm(j);
            ymi(counter,1) = ym(j);
            xbii(counter,1) = xbi(j);
            xbei(counter,1) = xbe(j);
            ybii(counter,1) = ybi(j);
            ybei(counter,1) = ybe(j);
            counter = counter + 1;
        end
    end
    ni = counter-1;
    Area_Ci(i) = calcArea(xmi,ymi,xbii,xbei,ybii,ybei,ni);
    fprintf("Inner Boundary C%i Detected, Area: %f\n",i,Area_Ci(i));
end
if max(C) == 1
    fprintf("No Inner Boundaries Detected\n")
end

% Constructing BEM Formulation Matrix
fprintf("Constructing BEM Formulation Matrix (%i Elements)...",n);
matrixSize = n + max(C) - 1;

A = zeros(matrixSize,matrixSize);
b = zeros(matrixSize,1);
source = 1.0;

for i = 1:n 
    for j = 1:n
        if (i == j)
             F = lm(j)/(2.0*pi)*(log(lm(j)/2.0) - 1.0);
             G2 = 0.0;
        else
            F = calcF(xm(i),ym(i),xbi(j),ybi(j),nx(j),ny(j),lm(j));
            G2 = calcG2(xm(i),ym(i),xbi(j),ybi(j),nx(j),ny(j),lm(j));
        end
        A(i,j) = -F;
        b(i) = b(i) - G2*(source);
    end
end
if max(C) > 1
    for i = 1:n
        if C(i) > 1
            A(i,n+C(i)-1) = A(i,n+C(i)-1) - 0.5;
        end
        for j = 1:n  
            if C(j) > 1
                if i == j
                    G = 0.0;
                else
                    G = calcG(xm(i),ym(i),xbi(j),ybi(j),nx(j),ny(j),lm(j));
                end
                A(i,n+C(j)-1) = A(i,n+C(j)-1) + G;
            end
        end
    end
    for i = n+1:matrixSize
        for j = 1:n
           if C(j) == (i - n) + 1
               A(i,j) = A(i,j) + lm(j);
           end
        end
        b(i) = b(i) + 2*Area_Ci(i - n);
    end
end
fprintf("Done\n")

fprintf("Solving BEM Formulation Matrix ...")
SolveResult = A\b; % Solving for dU/dn values at boundary
fprintf("Done\n")

ki_raw = [0];
for i = n+1:matrixSize
    ki_raw = [ki_raw SolveResult(i)];
end

if max(C) > 1
    fprintf("Inner Boundary K Value:\n")
    for i = 2:length(ki_raw)
        fprintf("K%i Value: %f\n",i-1,ki_raw(i));
    end
end

q = zeros(n,1);
ki = zeros(n,1);

for i = 1:n
    q(i) = SolveResult(i);
    ki(i) = ki_raw(C(i));
end

%% Solution Inside the Domain

% Ray Casting to create grid inside the domain
N = inner_domain_resolution; % Inner Solution Resolution
[x,y,h] = raycasting(xm,ym,xbi,xbe,ybi,ybe,N); 
n_inner = length(x);

% Calculating Prandtl Stress Function Inside the Domain
fprintf("Calculating Inner Domain Solution (%i Nodes) ...",n_inner)
u = zeros(n_inner,1);
tic
parfor i = 1:n_inner
    for k = 1:n
        F = calcF(x(i),y(i),xbi(k),ybi(k),nx(k),ny(k),lm(k));
        G = calcG(x(i),y(i),xbi(k),ybi(k),nx(k),ny(k),lm(k));
        G2 = calcG2(x(i),y(i),xbi(k),ybi(k),nx(k),ny(k),lm(k));
        u(i) = u(i) - q(k)*F + G2*(source) + G*ki(k);
    end 
end
fprintf("Done, Elapsed Time: %f ms\n",toc*1000)

%% Calculating Derivatives using Corrected SPH (Randles Libersky)

fprintf("Solution Processing ...")
J = 0;
for i = 1:length(u)
    J = J + 2*u(i)*h^2;
end 
for i = 1:length(Area_Ci)
    J =J + 2*ki_raw(i+1)*Area_Ci(i);
end
Tao = T/(Mu*J);

% Neighbour search
R = [x;y]';
neighbour = rangesearch(R,R,2.01*h);
for i = 1:length(x)
    dim = size(neighbour{i});
    neighbourlen(i) = dim(2);
end

% Computing numerical spatial derivative using CSPH
Sdf = SPHDerivative(x,y,neighbour,neighbourlen,h,u);

u_x = Sdf(:,1); % du/dx
u_y = Sdf(:,2); % du/dy

% Computing Stress
Syz = -u_x.*(Mu*Tao);
Sxz = u_y.*(Mu*Tao);
StressRes = zeros(length(x),1);
for i = 1:length(x)
    StressRes(i) = sqrt(Syz(i)^2 + Sxz(i)^2);
end
fprintf("Done\n")

%% Plotting the results

plotter(x,y,xbi,xbe,ybi,ybe,h,u,"Prandtl Stress Function")
plotter(x,y,xbi,xbe,ybi,ybe,h,Sxz,"Shear XZ Stress")
plotter(x,y,xbi,xbe,ybi,ybe,h,Syz,"Shear YZ Stress")
plotter(x,y,xbi,xbe,ybi,ybe,h,StressRes,"Resultant Stress")


