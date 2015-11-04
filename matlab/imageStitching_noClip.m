%% Author: Bishwamoy Sinha Roy
function [panoImg] = imageStitching_noClip(im1, im2, H2to1)
%%
%Inputs:
%img1       = source image
%img2       = image to be warped into img1
%H2to1      = homography from image 2 to image 1
%Outputs
%panoImg    = resulting image stitched  

%% variables
corner_im1 = ones(3,4);
corner_im2 = ones(3,4);
outSize = size(im1);
M = [1 0 0; 0 1 0; 0 0 1];
 

%% implementation
im1_max_y = size(im1, 1); im1_max_x = size(im1, 2);
im2_max_y = size(im2, 1); im2_max_x = size(im2, 2);

corner_im1(1:2, 2:4) = [im1_max_x,  1,          im1_max_x;
                        1,          im1_max_y,  im1_max_y];
corner_im2(1:2, 2:4) = [im2_max_x,  1,          im2_max_x;
                        1,          im2_max_y,  im2_max_y];                  

corner_im2in1 = H2to1 * corner_im2;
corner_im2in1(1,:) = round( corner_im2in1(1,:) ./ corner_im2in1(3,:) ); 
corner_im2in1(2,:) = round( corner_im2in1(2,:) ./ corner_im2in1(3,:) ); 

corner_x = [corner_im1(1,:), corner_im2in1(1,:)];
corner_y = [corner_im1(2,:), corner_im2in1(2,:)];

pano_max_x = max(corner_x); 
pano_max_y = max(corner_y);
pano_min_x = min(corner_x); 
pano_min_y = min(corner_y);

if(pano_min_x < 0 || pano_min_y < 0)
    M = [1 0 -(pano_min_x + 1);
         0 1 -(pano_min_y + 1);
         0 0        1          ];
end
     
outsize = [pano_max_y - pano_min_y, pano_max_x - pano_min_x];

mask1 = calcMask(im1); mask1 = repmat(mask1, [1 1 3]);
mask2 = calcMask(im2); mask2 = repmat(mask2, [1 1 3]);

im1in3 = im2double( warpH(im1, M, outsize) );
mask1in3 = im2double( warpH(mask1, M, outsize) );

im2in3 = im2double( warpH(im2, M*H2to1, outsize) );
mask2in3 = im2double( warpH(mask2, M*H2to1, outsize) );

panoImg = ( mask1in3.*im1in3 + mask2in3.*im2in3 ) ./ (mask1in3+mask2in3+eps);
end

function mask = calcMask(im)
    mask = zeros(size(im,1), size(im,2));
    mask(1,:) = 1; mask(end,:) = 1; mask(:,1) = 1; mask(:,end) = 1;
    mask = bwdist(mask, 'city');
    mask = mask/max(mask(:));
end