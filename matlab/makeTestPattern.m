function [ X_pix, Y_pix ] = makeTestPattern( width, n )
mu = 0;
sigma = sqrt( (width.^2) / 25 );

one_v = ones(1,n);

min = -4; max = 4;

rand_n = floor(normrnd(mu, sigma, [n 4]));
rand_n(rand_n < min) = min;
rand_n(rand_n > max) = max;

X_raw = [rand_n(:,1), rand_n(:,2)];
Y_raw = [rand_n(:,3), rand_n(:,4)];

X_hom = [X_raw(:,1).'; X_raw(:,2).'; one_v];
Y_hom = [Y_raw(:,1).'; Y_raw(:,2).'; one_v];

trans = [0 -1 4;
         1 0 4;
         0 0 1];

X_pix = trans*X_hom; %Beginning pixel is 1,1 not 0,0
Y_pix = trans*Y_hom;

X_pix = [X_pix(1,:).' + 1, X_pix(2,:).' + 1];
Y_pix = [Y_pix(1,:).' + 1, Y_pix(2,:).' + 1];

X_pix = sub2ind([9 9], X_pix(:,1), X_pix(:,2));
Y_pix = sub2ind([9 9], Y_pix(:,1), Y_pix(:,2));

save('testPattern.mat', 'X_pix', 'Y_pix');
end