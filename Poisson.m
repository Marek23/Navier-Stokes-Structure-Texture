function [ Inw ] = Poisson(vt,sf,maska,I,h)
[nx,ny] = size(sf);
%% parametry SOR
maxSOR =100;
Beta =1.5; maxEr =0.001;

for i=1:nx
	for j=1:ny
        if(maska(i,j) == 1)
            sf(i,j)=I(i,j);
        end
    end
end

%% Rozwi¹zanie SOR
for iter=1:maxSOR
    w=sf;
    for i=2:nx-1
        for j=2:ny-1
            if maska(i,j) == 0
                sf(i,j)=0.25*Beta*(sf(i+1,j)+sf(i-1,j)...
                    +sf(i,j+1)+sf(i,j-1)+h*h*vt(i,j))+(1.0-Beta)*sf(i,j);
            end
        end
    end
    Err=0.0;
    for i=1:nx
        for j=1:ny
            Err=Err+abs(w(i,j)-sf(i,j));
        end
    end
    if Err <= maxEr
        break %stop gdy spe³niony warunek
    end
end
Inw = sf;
end
