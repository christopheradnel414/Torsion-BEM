function G = calcG(xm,ym,xk,yk,nkx,nky,lk)
    G = (lk/(2.0*pi))*quad(@(t)intg(t,xm,ym,xk,yk,nkx,nky,lk),0,1,1e-4);
end

function y = intg(t, xm, ym, xk, yk, nkx, nky, lk)
    dx = -nky*lk;
    dy = nkx*lk;
    y = (nkx*(xk + t*dx - xm) + nky*(yk + t*dy - ym))...
        ./((xk + t*dx - xm).^2 + (yk + t*dy - ym).^2);
end