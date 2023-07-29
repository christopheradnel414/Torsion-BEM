function F = calcF(xm,ym,xk,yk,nkx,nky,lk)
    F = (lk/(4.0*pi))*quad(@(t)intf(t,xm,ym,xk,yk,nkx,nky,lk),0,1,1e-4);
end

function y = intf(t,xm,ym,xk,yk,nkx,nky,lk)
    dx = -nky*lk;
    dy = nkx*lk;
    y = log((xk + t*dx - xm).^2 + (yk + t*dy - ym).^2);
end
