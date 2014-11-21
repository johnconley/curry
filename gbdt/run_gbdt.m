% script to run the GBDT algorithm on per-possession two-point percentage
% data and output the error rate

filename='per_poss.csv';
data_type = 'per_poss';
stat_type = '2P%';
[Xtrain, Ytrain, Xtest, Ytest] = gen_data(data_type, stat_type, filename);

num_trees = 10;
tree_builder = 'random';
max_decisions = 15;
min_leaf = 30;
error_tol = 10^(-6);

fprintf('Running GBDT with %d trees, max %d decisions, min %d examples per leaf\n',...
        num_trees, max_decisions, min_leaf);
fprintf('Predicting statistic %s for %s data\n', stat_type, data_type);
f = gbdt(Xtrain, Ytrain, num_trees, tree_builder, max_decisions, min_leaf, error_tol);
pred_Y = f(Xtest);
percent_error = mean(100 * abs(pred_Y - Ytest) ./ Ytest);
mse = mean((pred_Y - Ytest).^2);

fprintf('Percent error: %.3f\nMean squared error: %.4f\n', percent_error, mse);
