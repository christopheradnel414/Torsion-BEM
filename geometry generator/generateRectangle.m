function [x,y] = generateRectangle(Sx,Sy,xmid,ymid,Nx,Ny,stat)

    x = [];
    y = [];
    
    if stat == 1
        for i = 0:Nx-1
            x = [x i*Sx/(Nx-1)];
            y = [y 0.0];
        end
        for i = 1:Ny-1
            x = [x (Nx-1)*Sx/(Nx-1)];
            y = [y i*Sy/(Ny-1)];
        end
        for i = 1:Nx-1
            x = [x (Nx-1-i)*Sx/(Nx-1)];
            y = [y (Ny-1)*Sy/(Ny-1)];
        end
        for i = 1:Ny-1
            x = [x 0.0];
            y = [y (Ny-1-i)*Sy/(Ny-1)];
        end
    else
        for i = Nx-1:-1:0
            x = [x i*Sx/(Nx-1)];
            y = [y 0.0];
        end
        for i = Ny-2:-1:1
            x = [x 0.0];
            y = [y (Ny-1-i)*Sy/(Ny-1)];
        end
        for i = Nx-1:-1:1
            x = [x (Nx-1-i)*Sx/(Nx-1)];
            y = [y (Ny-1)*Sy/(Ny-1)];
        end
        for i = Ny-1:-1:0
            x = [x (Nx-1)*Sx/(Nx-1)];
            y = [y i*Sy/(Ny-1)];
        end
    end
    
    for i = 1:length(x)
        x(i) = x(i) - Sx/2 + xmid;
        y(i) = y(i) - Sy/2 + ymid;
    end
    x = x';
    y = y';
end