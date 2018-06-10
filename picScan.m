function pixel_location= picScan(pic,Theta1,Theta2)
% PICSCAN  uses the pre-trained NN to identify RED and GREEN objects.
%
%   pixel_location = PICSCAN(pic,Theta1,Theta2) takes the pre-trained
%       weights (Theta1, Theta2) from the NN and scans through the picture
%       (pic). A 20x20 pixel window scans through the picture and predicts
%       for each window if there is a RED or GREEN object.
%  
%       Function is included in GUI app and is not called.
picd = double(pic);                           %Converts to double

%Resize to dimensions that is divisable by 20
resize_pic = imresize(pic,[760 1020]);        %Used for displaying
resize_picd = imresize(picd,[760 1020]);      %Used for computing
figure(1)
image(resize_pic)                             %Display image
pause;

%Some constants and intializing
results = zeros(122,163);
greenRed = [];
vertical_low = -19;
a =0;

figure(2)
for m = 1:38 %Contorls scanning across columns
    horizontal_low = -19; %Reset the the horizontal scan to left side
    vertical_low = vertical_low + 20;
    vertical_high = vertical_low + 19;
    for n = 1:51 %Controls scanning across rows
        %Creates dimensions for window
        horizontal_low = horizontal_low + 20;
        horizontal_high = horizontal_low+19;
        
        %Window creation
        window = resize_picd(vertical_low:vertical_high,...
            horizontal_low:horizontal_high,:); %Used for computing
        window_display = resize_pic(vertical_low:vertical_high,...
            horizontal_low:horizontal_high,:); %Used for displaying
        
        %Extract data from RGB matricies
        x1 = reshape(window(:,:,1),1,400);
        x2 = reshape(window(:,:,2),1,400);
        x3 = reshape(window(:,:,3),1,400);
        X=[x1 x2 x3];   %Roll into a single row vector
        X = (X-127)/255; %Feature scaling
        
        %Predict the color of the primary color of the window using
        %trainned weights
        results(m,n) = predict(Theta1,Theta2, X);
        
        %If the prediction outputs red or green display and store data
        if(results(m,n) == 1 || results(m,n) == 3)
            figure(2)
            image(window_display)
            figure(1)
            figure(1)
            hold on %%Remove app.UIAxes if not using app
            line([horizontal_low,horizontal_low],[vertical_low,vertical_high],'LineWidth',3);
            line([horizontal_high,horizontal_high],[vertical_low,vertical_high],'LineWidth',3);
            line([horizontal_low,horizontal_high],[vertical_low,vertical_low],'LineWidth',3);
            line([horizontal_low,horizontal_high],[vertical_high,vertical_high],'LineWidth',3);
            hold off
            a = a+1;

            pixel_location(a,:) = [vertical_low vertical_high...
                horizontal_low horizontal_high results(m,n)]
             pause;
        end
    end
end
  