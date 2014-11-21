function f = gbdt(X, Y, num_trees, tree_builder, max_decisions, min_leaf, error_tol)

delta = 1;
[m, n] = size(X);
avg_Y = mean(Y);

% initialize model with a constant value
hs = cell(num_trees,1);
bs = zeros(num_trees,1);
hs{1} = 1;
bs(1) = avg_Y;

for i = 2:num_trees+1
    disp(i);
    % compute pseudo-residuals
    predictions = predict_gbdt(X, bs, hs, i-1);
    residuals = Y - predictions;
    
    % train a decision tree on pseudo-residuals
%     h = fitrtree(X,residuals,'MinLeaf',min_leaf,'Prune','off');
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

f = @(x) predict_gbdt(x, bs, hs);

end
