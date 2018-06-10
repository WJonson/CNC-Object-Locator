function ss = imageCapture(url)
% IMAGECAPTURE captures the image from the inputed url.
%
%   ss = imageCapture(url)  captures the image from the url and saves it to
%                           ss.
%
%   Function was developed using the "IPcam" app from the apple app store.
%   URL is provided by the app and both the MATLAB and the app must be 
%   connected to WIFI to work.
%

ss  = imread(url);      %Reads image from url
image(ss);              %Display image
