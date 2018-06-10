function pixel2Gcode(str_results)
% PIXEL2GCODE  takes Gcode results from ENCODEPIXEL and formats the data 
%              to be sent to GRBL.
%
%   PIXEL2GCODE(str_results)  takes the Gcode data from str_results and 
%       formats them with Gcode to be used with the XY plotter. "Pen up" and
%       "pen down" commands are added as well as return-to-zero and
%       feedrate commands.
%  
%       Gcode commands to connect the RED and GREEN objects to "4" and "E"
%       on the grid are also included.

size_results = size(str_results,1);     %Determine size of str_results
gcode = [];                             %Pre-allocate memory for gcode
gcode=['F1000','\n'];                   %Set feedrate to "1000"
gcode = [gcode,'G90','\n'];             %Gcode in "absolute" positions
gcode=[gcode,'G21','\n'];               %Metric system

%Run through str_results and format the gcode properly
for n = 1:size_results
    gcode=[gcode,'M3 S90','\n'];        %Lift the pen up
    gcode=[gcode,'G4 P1','\n'];
    %Move the plotter to the location of the object
    gcode=[gcode,'G00', char(str_results(n,5)),char(str_results(n,4)),'\n'];
    gcode=[gcode,'M5 S90','\n'];        %Place pen down
    gcode=[gcode,'G4 P1','\n'];
    %Determine what object this is
    if str_results(n,1) == 'RED'
        gcode=[gcode,'G01',' X93',' Y229.5','\n']; %Connect to "4"
    elseif str_results(n,1) == 'GREEN'
        gcode=[gcode,'G01',' X4.5',' Y113.5','\n'];%Connect to "E"
    end
end

gcode=[gcode,'M3','\n'];            %Lift pen up
gcode=[gcode,'G4 P1','\n'];  

gcode=[gcode,'G000 X0.000 Y0.000','\n'];    %Return-to-zero
                                                                
gcode=[gcode,'M30','\n'];           %Notify GRBL Gcode end
u=sprintf(gcode);                   %Print Gcode to string

fid = fopen('gcode_grid.txt','w');  %Create text file to save Gcode
fprintf(fid,'%c',u);                
fclose(fid);                        %Close file
