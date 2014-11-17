function [Xtrain, Ytrain, Xtest, Ytest] = gen_data(years, data_type, filename, data_size)
% stats = csvread('fixedstats.csv');

stats = csvread(filename);
% stats(stats == -1) = NaN;
stats(stats == -1) = 0;
players = unique(stats(:,1));
p = size(players,1);

Xtrain = [];
Ytrain = [];
% for i=1:p
if data_size == 100
    AA = 100;
else
    AA = p;
end
for i=1:AA
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
        count = 1;
  
        while ((Xplayer(j,1) == Xplayer(j-1,1))&&(j<size(Xplayer,1)))
            count = count + 1;
            Xplayer(j-1,2:end) = (Xplayer(j-1,2:end) + Xplayer(j,2:end));            
            Xplayer = Xplayer([1:j-1,j+1:end],:);
        end
        
        if count > 1 && ~strcmp(data_type, 'totals')
            Xplayer(j-1,2:end) = (Xplayer(j-1,2:end)) / count;
        end
        
        j = j+1;
    end
    
    % column corresponds to which attribute we're predicting
    % last column is points scored
    n = size(Xplayer,2);
    Yplayer = Xplayer(2:end,n);
    Xplayer = Xplayer(1:end-1,:);
    if years == 2
        if size(Xplayer,1) == 1
            Xplayer = [zeros(1,n),Xplayer];
        else
            if size(Xplayer,1) > 0
                Xplayer = [[zeros(1,n);Xplayer(1:end-1,:)],Xplayer];
            end
        end
    end

    num_years = size(Xplayer,1);
    if num_years > 0
        Xtrain = [Xtrain; Xplayer];
        Ytrain = [Ytrain; Yplayer];
    end
end

m = size(Xtrain, 1);
permutation = randperm(m);
test_set = permutation(1:floor(m/10));
train_set = setdiff(1:m,test_set);
Xtest = Xtrain(test_set,:);
Ytest = Ytrain(test_set);
Xtrain = Xtrain(train_set,:);
Ytrain = Ytrain(train_set);

end
