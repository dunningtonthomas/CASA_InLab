%% Clean Up
close all; clear; clc;

%% Import Data
load('corrections.mat');

lowInd = 21;
highInd = 87;

% figure();
% plot(bins(34:86), concRatios1(34:86));
% hold on;
% plot(bins(34:86), concRatios2(34:86));
% plot(bins(34:86), concRatios3(34:86));
% plot(bins(34:86), concRatios4(34:86));
% plot(bins(34:86), concRatios5(34:86));

%Date from my aged experiments
load('correctionsAged.mat');

%Calculate the average, std, and +-10%
allTogether = [concRatios0516, concRatios0519, concRatios0522, concRatios0524];
avgAged = mean(allTogether, 2);
stdDev = std(allTogether, 0, 2);

figure();
lowRH = plot(bins(lowInd:highInd), concRatios0516(lowInd:highInd), 'r');
hold on;
% plot(bins(34:86), concRatios0517(34:86), 'r');
% plot(bins(34:86), concRatios0518(34:86), 'r');
plot(bins(lowInd:highInd), concRatios0519(lowInd:highInd), 'g');
plot(bins(lowInd:highInd), concRatios0522(lowInd:highInd), 'g');
medRH = plot(bins(lowInd:highInd), concRatios0524(lowInd:highInd), 'g');
avgplot = plot(bins(lowInd:highInd), avgAged(lowInd:highInd), 'k', 'linewidth', 2);
% plot(bins(lowInd:highInd), avgAged(lowInd:highInd) + stdDev(lowInd:highInd), 'b');
% plot(bins(lowInd:highInd), avgAged(lowInd:highInd) - stdDev(lowInd:highInd), 'b');
% plot(bins(lowInd:highInd), 1.1*avgAged(lowInd:highInd), 'm');
% plot(bins(lowInd:highInd), 0.9*avgAged(lowInd:highInd), 'm');

xlabel('Bin (nm)');
ylabel('Concentration Correction factor (butanol/water)');
title('SMPS Correction Factor');
legend([lowRH, medRH, avgplot], 'Low RH', 'Med RH', 'Avg','location', 'nw');

%Saving the correction data
save('finalCorrection.mat', 'avgAged');



