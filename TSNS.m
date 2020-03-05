clear; close all;
%% parametry algorytmu zadawane przez u?ytkownika
imageName   = 'test';
imageformat = '.png';
schemat = 1; % 1 - schemat centralny, 2 - schemat upwind
ITER    = 1000;
dt      = 0.01;
vi      = 0.75;
K       = 10^-12;
h       = 1;
anisDif = 5;
p_r     = 8;
s_r     = 30;
alfa    = 0.2;
lambda  = 0.01;
%%
imgName = [imageName imageformat];
resName = 'output.png';
output  = 'output.png';
%% pomocnicze nazwy plików (nie trzeba zmienia?)
img_uName = 'test_u.png';
img_vName = 'test_v.png';
maskName  = 'mask.png';
NavStoRes = 'NS_u.png';

I = im2double(imread(imgName));

[nx, ny, nz] = size(I);

maska = double(1-((I(:,:,1) == 0 ) & ...
                (  I(:,:,2) == 1) & ...
                (  I(:,:,3) == 0)));
%%maska zostaje powi?kszona bo algorytm segmentacji zazielenia granic?
erodedMask = maska;
for i=1:7
    erodedMask = imerode(erodedMask,ones(3,3));
end

R = I(:,:,1);
T = I(:,:,2);
F = I(:,:,3);

%% dla R T i F robiê rozbicie tesktury i struktury
tic
[RUN1,RV] = StructureTexture(R, lambda);
[TUN1,TV] = StructureTexture(T, lambda);
[FUN1,FV] = StructureTexture(F, lambda);
ts = toc;

U(:,:,1) = RUN1;
U(:,:,2) = TUN1;
U(:,:,3) = FUN1;

V(:,:,1) = RV;
V(:,:,2) = TV;
V(:,:,3) = FV;

imwrite(U, img_uName);
imwrite(V, img_vName);

%% Navier Stokes
tic
U1 = inpainiting(U(:,:,1),erodedMask,ITER,h,dt,anisDif,vi,K,schemat);
U2 = inpainiting(U(:,:,2),erodedMask,ITER,h,dt,anisDif,vi,K,schemat);
U3 = inpainiting(U(:,:,3),erodedMask,ITER,h,dt,anisDif,vi,K,schemat);
tns = toc;
U(:,:,1) = U1;
U(:,:,2) = U2;
U(:,:,3) = U3;
%% algorytm Criminisi

%s_r = ceil(sqrt(size(I,1)*0.02*size(I,2)*0.02))
C    = erodedMask;

RVTVFVm = main(nx,ny,nz,V(:),erodedMask(:),C(:),p_r,s_r,alfa);
RVTVFVr = reshape(RVTVFVm,[nx,ny,nz]);

RV = RVTVFVr(:,:,1);
TV = RVTVFVr(:,:,2);
FV = RVTVFVr(:,:,3);

%% konwersja do obrazu kolorowego
I(:,:,1) = U(:,:,1) + RV;
I(:,:,2) = U(:,:,2) + TV;
I(:,:,3) = U(:,:,3) + FV;

%% wynik obrazu kolorowego
imwrite(I, ['output' 'ts_' num2str(ts) 'tns_' num2str(tns) '_' imageName imageformat]);
