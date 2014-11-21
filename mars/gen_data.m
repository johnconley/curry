function [Xtrain, Ytrain, Xtest, Ytest] = gen_data(data_type, stat_type, filename, p)
% Input
% -----
% data_type: 'totals' or 'per_poss'
% stat_type: 'TRB', 'AST', 'PTS', or '2P%'
% file_name: name of the data file (see data directory)
% p: if specified, p is the number of players to generate data from
%
% Output
% ------
% Xtrain: [m_train x n] matrix of training input data
% Ytrain: [m_train x 1] vector of training output data
% Xtest: [m_test x n] matrix of training input data
% Ytest: [m_test x 1] vector of training output data

filename = strcat('../data/', filename);
stats = csvread(filename);
stats(stats == -1) = 0;
players = unique(stats(:,1));
total_players = size(players,1);

% if p > total_players, p < 1, or p is unspecified, set p to the total
% number of players
if p > total_players || p < 1, p = total_players; end
switch nargin
    case 3
        p = total_players;
end

Xtrain = [];
Ytrain = [];
for i = 1:p
    % select one player
    rows = stats(:,1) == players(i);
    Xplayer = stats(rows,:);

    % get rid of unnecessary features
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
    
    % select attribute by column
    if strcmp(stat_type, 'TRB') == 1
        Yplayer = Xplayer(2:end,8) + Xplayer(2:end,9);
    elseif strcmp(stat_type, 'AST') == 1
        Yplayer = Xplayer(2:end,10);
    elseif strcmp(stat_type, 'PTS') == 1
        Yplayer = Xplayer(2:end,end);
    else
        Yplayer = Xplayer(2:end,4) ./ Xplayer(2:end,5);
    end
    
    Xplayer = Xplayer(1:end-1,:);

    num_years = size(Xplayer,1);
    if num_years > 0
        Xtrain = [Xtrain; Xplayer];
        Ytrain = [Ytrain; Yplayer];
    end
end

% split into test set and training set
m = size(Xtrain, 1);
permutation = randperm(m);
test_set = permutation(1:floor(m/10));
train_set = setdiff(1:m,test_set);
Xtest = Xtrain(test_set,:);
Ytest = Ytrain(test_set);
Xtrain = Xtrain(train_set,:);
Ytrain = Ytrain(train_set);

end
