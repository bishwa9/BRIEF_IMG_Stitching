%% AUTHOR: BISHWAMOY SINHA ROY
function [im3] = generatePanorama(im1, im2)
%% 
%Inputs:
%im1        = image to be warped into
%im2        = image to warp into im1
%Outputs:
%im3        = Resulting panorama

%% variables

iter = 2000; % number of RANSAC iterations
tol  = 25; % tolerance for RANSAC determination of inlier

%% implementation

im1_g = im2double( rgb2gray(im1) );
im2_g = im2double( rgb2gray(im2) );
%keypoint desciption and matching
[l1, d1] = briefLite(im1_g);
[l2, d2] = briefLite(im2_g);
m = briefMatch(d1, d2);
%Homography
H2to1 = ransacH(m, l1, l2, iter, tol);

%warp
im3 = imageStitching_noClip(im1, im2, H2to1);

end