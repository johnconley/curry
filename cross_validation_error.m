function error = cross_validation_error(X, Y, lambda, mode, N)
% Calculates the cross-validation errors for different values of lambda, given the
% training set X, Y.
%
% ** Implementation notes **
% - As discussed in class, you should first randomly permute the examples, before starting the
%   cross-validation stage. Here we do it for you: use the vector idxperm
%   to index the examples
% - In the cross-validation stage, the indexes of the examples for the k-th subset must be 
%   idxperm([floor(m / N * k + 1) : floor(m / N * (k + 1))])
%   where k \in {0, 1, ..., N-1}
% - Do not change/initialize/reset the Matlab pseudo-number generator.
%
% INPUT
%  X: [m x d] matrix, where each row is a d-dimensional data example
%  Y: [m x 1] vector, where the i-th element is the ground truth target value for the i-th example. 
%  lambda: [1 x K] vector, containing the set of regularization hyperparameter values
%  mode: type of features, either 'linear' or 'quadratic'
%  N: number of folds for the cross-validation stage
%
% OUTPUT
%  error: [1 x K] vector containing the cross-validation error (i.e., the average of the mean 
%         squared errors over the N validation sets) for each lambda.
%


% ********  DO NOT TOUCH THE FOLLOWING 3 LINES  ********************
rand('twister', 0);
[m, d] = size(X);
idxperm = randperm(m);
% ******************************************************************

subset_size = floor(m / N);
subsets = zeros(N, subset_size);
for k = 0:N-1
    subsets(k+1,:) = idxperm(floor(subset_size * k + 1) : floor(subset_size * (k + 1)));
    subsets(k+1,:) = sort(subsets(k+1,:), 'descend');
end

K = size(lambda, 2);
error = zeros(1, K);
for k = 1:K
    err = zeros(1, N);
    l = lambda(k);
    
    for i = 1:N
        % initialize partitions
        training_input = X;
        training_output = Y;
        test_input = zeros(subset_size, d);
        test_output = zeros(subset_size, 1);
        for j = 1:subset_size
            r = subsets(i,j);
            training_input = training_input([1:r-1, r+1:end], :);
            training_output = training_output([1:r-1, r+1:end]);
            test_input(j, :) = X(r, :);
            test_output(j) = Y(r);
        end
        
        % calculate average error for this particular partition
        theta = train(training_input, training_output, l, mode);
        prediction = predict(theta, test_input, mode);
        err(i) = mean((prediction - test_output).^2);
    end
    
    % average error over all partitions for this particular value of lambda
    error(k) = mean(err);
end

end
