
close all
clc

% file that needs to be opened
T = readtable('2022_03_29To2022_04_05.csv');
% What type of waves 
vars = ["UVBCc", "BlueBCc", "GreenBCc", "RedBCc", "IRBCc"];
meanOfWaveLength = mean(T{:,vars}, 'omitnan');
meanOfWaveLength = meanOfWaveLength';
% Wavelengths
waveLengths = [300,400,500,700,1000]';
plotData = table(waveLengths, meanOfWaveLength);




plot(plotData.waveLengths,plotData.meanOfWaveLength)
title('WaveLength vs Amount of Black Carbon')
xlabel('Wavelength (nm)')
ylabel('Absoprtion')







