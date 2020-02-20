function [wo] = anisodiff2(we,c)
%% parametry
[nx,ny] = size(we);
wo = we;
%% 
for x=2:nx-1
    for y=2:ny-1
        wo(x,y) = we(x,y) + 0.1*(1/2)*((c(x,y)+c(x+1,y))*(we(x+1,y)-we(x,y))...
            -(c(x-1,y)+c(x,y))*(we(x,y)-we(x-1,y))+ (c(x,y)+c(x,y+1))*(we(x,y+1)-we(x,y))...
            -(c(x,y-1)+c(x,y))*(we(x,y)-we(x,y-1)));
    end
end



end