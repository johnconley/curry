stats = csvread('fixedstats.csv');
players = unique(stats(:,1));
% p = size(players,1);
% p=6;
% p=1000;
p = 100;

Xtrain = [];
Ytrain = [];
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
%         disp(Xplayer);
%         disp(Yplayer);
%         disp(players(i));
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

m = size(Xtrain, 1);
% test_size = ceiling(p/10);
test_size = 30;
Xtest = Xtrain(m-test_size:end,:);
Ytest = Ytrain(m-test_size:end);
Xtrain = Xtrain(1:m-(test_size+1),:);
Ytrain = Ytrain(1:m-(test_size+1),:);

% lambda = 5;
mode = 'linear';
% theta = train(Xtrain, Ytrain, lambda, mode);
% Y = predict(theta, Xtest, mode);
% err = mean((Ytest - Y).^2);

lambdas = [10^(-7);10^(-5);10^(-3);10^(-1);10^1;10^3;10^5;10^7];
error = zeros(size(lambdas));
for i=1:size(lambdas)
    theta = train(Xtrain, Ytrain, lambdas(i), mode);
    Y = predict(theta, Xtest, mode);
    error(i) = mean((Ytest - Y).^2);
end

plot(log10(lambdas), error, '-db');
ylabel('mean squared error');
title('mean squared error for linear regression');
xlabel('log_{10}\lambda');

saveas(gcf, 'lin.fig');
