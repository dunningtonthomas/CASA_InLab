%% Clean Up
clear; close all; clc;

%% Import Data

%SMPS import
pathSMPS = 'C:\Users\Thomas\Documents\MATLAB\GitHub\SPUR\CASA_InLab\CASA_InLab\FreshSmoke\DataFiles';
smpsData = importSMPS(pathSMPS);
smpsDataRaw = smpsData;


%% Analysis

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


%% Finding where the concentration dips below a certain amount

%Times less than 1000, looks at 1302 and 1303 columns
totalNumConc = [smpsData{4,:}];
logVec = totalNumConc < 10000;
timeNumConc = [smpsData{1,:}];
timeNumConc = timeNumConc(logVec);
totalNumConcTrunc = totalNumConc(logVec);






%% Plotting
%Plotting the individual size distribution
figure();
plot([smpsData{2,2}], [smpsData{3,2}]);
set(gca, 'xscale', 'log');
set(0, 'defaulttextinterpreter', 'latex');
hold on

%Creating color gradient so later in time is darker blue
colors = zeros(length(smpsData(1,:)), 3);
colors(:,2) = 0.5*ones(length(smpsData(1,:)),1);
colors(:,3) = linspace(0.5,1,length(smpsData(1,:)))';

for i = 1:length(smpsData(1,3:end))
    ind = i + 2; %Starting at index 3
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

%Total number concentration once the value is below 1000
figure();
plot(timeNumConc, totalNumConcTrunc);







