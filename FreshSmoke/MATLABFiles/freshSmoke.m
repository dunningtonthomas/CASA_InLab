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
numConc = [smpsData{4,:}];


%Calculating the average
meanConc = mean([smpsData{3,2:end}],2);

%% Plotting
figure();
plot([smpsData{2,2}], [smpsData{3,2}]);
set(gca, 'xscale', 'log');
set(0, 'defaulttextinterpreter', 'latex');
hold on
plot([smpsData{2,3}], [smpsData{3,3}]);
plot([smpsData{2,4}], [smpsData{3,4}]);
plot([smpsData{2,5}], [smpsData{3,5}]);
plot([smpsData{2,6}], [smpsData{3,6}]);

plot([smpsData{2,3}], meanConc, 'linewidth', 3, 'color', 'k');

xlabel('Size $$(nm)$$');
ylabel('Number Concentration $$\frac{\#}{cm^{3}}$$');
title('Number Concentration');

%Average Plot







