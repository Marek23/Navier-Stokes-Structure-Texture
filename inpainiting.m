function [sf] = inpainiting(I,maska,ITER,h,dt, anisDif, vi, K, schemat)
%% Parametry inpaintingu
%%Iloœæ iteracji do wykonania przez program
maskaP = imerode(imerode(maska, ones(3,3)),ones(3,3));

[nx, ny] = size(I);

vt = zeros(nx,ny);
w  = zeros(nx,ny);
sf = I;
%% Rozwi¹zanie NS
for istep = 1 : ITER
    newsf = Poisson(vt,sf,maska,I,h);

    CH=0.0;
	for i=1:nx
        for j=1:ny
            CH=CH+abs(newsf(i,j)-sf(i,j));
        end
    end

    if CH <= 0.01
        sf = newsf;
        break %stop gdy spe³niony warunek
    end

    sf = newsf;
    [sfy, sfx] = gradient(sf,h,h);
    u = sfy;
    v = -sfx;
    [uy, ux] = gradient(u,h,h);
    [vy, vx] = gradient(v,h,h);
    vt = vx - uy;
    
    %%schemat centralny
    if schemat == 1
        for i=2:nx-1
            for j=2:ny-1
                if(maskaP(i,j) == 0)
                    w(i,j)=-0.25*(u(i,j)*(vt(i+1,j)-vt(i-1,j))+v(i,j)*(vt(i,j+1)-vt(i,j-1)))/(h*h);
                end
            end
        end
    end

	%%schemat do przodu
    if schemat == 1
        for i=2:nx-1
            for j=2:ny-1
                if(maskaP(i,j) == 0)
                    w(i,j)=-0.25*(u(i,j)*(vt(i+1,j)-vt(i-1,j))+v(i,j)*(vt(i,j+1)-vt(i,j-1)))/(h*h);
                end
            end
        end
    elseif schemat == 2
        for i=2:nx-1
            for j=2:ny-1
                w(i,j)=-0.25*(abs(u(i,j))*(vt(i+sign(u(i,j)),j)-vt(i,j))+abs(v(i,j))*(vt(i,j+sign(v(i,j)))-vt(i,j)))/(h*h);
            end
        end
    end
    if anisDif == 1
        w = w + vi*anisodiff(w,K);
    end
    if anisDif == 2
        w = w + vi*anisodiff2(w,K);
    end
    if anisDif == 3
        w = w + vi*anisodiff2D(w,K);
    end
    if anisDif == 4
        for i=2:nx-1
            for j=2:ny-1 % compute
                w(i,j) = w(i,j) +vi*(vt(i+1,j)+vt(i-1,j)+vt(i,j+1)+vt(i,j-1)-4.0*vt(i,j))/(h*h);
            end
        end
    end

    for i=1:nx
        for j=1:ny
            if(maskaP(i,j) == 0)
                vt(i,j)=vt(i,j)+dt*w(i,j);
            end
        end
    end

    if rem(istep,30) == 0 && istep > 29
        istep
    end
end
end

