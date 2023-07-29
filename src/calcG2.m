function G2 = calcG2(xm,ym,xk,yk,nkx,nky,lk)
    G2 = (lk/(8.0*pi))*quad(@(t)intg2(t,xm,ym,xk,yk,nkx,nky,lk),0,1,1e-4);
end

function y = intg2(t, xm, ym, xk, yk, nkx, nky, lk)
    dx = -nky*lk;
    dy = nkx*lk;
    y = ((xk + t*dx - xm)*nkx + (yk + t*dy - ym)*nky).*(log((xk + t*dx - xm).^2 + (yk + t*dy - ym).^2)-1);
end