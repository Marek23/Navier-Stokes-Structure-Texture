function [I] = inpainiting(I,maska,ITER,h,dt)

%% Parametry inpaintingu
%%Ilo�� iteracji do wykonania przez program
[nx, ny] = size(I);
nz = 3;

%% Rozwi�zanie NS
for istep = 1 : ITER
    %% wyznaczenie wirowo�ci, Dla R, Theta i Fi
    [Iy, Ix] = gradient(I,h,h);
    u = Iy; v = -Ix;
    [uy, ux] = gradient(u,h,h);
    [vy, vx] = gradient(v,h,h);
    w = vx - uy;
    [wy, wx] = gradient(w,h,h);
    uwx = u.*wx;
    vwy = v.*wy;
    wnext = w - dt*(uwx+vwy);
    
%     Tutaj mo?na doda? dyfuzje anizotropow?
    
    nextI = Poisson(wnext,I,h);
    %% Tam gdzie jest maska aktualizuj� warto�ci w obrazie
    for x=1:nx
        for y=1:ny
            if(maska(x,y) == 0)
                I(x,y) = nextI(x,y);
            end
        end
    end
    if rem(istep,30) == 0 && istep > 29
        istep
    end
end
end

