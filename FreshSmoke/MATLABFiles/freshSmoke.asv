%% Clean Up
clear; close all; clc;

%% Import Data

%SMPS import
pathSMPS = 'C:\Users\Thomas\Documents\MATLAB\GitHub\SPUR\CASA_InLab\CASA_InLab\FreshSmoke\DataFiles\fs_08292022';
smpsData = importSMPS(pathSMPS);
smpsDataRaw = smpsData;


%% Analysis

%Size Distribution Analysis
sizeBins = [smpsData{2,1}]; %The size bins are the same for each scan
numConc = [smpsData{4,:}];


%% Plotting
figure();
plot([smpsData{2,3}], [smpsData{3,3}]);
hold on
plot([smpsData{2,4}], [smpsData{3,4}]);





