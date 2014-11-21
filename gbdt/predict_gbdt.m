function Y = predict_gbdt(X, hs, M)
% Input
% -----
% X: [m x n] matrix of training input data
% hs: [num_trees x 1] cell of trees
% M: number of terms to sum
%
% Output
% ------
% Y: [m x 1] vector of predicted output

switch nargin
    case 2
        M = size(hs,1);
end

m = size(X,1);
Y = zeros(m,1);
for i = 1:m
    x = X(i,:);
    y = hs{1};
    for j = 2:M
        h = hs{j};
        y = y + predict_tree(x, h);
    end
    Y(i) = y;
end

end
