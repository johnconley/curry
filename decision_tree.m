function tree = decision_tree(X, Y, max_decisions, min_leaf, tol)

[m, n] = size(X);
if m < min_leaf
    tree = [1, mean(Y), 0, 0, 0];
    return;
end
if max_decisions < 1
    tree = [1, mean(Y), 0, 0, 0];
    return;
end

tree = [];
leaf_vals = mean(Y);
S0 = mean((Y-leaf_vals(1)).^2);

min_S = Inf;
min_i = 0;
min_j = 0;
for i = 1:m
    for j = 1:n
        lt_rows = X(:,j) < X(i,j);
        lt_Y = Y(lt_rows);
        lt_mean = mean(lt_Y);

        gt_rows = lt_rows == 0;
        gt_Y = Y(gt_rows);
        gt_mean = mean(gt_Y);

        S = mean((lt_Y-lt_mean).^2) + mean((gt_Y-gt_mean).^2);
        if S < min_S
            min_S = S;
            min_i = i;
            min_j = j;
        end
    end
end

if S - min_S < tol || min_i == 0
    tree = [1, mean(Y), 0, 0, 0];
    return;
end

lt_rows = X(:,min_j) < X(min_i,min_j);
lt_X = X(lt_rows,:);
lt_Y = Y(lt_rows);
lt_tree = decision_tree(lt_X, lt_Y, max_decisions-1, min_leaf, tol);

gt_rows = lt_rows == 0;
gt_X  = X(gt_rows);
gt_Y = Y(gt_rows);
gt_tree = decision_tree(gt_X, gt_Y, max_decisions-1, min_leaf, tol);

tree = [tree;[0,X(min_i,min_j),min_j,1,size(lt_tree,1)+1];lt_tree;gt_tree];

end
