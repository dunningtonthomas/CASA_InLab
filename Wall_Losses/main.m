%% Main script
%This script reads in wall loss SMPS data to calculate the wall losses
%added comment

%% Clean Up
clear; close all; clc;

%% Import Data
%SMPS import
cd('./Data');
pathSMPS = pwd;
cd('../');
smpsData = importSMPS(pathSMPS);
smpsDataRaw = smpsData;


%Truncate so it is split by experiment
exp_start1 = datetime('24-Jan-2023 14:50:00');
exp_end1 = datetime('24-Jan-2023 17:56:00');
exp_start2 = datetime('25-Jan-2023 13:27:00');
exp_end2 = datetime('25-Jan-2023 16:14:00');
exp_start3 = datetime('26-Jan-2023 10:16:00');
exp_end3 = datetime('26-Jan-2023 14:44:00');

%Logical vectors of each experiment
exp1Log = [smpsData{1,:}] >= exp_start1 & [smpsData{1,:}] <= exp_end1;
exp2Log = [smpsData{1,:}] >= exp_start2 & [smpsData{1,:}] <= exp_end2;
exp3Log = [smpsData{1,:}] >= exp_start3 & [smpsData{1,:}] <= exp_end3;

%Data split into each experiment
exp1Data = smpsData(:,exp1Log);
exp2Data = smpsData(:,exp2Log);
exp3Data = smpsData(:,exp3Log);


%% Wall Loss Analysis
%Size Bins
sizeBins = exp1Data{2,1}; %The same for every scan

%Storing the smps data for each experiment in columns, each column is the
%number concentration corresponding to the size bins in the column vector 
exp1DN = zeros(length(sizeBins), length(exp1Data(:,1)));
for i = 1:length(exp1Data(1,:))
    exp1DN(:,i) = exp1Data{3,i};
end

exp2DN = zeros(length(sizeBins), length(exp2Data(:,1)));
for i = 1:length(exp2Data(1,:))
    exp2DN(:,i) = exp2Data{3,i};
end

exp3DN = zeros(length(sizeBins), length(exp3Data(:,1)));
for i = 1:length(exp3Data(1,:))
    exp3DN(:,i) = exp3Data{3,i};
end

%Calculate logdN
exp1DNLog = log(exp1DN);
exp2DNLog = log(exp2DN);
exp3DNLog = log(exp3DN);

%Extrapolating the time for each experiment so it starts at t=0
dateTimeExp1 = [exp1Data{1,:}];
timeExp1 = minutes(dateTimeExp1 - dateTimeExp1(1));

dateTimeExp2 = [exp2Data{1,:}];
timeExp2 = minutes(dateTimeExp2 - dateTimeExp2(1));

dateTimeExp3 = [exp3Data{1,:}];
timeExp3 = minutes(dateTimeExp3 - dateTimeExp3(1));


%Calculate the slope of decay for each row, this will give a decay rate 
%Experiment 1
coeff1 = zeros(length(exp1DNLog(:,1)), 2);
for i = 1:length(exp1DNLog(:,1))
    %Ignoring the value in the calculation if it is infinity (from log(0))
    filterLog = abs(exp1DNLog(i,:)) ~= inf;  
    
    %Truncating
    tempTime = timeExp1(filterLog);
    unfiltered = exp1DNLog(i,:);
    DNLogTemp = unfiltered(filterLog);
    
    %Linear Regression
    coeffTemp = polyfit(tempTime, DNLogTemp, 1);
    coeff1(i,:) = coeffTemp;
end

%Experiment 2
coeff2 = zeros(length(exp2DNLog(:,1)), 2);
for i = 1:length(exp2DNLog(:,1))
    %Ignoring the value in the calculation if it is infinity (from log(0))
    filterLog = abs(exp2DNLog(i,:)) ~= inf;  
    
    %Truncating
    tempTime = timeExp2(filterLog);
    unfiltered = exp2DNLog(i,:);
    DNLogTemp = unfiltered(filterLog);
    
    %Linear Regression
    coeffTemp = polyfit(tempTime, DNLogTemp, 1);
    coeff2(i,:) = coeffTemp;
end

%Experiment 3
coeff3 = zeros(length(exp3DNLog(:,1)), 2);
for i = 1:length(exp3DNLog(:,1))
    %Ignoring the value in the calculation if it is infinity (from log(0))
    filterLog = abs(exp3DNLog(i,:)) ~= inf;  
    
    %Truncating
    tempTime = timeExp3(filterLog);
    unfiltered = exp3DNLog(i,:);
    DNLogTemp = unfiltered(filterLog);
    
    %Linear Regression
    coeffTemp = polyfit(tempTime, DNLogTemp, 1);
    coeff3(i,:) = coeffTemp;
end


%Getting the slopes for each size bin
%Each column represents a trial for a total of 3
slopes = -1*[coeff1(:,1), coeff2(:,1), coeff3(:,1)]; %Times -1 because the slope is exp(-kt) so we solve for k


%% Plotting
figure()
plot([exp1Data{1,:}], exp1DN(102,:), 'linestyle', 'none', 'marker','.'); 

figure() 
plot([exp1Data{1,:}], exp1DNLog(102,:), 'linestyle', 'none', 'marker','.');

%Plotting the decay slope for each trial over the size bins
figure();
plot(sizeBins, slopes(:,1));
hold on
plot(sizeBins, slopes(:,2));
plot(sizeBins, slopes(:,3));


%% To do
%Make a cuttoff to get a proper range of the particle loss
    %Do not include the really big particles which are skewing the results







