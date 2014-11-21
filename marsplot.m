function marsplot(years, data_type, stat_type, filename, max_value, position, data_size)
%{ 
    Input
        Years: 1 or 2 (2 found to reduce data accuracy)
        data_type: 'totals' or 'pos' (totals has high error rate)
        stat_type{2P%,TRB,AST, PTS}
        filename: Input file name
        max_value: max number of knots
        position: position of players
        data_size: 'full' or 'partial'(100 players)
        
%}

 [Xtrain, Ytrain, Xtest, Ytest] = gen_data(years, data_type, stat_type, filename, data_size);
 %{
B = q5_features(Xtrain, 'linear');
theta = (B' * B) \ B' * Ytrain;
pred_Y = q5_features(Xtest,'linear') * theta;
pe_l = mean(abs(100*(Ytest - pred_Y)./Ytest));
B = q5_features(Xtrain, 'quadratic');
theta = (B' * B) \ B' * Ytrain;
pred_Y = q5_features(Xtest,'quadratic') * theta;
pe_q = mean(abs(100*(Ytest - pred_Y)./Ytest));
%}
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
    title(strcat(stat_type,' Totals(',position,')'), 'fontsize', 14);
else
    title(strcat(stat_type, ' Per 100 Possession(',position,')'), 'fontsize', 14);
end
xlabel('Max Number of Knots', 'fontsize', 12);
ylabel('Percent Error', 'fontsize', 12);
legend('MARS-Linear','MARS-Quadratic');
%{
data(1) = 1;
data(2) = max_value;
pe_l = pe_l * [1 ,1];
pe_q = pe_q * [1,1];
plot(max_terms, errorl, 'r-o', max_terms, errorq, 'b-x', data, pe_l, 'g-*', data, pe_q, 'k-+', 'LineWidth',2);
%}

subplot(1,2,2)
plot(max_terms, error_mse_l, 'r-o', max_terms, error_mse_q, 'LineWidth',2);
if strcmp(data_type,'totals') == 1
    title(strcat(stat_type, ' Totals(',position,')'), 'fontsize', 14);
else
    title(strcat(stat_type, ' Per 100 Possession(',position,')'), 'fontsize', 14);
end
xlabel('Max Number of Knots', 'fontsize', 12);
ylabel('Mean Squared Error', 'fontsize', 12);
legend('MARS-Linear','MARS-Quadratic');

i = 1;
true = 1;
while(true == 1)
    savename = strcat(position, '_', data_type, '_', stat_type, '_', num2str(max_value), '_size(', num2str(data_size), ')_', num2str(i), '.fig');
    if(exist(savename, 'file')  == 0)
        true = 0;
    else
        i = i+1;
    end
end
savefig(savename);


end
