% CREATEXY is a script that runs through the designated folders and
%   extracts the pixel data from the pictures inside. 
%
%  The data is formated into a 1x1201 matrix that contains the
%  X input and Y output data.
% 

% Extract pixel data from pictures in the folders
Xr = featureMaker('Red Objects');       %yr = 1
Xy = featureMaker('Yellow Objects');
Xy(:,1201) = Xy(:,1201) + 1;            %yy = 2
Xg = featureMaker('Green Objects');
Xg(:,1201) = Xg(:,1201) + 2;            %yg = 3 
Xbl = featureMaker('BlackGreyWhite Objects');
Xbl(:,1201) = Xbl(:,1201) + 3;          %ybl = 4

%Revmoes examples that are not representitive of the color
%White,black, and grey are exempt from this
Xr = abs(findBad(Xr));
Xy = abs(findBad(Xy));
Xg = abs(findBad(Xg));

%Creates two matricies with all of the examples
X_total = [Xr; Xy; Xg; Xbl];
X_total = X_total(randperm(size(X_total,1)),:); %Randomizes the order

%Seperates the Y data
y_total = X_total(:,1201);

%Feature fitting from -0.5 to 0.5
X_total(:,1:1200) = (X_total(:,1:1200)-127)/255;