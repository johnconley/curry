function B = q5_features(X, mode)
% Given the data matrix X (where each row X(i,:) is an example), the function
% computes the feature matrix B, where row B(i,:) represents the feature vector 
% associated to example X(i,:). The features should be either linear or quadratic
% functions of the inputs, depending on the value of the input argument 'mode'.
% Please make sure to implement the features according to the exact order
% specified in the text of the homework assignment.
%
% INPUT:
%  X: a matrix [m x d] where each row is a d-dimensional input example
%  mode: the type of features; it is a string that can be either 'linear' or 'quadratic'.
%
% OUTPUT:
%  B: a matrix [m x n], with each row containing the feature vector of an example
%

if ~strcmp(mode, 'linear') && ~strcmp(mode, 'quadratic')
  disp('Error, only linear and quadratic features are supported');
end
 
if strcmp(mode, 'linear')
    for j=1:size(X,1)
        B(j,:)=[1, X(j,:)];
    end
end

if strcmp(mode, 'mars')
    m = size(X, 1);
    d = size(X, 2);
    A = unique(X','rows')
end


if strcmp(mode, 'quadratic')
    if (mod(size(X,2), 2)) == 1
        a = (size(X,2) + 2) * ((size(X,2)+1)/2);
    if (mod(size(X,2), 2)) == 0
        a = ((size(X,2) + 1) * (size(X,2)/2)) + size(X,2) + 1;
    end
    B = ones(size(X,1), a);    
      
    for i=1:size(X,1)
        for l=1:size(X,2)
            B(i,l+1)= X(i,l);
        end
        count = size(X, 2) + 2;
        for j=1:size(X,2)
            for k=j:size(X,2)
                B(i,count) = X(i,j) * X(i, k);
                count = count + 1;
            end
        end
    end
end   
end   