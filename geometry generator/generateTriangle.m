function [x,y] = generateTriangle(a,xmid,ymid,N,stat)

    x = [];
    y = [];
    S = 3*a/cos(30*pi/180)
    h = S/(N-1)
    
    
    if stat == 1
        for i = 0:N-1
            x = [x a];
            y = [y -S/2+i*h];
        end
        for i = 1:N-1
            x = [x a-i*h*cos(30*pi/180)];
            y = [y S/2-i*h*sin(30*pi/180)];
        end
        for i = 1:N-1
            x = [x -2*a+i*h*cos(30*pi/180)];
            y = [y -i*h*sin(30*pi/180)];
        end
    else
        for i = N-1:-1:1
            x = [x a];
            y = [y -S/2+i*h];
        end
        for i = N-1:-1:1
            x = [x -2*a+i*h*cos(30*pi/180)];
            y = [y -i*h*sin(30*pi/180)];
        end
        for i = N-1:-1:0
            x = [x a-i*h*cos(30*pi/180)];
            y = [y S/2-i*h*sin(30*pi/180)];
        end
    end
    
    for i = 1:length(x)
        x(i) = x(i) + xmid;
        y(i) = y(i) + ymid;
    end
    x = x';
    y = y';
end