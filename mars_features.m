function H = mars_features(knots, X)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
knotNum = (size(knots,2) / 2);
H = ones(size(X,1), 1 + (knotNum * 2));
count = 2;
for knotcount=1:size(knots,2)
    if (mod(knotcount,2) == 1)
        n = knots(1, knotcount + 1);
        for Xrow=1:size(X, 1)
            if (knots(1, knotcount) - X(Xrow, n)) > 0 
                H(Xrow, count) = (knots(1, knotcount) - X(Xrow, n));
            else
                H(Xrow, count) = 0;
            end
            if (X(Xrow, n) - knots(1, knotcount)) > 0 
                H(Xrow, count + 1) = (X(Xrow, n) - knots(1, knotcount));
            else
                H(Xrow, count + 1) = 0;
            end
        end
        count = count + 2;
    end
end

end

