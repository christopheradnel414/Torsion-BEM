function [x,y] = writeLine(x,y,fid)
    for i = 1:length(x)
        fprintf(fid,"%f\t%f\n",x(i),y(i));
    end
end