function r = gcv(m, mars_terms, c, rss)
% m - number of training examples
% mars_terms - number of terms in the model
% c - penalty for terms (usually around 2 or 3)
% RSS - residual sum of squares measured on the training data

params = mars_terms + c * (mars_terms-1)/2;
r = rss / (m * (1 - params/m)^2);

end
