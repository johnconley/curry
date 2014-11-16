% function [mus, sigmas, priors] = ldm_fit(X, mus_init, sigmas_init, priors_init, num_iterations)
function [A, gamma, C, sigma] = ldm_fit(X, mu0, P0, num_iterations)
% Learn a Linear Dynamical model (LDM) using the EM algorithm
%
% INPUT:
%  X: [m x n] matrix, where each row is an n-dimensional input example
%  mus_init: [n x K] matrix containing the n-dimensional means of the K gaussians
%  sigmas_init: [n x n x K] 3-dimensional matrix, where each matrix sigmas(:,:,i) is the [n x n] 
%                           covariance matrix of the i-th Gaussian
%  priors_init: [1 x K] vector, containing the mixture priors of the K Gaussians.
%  num_iterations: [1 x 1] scalar value, indicating the number of EM iterations.
%
% OUTPUT:
%  mus: [n x K] matrix containing the d-dimensional means of the K gaussians
%  sigmas: [n x n x K] 3-dimensional matrix, where each matrix sigmas(:,:,i) is the [n x n] 
%                      covariance matrix of the i-th Gaussian
%  priors: [1 x K] vector, containing the mixture priors of the K Gaussians.

n = size(X,1);
% A = eye(n);
% gamma = zeros(n);
% C = eye(n);
% sigma = zeros(n);
A = rand(n);
gamma = rand(n);
C = rand(n);
sigma = rand(n);

for iteration = 1:num_iterations
    [mus, Vs, Js] = ldm_expectation(X, mu0, P0, A, gamma, C, sigma);
    [A, gamma, C, sigma] = ldm_maximization(X, mus, Vs, Js);
end

end
