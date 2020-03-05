function [wo] = anisodiff2(we,K)
[nx,ny] = size(we);
wo = zeros(nx,ny);
g  = zeros(nx,ny);
normw = zeros(nx,ny);
[wy, wx] = gradient(we);

for x=1:nx
    for y=1:ny
        normw(x,y) = sqrt(wx(x,y)*wx(x,y) + wy(x,y)*wy(x,y));
        g(x,y) = 1/(1+(normw(x,y)/K)^2);
    end
end

%% 
for x=2:nx-1
    for y=2:ny-1
        wo(x,y) = ((g(x,y)-g(x+1,y))*(we(x+1,y)-we(x,y))...
            -(g(x-1,y)-g(x,y))*(we(x,y)-we(x-1,y))+ (g(x,y)-g(x,y+1))*(we(x,y+1)-we(x,y))...
            -(g(x,y-1)-g(x,y))*(we(x,y)-we(x,y-1)));
    end
end
end