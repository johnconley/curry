function l = huber_loss(Y, pred_Y, d)
% pseudo-huber loss function
% we use the pseudo-huber loss rather than huber loss because we
% need a differentiable loss function to compute the pseudo-residuals

l = 0;
for i = 1:size(Y,1)
    diff = abs(Y(i)-pred_Y(i));
    if diff > d
        l = l + d*diff - 0.5*d^2;
    else
        l = l + 0.5 * diff^2;
    end

%     l = l + d^2*(sqrt(1+(diff/d)^2) - 1);
end

end