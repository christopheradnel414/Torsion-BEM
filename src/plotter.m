function plotter(x,y,xbi,xbe,ybi,ybe,h,f,name)
    maxnumx = (max(x) - min(x))/h;
    maxnumy = (max(y) - min(y))/h;
    maxnum = max([maxnumx,maxnumy]);
    scattersize = 400^2/(maxnum)^2 + 1.2;
    n = length(xbi);

    figure()
    scatter(x,y,scattersize,f,'filled')
    hold on
    for i = 1:n
        xx = [xbi(i),xbe(i)];
        yy = [ybi(i),ybe(i)];
        line(xx,yy,'Color','k','LineWidth',1)
    end
    hold on
    scatter(xbi,ybi,1.5*scattersize,'k','filled')
    axis('equal')
    title(name)
end