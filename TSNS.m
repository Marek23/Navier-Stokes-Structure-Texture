clear; close all;

I = im2double(imread('test.png'));

[nx, ny, nz] = size(I);

maska = double(1-((I(:,:,1) < 0.03) & ...
                 ( I(:,:,2) > 0.9)  & ...
                 ( I(:,:,3) < 0.03)));

ITER = 2000;
dt   = 0.5;

ni     = 2;
h      = 3;
p_r    = 3;
lambda = 0.002;

%% konwertujê RGB na Spherical Coordinate System zgodnie z artyku³em "Image Inpainting via Fluid Equation, 2006
L = rgb2hsv(I);
R = L(:,:,1);
T = L(:,:,2);
F = L(:,:,3);

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

imwrite(hsv2rgb(U), ['output' 'U' '.png']);
imwrite(hsv2rgb(V), ['output' 'V' '.png']);

%% wstawiam maskê w obraz, od teraz w obrazie nie ma czêœci do inpaintingu
RUN1 = RUN1.*(maska); TUN1 = TUN1.*(maska); FUN1 = FUN1.*(maska);
RV   = RV.*(maska); TV = TV.*(maska); FV = FV.*(maska);
%% realizacja 3 algorytmów inpaintingu dla ka¿dej warstwy
tic
RUN1 = inpainiting(RUN1,maska,ITER,h,dt);
TUN1 = inpainiting(TUN1,maska,ITER,h,dt);
FUN1 = inpainiting(FUN1,maska,ITER,h,dt);
tns = toc;
%% OPCJA 2 dopasowanie patcha tylko na podstawie RV, tu nie tworz¹ siê nowe kolory
RVTVFV(:,:,1) = RV;
RVTVFV(:,:,2) = TV;
RVTVFV(:,:,3) = FV;

%% algorytm Criminisi
p_r=5;
%s_r = ceil(sqrt(size(I,1)*0.02*size(I,2)*0.02))
s_r  = 30;
alfa = 0.2;

mask = double(1-((I(:,:,1) == 0 ) & ...
                ( I(:,:,2) == 1) & ...
                ( I(:,:,3) == 0)));
C = mask;

tic
RVTVFVm = main(nx,ny,nz,RVTVFV(:),mask(:),C(:),p_r,s_r,alfa);
tt = toc;

RVTVFVr = reshape(RVTVFVm,[nx,ny,nz]);

RV = RVTVFVr(:,:,1);
TV = RVTVFVr(:,:,2);
FV = RVTVFVr(:,:,3);

%% konwersja do obrazu kolorowego
R = RUN1 + RV; T = TUN1+TV; F = FUN1+FV;
L(:,:,1) = R;
L(:,:,2) = T;
L(:,:,3) = F;

I = hsv2rgb(L);
%% wynik obrazu kolorowego
imwrite(I, ['output' 'ITER_' num2str(ITER) 'dt_' num2str(dt) 'h_' num2str(h) 'pr_' num2str(p_r)  'ts_' num2str(ts) 'tns_' num2str(tns) 'tt_' num2str(tt) '.png']);
