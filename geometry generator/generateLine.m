function [x,y] = generateLine(xi,yi,xe,ye,N,includestart)

    x = [];
    y = [];
    
    if includestart == true
        for i = 1:N
            x = [x xi+(i-1)/(N-1)*(xe-xi)];
            y = [y yi+(i-1)/(N-1)*(ye-yi)];
        end
    else
        for i = 2:N
            x = [x xi+(i-1)/(N-1)*(xe-xi)];
            y = [y yi+(i-1)/(N-1)*(ye-yi)];
        end
    end

    x = x';
    y = y';

end