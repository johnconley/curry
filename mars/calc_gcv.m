function r = calc_gcv(m, mars_terms, c, rss)
% Input
% -----
% m: number of training examples
% mars_terms: number of terms in the model
% c: penalty for terms (usually around 2 or 3); smaller c => more complex model
% RSS: residual sum of squares measured on the training data
%
% Output
% ------
% r: generalized cross validation

params = mars_terms + c * (mars_terms-1)/2;
r = rss / (m * (1 - params/m)^2);

end
