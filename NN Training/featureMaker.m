function X = featureMaker(folderName)
% FEATUREMAKER   Creates the features to be used for a machine learning 
%   algorithm to detect color.
%
%       X = FEATUREMAKER(folderName)    Moves to the folder specified and
%           takes all of the picture files inside of the folder. Then the
%           function extracts the RGB pixel data from each picture and 
%           rolls them into a 1x1201 vector to be fed into the NN.
%

cd(folderName);   %Change directory

files = dir;      %Gathers information of the files in side of 'folderName'

num_files = size(files,1);      %Finds total amount of files
X = zeros(num_files-2,1201);    %Prealocates location for X matrix

for n = 3:num_files
    [pic,map] = imread(files(n).name);             %Gathers pixel data
    if isempty(map)                                %Turns to RGB if not
        pic = double(pic);
        resize_pic = imresize(pic,[20 20]);        %Resize to 20 x 20 img
        x1 = reshape(resize_pic(:,:,1),1,400);
        x2 = reshape(resize_pic(:,:,2),1,400);
        x3 = reshape(resize_pic(:,:,3),1,400);
        X(n-2,1:1200)=[x1 x2 x3];                  %Put all data into a 
                                                   %single vector
    end
end
X(:,1201) = ones(num_files-2,1);                    %Creates vector of 1's

cd ../                                              %Return to directory
