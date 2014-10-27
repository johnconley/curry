stats = csvread('fixedstats.csv');
players = unique(stats(:,1));
p = size(players,1);

Xtrain = [];
Ytrain = [];
% for i=1:p
% for i=1:6
for i=1:1000
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
num = 30;
Xtest = Xtrain(m-num:end,:);
Ytest = Ytrain(m-num:end);
Xtrain = Xtrain(1:m-(num+1),:);
Ytrain = Ytrain(1:m-(num+1),:);

lambda = 5;
mode = 'quadratic';
disp('size Xtrain');
disp(size(Xtrain));
disp('size Ytrain');
disp(size(Ytrain));
disp('size theta');
disp(size(theta));
theta = train(Xtrain, Ytrain, lambda, mode);
disp('theta');
disp(theta);
Y = predict(theta, Xtest, mode);
% err = mean((Ytest - Y).^2);