function B = features(X, mode)
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

    function W = q(Z)
        if size(Z,2) > 1
            Z2 = Z;
            for k = 1:size(Z,1)
                Z2(k,:) = Z(k,1) * Z(k,:);
            end
            W = cat(2,Z2,q(Z(:,2:end)));
        else
            W = Z.^2;
        end
    end

m = size(X,1);
os = ones(m,1);

B = cat(2,os,X);
if strcmp(mode, 'quadratic')
    B = cat(2,B,q(X));
end

end