function knot_pool = knot_combo(xj, mode)
% Input
% -----
% xj: [m x n] matrix of unique training features
% mode: 'linear' or 'quadratic'
%
% Output
% ------
% knot_pool: [4 x S] matrix of candidate hinge functions

m = size(xj,1);
n = size(xj,2);
count = 1;
for j=1:n
    for i=1:m
        if xj(i,j) ~= 0
            temp(1,count) = xj(i,j);
            temp(2,count) = j;
            temp(3,count) = 0;
            temp(4,count) = 0;
            count = count + 1;
        end
    end
end

knot_pool = temp;

if strcmp(mode,'quadratic') == 1
    for a=1:size(temp,2)
        for b=a:size(temp,2)
            if rand() < .01
                knot_pool(1,count) = temp(1,a);
                knot_pool(2,count) = temp(2,a);
                knot_pool(3,count) = temp(1,b);
                knot_pool(4,count) = temp(2,b);
                count = count + 1;
            end
        end
    end
end

end

