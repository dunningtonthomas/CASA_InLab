%% Clean Up
close all; clear; clc;

%% Import Data
lowInd = 21;
highInd = 87;

%Date from my aged experiments
load('correctionsFresh.mat');

%Calculate the average, std, and +-10%
allTogether = [concRatios0509, concRatios0512, concRatios0516, concRatios0519, concRatios0522, concRatios0524];
avgAged = mean(allTogether, 2);
stdDev = std(allTogether, 0, 2);

figure();
lowRH = plot(bins(lowInd:highInd), concRatios0516(lowInd:highInd), 'r');
hold on;
plot(bins(lowInd:highInd), concRatios0509(lowInd:highInd), 'r');
plot(bins(lowInd:highInd), concRatios0512(lowInd:highInd), 'r');
plot(bins(lowInd:highInd), concRatios0519(lowInd:highInd), 'g');
plot(bins(lowInd:highInd), concRatios0522(lowInd:highInd), 'g');
medRH = plot(bins(lowInd:highInd), concRatios0524(lowInd:highInd), 'g');
avgplot = plot(bins(lowInd:highInd), avgAged(lowInd:highInd), 'k', 'linewidth', 2);

%Error bars and standard deviation
% plot(bins(lowInd:highInd), avgAged(lowInd:highInd) + stdDev(lowInd:highInd), 'b');
% plot(bins(lowInd:highInd), avgAged(lowInd:highInd) - stdDev(lowInd:highInd), 'b');
% plot(bins(lowInd:highInd), 1.1*avgAged(lowInd:highInd), 'm');
% plot(bins(lowInd:highInd), 0.9*avgAged(lowInd:highInd), 'm');

%Plotting labels
xlabel('Bin (nm)');
ylabel('Concentration Correction factor (butanol/water)');
title('SMPS Correction Factor');
legend([lowRH, medRH, avgplot], 'Low RH', 'Med RH', 'Avg','location', 'nw');

%Saving the correction data
save('finalCorrection.mat', 'avgAged');



