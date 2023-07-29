function [x,y] = boundaryreader(filename)

    fid = fopen(filename,'r');

    x = [];
    y = [];

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

            x(counter,1) = str2double(splitdata(1,1));
            y(counter,1) = str2double(splitdata(2,1));

            counter = counter + 1;
        end
    end
    fclose(fid);
end