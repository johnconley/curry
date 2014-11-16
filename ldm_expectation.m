% function [prob_c, free_energy_e, likelihood_e] = ldm_expectation(X, mus, sigmas, priors)
function [mu_hats, V_hats, Js] = ldm_expectation(X, mu0, P0, A, gamma, C, sigma)
% E-step for an LDM

[n, num_years] = size(X);

mus = zeros(n, num_years);
Ps = zeros(n,n,num_years);
Vs = zeros(n,n,num_years);
Ks = zeros(n,n,num_years);

Ks(:,:,1) = P0*C' / (C*P0*C' + sigma); % K1 = P0*C'*(C*P0*C'+sigma)^(-1)
mus(:,1) = mu0 + Ks(:,:,1)*(X(:,1) - C*mu0);
Vs(:,:,1) = (eye(n) - Ks(:,:,1)*C)*P0;
for k = 2:num_years
    Ps(:,:,k-1) = A*Vs(:,:,k-1)*A' + gamma;
    Ks(:,:,k) = Ps(:,:,k-1)*C' / (C*Ps(:,:,k-1)*C' + sigma);
    mus(:,k) = A*mus(:,k-1) + Ks(:,:,k)*(X(:,k) - C*A*mus(:,k-1));
    Vs(:,:,k) = (eye(n) - Ks(:,:,k)*C) * Ps(:,:,k-1);
end

Js = zeros(n,n,num_years);
for k = 2:num_years
    Js(:,:,k) = Vs(:,:,k)*A' / Ps(:,:,k);
end

mu_hats = zeros(n, num_years);
mu_hats(:,num_years) = mus(:,num_years);
V_hats = zeros(n,n,num_years);
V_hats(:,:,num_years) = Vs(:,:,num_years);
for k = num_years-1:-1:1
    mu_hats(:,k) = mus(:,k) + Js(:,:,k)*(mu_hats(:,k+1) - A*mus(:,k));
    V_hats(:,:,k) = Vs(:,:,k) + Js(:,:,k)*(V_hats(:,:,k+1) - Ps(:,:,k))*Js(:,:,k)';
end

% INPUT:
%  X: [m x n] matrix, where each row is an n-dimensional input example
%  mus: [n x K] matrix containing the n-dimensional means of the K Gaussians
%  sigmas: [n x n x K] 3-dimensional matrix, where each matrix sigmas(:,:,i) is the [n x n] 
%                           covariance matrix of the i-th Gaussian
%  priors: [1 x K] vector, containing the mixture priors of the K Gaussians.
%
% OUTPUT:
%  prob_c: [K x m] matrix, containing the posterior probabilities over the K Gaussians for the m examples.
%          Specifically, prob_c(j, i) represents the probability that the
%          i-th example belongs to the j-th Gaussian, 
%          i.e., P(z^(i) = j | X^(i,:))
%  free_energy_e: [1 x 1] scalar value representing the free energy value
%  likelihood_e: [1 x 1] scalar value representing the log-likelihood value

% m = size(X,1);
% K = size(priors,2);
% 
% prob_c = zeros(K,m);
% free_energy_e = 0;
% likelihood_e = 0;
% for i = 1:m
%     x = X(i,:);
%     p_x = 0;
%     for j = 1:K
%         mu = mus(:,j);
%         sigma = sigmas(:,:,j);
%         p_x_given_z = exp(q5_logprobgauss(x,mu,sigma));
%         p_x = p_x + p_x_given_z*priors(j);
%     end
%     likelihood_e = likelihood_e + log(p_x);
%     
%     for j = 1:K
%         mu = mus(:,j);
%         sigma = sigmas(:,:,j);
%         p_x_given_z = exp(q5_logprobgauss(x,mu,sigma));
%         prob_c(j,i) = p_x_given_z*priors(j)/p_x;
%         free_energy_e = free_energy_e + prob_c(j,i)*log(p_x);
%     end
% end

end