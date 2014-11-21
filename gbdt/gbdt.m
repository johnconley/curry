function f = gbdt(X, Y, num_trees, tree_builder, max_decisions, min_leaf, error_tol)
% Input
% -----
% X: [m x n] matrix of training input data
% Y: [m x 1] vector of training output data
% num_trees: number of trees in the model
% tree_builder: 'random' or 'all'
% max_decisions: maximum number of decisions in a tree
% min_leaf: minimum number of examples in a leaf
% error_tol: minimum error decrease for a decision of a decision tree
%
% Output
% ------
% f(x): linear combination of decision trees

% initialize model with a constant value
hs = cell(num_trees,1);
hs{1} = mean(Y);

for i = 2:num_trees+1
    % compute residuals
    predictions = predict_gbdt(X, hs, i-1);
    residuals = Y - predictions;
    
    % train a decision tree on the residuals
    hs{i} = decision_tree(X, residuals, tree_builder, max_decisions, ...
                      min_leaf, error_tol);
end

f = @(x) predict_gbdt(x, hs);

end
