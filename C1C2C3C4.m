function [ c1,c2,c3,c4 ] = C1C2C3C4(u)

[nx, ny] = size(u);
epsilon = 0.0001;
c4 = zeros(nx,ny); c1 = c4; c2 = c4; c3 = c4;

h=1;
L = [u(1,1); u(:,1); u(nx,1)];
P = [u(1,ny); u(:,ny); u(nx,ny)];
u = [L, [u(1,:); u; u(nx,:)], P]; 

for i=2 : nx+1
    for j=2 : ny+1
        c1(i-1,j-1) = 1/sqrt( ((u(i+1,j)-u(i,j))/h)^2 + ((u(i,j+1)-u(i,j-1))/(2*h))^2 + epsilon);
        c2(i-1,j-1) = 1/sqrt( ((u(i,j)-u(i-1,j))/h)^2 + ((u(i-1,j+1)-u(i-1,j-1))/(2*h))^2 +epsilon);
        c3(i-1,j-1) = 1/sqrt( ((u(i+1,j)-u(i-1,j))/(2*h))^2 + ((u(i,j+1)-u(i,j))/h)^2 +epsilon);
        c4(i-1,j-1) = 1/sqrt( ((u(i+1,j-1)-u(i-1,j-1))/(2*h))^2 + ((u(i,j)-u(i,j-1))/h)^2 +epsilon);
    end
end
C1 = c1; C2 = c2; C3 = c3; C4 = c4;
clear c1 c2 c3 c4
%poszerzam macierz o 1 do warunków granicznych
%dla C1
L = [C1(1,1); C1(:,1); C1(nx,1)];
P = [C1(1,ny); C1(:,ny); C1(nx,ny)];
c1 = [L, [C1(1,:); C1; C1(nx,:)], P];
%dla C2
L = [C2(1,1); C2(:,1); C2(nx,1)];
P = [C2(1,ny); C2(:,ny); C2(nx,ny)];
c2 = [L, [C2(1,:); C2; C2(nx,:)], P];
%dla C3
L = [C3(1,1); C3(:,1); C3(nx,1)];
P = [C3(1,ny); C3(:,ny); C3(nx,ny)];
c3 = [L, [C3(1,:); C3; C3(nx,:)], P];
%dla C4
L = [C4(1,1); C4(:,1); C4(nx,1)];
P = [C4(1,ny); C4(:,ny); C4(nx,ny)];
c4 = [L, [C4(1,:); C4; C4(nx,:)], P];

end

