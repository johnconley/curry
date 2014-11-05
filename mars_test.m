function finalerr = mars_test(Xtrain, Ytrain, Xtest,Ytest, max_terms)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
[knots, B] = mars(Xtrain, Ytrain, max_terms);
H = mars_features(knots, Xtest);
finalerr = mars_error(B, H, Ytest);

end

