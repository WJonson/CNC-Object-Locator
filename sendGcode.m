function sendGcode(GCodeCell,PORT)
%APPSENDGCODE   sends generated Gcode to the connected Arduino.
%
%       Tested only with Arduino UNO.
%       GCodeCell = Of type CELL that contains Gcode to be sent
%       PORT = Serial port that Arduino is connected to
%
%       Function is already included in GUI app.

out = instrfind;
fclose(out);

cellSize = size(GCodeCell,1);

arduino = serial(PORT, 'BaudRate',115200);%Arduino object with 115200 Baud Rate
set(arduino,'TimeOut',30);  %If MATALAB does not recieve data from Arduino in 30 seconds
                            %then stop serial commuincation.
                            %Change if need more time to send data or if too slow
fprintf('Initiating Arduino Serial Connection...')
fopen(arduino);             %Open Serial communication
pause;

fscanf(arduino)             %Print GRBL startup text
fscanf(arduino)

%Read Gcode and Send
for n = 1:cellSize

    fprintf(arduino,GCodeCell{n});
    confirm = fgetl(arduino);
    fprintf('%s \t %s',GCodeCell{n},confirm);

end

fclose(arduino);
