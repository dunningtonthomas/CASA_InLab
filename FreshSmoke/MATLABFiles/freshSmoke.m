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
initialConc = sum([smpsData{3,1}]);
for i = 1:length(smpsData(1,1:end))
    
    smpsData{4,i} = sum([smpsData{3,i}]) - initialConc;
    
end




%% Plotting
%Plotting the individual size distribution
figure();
plot([smpsData{2,2}], [smpsData{3,2}]);
set(gca, 'xscale', 'log');
set(0, 'defaulttextinterpreter', 'latex');
hold on

for i = 1:length(smpsData(1,3:end))
    ind = i + 2; %Starting at index 3
    plot([smpsData{2,ind}], [smpsData{3,ind}]);
end

plot([smpsData{2,3}], meanConc, 'linewidth', 3, 'color', 'k');

xlabel('Size $$(nm)$$');
ylabel('Number Concentration $$\frac{\#}{cm^{3}}$$');
title('Number Concentration');


%Total number concentration
figure();
plot([smpsData{1,:}], [smpsData{4,:}]);







