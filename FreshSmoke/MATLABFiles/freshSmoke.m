%% Clean Up
clear; close all; clc;

%% Import Data

%SMPS import
pathSMPS = 'C:\Users\Thomas\Documents\MATLAB\GitHub\SPUR\CASA_InLab\CASA_InLab\FreshSmoke\DataFiles';
smpsData = importSMPS(pathSMPS);
smpsDataRaw = smpsData;

timeData = [smpsData{1,:}];


%RH data import
pathRH = 'C:\Users\Thomas\Documents\MATLAB\GitHub\SPUR\CASA_InLab\CASA_InLab\FreshSmoke\DataFiles\RHData';

rhTable = importRHDataTSI(pathRH);
 
rhData = [rhTable{:,2}];
rhTime = [rhTable{:,1}];


%% Analysis
%Truncating RH data so it is within the experiment
expStart = timeData(1);
expEnd = timeData(end);

logVec = rhTime >= expStart & rhTime <= expEnd;

rhData = rhData(logVec);
rhTime = rhTime(logVec);

%Size Distribution Analysis
sizeBins = [smpsData{2,1}]; %The size bins are the same for each scan


%Calculating the average
meanConc = mean([smpsData{3,2:end}],2);

%Finding the maximum concentration of the mean
[maxConc, ind] = max(meanConc);

%Finding total number concentration, storing in the fourth row
for i = 1:length(smpsData(1,:))
    
    smpsData{4,i} = sum([smpsData{3,i}]);
end

%Subtracting the ambient scan initial concentration to get the change once
%smoke is introduced
% initialConc = sum([smpsData{3,1}]);
% for i = 1:length(smpsData(1,1:end))
%     
%     smpsData{4,i} = sum([smpsData{3,i}]) - initialConc;
%     
% end


%Finding the size of the max for the mean concentration
[maximumMeanConc, maximumMeanInd] = max(meanConc);
maxMeanSize = sizeBins(maximumMeanInd);

%% Finding the maximum concentration for each scan, plotting the size bin of this over time
%Literature:
%Smoke coagulation changing the size distribution versus the high RH

maxSizeBin = zeros(length(smpsData(1,:)),1); %Vector to store the size bin of the max concentration
for i = 1:length(smpsData(1,:))    
    [maxConc, maxConcInd] = max([smpsData{3,i}]);
    maxSizeBin(i) = sizeBins(maxConcInd);
end


%% Calculate the total volume over time
%TOTAL volume concentration is stored in the 5 row of smpsData
%VolumeBins is the volume of a single particle in each bin
%Units are micrometers cubed
volumeBins = [smpsData{2,1}];
volumeBins = (1/6)*pi*(volumeBins / 1000).^3;
for i = 1:length(smpsData(1,:))
    volumes = volumeBins .* [smpsData{3,i}];
    totalVolumeScan = sum(volumes);
    smpsData{5,i} = totalVolumeScan;
end


%% Finding where the concentration dips below a certain amount

%Times less than 1000, looks at 1302 and 1303 columns
totalNumConc = [smpsData{4,:}];
[maxVal, indMaxNum] = max(totalNumConc);


%% Plotting
%Plotting the individual size distribution
figure();
%Starting the plot from the maximum index + 1
plot([smpsData{2,indMaxNum+1}], [smpsData{3,indMaxNum+1}]);
set(gca, 'xscale', 'log');
set(0, 'defaulttextinterpreter', 'latex');
hold on

%Creating color gradient so later in time is darker blue
colors = zeros(length(smpsData(1,:)), 3);
colors(:,2) = 0.5*ones(length(smpsData(1,:)),1);
colors(:,3) = linspace(0.5,1,length(smpsData(1,:)))';

for i = 1:length(smpsData(1,indMaxNum+2:end))
    ind = i + indMaxNum + 1; %Starting at index 3
    plot([smpsData{2,ind}], [smpsData{3,ind}], 'color', colors(i,:));
end

plot([smpsData{2,3}], meanConc, 'linewidth', 3, 'color', 'k');

xlabel('Size $$(nm)$$');
ylabel('Number Concentration $$\frac{\#}{cm^{3}}$$');
title('Number Concentration');


%Total number concentration
figure();
plot([smpsData{1,:}], [smpsData{4,:}], 'linewidth', 2);

xlabel('Time');
ylabel('Total Number Concentration $$\frac{\#}{cm^{3}}$$');
title('Number Concentration over Time');


%Total Volume Concentration
%plotting a time window of 8 hours from the start of the scans, this makes
%it so we look at when the smoke is coagulating and growing. This number
%was determined by inspection of the maxSizeBin versus time plot

%Setting time limit
timeLim = smpsData{1,1} + hours(8);
logTime = timeData < timeLim;

%Getting the volume to plot
volumeTotal = [smpsData{5,:}];

%Plot
figure();
timePlot = timeData(logTime);
volumePlot = volumeTotal(logTime);

plot(timePlot(3:end), volumePlot(3:end), 'linewidth', 2);

xlabel('Time');
ylabel('Total Volume Concentration $$\frac{\mu m^{3}}{cm^{3}}$$');
title('Volume Concentration over Time');



%Plotting the maximum size bin for each scan over time
%Removing Background Data, start at index 3
%Also plotting within the time window determined by inspection to be 8
%hours where the smoke is continuing to coagulate
figure();

sizeBinPlot = maxSizeBin(logTime);
plot(timePlot(3:end), sizeBinPlot(3:end), 'linewidth', 2, 'color', rgb('light red'));
hold on

xlabel('Time');
ylabel('Peak Size Bin $$nm$$');
title('Maximum Concentration Size Bin Over Time');


%Plotting the RH data
figure();
plot(rhTime, rhData, 'linewidth', 2, 'color', rgb('light blue'));

xlabel('Time');
ylabel('RH $$\%$$');
title('Relative Humidity Over Time');

%Add comment











