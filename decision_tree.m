function tree = decision_tree(X, Y, tree_builder, max_decisions, min_leaf, tol)
% rows: [1 x m] training examples to consider for decision functions
% features: [1 x n] features to consider for decision functions

[m, n] = size(X);
if m < min_leaf
    disp('min leaf');
    tree = [1, mean(Y), 0, 0, 0];
    return;
end
if max_decisions < 1
    disp('max decisions');
    tree = [1, mean(Y), 0, 0, 0];
    return;
end

tree = [];
leaf_vals = mean(Y);
S0 = mean((Y-leaf_vals(1)).^2);

if strcmp(tree_builder, 'random') == 1
    rows = randperm(m);
    rows = rows(1:ceil(m/3));
    features = randperm(n);
    features = features(1:ceil(3*n/4));
else % tree_builder = 'all'
    rows = 1:m;
    features = 1:n;
end

min_S = S0;
min_i = 0;
min_j = 0;
for ix1 = 1:size(rows,2)
    for ix2 = 1:size(features,2)
        i = rows(ix1);
        j = features(ix2);

        lt_rows = X(:,j) < X(i,j);
        lt_Y = Y(lt_rows);
        gt_rows = lt_rows == 0;
        gt_Y = Y(gt_rows);

        if size(lt_Y,1) >= min_leaf && size(gt_Y,1) >= min_leaf
            lt_mean = mean(lt_Y);
            gt_mean = mean(gt_Y);
            S = mean((lt_Y-lt_mean).^2) + mean((gt_Y-gt_mean).^2);

            if S < min_S
                min_S = S;
                min_i = i;
                min_j = j;
            end
        end
    end
end

if min_i == 0 || S - min_S < tol
%     disp('diff less than tol');
    tree = [1, mean(Y), 0, 0, 0];
    return;
end

lt_rows = X(:,min_j) < X(min_i,min_j);
lt_X = X(lt_rows,:);
lt_Y = Y(lt_rows);
lt_tree = decision_tree(lt_X, lt_Y, tree_builder, max_decisions-1, min_leaf, tol);

gt_rows = lt_rows == 0;
gt_X  = X(gt_rows,:);
gt_Y = Y(gt_rows);
gt_tree = decision_tree(gt_X, gt_Y, tree_builder, max_decisions-1, min_leaf, tol);

tree = [tree;[0,X(min_i,min_j),min_j,1,size(lt_tree,1)+1];lt_tree;gt_tree];

end
