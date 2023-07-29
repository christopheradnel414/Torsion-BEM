% Ray Casting Algorithm to create grid inside the domain
function [x,y,h] = raycasting(xm,ym,xbi,xbe,ybi,ybe,N)
    
    n = length(xbi);
    Nx = N;
    Ny = N;
    xstart = min([xbi;xbe]) - 1e-4;
    ystart = min([ybi;ybe]) - 1e-4;
    xend = max([xbi;xbe]) + 1e-4;
    yend = max([ybi;ybe]) + 1e-4;
    h = max([yend-ystart,xend-xstart])/N;

    c = 1;
    for i = 1:Nx
        for j = 1:Ny

            xp = xstart + i*h;
            yp = ystart + j*h;

            far = true;
            inside = false;

            obs = 0;
            for k = 1:n
                if ((ybi(k) < yp) && (ybe(k) > yp)) || ((ybi(k) > yp) && (ybe(k) < yp))
                    m = ((xbe(k)-xbi(k))/(ybe(k)-ybi(k)));
                    xobs = xbi(k) + m*(yp - ybi(k));
                    if xp > xobs          
                        obs = obs + 1;
                    end
                end
            end
            if mod(obs,2) == 1
               inside = true;
            end
            for k = 1:n
                if ((xp-xm(k))^2 + (yp-ym(k))^2) < (0.01*h)^2
                    far = false;
                    break
                end
            end
            if far == true && inside == true
                x(c) = xp;
                y(c) = yp;
                c = c+1;
            end
        end
    end
end