function [un,g1n,g2n] = solveUG1G2(u,g1,g2,i,lambda)

mi = 2;
dim = size(u);
un = u; g1n = g1; g2n = g2; h=1;
[c1, c2, c3, c4] = C1C2C3C4(u);

%dla u
L = [u(1,1); u(:,1); u(dim(1),1)];
P = [u(1,dim(2)); u(:,dim(2)); u(dim(1),dim(2))];
U = [L, [u(1,:); u; u(dim(1),:)], P];
    
%dla g1
L = [g1(1,1); g1(:,1); g1(dim(1),1)];
P = [g1(1,dim(2)); g1(:,dim(2)); g1(dim(1),dim(2))];
G1 = [L, [g1(1,:); g1; g1(dim(1),:)], P];

%dla g2
L = [g2(1,1); g2(:,1); g2(dim(1),1)];
P = [g2(1,dim(2)); g2(:,dim(2)); g2(dim(1),dim(2))];
G2 = [L, [g2(1,:); g2; g2(dim(1),:)], P];

%dla i
L = [i(1,1); i(:,1); i(dim(1),1)];
P = [i(1,dim(2)); i(:,dim(2)); i(dim(1),dim(2))];
I = [L, [i(1,:); i; i(dim(1),:)], P];



for i=2 : dim(1)+1
    for j=2 : dim(2)+1
        un(i-1,j-1) = (1/( 1 + (1/(2*lambda*h^2))*(c1(i,j)+c2(i,j)+c3(i,j)+c4(i,j)) ))*(I(i,j) - ((G1(i+1,j)-G1(i-1,j))/(2*h)) - ((G2(i,j+1)-G2(i,j-1))/(2*h)) + (1/(2*lambda*h^2))*(c1(i,j)*U(i+1,j)+c2(i,j)*U(i-1,j)+c3(i,j)*U(i,j+1)+c4(i,j)*U(i,j-1)) );
        g1n(i-1,j-1) = (2*lambda/(mi*sqrt(2*lambda) + 4*lambda/(2*h)))*((U(i+1,j)-U(i-1,j))/(2*h) - (I(i+1,j)-I(i-1,j))/(2*h) + (G1(i+1,j)+G1(i-1,j))/(h^2) + 1/(2*h^2)*(2*G2(i,j) + G2(i-1,j-1) + G2(i+1,j+1) - G2(i,j-1) - G2(i-1,j) + G2(i+1,j) - G2(i,j+1) ));
        g2n(i-1,j-1) = (2*lambda/(mi*sqrt(2*lambda) + 4*lambda/(2*h)))*((U(i,j+1)-U(i,j-1))/(2*h) - (I(i,j+1)-I(i,j-1))/(2*h) + (G2(i,j+1)+G2(i,j-1))/(h^2) + 1/(2*h^2)*(2*G1(i,j) + G1(i-1,j-1) + G1(i+1,j+1) - G1(i,j-1) - G1(i-1,j) + G1(i+1,j) - G1(i,j+1) ));
    end
end
end

