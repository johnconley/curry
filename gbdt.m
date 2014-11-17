function f = gbdt(X, Y)

M = 10;
delta = 1;
min_leaf = 5;
avg_Y = mean(Y);

% initialize model with a constant value
hs = cell(M,1);
bs = zeros(M,1);
hs{1} = 1;
bs(1) = avg_Y;

for i = 2:M
    % compute pseudo-residuals
    predictions = predict_gbdt(X, bs, hs, i-1);
    residuals = Y - predictions;
    
    % train a decision tree on pseudo-residuals
    % replace with our own decision tree calculator
    h = fitrtree(X, residuals, 'MinLeaf', min_leaf);
    hs{i} = h;
    
    % find arg min_b huber_loss(Y,pred_Y)
    b1 = bs(1:i-1);
    b2 = bs(i+1:end);
    g = @(b) huber_loss(Y, predict_gbdt(X, [b1;b;b2], hs, i), delta);
    bs(i) = fmincon(g,1,[],[],[],[],0,20);
end

f = @(x) predict_gbdt(x, bs, hs);

end