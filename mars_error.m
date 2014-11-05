function err = mars_error(B, H, Ytest)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

pred_y = H * B;

y = 0;
for row=1:size(pred_y, 1)
    x = (pred_y(row,1) - Ytest(row,1)) ^ 2;
    y = y + x;
end
    err = y / row;
end

