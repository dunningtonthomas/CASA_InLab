function [rh_data] = importRHDataTSI(path)
%importRHDataTSI - Import data from TSI RH probe 
%   Output is a table of the RH data with the headers time, RH, and
%   rh_volts
%   rh_data.time is the date and time in Matlab datetime format
%   rh_data.RH is the percent relative humidity
%   rh_data.Temp is the temperature
%   Last edited 3/24/22 by KJM

%% Import data
    % Open folder
    %Get the current directory
    currD = pwd;
    if nargin > 0
        current = cd(path);
    else
        path = cd();
    end
    
    % Select RH data files (can select multiple text files)
    filelist = uigetfile('.txt', 'Select RH data file', 'MultiSelect', 'on');
    
    tempBool = 0;
    if(ischar(filelist)) %Condition for 1 input file
        tempBool = 1;
    end
    
    %% Set up the Import Options and import the data
    opts = delimitedTextImportOptions("NumVariables", 4);
    
    % Specify range and delimiter
    opts.DataLines = [4, Inf];
    opts.Delimiter = ",";
    
    % Specify column names and types
    opts.VariableNames = ["date", "time", "RH", "Temp"];
    opts.VariableTypes = ["datetime", "datetime", "double", "double"];
    
    % Specify file level properties
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";
    
    % Specify variable properties
    opts = setvaropts(opts, "date", "InputFormat", "MM/dd/yyyy");
    opts = setvaropts(opts, "time", "InputFormat", "HH:mm:ss");
    
    % Import the data
    [~,c] = size(filelist);
    rh_data = table();
    
    if(~tempBool)
        for i = 1:c
            temp = readtable([path,'\',filelist{i}], opts);
            rh_data = [rh_data;temp];
            clearvars temp
        end
    else
        temp = readtable([path,'\',filelist], opts);
        rh_data = [rh_data;temp];
        clearvars temp    
    end
        
    
    % Combine date and time into a single column
    rh_data.time.Day = rh_data.date.Day;
    rh_data.time.Month = rh_data.date.Month;
    rh_data.time.Year = rh_data.time.Year;
    rh_data.time.Format = 'default';
    rh_data.date = []; %delete unnecessary date column
    
    % Sort table by time and date so it is in order
    rh_data = sortrows(rh_data);
    
    %% Clear temporary variables
    clear opts
    %Go back
    cd(currD);
end