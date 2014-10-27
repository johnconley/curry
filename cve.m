function cve()
stats = csvread('fixedstats.csv');
players = unique(stats(:,1));
p = size(players,1);

Xtrain = [];
Ytrain = [];
% for i=1:1000
for i=1:p
    rows = stats(:,1) == players(i);
    Xplayer = stats(rows,:);
    Xplayer = Xplayer(:, [2, 4:end]);
    
    % combine two teams in same year to one line
    j=2;
    while (j<size(Xplayer,1))
        if Xplayer(j,1) == Xplayer(j-1,1)
            Xplayer(j-1,2:end) = Xplayer(j-1,2:end) + Xplayer(j,2:end);
            Xplayer(j-1,4:end) = Xplayer(j-1,4:end) / Xplayer(j-1,3);
            pctgs = [6,9,12,15];
            for k=1:size(pctgs,1)
                ix = pctgs(k);
                if Xplayer(j,ix-1) > 0
                    Xplayer(j,ix) = Xplayer(j,ix-2)/Xplayer(j,ix-1);
                else
                    Xplayer(j,ix) = -1;
                end
            end
            Xplayer = Xplayer([1:j-1,j+1:end],:);
        else
            j = j+1;
        end
    end
    
    Yplayer = Xplayer(2:end,end);
    num_years = size(Xplayer,1);
    if num_years > 1
        for j=2:num_years-1;
            % sum statistics and recalculate percentages
            Xplayer(j,2:end) = Xplayer(j-1,2:end) + Xplayer(j,2:end);
            pctgs = [6,9,12,15];
            for k=1:size(pctgs,1)
                ix = pctgs(k);
                if Xplayer(j,ix-1) > 0
                    Xplayer(j,ix) = Xplayer(j,ix-2)/Xplayer(j,ix-1);
                else
                    Xplayer(j,ix) = -1;
                end
            end
        end
        Xtrain = [Xtrain; Xplayer(1:end-1,:)];
        Ytrain = [Ytrain; Yplayer];
    end
end
X = Xtrain;
Y = Ytrain;

% Try different lambda with a linear model
lambda = 10.^[-5:2:7];
error = cross_validation_error(X, Y, lambda, 'linear', 10);
% Plot the results
figure;
subplot(2,1,1);
plot(log10(lambda), error, '-db');
ylabel('squared error per sample');
title('cross validation error for regularized least square with b^l(x)');
xlabel('log_{10}\lambda');

% Try different lambda with a quadratic model
lambda = 10.^[-5:2:7];
error = cross_validation_error(X, Y, lambda, 'quadratic', 10);
% Plot the results
subplot(2,1,2);
plot(log10(lambda), error, '-db');
ylabel('squared error per sample');
title('cross validation error for regularized least square with b^q(x)');
xlabel('log_{10}\lambda');

saveas(gcf, 'cve.fig');

end

