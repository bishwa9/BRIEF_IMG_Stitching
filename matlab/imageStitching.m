function [panoImg] = imageStitching(im1, im2, H2to1)
%%
%Inputs:
%img1       = source image
%img2       = image to be warped into img1
%H2to1      = homography from image 2 to image 1
%Outputs
%panoImg    = resulting image stitched  

%% variables
outSize = size(im1);

im1 = im2double(im1);
im2 = im2double(im2);

%% implementation
mask1 = calcMask(im1); mask1 = repmat(mask1, [1 1 3]);
mask2 = calcMask(im2); mask2 = repmat(mask2, [1 1 3]);
im2in1 = warpH(im2, H2to1, outSize);
mask2in1 = warpH(mask2, H2to1, outSize);
panoImg = ( mask1.*im1 + mask2in1.*im2in1 ) ./ (mask2in1+mask1+eps);
end

function mask = calcMask(im)
    mask = zeros(size(im,1), size(im,2));
    mask(1,:) = 1; mask(end,:) = 1; mask(:,1) = 1; mask(:,end) = 1;
    mask = bwdist(mask, 'city');
    mask = mask/max(mask(:));
end