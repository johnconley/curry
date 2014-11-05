function [knots, B] = mars(X, Y, max_terms)
% X - mxn matrix
% Y - mx1 vector

m = size(X,1);
n = size(X,2);

xj = zeros(m,n);
for i=1:n
    u = unique(X(:,i));
    for j=1:size(u)
        xj(j,i) = u(j);
    end
end

knots = zeros(2, max_terms);
H = zeros(m, (max_terms * 2) + 1);
H(:,1) = 1;
term_ix = 1;

for knotNum = 1:max_terms
    min_err = Inf;
    for xj_row = 1:m
        for xj_col=1:n
            if xj(xj_row,xj_col) ~= 0
                temp_H = H;
                temp_H(:, find(sum(abs(temp_H)) == 0)) = []; % remove 0 columns
                temp_H_zeros = zeros(size(temp_H,1),2);
                temp_H = cat(2, temp_H, temp_H_zeros);
                for X_row = 1:m
                    % temp_H is already matrix of zeros, so if statements
                    % act as max(x,0)
                    if xj(xj_row,xj_col) - X(X_row,xj_col) > 0
                        temp_H(X_row, size(temp_H,2)-1) = xj(xj_row,xj_col) - X(X_row,xj_col);
                    end
                    if X(X_row,xj_col) - xj(xj_row,xj_col) > 0
                        temp_H(X_row, size(temp_H,2)) = X(X_row,xj_col) - xj(xj_row,xj_col);
                    end
                end

                zerocol = size(temp_H,2);
                temp_H(:, find(sum(abs(temp_H)) == 0)) = [];
                if size(temp_H,2) == zerocol
                    B = ((temp_H' * temp_H) \ temp_H') * Y;
                    curr_err = mars_error(B, temp_H, Y);
                    if curr_err < min_err
                        winning_H = temp_H;
                        winning_knot_row = xj_row;
                        winning_knot_col = xj_col;
                        min_err = curr_err;
                    end
                end
            end
        end
    end

    H = winning_H;
    knots(1,term_ix) = xj(winning_knot_row, winning_knot_col);
    knots(1,term_ix+1) = winning_knot_col;
    term_ix = term_ix + 2;

    xj(winning_knot_row, winning_knot_col) = 0;
end

B = ((H' * H) \ H') * Y;

end
