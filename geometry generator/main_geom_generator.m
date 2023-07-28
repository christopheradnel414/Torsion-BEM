clear all
clc

fid = fopen("geometry/multiple_hollowed_square.txt","w");
[x,y] = generateRectangle(6,3,0,0,30,15,1);
[x,y] = writeGeom(x,y,fid);scatter(x,y);hold on;plot(x,y);hold on
[x,y] = generateCircle(1,0,0,30,0);
[x,y] = writeGeom(x,y,fid);scatter(x,y);hold on;plot(x,y);hold on
[x,y] = generateCircle(0.5,-2,0,15,0);
[x,y] = writeGeom(x,y,fid);scatter(x,y);hold on;plot(x,y);hold on
[x,y] = generateCircle(0.5,2,0,15,0);
[x,y] = writeGeom(x,y,fid);scatter(x,y);hold on;plot(x,y);hold on

% fid = fopen("geometry/custom_geom.txt","w");
% [x,y] = generateRectangle(6,3,0,0,30,15,1);
% [x,y] = writeGeom(x,y,fid);scatter(x,y);hold on;plot(x,y);hold on
% [x,y] = generateRectangle(1,1,-2,0.5,5,5,0);
% [x,y] = writeGeom(x,y,fid);scatter(x,y);hold on;plot(x,y);hold on
% [x,y] = generateRectangle(1,1,0,-0.5,5,5,0);
% [x,y] = writeGeom(x,y,fid);scatter(x,y);hold on;plot(x,y);hold on
% [x,y] = generateRectangle(1,1,2,0,5,5,0);
% [x,y] = writeGeom(x,y,fid);scatter(x,y);hold on;plot(x,y);hold on

fclose(fid);

axis('equal')