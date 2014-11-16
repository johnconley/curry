% function [mus, sigmas, priors, free_energy_m, likelihood_m] = ldm_maximization(X, prob_c)
function [A, gamma, C, sigma] = ldm_maximization(X, mus, Vs, Js)
% M-step for an LDM
%
% X: [n x num_years] matrix representing num_years of data for one player
% mus: [n x num_years] matrix containing the n-dimensional means of the
%                      num_years gaussians
% Vs: [n x n x num_years]
% Js: [n x n x num_years]
% P_0: [n x n] matrix

% A: [n x n] matrix
% gamma: [n x n] matrix
% C: [n x n] matrix
% sigma: [n x n] matrix

[n, num_years] = size(X);

A_sum1 = zeros(n);
A_sum2 = zeros(n);
for k = 2:num_years
    V_k = Vs(:,:,k);
    V_k1 = Vs(:,:,k-1);
    J_k1 = Js(:,:,k-1);
    mu_k = mus(:,k);
    mu_k1 = mus(:,k-1);

    A_sum1 = A_sum1 + V_k*J_k1' + mu_k*mu_k';
    A_sum2 = A_sum2 + V_k1 + mu_k1*mu_k1';
end
A = A_sum1 / A_sum2; % A = A_sum1*A_sum2^(-1)

gamma = zeros(n,n);
C_sum1 = X(:,1)*mus(:,1)';
C_sum2 = Vs(:,:,1) + mus(:,1)*mus(:,1)';
for k = 2:num_years
    x_k = X(:,k);
    V_k = Vs(:,:,k);
    V_k1 = Vs(:,:,k-1);
    J_k1 = Js(:,:,k-1);
    mu_k = mus(:,k);
    mu_k1 = mus(:,k-1);

    gamma = gamma + V_k + mu_k*mu_k' -A*(J_k1*V_k' + mu_k1*mu_k')...
              - (V_k*J_k1' + mu_k*mu_k1')*A' + A*(V_k1 + mu_k1*mu_k1')*A';
          
    C_sum1 = C_sum1 + x_k*mu_k';
    C_sum2 = C_sum2 + V_k + mu_k*mu_k';
end
gamma = gamma/(num_years-1);
C = C_sum1 / C_sum2; % C = C_sum1*C_sum2^(-1)

sigma = zeros(n,n);
for k = 1:num_years
    x_k = X(:,k);
    V_k = Vs(:,:,k);
    mu_k = mus(:,k);
    
    sigma = sigma + x_k*x_k' - C'*mu_k*x_k'...
                  - x_k*mu_k'*C + C'*(V_k + mu_k*mu_k')*C;
end
sigma = sigma/num_years;

% INPUT:
%  X: [m x n] matrix, where each row is an n-dimensional input example
%  prob_c: [K x m] matrix, containing the the posterior probabilities over the K Gaussians for the m examples.
%                  Please see the comments in q5_GM_Expectation.m
%
% OUTPUT:
%  mus: [n x K] matrix containing the n-dimensional means of the K gaussians
%  sigmas: [n x n x K] 3-dimensional matrix, where each matrix sigmas(:,:,i) is the [n x n] 
%                           covariance matrix of the i-th Gaussian.
%  priors: [1 x K] vector, containing the mixture priors of the K Gaussians.
%  free_energy_m: [1 x 1] scalar value representing the free energy value
%  likelihood_m: [1 x 1] scalar value representing the log-likelihood value

% [m, n] = size(X);
% K = size(prob_c,1);
% prob_c_sums = sum(prob_c,2);
% priors = prob_c_sums'/m;
% 
% mus = zeros(n,K);
% sigmas = zeros(n,n,K);
% free_energy_m = 0;
% likelihood_m = 0;
% for j = 1:K
%     gamma_j = prob_c(j,:);
%     mu = transpose(gamma_j*X / prob_c_sums(j));
%     mus(:,j) = mu;
%     
%     sigma = zeros(n,n);
%     for i = 1:m
%         x = X(i,:) - mu'; % row vector
%         sigma = sigma + gamma_j(i) * (x'*x);
%     end
%     sigma = sigma / prob_c_sums(j);
%     sigmas(:,:,j) = sigma;
%     
%     p_x = 0;
%     for i = 1:m
%         x = X(i,:);
%         p_x_given_z = exp(q5_logprobgauss(x,mu,sigma));
%         p_x = p_x + p_x_given_z*priors(j);
%         free_energy_m = free_energy_m + prob_c(j,i) * (log(p_x_given_z) ...
%                         + log(priors(j)) - log(prob_c(j,i)));
%     end
%     likelihood_m = likelihood_m + log(p_x);
%     
% end

end