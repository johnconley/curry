function H = mars_features(X, knots)
% X - mxn matrix
%   Detailed explanation goes here

m = size(X,1);
num_knots = size(knots,2)/2;
H = ones(m, 1 + 2*num_knots);
count = 2;
for k = 1:2*num_knots
    if mod(k,2) == 1
        j = knots(1, k + 1);
        for Xrow=1:size(X, 1)
            H(Xrow, count) = max(knots(1, k) - X(Xrow, j), 0);
            H(Xrow, count + 1) = max(X(Xrow, j) - knots(1, k), 0);
        end
        count = count + 2;
    end
end

end
