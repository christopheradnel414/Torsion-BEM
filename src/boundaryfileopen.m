function [n,xbi,xbe,ybi,ybe,xm,ym,lm,nx,ny,C] = boundaryfileopen(filename)

    fid = fopen(filename,'r');

    xb = [];
    yb = [];

    BC_counter = 1;
    counter = 1;
    while true
        line = fgetl(fid);

        if ~ischar(line)
            break 
        end  %end of file

        if line == "end"
            BC_counter = BC_counter + 1;
        else
            BC(counter) = int32(BC_counter);

            splitdata = split(line);

            xb(counter,1) = str2double(splitdata(1,1));
            yb(counter,1) = str2double(splitdata(2,1));

            counter = counter + 1;
        end
    end
    fclose(fid);

    n = length(xb) - (BC_counter-1);

    xbi = zeros(n,1);
    xbe = zeros(n,1);
    ybi = zeros(n,1);
    ybe = zeros(n,1);
    xm = zeros(n,1);
    ym = zeros(n,1);
    lm = zeros(n,1);
    nx = zeros(n,1);
    ny = zeros(n,1);
    C = zeros(n,1);

    if BC_counter > 1
        nraw = zeros(BC_counter-1,1);
        for i = 1:length(xb)
            nraw(BC(i)) = nraw(BC(i)) + 1;
        end
        counter1 = 1;
        counter2 = 1;
        for i = 1 : length(nraw)
            for j = 1 : nraw(i)-1
                xbi(counter1) = xb(counter2);
                xbe(counter1) = xb(counter2+1);
                ybi(counter1) = yb(counter2);
                ybe(counter1) = yb(counter2+1);
                xm(counter1) = 0.5*(xb(counter2) + xb(counter2+1)); % Element mid point x
                ym(counter1) = 0.5*(yb(counter2) + yb(counter2+1)); % Element mid point y
                lm(counter1) = sqrt((xb(counter2+1) - xb(counter2))^2 + (yb(counter2+1) - yb(counter2))^2); % Element length
                nx(counter1) = (yb(counter2+1) - yb(counter2))/lm(counter1); % Element normal vector x
                ny(counter1) = (xb(counter2) - xb(counter2+1))/lm(counter1); % Element normal vector y
                C(counter1) = i;
                counter1 = counter1 + 1;
                counter2 = counter2 + 1;
            end
            counter2 = counter2 + 1;
        end
    else
        for i = 1:n
            xbi(i) = xb(i);
            xbe(i) = xb(i+1);
            ybi(i) = yb(i);
            ybe(i) = yb(i+1);
            xm(i) = 0.5*(xb(i) + xb(i+1)); % Element mid point x
            ym(i) = 0.5*(yb(i) + yb(i+1)); % Element mid point y
            lm(i) = sqrt((xb(i+1) - xb(i))^2 + (yb(i+1) - yb(i))^2); % Element length
            nx(i) = (yb(i+1) - yb(i))/lm(i); % Element normal vector x
            ny(i) = (xb(i) - xb(i+1))/lm(i); % Element normal vector y
        end
    end
end