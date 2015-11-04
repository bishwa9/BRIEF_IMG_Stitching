function [ P_C ] = computePrincipalCurvature( DoG_P )
%COMPUTEPRINCIPALCURVATURE 

%gradients
[Fx,  Fy] = gradient(DoG_P);
[Fxx, Fxy] = gradient(Fx);
[Fyx, Fyy] = gradient(Fy);

%element wise craetion of Hessian then calculation of R
P_C = arrayfun(@comp_r, Fxx, Fxy, Fyx, Fyy);
end

function [R] = comp_r(Dxx, Dxy, Dyx, Dyy)
    H = [Dxx, Dxy; Dyx, Dyy];
    R = trace(H).^2 / det(H);
end