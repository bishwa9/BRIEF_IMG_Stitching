function [ locs_v, desc ] = computeBrief( im, locs, lvls, X, Y )
%% Comments
%INPUTS:
%im     =   image in grayscale and 0-1
%locs   =   location of feature poits
%lvls   =   DoG levels
%X      =   points in patch (check BRIEF: Binary Robust Independent Elementary Features)
%Y      =   points in patch (check BRIEF: Binary Robust Independent Elementary Features)
%Outputs
%locs_v   =   location of feature points
%desc   =   corresponding BRIEF descriptor

%% Implementation
p_sz    = 9;
n       = 256;
locs_v  = zeros(size(locs));%valid locations
desc    = zeros(size(locs,1), n);

G_L = [-1:4];
k = sqrt(2);
sigma0 = 1;

G_P = createGaussianPyramid(im, sigma0, k, G_L);
[DoG_P, DoG_L] = createDoGPyramid(G_P, G_L);

for i=1:size(locs,1)
    layer_num = find(DoG_L == locs(i,3));
    [p, v] = getPatch(DoG_P, p_sz, locs(i,2), locs(i,1), layer_num); 
    if(v == 1)
        locs_v(i,:) = locs(i,:);
        p_X = diag( p(X(:,1), X(:,2)) );
        p_Y = diag( p(Y(:,1), Y(:,2)) );
        t = p_X < p_Y;
        desc(i,:) = t.';
    end
end
locs_v(all(locs_v==0,2),:)  = [];
desc(all(desc==0,2),:)      = [];
end
%% 
function [patch, valid] = getPatch(DoG, patch_sz, p_r, p_c, p_l)
%% Comments
%INPUTS:
%im     =   image in grayscale and 0-1
%p_sx   =   desire patch size
%p_r    =   patch center row
%p_c    =   patch cetner collumn
%p_l    =   patch center level
%Outputs
%patch  =   patch
%valid  =   false if center is near edge of im

%% Implementation
min_r = 1;
min_c = 1;
max_r = size(DoG, 1);
max_c = size(DoG, 2);

%figure out if center is near edge
%NOTE: patch size has to be even...
div = floor(patch_sz / 2);
r_s = p_r - div;
r_e = p_r + div;
c_s = p_c - div;
c_e = p_c + div;

patch = zeros(patch_sz, patch_sz);

if(r_s > min_r & r_e < max_r & c_s > min_c & c_e < max_c)
    valid = 1;
    patch(:,:) = DoG(r_s:r_e, c_s:c_e);
else
    valid = 0;
    patch = [];
end
%%
end