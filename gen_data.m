function [Xtrain, Ytrain, Xtest, Ytest] = gen_data()
% stats = csvread('fixedstats.csv');
stats = csvread('totals_stats_no1979_fixed.csv');
% stats(stats == -1) = NaN;
stats(stats == -1) = 0;
players = unique(stats(:,1));
p = size(players,1);

Xtrain = [];
Ytrain = [];
% for i=1:p
for i=1:100
    rows = stats(:,1) == players(i);
    Xplayer = stats(rows,:);

    % get rid of unnecessary features
%     Xplayer = Xplayer(:, [2,10:end]);
%     n = size(Xplayer,2);
%     pctgs = n - [18,15,12,9];
%     Xplayer = Xplayer(:,setdiff(1:n,pctgs));
    Xplayer = Xplayer(:,[2,13,14,16,17,19,20,22,23,25,26:end]);
    
    % combine two teams in same year to one line
    j=2;
    while (j<size(Xplayer,1))
        if Xplayer(j,1) == Xplayer(j-1,1)
            % for totals
            Xplayer(j-1,2:end) = Xplayer(j-1,2:end) + Xplayer(j,2:end);
            Xplayer = Xplayer([1:j-1,j+1:end],:);
        else
            j = j+1;
        end
    end
    
    % column corresponds to which attribute we're predicting
    % end is points scored
    Yplayer = Xplayer(2:end,end);
    Xplayer = Xplayer(1:end-1,:);

    num_years = size(Xplayer,1);
    if num_years > 0
        Xtrain = [Xtrain; Xplayer];
        Ytrain = [Ytrain; Yplayer];
    end
end

m = size(Xtrain, 1);
disp(m);
permutation = randperm(m);
test_set = permutation(1:10);
train_set = setdiff(1:m,test_set);
Xtest = Xtrain(test_set,:);
Ytest = Ytrain(test_set);
Xtrain = Xtrain(train_set,:);
Ytrain = Ytrain(train_set);

end
