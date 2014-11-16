function f = gbdt(X,Y)

M = 10;
delta = 1;
avg_Y = mean(Y);

% initialize model with a constant value
h = cell(M,1);
b = zeros(M,1);
h{1} = @(x) 1;
b(1) = avg_Y;

for i = 1:M
    
    
    
end

end