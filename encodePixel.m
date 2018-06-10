function results = encodePixel(pixel_location)
% ENCODEPIXEL  takes results from PICSCAN and identifies where the objects
%              are on the grid.
%   results = ENCODEPIXEL(pixel_location) takes data from pixel_location
%     data and looks up where the object lies on the grid. Results will 
%     contain data of the color, column and row location, and Gcode
%     (in absolute) position.
%
%   Note: Only the first 2 green and first 2 red objects will be saved. 
%         This will make results a 4x5 matrix.
%

%Pre-allocate memory
sizeResults = size(pixel_location,1);
str_results = strings(sizeResults,5);
results = strings(4,5);

%Initalize variables
red_count = 0;
green_count = 0;
total_count=1;

%Will determine the color of the results in pixel_location (last row should
%be information of the color.
for n = 1:sizeResults
    if pixel_location(n,5) == 1  %1 = red
        str_results(n,1) = 'RED';
    elseif pixel_location(n,5) == 3 %3 = green
        str_results(n,1) = 'GREEN';
    end
end

%LUT to determine column, row, and Gcode
for m = 1:sizeResults
    %LUT to determine vertical location (ROWS)
    if pixel_location(m,4) >= 176 && ...  %Numbers represent pixels
            pixel_location(m,4)<= 233
        str_results(m,2) = 'AJ';          %Grid location on the paper 
        str_results(m,4) = ' Y211';       %Gcode to move vertically
    elseif pixel_location(m,4) > 233 && ...
            pixel_location(m,4)<= 290
        str_results(m,2) = 'BK';
        str_results(m,4) = ' Y187';
    elseif pixel_location(m,4) > 290 && ...
            pixel_location(m,4)<= 348
        str_results(m,2) = 'CL';
        str_results(m,4) = ' Y163';
    elseif pixel_location(m,4) > 348 && ...
            pixel_location(m,4)<= 402
        str_results(m,2) = 'DM';
        str_results(m,4) = ' Y139';
    elseif pixel_location(m,4) > 402 && ...
            pixel_location(m,4)<= 460
        str_results(m,2) = 'EN';
        str_results(m,4) = ' Y115';
    elseif pixel_location(m,4) > 460 && ...
            pixel_location(m,4)<= 515
        str_results(m,2) = 'FO';
        str_results(m,4) = ' Y91';
    elseif pixel_location(m,4) > 515 && ...
            pixel_location(m,4)< 572
        str_results(m,2) = 'GP';
        str_results(m,4) = ' Y67';
    elseif pixel_location(m,4) > 572 && ...
            pixel_location(m,4)<= 627
        str_results(m,2) = 'HQ';
        str_results(m,4) = ' Y43';
    elseif pixel_location(m,4) > 627 && ...
            pixel_location(m,4)<= 686
        str_results(m,2) = 'IR';
        str_results(m,4) = ' Y19';
    end
    
    %LUT to determine horizontal location (COLUMNS)
    if pixel_location(m,2) <= 675 && ...
          pixel_location(m,2)>= 601
        str_results(m,3) = '18';            %Grid location on paper
        str_results(m,5) = ' X21';          %Gcode to move horizontally
    elseif pixel_location(m,2) < 601 ...
           && pixel_location(m,2)>= 527
        str_results(m,3) = '29';
        str_results(m,5) = ' X45';
    elseif pixel_location(m,2) < 527 ...
            && pixel_location(m,2)>= 453
        str_results(m,3) = '310';
        str_results(m,5) = ' X69';
    elseif pixel_location(m,2) < 453 ...
           && pixel_location(m,2)>= 385
        str_results(m,3) = '411';
        str_results(m,5) = ' X93';
    elseif pixel_location(m,2) < 385 ...
            && pixel_location(m,2)>= 305
        str_results(m,3) = '512';
        str_results(m,5) = ' X117';
    elseif pixel_location(m,2) < 305 ...
            && pixel_location(m,2)>= 231
        str_results(m,3) = '613';
        str_results(m,5) = ' X141';
    elseif pixel_location(m,2) < 231 ...
            && pixel_location(m,2)>= 159
        str_results(m,3) = '714';
        str_results(m,5) = ' X165';
    end

    %Stop program if 2 red and 2 green objects are found already
    %Saves first result m == 1
    if m == 1
        if str_results(m,1) == 'RED'
            red_count = red_count + 1;     %Increase count for red
        end
        if str_results(m,1) == 'GREEN'
            green_count = green_count + 1; %Increase count for green
        end  
        results(total_count,:) = str_results(m,:); %Save results 
        total_count = total_count+1;       %Counts how many have been saved  
    %Saves results when m >=2
    elseif str_results(m,2) ~= str_results(m-1,2) &&...
            str_results(m,3) ~= str_results(m-1,3) && m >=2
        if str_results(m,1) == 'RED'
            red_count = red_count + 1;
        end
        if str_results(m,1) == 'GREEN'
            green_count = green_count + 1;
        end
        results(total_count,:) = str_results(m,:);
        total_count = total_count+1;
    end
    
    %If 2 red and 2 green objects have been saved, break loop
    if red_count == 2 && green_count == 2
        break
    end
end
