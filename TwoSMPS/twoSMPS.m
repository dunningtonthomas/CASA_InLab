%% Clean Up
clear; close all; clc;

%% Import Data
%SMPS Import 1
pathSMPS = 'C:\Users\Thomas\Documents\MATLAB\GitHub\SPUR\CASA_InLab\CASA_InLab\TwoSMPS\Data';
smpsData1 = importSMPS(pathSMPS);
smpsDataRaw1 = smpsData1;

%SMPS import 2
smpsData2 = importSMPS(pathSMPS);
smpsDataRaw2 = smpsData2;

timeData = [smpsData1{1,:}];


%RH data import
pathRH = 'C:\Users\Thomas\Documents\MATLAB\GitHub\SPUR\CASA_InLab\CASA_InLab\TwoSMPS\RHData';
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
sizeBins = [smpsData1{2,1}]; %The size bins are the same for each scan


%Calculating the average
meanConc1 = mean([smpsData1{3,2:end}],2);
meanConc2 = mean([smpsData2{3,2:end}],2);

%Finding the maximum concentration of the mean
[maxConc1, ind1] = max(meanConc1);
[maxConc2, ind2] = max(meanConc2);

%Finding total number concentration, storing in the fourth row
for i = 1:length(smpsData1(1,:))
    
    smpsData1{4,i} = sum([smpsData1{3,i}]);
end

for i = 1:length(smpsData2(1,:))
    
    smpsData2{4,i} = sum([smpsData2{3,i}]);
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
[maximumMeanConc1, maximumMeanInd1] = max(meanConc1);
maxMeanSize1 = sizeBins(maximumMeanInd1);

[maximumMeanConc2, maximumMeanInd2] = max(meanConc2);
maxMeanSize2 = sizeBins(maximumMeanInd2);

%% Finding the maximum concentration for each scan, plotting the size bin of this over time
%Literature:
%Smoke coagulation changing the size distribution versus the high RH

maxSizeBin1 = zeros(length(smpsData1(1,:)),1); %Vector to store the size bin of the max concentration
for i = 1:length(smpsData1(1,:))    
    [maxConc1, maxConcInd1] = max([smpsData1{3,i}]);
    maxSizeBin1(i) = sizeBins(maxConcInd1);
end

maxSizeBin2 = zeros(length(smpsData2(1,:)),1); %Vector to store the size bin of the max concentration
for i = 1:length(smpsData2(1,:))    
    [maxConc2, maxConcInd2] = max([smpsData2{3,i}]);
    maxSizeBin2(i) = sizeBins(maxConcInd2);
end


%% Calculate the total volume over time
%TOTAL volume concentration is stored in the 5 row of smpsData
%VolumeBins is the volume of a single particle in each bin
%Units are micrometers cubed
volumeBins1 = [smpsData1{2,1}];
volumeBins1 = (1/6)*pi*(volumeBins1 / 1000).^3;
for i = 1:length(smpsData1(1,:))
    volumes1 = volumeBins1 .* [smpsData1{3,i}];
    totalVolumeScan1 = sum(volumes1);
    smpsData1{5,i} = totalVolumeScan1;
end

volumeBins2 = [smpsData2{2,1}];
volumeBins2 = (1/6)*pi*(volumeBins2 / 1000).^3;
for i = 1:length(smpsData2(1,:))
    volumes2 = volumeBins2 .* [smpsData2{3,i}];
    totalVolumeScan2 = sum(volumes2);
    smpsData2{5,i} = totalVolumeScan2;
end

%% Finding where the concentration dips below a certain amount

%Times less than 1000, looks at 1302 and 1303 columns
totalNumConc1 = [smpsData1{4,:}];
[maxVal1, indMaxNum1] = max(totalNumConc1);

totalNumConc2 = [smpsData2{4,:}];
[maxVal2, indMaxNum2] = max(totalNumConc2);


%% Plotting
%Plotting the individual size distribution
figure();
subplot(1,2,1)
%Starting the plot from the maximum index + 1
plot([smpsData1{2,indMaxNum1+1}], [smpsData1{3,indMaxNum1+1}]);
set(gca, 'xscale', 'log');
set(0, 'defaulttextinterpreter', 'latex');
hold on

%Creating color gradient so later in time is darker blue
colors = zeros(length(smpsData1(1,:)), 3);
colors(:,2) = 0.5*ones(length(smpsData1(1,:)),1);
colors(:,3) = linspace(0.5,1,length(smpsData1(1,:)))';

for i = 1:length(smpsData1(1,indMaxNum1+2:end))
    ind1 = i + indMaxNum1 + 1; %Starting at index 3
    plot([smpsData1{2,ind1}], [smpsData1{3,ind1}], 'color', colors(i,:));
end

plot([smpsData1{2,3}], meanConc1, 'linewidth', 3, 'color', 'k');

xlabel('Size $$(nm)$$');
ylabel('Number Concentration $$\frac{\#}{cm^{3}}$$');
title('Dry Number Concentration');



subplot(1,2,2)
%Starting the plot from the maximum index + 1
plot([smpsData2{2,indMaxNum2+1}], [smpsData2{3,indMaxNum2+1}]);
set(gca, 'xscale', 'log');
set(0, 'defaulttextinterpreter', 'latex');
hold on

%Creating color gradient so later in time is darker blue
colors = zeros(length(smpsData2(1,:)), 3);
colors(:,2) = 0.5*ones(length(smpsData2(1,:)),1);
colors(:,3) = linspace(0.5,1,length(smpsData2(1,:)))';

for i = 1:length(smpsData2(1,indMaxNum2+2:end))
    ind2 = i + indMaxNum2 + 1; %Starting at index 3
    plot([smpsData2{2,ind2}], [smpsData2{3,ind2}], 'color', colors(i,:));
end

plot([smpsData2{2,3}], meanConc2, 'linewidth', 3, 'color', 'k');

xlabel('Size $$(nm)$$');
ylabel('Number Concentration $$\frac{\#}{cm^{3}}$$');
title('Wet Number Concentration');



%Total number concentration
figure();
subplot(1,2,1)
plot([smpsData1{1,:}], [smpsData1{4,:}], 'linewidth', 2);

xlabel('Time');
ylabel('Total Number Concentration $$\frac{\#}{cm^{3}}$$');
title('Dry Number Concentration over Time');

subplot(1,2,2)
plot([smpsData2{1,:}], [smpsData2{4,:}], 'linewidth', 2);

xlabel('Time');
ylabel('Total Number Concentration $$\frac{\#}{cm^{3}}$$');
title('Wet Number Concentration over Time');


%Total Volume Concentration
%plotting a time window of 8 hours from the start of the scans, this makes
%it so we look at when the smoke is coagulating and growing. This number
%was determined by inspection of the maxSizeBin versus time plot

%Setting time limit
timeLim1 = smpsData1{1,1} + hours(8);
logTime1 = timeData < timeLim1;

%Getting the volume to plot
volumeTotal1 = [smpsData1{5,:}];

%Setting time limit
timeLim2 = smpsData2{1,1} + hours(8);
logTime2 = timeData < timeLim2;

%Getting the volume to plot
volumeTotal2 = [smpsData2{5,:}];

%Plot
figure();
subplot(1,2,1)
timePlot1 = timeData(logTime1);
volumePlot1 = volumeTotal1(logTime1);

plot(timePlot1(3:end), volumePlot1(3:end), 'linewidth', 2);

xlabel('Time');
ylabel('Total Volume Concentration $$\frac{\mu m^{3}}{cm^{3}}$$');
title('Dry Volume Concentration over Time');

subplot(1,2,2)
timePlot2 = timeData(logTime2);
volumePlot2 = volumeTotal2(logTime2);

plot(timePlot2(3:end), volumePlot2(3:end), 'linewidth', 2);

xlabel('Time');
ylabel('Total Volume Concentration $$\frac{\mu m^{3}}{cm^{3}}$$');
title('Wet Volume Concentration over Time');



%Plotting the maximum size bin for each scan over time
%Removing Background Data, start at index 3
%Also plotting within the time window determined by inspection to be 8
%hours where the smoke is continuing to coagulate
figure();
subplot(1,2,1);

sizeBinPlot1 = maxSizeBin1(logTime1);
plot(timePlot1(3:end), sizeBinPlot1(3:end), 'linewidth', 2, 'color', rgb('light red'));
hold on

xlabel('Time');
ylabel('Peak Size Bin $$nm$$');
title('Dry Maximum Concentration Size Bin Over Time');

subplot(1,2,2);

sizeBinPlot2 = maxSizeBin2(logTime2);
plot(timePlot2(3:end), sizeBinPlot2(3:end), 'linewidth', 2, 'color', rgb('light red'));
hold on

xlabel('Time');
ylabel('Peak Size Bin $$nm$$');
title('Wet Maximum Concentration Size Bin Over Time');


%Plotting the RH data
figure();
plot(rhTime, rhData, 'linewidth', 2, 'color', rgb('light blue'));

xlabel('Time');
ylabel('RH $$\%$$');
title('Relative Humidity Over Time');












