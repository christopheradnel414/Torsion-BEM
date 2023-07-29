# Torsion Boundary Element Method
This repository is part of my Continuum Mechanics course project and contains a cross sectional torsion problem solver using Boundary Element Method. The detail derivation and theoretical background for the boundary element method application in torsional problem is included as PDF in the "Boundary Element Method Torsion.pdf" file.

<img height="150" alt="Screenshot 2023-07-27 at 00 47 04" src="https://github.com/christopheradnel414/Torsion-BEM/assets/41734037/d84d779c-b8bf-44e5-b896-b7411ca5312e">
<img height="150" alt="Screenshot 2023-07-27 at 00 47 04" src="https://github.com/christopheradnel414/Torsion-BEM/assets/41734037/1c14accc-d105-454b-a74b-2bb82186c121">
<img height="150" alt="Screenshot 2023-07-27 at 00 47 04" src="https://github.com/christopheradnel414/Torsion-BEM/assets/41734037/480364e0-ecd3-4aad-8aca-5b0158ee2962">
<img height="150" alt="Screenshot 2023-07-27 at 00 47 04" src="https://github.com/christopheradnel414/Torsion-BEM/assets/41734037/6d4337e5-5084-4b2d-a20e-81cffc6c9598">
<img height="150" alt="Screenshot 2023-07-27 at 00 47 04" src="https://github.com/christopheradnel414/Torsion-BEM/assets/41734037/aed878f5-e40c-41b1-b2a5-1602f66ba616">
<img height="50" alt="Screenshot 2023-07-27 at 00 47 04" src="https://github.com/christopheradnel414/Torsion-BEM/assets/41734037/e49367cd-062e-4662-b032-fb8e6cc93999">



This repository consists of 3 parts:
1. Boundary element method solver (src folder)
2. Geometry generation scripts (geometry generator folder)
3. Geometry example data (geometry folder)

# Boundary Element Method Solver
The main code for the boundary element solver is the "main_torsion.m" file which also includes some solver parameters such as solution resolution, geometry file name, and the material properties. The main solver takes a .txt file as an input, which consists of edges (boundary) of the domain that can be generated using the example in the "geometry generator" folder. As this solver supports inner boundary, we are using counter clockwise defined edges as outer boundaries and clockwise defined edges as inner boundaries. Due to the nature of boundary element methods, we also need to distribute point clouds inside the domain where the stress is going to be computed. To support this, I am distributing points in a uniform grid and use a very simple raycasting algorithm to determine whether a point is inside or outside of the domain (https://en.wikipedia.org/wiki/Ray_casting). Furthermore, to compute the spatial gradient of the cloud point, I am implementing a simple SPH based gradient calculation method (https://en.wikipedia.org/wiki/Smoothed-particle_hydrodynamics).

# Geometry Generation
The geometry generation scripts are a tool to help simplify geometry creation. The geometry generation folder consists of several functions to generate simple boundaries and a main function which serves as an example on how to use these functions to create the final geometry. Here, as we are dealing with both outer and inner boundaries, our boundary generation functions will take an input on the last parameter to determine whether it is an inner or outer boundary. Example:
```
[x,y] = generateRectangle(6,3,0,0,30,15,1); % the last 1 in the input means that the rectangle boundary is outer boundary
[x,y] = generateCircle(1,0,0,30,0); % the last 0 in the input means that the circle boundary is inner boundary
```

# Geometery Example Data
I am including a few geometry examples that the user can try to experiment with in the geometry folder. To use these example geometries, the user needs to modify the geometry file name in the solver "main_torsion.m" script before executing it.
