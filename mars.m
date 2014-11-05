function [knots, B] = mars(X, Y, max_terms)
% X: [m x n] matrix of training input data
% Y: [m x 1] vector of training output data
% max_terms: maximum numbers of terms in the model

[knots, B] = forward_pass(X, Y, max_terms);
[knots, B]  = backward_pass(X, Y, knots, B);

end
