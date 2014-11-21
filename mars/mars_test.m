function error = mars_test(Xtrain, Ytrain, Xtest, Ytest, max_terms, mode)
% Xtrain: [m x n] matrix of training input data
% Ytrain: [m x 1] vector of training input data
% Xtest: [k x n] matrix of test input data
% Ytest: [k x 1] vector of test input data
% max_terms: maximum numbers of terms in the model

[knots, B, H] = mars(Xtrain, Ytrain, max_terms, mode);
H = mars_features(Xtest, knots);
pred_Y = H * B;
error = mean((Ytest - pred_Y).^2);

end
