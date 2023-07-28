function [x,y] = writeGeom(x,y,fid)
    for i = 1:length(x)
        fprintf(fid,"%f\t%f\n",x(i),y(i));
    end
    fprintf(fid,"end\n");
end