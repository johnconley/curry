% filename='data/stats_per_poss_no1979_fixed.csv';
% data_type = 'per_poss';
% [Xtrain, Ytrain, Xtest, Ytest] = gen_data(data_type, filename);

% on per possession data, all players, 10 trees, 15 decisions,
% min_leaf = 30, and tree_builder = 'all', our decision tree achieved 9.18%
% error when predicting 2 point percentage (ARESlab 7.61, linear r. 7.65)
num_trees_list = [4,8,12,16,20];
tree_builder = 'all';
max_decisions = 15;
% min_leaf = 30;
min_leaf = 100;
error_tol = 10^(-6);

error = zeros(size(num_trees_list));
f = gbdt(Xtrain, Ytrain, max(num_trees_list), tree_builder, max_decisions, min_leaf, error_tol);
for i = 1:size(num_trees_list,2)
    num_trees = num_trees_list(i);
    pred_Y = f(Xtest, num_trees+1);
    error(i) = mean(100 * abs(pred_Y - Ytest) ./ Ytest);
end
plot(error);
