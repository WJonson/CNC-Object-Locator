function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

%Part I:Feedforward and Cost Function

%Feedforward to find hypothesis(h) 
a1 = [ones(m,1) X];
z2 = a1 * Theta1';
a2 = [ones(m,1) sigmoid(z2)];
z3 = a2 * Theta2';
h = sigmoid(z3);

%Cost Function
eye_matrix = eye(num_labels);
y_matrix = eye_matrix(y,:);

J = 1/m * sum(sum(-y_matrix .* log(h) - ((1-y_matrix) .* log(1-h)),2),1)...
    + lambda/(2*m) * (sum(sum(Theta1(:,2:end).^2,2),1) + sum(sum(Theta2(:,2:end).^2,2),1));

%Part II
delta3 = h - y_matrix;
delta2 = delta3 * Theta2(:,2:end) .* sigmoidGradient(z2);

DEL1 = delta2' * a1;
DEL2 = delta3' * a2;

Theta1_grad = 1/m * DEL1;
Theta2_grad = 1/m * DEL2;

%Part III
Theta1(:,1) = 0;
Theta2(:,1) = 0;

Theta1 = Theta1*(lambda/(m));
Theta2 = Theta2*(lambda/(m));

Theta1_grad = Theta1_grad + Theta1;
Theta2_grad = Theta2_grad + Theta2;



% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
