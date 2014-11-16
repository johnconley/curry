function [knots, B] = forward_pass(X, Y, max_terms)
% X: [m x n] matrix of training input data
% Y: [m x 1] vector of training output data
% max_terms: maximum numbers of terms in the model

m = size(X,1);
n = size(X,2);

xj = zeros(m,n);
for i=1:n
    u = unique(X(:,i));
    for j=1:size(u)
        xj(j,i) = u(j);
    end
end
knot_pool = knot_combo(xj);
% knots(1,:) = [t,j,s], where t is the value of the knot, j is the feature,
% and s in {1,-1}. one row generates max(s*(t-xj),0)
knots = zeros(2*max_terms,5);
H = zeros(m, (max_terms * 2) + 1);
H(:,1) = 1;
term_ix = 1;

% TODO: generate max_terms terms, not 2*max_terms
for knotNum = 1:max_terms
    min_err = Inf;
    for i=1:size(knot_pool,2)       
        temp_H = H;
        temp_H(:, find(sum(abs(temp_H)) == 0)) = []; % remove 0 columns
        temp_H_zeros = zeros(size(temp_H,1),2);
        temp_H = cat(2, temp_H, temp_H_zeros);
        for X_row = 1:m
            % temp_H is already matrix of zeros, so if statements
            % act as max(x,0)
            if(knot_pool(3,i) == 0)
                temp_H(X_row, size(temp_H,2)-1) = max(knot_pool(1,i) - X(X_row,knot_pool(2,i)),0);
                temp_H(X_row, size(temp_H,2)) = max(X(X_row,knot_pool(2,i)) - knot_pool(1,i),0);
            else
                k1 = knot_pool(1,i) - X(X_row,knot_pool(2,i));
                k2 = knot_pool(3,i) - X(X_row,knot_pool(4,i));
                temp_H(X_row, size(temp_H,2)-1) = max((k1*k2),0);
                temp_H(X_row, size(temp_H,2)) = max((-1*k1*k2),0);
            end
        end
        zerocol = size(temp_H,2);
        temp_H(:, find(sum(abs(temp_H)) == 0)) = [];
        if size(temp_H,2) == zerocol %check if we have column of zeros
            B = ((temp_H' * temp_H) \ temp_H') * Y;
            curr_err = mean((Y - temp_H*B).^2); % mse
            if curr_err < min_err
                winning_H = temp_H;
                winning_col = i;
                min_err = curr_err;
            end
        end
    end
    H = winning_H;
    knots(term_ix,1) = knot_pool(1,winning_col);
    knots(term_ix,2) = knot_pool(2,winning_col);
    knots(term_ix,3) = knot_pool(3,winning_col);
    knots(term_ix,4) = knot_pool(4,winning_col);
    knots(term_ix,5) = 1;
    knots(term_ix+1,:) = knots(term_ix,:);
    knots(term_ix+1,5) = -1;
    term_ix = term_ix + 2;
    knot_pool(:,winning_col) = [];
end

B = ((H' * H) \ H') * Y;

end
