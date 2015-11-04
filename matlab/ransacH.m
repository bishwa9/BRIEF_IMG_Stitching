function [bestH] = ransacH(matches, locs1, locs2, nIter, tol)
%%
%Inputs
%matches    = matches between the breif descriptors
%locs1      = locations of matching points in image 1
%locs2      = locations of matching points in image 2
%nIter      = iterations for RANSAC
%to1        = tolerance for determining inliers (abs(err) < tol -> inlier)
%Outputs
%bestH      = H chosen from nIter iterations with a tol tolerance to
%             classify inliers
%% variables
num_matches         = size(matches, 1);
best_h              = zeros(3,3);
best_num_inliers    = 0;

%% implementation

%create a p1s and p2s
p1 = locs1(matches(:,1), 1:2);
p2 = locs2(matches(:,2), 1:2);
p1_hom = [p1, ones(num_matches, 1)].';
p2_hom = [p2, ones(num_matches, 1)].';

for i = 1:nIter
    i
    ns = randperm(num_matches, 4).';
    p1_sub = p1(ns, :);
    p2_sub = p2(ns, :);
    h2to1_hypo = computeH(p1_sub, p2_sub); %hypothesis
    p1_hypo = ( h2to1_hypo * p2_hom ).';      %use hypothesis
    p1_div = repmat(p1_hypo(:,3), [1 2]);
    p1_hypo = p1_hypo(:, 1:2) ./ p1_div;
    
    err_hypo = diag( pdist2(p1_hypo, p1) ); %calc error
    
    inliers_hypo = err_hypo( err_hypo < tol ); %count inliers
     
    if( best_num_inliers < size(inliers_hypo,1) )
        %figure;
        %plot(err_hypo);
        best_num_inliers = size(inliers_hypo,1);
        best_h = h2to1_hypo;
    end
end

bestH = best_h;
end