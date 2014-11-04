function theta = train(X, Y, lambda, mode)
% Trains the regularized least squares regression model using the closed form solution given the training data X, Y.
%
% INPUT:
%  X: [m x d] matrix, where each row is a d-dimensional input example
%  Y: [m x 1] vector, where the i-th element is the correct output value for the i-th input example. 
%  lambda: regularization hyperparameter (scalar value)
%  mode: type of features, either 'linear' or 'quadratic'. 
%
% OUTPUT:
%  theta: [n x 1] vector, containing the learned model parameters.
%

B = features(X, mode);
E = lambda * eye(size(B, 2));
E(1,1) = 0;

theta = (B' * B + E) \ (B' * Y);

end