function gcodeLines = readGCodeFile(fileName)
%READGCODEFILE reads the text file containg Gcode.
%   gcodeLines = readGCodeFile(fileName) takes the file specifed and turns
%   it into a CELL type.

fid=fopen(fileName);                %Open file
tline = fgetl(fid);                 
gcodeLines = cell(0,1);             %Pre-allocated variable

%While there are still lines to read in the file
while ischar(tline)
    gcodeLines{end+1,1} = tline;
    tline = fgetl(fid);
end

fclose(fid);