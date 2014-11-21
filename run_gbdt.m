years = 1;
filename='data/stats_per_poss_no1979_fixed.csv';
data_type = 'per_poss';
[Xtrain, Ytrain, Xtest, Ytest] = gen_data(years, data_type, filename, 1000);

% on per possession data, all players, 10 trees, 15 decisions,
% min_leaf = 30, and tree_builder = 'all', our decision tree achieved 9.18%
% error when predicting 2 point percentage (ARESlab 7.61, linear r. 7.65)
num_trees = 10;
tree_builder = 'all';
max_decisions = 15;
% min_leaf = 30;
min_leaf = 100;
error_tol = 10^(-6);
f = gbdt(Xtrain, Ytrain, num_trees, tree_builder, max_decisions, min_leaf, error_tol);
pred_Y = f(Xtest);
error = 100 * abs(pred_Y - Ytest)./Ytest;
% for i = 1:size(error), if error(i) == Inf, error(i) = 0; end; end
disp(mean(error));
plot(error);
