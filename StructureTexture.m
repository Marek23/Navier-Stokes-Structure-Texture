function [UN1,V] = StructureTexture(I,lambda)

[nx,ny] = size(I); normGradI = I;
%% parametry algorytmu
eps = 0.0001;

%% algorytm rozbicia
UN1 = I;
[Iy, Ix] = gradient(I);
Iy(Iy == 0) = eps; Ix(Ix == 0) = eps;
for x=1:nx
    for y=1:ny
        normGradI(x,y) = norm([Ix(x,y), Iy(x,y)]);
    end
end
normGradI(normGradI == 0) = eps;
G1N = -Ix./normGradI/(2*lambda);
G2N = -Iy./normGradI/(2*lambda);

%% algorytm rozbicia
for i=1:20
    [UN1, G1N, G2N] = solveUG1G2(UN1,G1N,G2N,I,lambda);
end
%% wynik V
V = I-UN1;
%% koniec
end
