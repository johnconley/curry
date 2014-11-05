function marsplot()
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

[Xtrain, Ytrain, Xtest, Ytest] = regress();

max_terms = [10,50, 100, 200];
figure;
for i=1:size(max_terms,2)
disp(max_terms(i))
err(i) = mars_test(Xtrain,Ytrain,Xtest,Ytest,max_terms(i));
end

plot(max_terms, err,'-db');

end

