function [locs, G_P] ...
    = DoGDetector(im, sigma0, k, levels, th_c, th_r)

    G_P = createGaussianPyramid(im, sigma0, k, levels);
    [DoG_P, DoG_L] = createDoGPyramid(G_P, levels);
    P_C = computePrincipalCurvature(DoG_P);
    locs = getLocalExtrema(DoG_P, DoG_L, P_C, th_c, th_r);
end

