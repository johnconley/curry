function [knots, B, H] = mars(X, Y, max_terms, mode)
% X: [m x n] matrix of training input data
% Y: [m x 1] vector of training output data
% max_terms: maximum numbers of terms in the model

[knots, B, H] = forward_pass(X, Y, max_terms, mode);
[knots, B]  = backward_pass(X, Y, knots, B);

end
