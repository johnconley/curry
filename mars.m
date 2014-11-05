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

knots = zeros(1, 2 * max_terms);
finalH = zeros(m, (max_terms * 2) + 1);
tempH=zeros(m, (max_terms * 2) + 1);
finalH(:,1) = 1;
tempH(:,1) = 1;

for knotNum=1:max_terms
    minErr = -1;
    for xjRow=1:m
        for xjCol=1:n
            if xj(xjRow,xjCol) ~= 0
                tempH = finalH;
                tempH(:, find(sum(abs(tempH)) == 0)) = [];
                tempH_zeros = zeros(size(tempH,1),2);
                tempH = cat(2,tempH, tempH_zeros);
                for XRow=1:m
                    if (xj(xjRow,xjCol) - X(XRow,xjCol)) > 0
                        tempH(XRow, size(tempH,2)-1) = (xj(xjRow,xjCol) - X(XRow,xjCol));
                    end
                    if (X(XRow,xjCol) - xj(xjRow,xjCol)) > 0
                        tempH(XRow, size(tempH,2)) = (X(XRow,xjCol) - xj(xjRow,xjCol));
                    end
                end
                zerocol = size(tempH,2);
                tempH(:, find(sum(abs(tempH)) == 0)) = [];
                if(size(tempH,2) == zerocol) 
                    B = ((tempH' * tempH) \ tempH') * Y;
                    currErr = mars_error(B, tempH, Y);
                    if (minErr == -1 || currErr < minErr) 
                        winningH = tempH;
                        winningknotrow = xjRow;
                        winningknotcol = xjCol;
                        minErr = currErr;
                    end
                end
            end
        end
    end
     finalH = winningH;
     check = 0;
     for win=1:size(knots, 2)
         if(knots(1, win) == 0 && check == 0)
             knots(1,win) = xj(winningknotrow, winningknotcol);
             knots(1, win + 1) = winningknotcol;
             check = 1;
             xj(winningknotrow, winningknotcol) = 0;
         end
     end
end

B = ((finalH' * finalH) \ finalH') * Y;

%{
for xjRow=1:m
    for xjCol=1:n
        if xj(xjRow, xjCol) ~= 0
            for Xrow=1:m
                TEMP(m,1) = 1;
                if (X(Xrow,xjCol) - xj(xjRow,xjCol)) > 0
                    TEMP(m,2) = (X(Xrow,xjCol) - xj(xjRow,xjCol));
                else
                    TEMP(m,2) = 0;
                end
                if (xj(xjRow,xjCol) - X(Xrow,xjCol)) > 0
                    TEMP(m,3) = (xj(xjRow,xjCol) - X(Xrow,xjCol));
                else
                    TEMP(m,3) = 0;
                end
                
            end
        end
    end
end








knots = sum(sum(xj ~=0));
H = zeros(m,2 * knots);
for Xrow=1:size(X,1)
    count = 1;
    for Xcol=1:size(X,2)
        for knotRow=1:m
            if xj(knotRow,Xcol) ~= 0
                if (X(Xrow,Xcol)-xj(knotRow,Xcol)) > 0
                    H(Xrow, count) = (X(Xrow,Xcol)-xj(knotRow,Xcol));
                else
                    H(Xrow, count) = 0;
                end
                count = count + 1;
                if (xj(knotRow,Xcol)-X(Xrow,Xcol)) > 0
                    H(Xrow, count) = (xj(knotRow,Xcol)-X(Xrow,Xcol));
                else
                    H(Xrow, count) = 0; 
                end
                count = count + 1;
            end
        end
    end
end
%eliminates 0 vectors as they contain no information
H(:, find(sum(abs(H)) == 0)) = [];
B = H' * H;
%}
end