function H = mars_features(X, knots)
% Input
% -----
% X: [m x n] matrix
% knots: [K x 5] matrix of knots
%
% Output
% ------
% H: [m x K+1] matrix of MARS features

m = size(X,1);
num_hinges = size(knots,1);
H = zeros(m,num_hinges);

for k = 1:num_hinges
    t1 = knots(k,1);
    j1 = knots(k,2);
    t2 = knots(k,3);
    j2 = knots(k,4);
    s = knots(k,5);
    for i = 1:m
        if(t2 == 0)
            H(i,k) = max(s*(t1-X(i,j1)),0);
        else
            H(i,k) = max(s*(t1-X(i,j1))*(t2-X(i,j2)),0);
        end
    end
end

H = cat(2, ones(m,1), H);

end
