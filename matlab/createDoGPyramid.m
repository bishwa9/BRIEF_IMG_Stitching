function [ DoG_P, DoG_Ls ] ...
    = createDoGPyramid( G_P, Ls )
%CREATEDOGPYRAMID 
%Create Difference of Gaussian Pyramid using the Gausian Pyramid

R = size(G_P, 1); %Number of Rows in Gaussian Pyramid Img
C = size(G_P, 2); %Number of Cols in Gaussian Pyramid Img
DoG_Ls = Ls(2:size(Ls,2));
DoG_P = diff(G_P, [], 3);
end

