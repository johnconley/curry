function error = mars_test(Xtrain, Ytrain, Xtest, Ytest, max_terms)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

[knots, B] = mars(Xtrain, Ytrain, max_terms);
H = mars_features(Xtest, knots);

pred_Y = H * B;
error = mean((Ytest - pred_Y).^2);

end

