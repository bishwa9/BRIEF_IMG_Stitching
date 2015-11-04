function [ locs, desc ] = briefLite( im )
%% 
%Inputs
%im = grayscale image with value [0,1]
%Outputs
%locs   =   location of feature points
%desc   =   corresponding BRIEF descriptor

%% variables
G_L = [-1:4];
th_r = 12;
th_c = 0.03;
k = sqrt(2);
sigma0 = 1;
load('testPattern.mat');
[X_pixS(:,1), X_pixS(:,2)] = ind2sub([9 9], compareX);
[Y_pixS(:,1), Y_pixS(:,2)] = ind2sub([9 9], compareY);

%% implmentation
[l g] = DoGDetector(im, sigma0, k, G_L, th_c, th_r);
[ locs, desc ] = computeBrief( im, l, G_L, X_pixS, Y_pixS );
end

