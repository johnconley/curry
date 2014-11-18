function Y = predict_gbdt(X, bs, hs, M)

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
%         y = y + b*h.predict(x);
        y = y + b*predict_tree(x, h);
    end
    Y(i) = y;
end

end
