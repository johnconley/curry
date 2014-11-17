stats = csvread('totals_stats_no1979_fixed.csv');
stats(stats == -1) = 0;
players = unique(stats(:,1));

rows = stats(:,2) == 1; % first year in NBA
Xtrain = stats(rows,:);
% Xtrain = Xtrain(:,[2,13,14,16,17,19,20,22,23,25,26:end]);
Xtrain = Xtrain(:,[13,14,16,17,19,20,22,23,25,26:end]); % can remove year # as well

mu0_init = sum(Xtrain)'/size(Xtrain,1);
P0 = cov(Xtrain)';

% p = 1;
p = floor(rand * size(players,1));
rows = stats(:,1) == players(p);
Xtest = stats(rows,:);
% Xtest = Xtest(:,[2,13,14,16,17,19,20,22,23,25,26:end])';
Xtest = Xtest(:,[13,14,16,17,19,20,22,23,25,26:end])'; % can remove year # as well

num_iterations = 10;
[mu0, V0, A, gamma, C, sigma] = ldm_fit(Xtest, mu0_init, P0, num_iterations);
