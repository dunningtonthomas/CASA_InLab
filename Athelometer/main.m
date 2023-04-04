%% Clean Up
clear; close all; clc;

%% Import Data​
T1 = readtable('MA200-0030_20220325-044400_post-processed_55911.csv');
T2 = readtable('MA200-0030_20220325-044400_post-processed_55911.csv');
T3 = readtable('MA200-0030_20220325-044400_post-processed_55911.csv');
T4 = readtable('MA200-0030_20220325-044400_post-processed_55911.csv');
T5 = readtable('MA200-0030_20220325-044400_post-processed_55911.csv');

% What type of waves 
vars = ["UVBCcPost", "BlueBCcPost", "GreenBCcPost", "RedBCcPost", "IRBCcPost"];
data = T1{:,vars};
logVec = ~isnan(data);
dataTrunc = rmmissing(data); %Getting rid of NAN values

%Getting time data
dateOnly = T1{:,"DateLocal"};
timeOnly = T1{:,"TimeLocal"};
dateOnly = datetime(dateOnly, 'InputFormat',"yyyy/MM/dd");
time = dateOnly + timeOnly;

%Truncate time to match with data without nan values
timeLog = (logVec(:,1) .* logVec(:,2)) == 1;
time = time(timeLog);


%Subtract IRBcc from UVBCc to get brown carbon, normalize with UVBCc
%This gives you an approximate amount of brown carbon in the sample
%Use the POST data at the last columns in the data files

%Keep all 5 channels, get black carbon

%% Analysis



%% Plotting
%Plotting the wavelength concentrations over time
figure();
plot(time, dataTrunc(:,1));
hold on
plot(time, dataTrunc(:,2));

xlabel('Time');
ylabel('Absorption');
legend('UVBCc', 'IRBCc');


