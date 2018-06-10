%% NN Color Recongizer: Image Capture and Scanning
% This script will capture an image from an iPhone running "IPCam"
% After capturing the image, it will scan the image for green and red
% objects, save their locations, and encode them to a physical location


%% Initialization
clear ; close all; clc
%% ==================== Part 1: IPCam Image Capture =================
%Grab the image from the iPhone and save
url = 'http://10.143.236.237:8020//image.jpg';       %URL of IPcam on iPhone

IPcam_snap = imageCapture(url);                    %Save image from iPhone
image(IPcam_snap)
pause;

%% ===================Part 2: Image Scan ============================
%Scan through the image saved from Part 1 and use the trained theta values
%from "NN_ParameterTrainning" to find the green and red objects

pixel_location = picScan(IPcam_snap,Theta1,Theta2);
pause;
%% ==================Part 3: Encode Pixel Locations ==================
% We have predetermined the pixel locations of the axes of the grid. (A-R)
% and (1-14). We will determine where the red and green objects are
% positioned by using the pixel_location found in Part 2.
% This all depends on the camera being position 33mm above the paper and
% positioned with the sides aligned with the camera edges and equal amounts
% of space above and below the paper.

str_results = encodePixel(pixel_location);
pause;
%% ================== Part 4: Send to Motor ==========================
% After finding our the locations of the objects in the picture,
% predetermined Gcode to move to these positions and connect the dots will
% be send to the motors.


pixel2Gcode(str_results);
gcodeLines = readGCodeFile('gcode_grid.txt');
sendGcode(gcodeLines,'COM14');
