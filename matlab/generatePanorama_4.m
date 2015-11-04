%% AUTHOR: BISHWAMOY SINHA ROY
%% variables

iter = 2000; % number of RANSAC iterations
tol  = 25; % tolerance for RANSAC determination of inlier
im1 = imread('results/ec8_1.JPG');
im2 = imread('results/ec8_2.JPG');
im3 = imread('results/ec8_3.JPG');

%% implementation

im1_g = im2double( rgb2gray(im1) );
im2_g = im2double( rgb2gray(im2) );
im3_g = im2double( rgb2gray(im3) );

%keypoint desciption and matching
[l1, d1] = briefLite(im1_g);
[l2, d2] = briefLite(im2_g);
[l3, d3] = briefLite(im3_g);

m12 = briefMatch(d1, d2);
H2to1 = ransacH(m12, l1, l2, iter, tol);
im_12 = imageStitching_noClip(im1, im2, H2to1);
[l12, d12] = briefLite(im_12);

m123 = briefMatch(d12, d3);
H = ransacH(m123, l12, l3, iter, tol);

im_123 = imageStitching_noClip(im_12, im3, H);