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
% f(x, M): linear combination of decision trees

delta = 1;

% initialize model with a constant value
hs = cell(num_trees,1);
bs = zeros(num_trees,1);
hs{1} = 1;
bs(1) = mean(Y);

for i = 2:num_trees+1
    disp(i);
    % compute residuals
    predictions = predict_gbdt(X, bs, hs, i-1);
    residuals = Y - predictions;
    
    % train a decision tree on the residuals
    h = decision_tree(X, residuals, tree_builder, max_decisions, ...
                      min_leaf, error_tol);
    hs{i} = h;
    
    % explain why we altered this
    % find arg min_b huber_loss(Y,pred_Y)
%     b1 = bs(1:i-1);
%     b2 = bs(i+1:end);
%     g = @(b) huber_loss(Y, predict_gbdt(X, [b1;b;b2], hs, i), delta);
%     bs(i) = fmincon(g,1,[],[],[],[],0,20);
    bs(i) = 1;
end

f = @(x, M) predict_gbdt(x, bs, hs, M);

end
