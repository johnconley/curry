function marsplot(years, data_type, filename, max_value, position, data_size)
%{ 
    Input
        Years: 1 or 2 (2 found to reduce data accuracy)
        Data_Type: 'totals' or 'pos' (totals has high error rate)
        filename: Input file name
        max_value: max number of knots
        position: position of players
        data_size: 100 or anything else=all
        
%}

 [Xtrain, Ytrain, Xtest, Ytest] = gen_data(years, data_type, filename, data_size);


max_terms = [1:max_value];

errorl = zeros(size(max_terms));
errorq = zeros(size(max_terms));
error_mse_l = zeros(size(max_terms));
error_mse_q = zeros(size(max_terms));

[knots_l, B, H_l] = forward_pass(Xtrain, Ytrain, max(max_terms), 'linear');
[knots_q, B, H_q] = forward_pass(Xtrain, Ytrain, max(max_terms), 'quadratic');
for i=1:max(max_terms)
    B_l = ((H_l' * H_l) \ H_l') * Ytrain;
    B_q = ((H_q' * H_q) \ H_q') * Ytrain;
    [knots_back_l, B_back_l] = backward_pass(Xtrain,Ytrain,knots_l,B_l);
    [knots_back_q, B_back_q] = backward_pass(Xtrain,Ytrain,knots_q,B_q);
    H_fl = mars_features(Xtest, knots_back_l);
    H_fq = mars_features(Xtest, knots_back_q);
    pred_Y_l = H_fl * B_back_l;
    pred_Y_q = H_fq * B_back_q;
    errorl(max(max_terms) + 1 - i) = mean(abs(100*(Ytest - pred_Y_l)./Ytest));
    errorq(max(max_terms) + 1 - i) = mean(abs(100*(Ytest - pred_Y_q)./Ytest));
    error_mse_l(max(max_terms) + 1 - i) = mean((Ytest - pred_Y_l).^2);
    error_mse_q(max(max_terms) + 1 - i) = mean((Ytest - pred_Y_q).^2);
    %{
    H_fl = mars_features(Xtrain, knots_back_l);
    H_fq = mars_features(Xtrain, knots_back_q);
    pred_Y_l = H_fl * B_back_l;
    pred_Y_q = H_fq * B_back_q;
    error(max(max_terms) + 1 - i) = mean((Ytrain - pred_Y_l).^2);
    error3(max(max_terms) + 1 - i) = mean((Ytrain - pred_Y_q).^2);
    %}
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
set(gcf,'color','white')
subplot(1,2,1)
plot(max_terms, errorl, 'r-o', max_terms, errorq, 'b-x', 'LineWidth',2);
if strcmp(data_type,'totals') == 1
    title(strcat('M.A.R.S. Totals(',position,')'), 'fontsize', 14);
else
    title(strcat('M.A.R.S. Per 100 Possession(',position,')'), 'fontsize', 14);
end
xlabel('Max Number of Knots', 'fontsize', 12);
ylabel('Percent Error', 'fontsize', 12);
legend('Linear','Quadratic');

subplot(1,2,2)
plot(max_terms, error_mse_l, 'r-o', max_terms, error_mse_q, 'b-x', 'LineWidth',2);
if strcmp(data_type,'totals') == 1
    title(strcat('M.A.R.S. Totals(',position,')'), 'fontsize', 14);
else
    title(strcat('M.A.R.S. Per 100 Possession(',position,')'), 'fontsize', 14);
end
xlabel('Max Number of Knots', 'fontsize', 12);
ylabel('Mean Squared Error', 'fontsize', 12);
legend('Linear','Quadratic');






%{
for i=1:size(max_terms,2)
    disp(max_terms(i))
    error(i) = mars_test(Xtrain, Ytrain, Xtrain, Ytrain, max_terms(i),'linear')
    error2(i) = mars_test(Xtrain, Ytrain, Xtest, Ytest, max_terms(i),'linear')
    error3(i) = mars_test(Xtrain, Ytrain, Xtrain, Ytrain, max_terms(i),'quadratic')
    error4(i) = mars_test(Xtrain, Ytrain, Xtest, Ytest, max_terms(i),'quadratic')
end
%}


%{
Old plotting
plot(max_terms, error, 'r-o', max_terms, error2, 'b-x', max_terms, error3, 'g-+', max_terms, error4, 'k-d','LineWidth',2);
title('M.A.R.S. Test on Season Totals(One Year)', 'fontsize', 14);
xlabel('Max number of knots', 'fontsize', 12);
ylabel('Mean Squared Error', 'fontsize', 12);
legend('Linear-Train','Linear-Test','Quadratic-Train','Quadratic-Test');
%}

end
