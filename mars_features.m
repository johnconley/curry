function H = mars_features(X, knots)
% X: [m x n] matrix

m = size(X,1);
num_hinges = size(knots,1);
H = zeros(m,num_hinges);

for k = 1:num_hinges
    t = knots(k,1);
    j = knots(k,2);
    s = knots(k,3);
    for i = 1:m
        H(i,k) = max(s*(t-X(i,j)),0);
    end
end

H = cat(2, ones(m,1), H);

end
