function marsplot()
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

% [Xtrain, Ytrain, Xtest, Ytest] = gen_data();
S = load('autompg.mat');
Xtrain = S.trainsetX;
Ytrain = S.trainsetY;
Xtest = S.testsetX;
Ytest = S.testsetY;
clear S

max_terms = [10, 50, 100, 200];
max_terms = [8,12,16,20,24];
max_terms = [10, 50];
error = zeros(size(max_terms));
figure;
for i=1:size(max_terms,2)
    disp(max_terms(i))
    error(i) = mars_test(Xtrain, Ytrain, Xtest, Ytest, max_terms(i));
end

plot(max_terms, error, '-db');

end
