function [knots, B] = backward_pass(X, Y, overfit_knots, overfit_B)
% X: [m x n] matrix of training input data
% Y: [m x 1] vector of training output data
% knots: 
% B: 

penalty = 2;
m = size(X,1);
knots = overfit_knots;
B = overfit_B;
H = mars_features(X, knots);

pred_Y = H*B;
rss = sum((Y - pred_Y).^2);
old_gcv = calc_gcv(m, size(H,2), penalty, rss);
% disp('initial gcv');
% disp(old_gcv);

% TODO: when do we stop
while true
    min_gcv = Inf;
    mars_terms = size(H,2);
    for k = 2:mars_terms
        pred_Y = H(:,[1:k-1,k+1:end])*B([1:k-1,k+1:end],:);
        rss = sum((Y - pred_Y).^2);
        gcv = calc_gcv(m, mars_terms-1, penalty, rss);
        if gcv < min_gcv
            min_gcv = gcv;
            min_ix = k;
        end
    end
%     disp('new min gcv');
%     disp(min_gcv);
    if min_gcv >= old_gcv
        break;
    end
    old_gcv = min_gcv;
    % remove hinge function which gives smallest gcv
    H = H(:,[1:min_ix-1,min_ix+1:end]);
    knots_min_ix = min_ix - 1;
    knots = knots([1:knots_min_ix-1,knots_min_ix+1:end],:);
    B = B([1:min_ix-1,min_ix+1:end],:);
end

end
