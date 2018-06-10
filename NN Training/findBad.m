function X = findBad(featureMatrix)
% FINDBAD   removes examples in 'featureMatrix' that may not be
%   representitive of the color it represents.
%
%       X = findBad(featureMatrix)   Scans through the feature vectors and
%           checks to see if the values are mostly larger than 10. For 
%           colors that are not black or white, the pixel data for a 
%           portion of the matrix should be much greater than 10.
%
%       **NOTE** This function was created because the pictures extracted 
%       from the internet were not all of the same file type. When 
%       inporting the data to MATLAB some pictures did not import correctly.
%
%       In future versions, I would like to remove this function because
%       by removing pictures we get imbalanced class sizes.
%

[row,column] = size(featureMatrix);         %Extract dimensions
X = zeros(1,column);                        %Pre-allocate memory

for m = 1:row
    %Sums up the pixel data for example m
    total = sum(featureMatrix(m,1:1200));
    %Data that has a sum less than 10 usually means all pixels are 0
    if (total>10)
        X = [X;featureMatrix(m,:)];
    end
end

%Remove top row because it is empty from the preallocation
X(1,:) = [];
end