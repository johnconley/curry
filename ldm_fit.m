function [mu0, V0, A, gamma, C, sigma] = ldm_fit(X, mu0_init, V0_init, num_iterations)
% Learn a Linear Dynamical model (LDM) using the EM algorithm
%
% INPUT:
%  X: [n x num_years] matrix, where each column is an n-dimensional input example
%
% OUTPUT:
% A: [n x n] matrix
% gamma: [n x n] matrix
% C: [n x n] matrix
% sigma: [n x n] matrix

n = size(X,1);
% A = eye(n);
% gamma = zeros(n);
% C = eye(n);
% sigma = zeros(n);
A = rand(n);
gamma = rand(n);
C = rand(n);
sigma = rand(n);

mu0 = mu0_init;
V0 = V0_init;

for iteration = 1:num_iterations
    [mu_hats, V_hats, Js] = ldm_expectation(X, mu0, V0, A, gamma, C, sigma);
    [mu0, V0, A, gamma, C, sigma] = ldm_maximization(X, mu_hats, V_hats, Js);
end

end
