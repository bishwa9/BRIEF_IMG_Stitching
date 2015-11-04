function [ H2to1 ] = computeH( p1, p2 )
%% p1 = H2to1 * p2
%Inputs 
%p1 = n-points from Camera 1 (2 x n in non-homogenous coordinates)
%p2 = n-points from Camera 2 (2 x n in non-homogenous coordinates)
%Output
%H2to1 = 3x3 homography matrix to transform from C2 to C1.

%% checks
N1 = size(p1, 1);
N2 = size(p2, 1);

if( N1 ~= N2 ) 
    error('ERROR: size mismatch');
end

%% variables
N = N1;
num_vars = 9;
DOF = num_vars - 1;
p1_hom = ones(3, N); 
p2_hom = ones(3, N); 
A = zeros(2*N, num_vars);
p1 = p1.';
p2 = p2.';

%% implementation
p1_hom(1:2, :) = p1;
p2_hom(1:2, :) = p2;

A(1:N, 1:3) = -1*(p2_hom.');
A((N+1):(2*N), 4:6) = -1*(p2_hom.');

mat_helper = [p1(1,:).'; p1(2,:).'];
mat_helper2 = [p2(1,:).';p2(1,:).'];
mat_helper3 = [p2(2,:).';p2(2,:).'];

A(:, 7) = mat_helper.*mat_helper2;
A(:, 8) = mat_helper.*mat_helper3;
A(:, 9) = mat_helper; 

[U, S, V] = svd(A);

S = diag(S);
%S = S.^2;
[~,mini] = min(S);
H2to1 = V(:, mini);
H2to1 = (reshape(H2to1, [3,3])).';
end

