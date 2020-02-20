function [wy] = anisodiff(we)
K = 10^-16;
[nx,ny] = size(we);
g = zeros(nx,ny);
normw = zeros(nx,ny);
[wy, wx] = gradient(we);

for x=1:nx
    for y=1:ny
        normw(x,y) = norm(wy(x,y),wx(x,y));
        g(x,y) = 1/(1+(normw(x,y)/K)^2);
    end
end

gwx = g.*wx; gwy = g.*wy;
[gwxy, gwxx] = gradient(gwx); [gwyy, gwyx] = gradient(gwy);
wy = we + (gwxx + gwyy);
end