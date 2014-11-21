function Y = predict_gbdt(X, bs, hs, M)
% Input
% -----
% X: [m x n] matrix of training input data
% bs: [num_trees x 1] vector of coefficients for elements of hs
% hs: [num_trees x 1] cell of trees
% M: number of terms to sum
%
% Output
% ------
% Y: [m x 1] vector of predicted output

switch nargin
    case 3
        M = size(bs,1);
end

m = size(X,1);
Y = zeros(m,1);
for i = 1:m
    x = X(i,:);
    y = bs(1)*hs{1};
    for j = 2:M
        b = bs(j);
        h = hs{j};
        y = y + b*predict_tree(x, h);
    end
    Y(i) = y;
end

end
