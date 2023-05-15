%% Clean Up
clear; close all; clc;

%% Import Data​
T = readtable('MA200-0030_20220329-042400_post-processed_55913');
%%
timeonly = T.TimeLocal;
dateonly = T.DateLocal;



%%
logVec = ~isnan(T.IRBCcPost);
BC = rmmissing(T.IRBCcPost); %Getting rid of NAN values
time = rmmissing(T.new_datetime);
%{
% What type of waves 
vars = ["DateLocal", "TimeLocal", "UVBCcPost", "BlueBCcPost", "GreenBCcPost", "RedBCcPost", "IRBCcPost"];
data = T{:,vars};
logVec = ~isnan(data);
data = rmmissing(data); %Getting rid of NAN values

%Getting time data
dateOnly = T{:,"DateLocal"};
timeOnly = T{:,"TimeLocal"};
dateOnly = datetime(dateOnly, 'InputFormat',"yyyy/MM/dd");
time = dateOnly + timeOnly;

%Truncate time to match with data without nan values
time = time(logVec(:,1));
%}

%{
%%
meanOfWaveLength = mean(T{:,vars}, 'omitnan');
meanOfWaveLength = meanOfWaveLength';
% Wavelengths
waveLengths = [375,470,528,625,880]';
plotData = table(waveLengths, meanOfWaveLength);
%}

%% Analysis



%% Plotting
plot(plotData.waveLengths,plotData.meanOfWaveLength)
title('WaveLength vs Amount of Black Carbon')
xlabel('Wavelength (nm)')
ylabel('Absoprtion')


%Plotting the wavelength concentrations over time
figure();
plot(time, data(:,1));
hold on
plot(time, data(:,2));
plot(time, data(:,3));
plot(time, data(:,4));

xlabel('Time');
ylabel('Absorption');
legend('UVBCc', 'BlueBCc', 'GreenBCc', 'RedBCc', 'IRBCc');


