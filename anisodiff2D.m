function diff_im = anisodiff2D(im, num_iter, lambda, kappa, option)
diff_im = im;
hN = [0 1 0; 0 -1 0; 0 0 0];
hS = [0 0 0; 0 -1 0; 0 1 0];
hE = [0 0 0; 0 -1 1; 0 0 0];
hW = [0 0 0; 1 -1 0; 0 0 0];
for t = 1:num_iter
        nablaN = imfilter(diff_im,hN,'same');
        nablaS = imfilter(diff_im,hS,'same');   
        nablaW = imfilter(diff_im,hW,'same');
        nablaE = imfilter(diff_im,hE,'same');   
        if option == 1
            cN = exp(-(nablaN/kappa).^2);
            cS = exp(-(nablaS/kappa).^2);
            cW = exp(-(nablaW/kappa).^2);
            cE = exp(-(nablaE/kappa).^2);
        elseif option == 2
            cN = 1./(1 + (nablaN/kappa).^2);
            cS = 1./(1 + (nablaS/kappa).^2);
            cW = 1./(1 + (nablaW/kappa).^2);
            cE = 1./(1 + (nablaE/kappa).^2);
        end
        diff_im = diff_im + lambda*(cN.*nablaN +cS.*nablaS + cW.*nablaW + cE.*nablaE);
end