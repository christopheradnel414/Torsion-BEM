function Sdf = SPHDerivative(x,y,neighbour,neighbourlen,h,u)
    
    [W,dWdx,dWdy] = KernelCSpline(x,y,neighbour,neighbourlen,h);
    [Wn,dWdxn,dWdyn] = kernelnorm(W,dWdx,dWdy,x,neighbourlen,h);
    B = CalcB(dWdxn,dWdyn,x,y,neighbour,neighbourlen,h);
    Sdf = SPHCdf(dWdxn,dWdyn,x,u,neighbour,neighbourlen,B,h);
end

function [W,dWdx,dWdy] = KernelCSpline(x,y,neighbour,neighbourlen,h)
    
    Nsph = length(x);
    s = h;
    const = 10/(7*pi);

    W = cell(Nsph,1);
    dWdx = cell(Nsph,1);
    dWdy = cell(Nsph,1);

    for i = 1:Nsph
        for j = 1:neighbourlen(i)

            dX = x(i) - x(neighbour{i,1}(j));
            dY = y(i) - y(neighbour{i,1}(j));
            dr = sqrt(dX^(2) + dY^(2));
            dR = dr/s;

            if dR < 1
                W{i,1}(j) = const*(2/3 - dR^(2) + 1/2*dR^(3));
                if i == neighbour{i,1}(j)
                    dWdx{i,1}(j) = 0.0;
                    dWdy{i,1}(j) = 0.0;
                else
                    dWdx{i,1}(j) = (dX/(dr*h))*const*(-2*dR + 3/2*dR^(2));
                    dWdy{i,1}(j) = (dY/(dr*h))*const*(-2*dR + 3/2*dR^(2));
                end

            elseif (1 <= dR) && (dR < 2)
                W{i,1}(j) = const*(1/6 *(2-dR)^(3));
                dWdx{i,1}(j) = (dX/(dr*h))*const*(-1/2*(2-dR)^(2));
                dWdy{i,1}(j) = (dY/(dr*h))*const*(-1/2*(2-dR)^(2));

            elseif 2 <= dR
                W{i,1}(j) = const*(0);
                dWdx{i,1}(j) = const*(0);
                dWdy{i,1}(j) = const*(0);
            end
        end
    end
end

function [Wn,dWdxn,dWdyn] = kernelnorm(W,dWdx,dWdy,x,neighbourlen,h)
    
    Nsph = length(x);

    Wn = cell(Nsph,1);
    dWdxn = cell(Nsph,1);
    dWdyn = cell(Nsph,1);

    C = zeros(Nsph,1);

    for i = 1:Nsph
        for j = 1:neighbourlen(i)  
            C(i) = C(i) + h^2 *W{i,1}(j);
        end   
    end

    for i = 1:Nsph
        for j = 1:neighbourlen(i)  
            dWdxn{i,1}(j) = 1/C(i) *dWdx{i,1}(j);
            dWdyn{i,1}(j) = 1/C(i) *dWdy{i,1}(j);
            Wn{i,1}(j) = 1/C(i) *W{i,1}(j);        
        end   
    end
end

function B = CalcB(dWdxn,dWdyn,x,y,neighbour,neighbourlen,h)

    Nsph = length(x);

    B = cell(Nsph,1);

    for i = 1:Nsph
        B{i,1} = zeros(2,2);
        for j = 1:neighbourlen(i) 

            B{i,1}(1,1) = B{i,1}(1,1) + (x(neighbour{i,1}(j)) - x(i))*h^2 *dWdxn{i,1}(j);
            B{i,1}(1,2) = B{i,1}(1,2) + (x(neighbour{i,1}(j)) - x(i))*h^2 *dWdyn{i,1}(j);
            B{i,1}(2,1) = B{i,1}(2,1) + (y(neighbour{i,1}(j)) - y(i))*h^2 *dWdxn{i,1}(j);
            B{i,1}(2,2) = B{i,1}(2,2) + (y(neighbour{i,1}(j)) - y(i))*h^2 *dWdyn{i,1}(j);

        end
        B{i,1} = inv(B{i,1});
    end
end

function Sdf = SPHCdf(dWdxn,dWdyn,x,u,neighbour,neighbourlen,B,h)

    Nsph = length(x);

    Sdf = zeros(Nsph,2);

    for i = 1:Nsph
        for j = 1:neighbourlen(i) 

            Sdf(i,1) = Sdf(i,1) + (u(neighbour{i,1}(j)) - u(i))*h^2 *dWdxn{i,1}(j);
            Sdf(i,2) = Sdf(i,2) + (u(neighbour{i,1}(j)) - u(i))*h^2 *dWdyn{i,1}(j);

        end
        Sdf(i,:) = Sdf(i,:)*B{i,1};
    end
end