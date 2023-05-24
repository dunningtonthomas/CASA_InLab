%% Clean Up
clear; close all; clc;

%% Import Data
%SMPS Import 1
pathSMPS = 'C:\Users\Thomas\Documents\MATLAB\GitHub\SPUR\CASA_InLab\CASA_InLab\TwoSMPSCalibration\Data';
smpsData1 = importSMPS(pathSMPS);
smpsDataRaw1 = smpsData1;

%SMPS import 2
smpsData2 = importSMPS(pathSMPS);
smpsDataRaw2 = smpsData2;

timeData = [smpsData1{1,:}];


%% Analysis
%Size Distribution Analysis
sizeBins = [smpsData1{2,1}]; %The size bins are the same for each scan


%Calculating the average
meanConc1 = mean([smpsData1{3,1:end}],2);
meanConc2 = mean([smpsData2{3,1:end}],2);

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
%This is also the total mass for the PSLs since the density is 1

volumeBins1 = [smpsData1{2,1}];
volumeBins1 = (1/6)*pi*(volumeBins1 / 1000).^3;
for i = 1:length(smpsData1(1,:))
    volumes1 = volumeBins1 .* [smpsData1{3,i}];
    smpsData1{5,i} = volumes1;
end

volumeBins2 = [smpsData2{2,1}];
volumeBins2 = (1/6)*pi*(volumeBins2 / 1000).^3;
for i = 1:length(smpsData2(1,:))
    volumes2 = volumeBins2 .* [smpsData2{3,i}];
    smpsData2{5,i} = volumes2;
end


%% Finding the maximum concentration

%Calculating the average
meanMass1 = mean([smpsData1{5,1:end}],2);
meanMass2 = mean([smpsData2{5,1:end}],2);

%Finding the maximum number concentration
[maxVal1, indMaxNum1] = max(meanConc1);
[maxVal2, indMaxNum2] = max(meanConc2);

%Finding the maximum Mass concentration
[maxMass1, indMaxMass1] = max(meanMass1);
[maxMass2, indMaxMass2] = max(meanMass2);

%Max bins
bins = [smpsData1{2,1}];
maxNumBin1 = bins(indMaxNum1);
maxNumBin2 = bins(indMaxNum2);
maxMassBin1 = bins(indMaxMass1);
maxMassBin2 = bins(indMaxMass2);

%% Concentration Correction
% Butanol / water
concRatios5 = meanConc1 ./ meanConc2;

figure();
plot(bins(34:86), concRatios5(34:86));

fileName = "corrections.mat";
save(fileName,'concRatios5', 'bins','-append');   


%% Plotting
%Plotting the individual size distribution
figure();
subplot(1,2,1)

%Plot all of the points
indMaxNum1 = 0;
indMaxNum2 = 0;

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


%%%%%Plotting the individual size distribution MASS
figure();
subplot(1,2,1)

%Plot all of the points
indMaxNum1 = 0;
indMaxNum2 = 0;

%Starting the plot from the maximum index + 1
plot([smpsData1{2,indMaxNum1+1}], [smpsData1{5,indMaxNum1+1}]);
set(gca, 'xscale', 'log');
set(0, 'defaulttextinterpreter', 'latex');
hold on

%Creating color gradient so later in time is darker blue
colors = zeros(length(smpsData1(1,:)), 3);
colors(:,2) = 0.5*ones(length(smpsData1(1,:)),1);
colors(:,3) = linspace(0.5,1,length(smpsData1(1,:)))';

for i = 1:length(smpsData1(1,indMaxNum1+2:end))
    ind1 = i + indMaxNum1 + 1; %Starting at index 3
    plot([smpsData1{2,ind1}], [smpsData1{5,ind1}], 'color', colors(i,:));
end

plot([smpsData1{2,3}], meanMass1, 'linewidth', 3, 'color', 'k');

xlabel('Size $$(nm)$$');
ylabel('Mass Concentration $$\frac{\mu g}{cm^{3}}$$');
title('Butanol Mass Concentration');



subplot(1,2,2)
%Starting the plot from the maximum index + 1
plot([smpsData2{2,indMaxNum2+1}], [smpsData2{5,indMaxNum2+1}]);
set(gca, 'xscale', 'log');
set(0, 'defaulttextinterpreter', 'latex');
hold on

%Creating color gradient so later in time is darker blue
colors = zeros(length(smpsData2(1,:)), 3);
colors(:,2) = 0.5*ones(length(smpsData2(1,:)),1);
colors(:,3) = linspace(0.5,1,length(smpsData2(1,:)))';

for i = 1:length(smpsData2(1,indMaxNum2+2:end))
    ind2 = i + indMaxNum2 + 1; %Starting at index 3
    plot([smpsData2{2,ind2}], [smpsData2{5,ind2}], 'color', colors(i,:));
end

plot([smpsData2{2,3}], meanMass2, 'linewidth', 3, 'color', 'k');

xlabel('Size $$(nm)$$');
ylabel('Mass Concentration $$\frac{\mu g}{cm^{3}}$$');
title('Water Mass Concentration');


