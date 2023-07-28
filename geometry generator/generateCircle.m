function [x,y] = generateCircle(R,xmid,ymid,N,stat)

    x = [];
    y = [];
    
    if stat == 1
        for i = 0:N-1
            x = [x R*sin(-i/(N-1)*2*pi)];
            y = [y R*cos(-i/(N-1)*2*pi)];
        end
    else
        for i = N-1:-1:0
            x = [x R*sin(-i/(N-1)*2*pi)];
            y = [y R*cos(-i/(N-1)*2*pi)];
        end
    end
    
    for i = 1:length(x)
        x(i) = x(i) + xmid;
        y(i) = y(i) + ymid;
    end
    x = x';
    y = y';
end