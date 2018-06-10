%% NN Color Recongizer: Parameter Training
% This script will identify Green and Red objects from a picture
% Work still needed to be done:
%   - Improve accuracy of NN
%   - Possibly add more examples to even out classes
%   - Encode pixel data to stepper motor data


%% Initialization
clear ; close all; clc

%% Setup the parameters
input_layer_size  = 1200;  % 20x20 Input Images of Digits
hidden_layer_size = 25;   % 25 hidden units
num_labels = 4;          % 7 labels, from 1 to 7  

%% =========== Part 1: Loading and Visualizing Data =============
%  Loading and visualizing the dataset. 

% Load Training Data
fprintf('Loading and Visualizing Data ...\n')

createXY;   %Creates feature matricies and output vector

%Train set = 60%, Test and Val set = 20% each
train_size = ceil(size(X_total,1)*.60);
test_val_size = floor((size(X_total,1)-train_size)/2);

%Training Set
X = X_total(1:train_size,1:1200);
y = X_total(1:train_size,1201);

%Cross-Validation Set
Xval = X_total((train_size+1):(test_val_size+train_size),1:1200);
yval = X_total((train_size+1):(test_val_size+train_size),1201);

%Test Set
Xtest = X_total((test_val_size+train_size+1):end,1:1200);
ytest = X_total((test_val_size+train_size+1):end,1201);

fprintf('Program paused. Press enter to continue.\n');
pause;

%% ================ Part 2: Initializing Pameters ================
%  Implementing a function to initialize the weights of the neural network
%  (randInitializeWeights.m)

fprintf('\nInitializing Neural Network Parameters ...\n')

%Randomly intializes theta1 and Theta2
initial_Theta1 = randInitializeWeights(input_layer_size, hidden_layer_size);
initial_Theta2 = randInitializeWeights(hidden_layer_size, num_labels);

% Unroll parameters
initial_nn_params = [initial_Theta1(:) ; initial_Theta2(:)];

%% =================== Part 3: Training NN ===================
% To train the neural network, use "fmincg", which is a minmization function

fprintf('\nTraining Neural Network... \n')

%Number of iterations the trainner will use for finding Lambda
options = optimset('MaxIter', 500);

%  Runs through different values of Lambda to find the one with the least
%  error
lambda = lambdaPicker(X, y, Xval, yval, initial_nn_params,...
    input_layer_size,hidden_layer_size,num_labels, options);

fprintf('Optimal Lambda = %d\n',lambda);

%Number of iterations to train the NN
options = optimset('MaxIter', 5000);

% Create "short hand" for the cost function to be minimized
costFunction = @(p) nnCostFunction(p, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, X, y, lambda);

% Now, costFunction is a function that takes in only one argument (the
% neural network parameters)
[nn_params, ~] = fmincg(costFunction, initial_nn_params, options);

% Obtain Theta1 and Theta2 back from nn_params
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));
             
% Save weights for use in the future
save('nnWeights.mat','Theta1','Theta2');
fprintf('Theta1 and Theta2 saved!\n');

fprintf('Program paused. Press enter to continue.\n');
pause;

%% ================= Part 4: Implement Predict =================
%  Predict the classes of the test set examples

pred = predict(Theta1, Theta2, Xtest);

fprintf('\nTraining Set Accuracy: %f\n', mean(double(pred == ytest)) * 100);


%% ================ Part 5: Test for Plane Features ================
%Tests if the NN can classify the Green and Red boxes from the plane
%accurately

%Gathers data from TEST folder
feat = featureMaker('TEST');
Xt = (feat(:,1:1200)-127)/255;
yt = feat(:,1201);
yt(2) = yt(2) + 2;  %y = 3 = 'Green' Class

pred = predict(Theta1, Theta2, Xt);

fprintf('\nTraining Set Accuracy: %f\n', mean(double(pred == yt)) * 100);
pause;
