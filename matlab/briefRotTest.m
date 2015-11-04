%% Author: Bishwamoy Sinha Roy
clear;

im = imread('../data/model_chickenbroth.jpg');
im = im2double(rgb2gray(im));
[l, d] = briefLite(im);

matches_num  = zeros(37, 2);

for deg = 0:10:360
    im_rot = imrotate(im, deg);
    [l_rot, d_rot] = briefLite(im_rot);
    m = briefMatch(d, d_rot);
    
    %figure;
    %plotMatches(im, im_rot, m, l, l_rot);
    
    matches_num((deg/10) + 1, 1) = size(m, 1);
    matches_num((deg/10) + 1, 2) = deg;
end
bar(matches_num(:,2), matches_num(:,1));