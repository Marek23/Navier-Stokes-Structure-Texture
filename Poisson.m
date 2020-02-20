function [ Inw ] = Poisson(wn,In,h)
[nx,ny] = size(In);
%% parametry SOR
maxSOR =100;
Beta =1.5; maxEr =0.001;

%% Rozwi¹zanie SOR
for iter=1:maxSOR
    rhs=In;
    for i=2:nx-1
        for j=2:ny-1
            In(i,j)=0.25*Beta*(In(i+1,j)+In(i-1,j)...
                +In(i,j+1)+In(i,j-1)+h*h*wn(i,j))+(1.0-Beta)*In(i,j);
        end
    end
    Err=0.0;
    for i=1:nx
        for j=1:ny
            Err=Err+abs(rhs(i,j)-In(i,j));
        end
    end
    if Err <= maxEr
        break %stop gdy spe³niony warunek
    end
end
Inw = In;
end
