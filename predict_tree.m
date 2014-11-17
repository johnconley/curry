function Y = predict_tree(X, tree)
% X: [m x n] matrix of input vectors
% tree: [d x 5] decision tree

m = size(X,1);
Y = zeros(m,1);
for i = 1:m
    x = X(i,:);
    t = 1;
    while true
        is_leaf = tree(t,1);
        val = tree(t,2);
        if is_leaf
            Y(i) = val;
            break;
        else
            j = tree(t,3);
            if x(j) < val
                t = t + tree(t,4);
            else
                t = t + tree(t,5);
            end
        end
    end
end

end