function [cellArr] = importRh(fileName,directory)
%IMPORTRH This function takes as input the RH data file generated from
%Python and the directory where this is stored, it then inputs the data
%into a cell array that is 2 by n with the first column storing the time
%and the second storing the RH data

%Storing the current directory
currD = pwd;

cd(directory);

%Setting up the options for importing using readmatrix
opts = delimitedTextImportOptions('NumVariables', 5);
opts.VariableNames(1) = {'Time'};
opts.VariableNames(2) = {'Something'};
opts.VariableNames(3) = {'Something'};
opts.VariableNames(4) = {'Something'};
opts.VariableNames(5) = {'Something'};

%Reading in the data
data = readmatrix(fileName, opts);

RH = data(4:end, 3);

%Concatenating the dates and times to get a datetime
%Will store the times as a duration variable and the dates as a datetime,
%then will add the duration variable to the datetime to get the overall
%datetime
%Variable Initialization
dateTimes = datetime('10/03/2022');

%Creating the cell array to store the data
cellArr = cell(2,length(data(4:end, 1)));
infmt = 'MM/dd/uuuu HH:mm:ss';
for i = 4:length(data(4:end, 1))
    dateTemp = datetime(strcat(data{i,1}," ", data{i,2}), 'InputFormat', infmt);
    cellArr{1,i-3} = dateTemp;
    cellArr{2,i-3} = RH(i-3);
end

%Back to the original directory
cd(currD);
end

