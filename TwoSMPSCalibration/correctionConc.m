%% Clean Up
close all; clear; clc;

%% Import Data
load('corrections.mat');

figure();
plot(bins(34:86), concRatios1(34:86));
hold on;
plot(bins(34:86), concRatios2(34:86));
plot(bins(34:86), concRatios3(34:86));
plot(bins(34:86), concRatios4(34:86));
% plot(bins(34:86), concRatios5(34:86));