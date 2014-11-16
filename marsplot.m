function marsplot()
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

 [Xtrain, Ytrain, Xtest, Ytest] = gen_data();


max_terms = [1];

error = zeros(size(max_terms));
error2 = zeros(size(max_terms));
error3 = zeros(size(max_terms));
error4 = zeros(size(max_terms));
[knots_l, B, H_l] = forward_pass(Xtrain, Ytrain, max(max_terms), 'linear');
[knots_q, B, H_q] = forward_pass(Xtrain, Ytrain, max(max_terms), 'quadratic');
for i=1:max(max_terms)
    B_l = ((H_l' * H_l) \ H_l') * Ytrain;
    B_q = ((H_q' * H_q) \ H_q') * Ytrain;
    H_fl = mars_features(Xtest, knots_l);
    H_fq = mars_features(Xtest, knots_q);
    pred_Y_l = H_fl * B_l;
    pred_Y_q = H_fq * B_q;
    error2(max(max_terms) + 1 - i) = mean((Ytest - pred_Y_l).^2);
    error4(max(max_terms) + 1 - i) = mean((Ytest - pred_Y_q).^2);
    H_fl = mars_features(Xtrain, knots_l);
    H_fq = mars_features(Xtrain, knots_q);
    pred_Y_l = H_fl * B_l;
    pred_Y_q = H_fq * B_q;
    error(max(max_terms) + 1 - i) = mean((Ytrain - pred_Y_l).^2);
    error3(max(max_terms) + 1 - i) = mean((Ytrain - pred_Y_q).^2);
    knots_l(size(knots_l,1),:) = [];
    knots_l(size(knots_l,1),:) = [];
    knots_q(size(knots_q,1),:) = [];
    knots_q(size(knots_q,1),:) = [];
    H_l(:,size(H_l,2))=[];
    H_l(:,size(H_l,2))=[];
    H_q(:,size(H_q,2))=[];
    H_q(:,size(H_q,2))=[];
end

figure;
%{
for i=1:size(max_terms,2)
    disp(max_terms(i))
    error(i) = mars_test(Xtrain, Ytrain, Xtrain, Ytrain, max_terms(i),'linear');
    error2(i) = mars_test(Xtrain, Ytrain, Xtest, Ytest, max_terms(i),'linear');
    error3(i) = mars_test(Xtrain, Ytrain, Xtrain, Ytrain, max_terms(i),'quadratic');
    error4(i) = mars_test(Xtrain, Ytrain, Xtest, Ytest, max_terms(i),'quadratic');
end
%}



plot(max_terms, error, 'r-o', max_terms, error2, 'b-x', max_terms, error3, 'g-+', max_terms, error4, 'k-d');


end
