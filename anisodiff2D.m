function wy = anisodiff2D(im, K)
option = 1;
wy = im;
hN = [0 1 0; 0 -1 0; 0 0 0];
hS = [0 0 0; 0 -1 0; 0 1 0];
hE = [0 0 0; 0 -1 1; 0 0 0];
hW = [0 0 0; 1 -1 0; 0 0 0];
nablaN = imfilter(wy,hN,'same');
nablaS = imfilter(wy,hS,'same');   
nablaW = imfilter(wy,hW,'same');
nablaE = imfilter(wy,hE,'same');   
if option == 1
    cN = exp(-(nablaN/K).^2);
	cS = exp(-(nablaS/K).^2);
	cW = exp(-(nablaW/K).^2);
	cE = exp(-(nablaE/K).^2);
elseif option == 2
    cN = 1./(1 + (nablaN/K).^2);
	cS = 1./(1 + (nablaS/K).^2);
	cW = 1./(1 + (nablaW/K).^2);
	cE = 1./(1 + (nablaE/K).^2);
end
	wy = cN.*nablaN + cS.*nablaS + cW.*nablaW + cE.*nablaE;
end