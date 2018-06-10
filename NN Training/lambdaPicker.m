function lambda = lambdaPicker(X, y, Xval, yval, initial_nn_params,...
    input_layer_size,hidden_layer_size,num_labels, options)
% LAMBDAPICKER Tests different lambda values to see which one produces
%   the least amount of error.
%
%       lambda = LAMBDAPICKER(X, y, Xval, yval, initial_nn_params,...
%           (input_layer_size, hidden_layer_size, num_labels, options)
%           Tests an array of lambda values from 0.01 to 30 and checks 
%           which lambda produces the least error.
%

%An array of lambdas to test
lambda_temp = [0.01 0.03 0.1 0.3 1 3 10 30];

error = zeros(size(lambda_temp,2),1);

for n = 1:size(lambda_temp,2)
    % Create "short hand" for the cost function to be minimized
    costFunction = @(p) nnCostFunction(p, ...
                                       input_layer_size, ...
                                       hidden_layer_size, ...
                                       num_labels, X, y, lambda_temp(n));

    % Now, costFunction is a function that takes in only one argument (the
    % neural network parameters)
    [nn_params, ~] = fmincg(costFunction, initial_nn_params, options);

    % Obtain Theta1 and Theta2 back from nn_params
    Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                     hidden_layer_size, (input_layer_size + 1));

    Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                     num_labels, (hidden_layer_size + 1));
   pred = predict(Theta1, Theta2, Xval);      %Predicts with current Lambda
   error(n,:) = mean(double(pred == yval)) * 100; %Saves error in Array
end

%Find the lambda with the least error
lambda_index = find(error==min(min(error)));
%If there are 2 or more lambdas, then pick the largest one
r = find(lambda_index==max(lambda_index));
lambda = lambda_temp(lambda_index(r)); %Use the index to get the lambda