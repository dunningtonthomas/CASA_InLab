%% Clean Up
clear; close all; clc;

%% Import Data​
T1 = readtable('MA200-0030_20220322-054059_post-processed_55910.csv');
T2 = readtable('MA200-0030_20220325-044400_post-processed_55911.csv');
T3 = readtable('MA200-0030_20220329-042400_post-processed_55913.csv');
T4 = readtable('MA200-0030_20220402-002100_post-processed_55915.csv');
T5 = readtable('MA200-0030_20220405-043200_post-processed_55916.csv');

% What type of waves 
vars = ["UVBCcPost", "BlueBCcPost", "GreenBCcPost", "RedBCcPost", "IRBCcPost"];
data1 = T1{:,vars};
data2 = T2{:,vars};
data3 = T3{:,vars};
data4 = T4{:,vars};
data5 = T5{:,vars};
data = [data1; data2; data3; data4; data5];
logVec = ~isnan(data);
dataTrunc = rmmissing(data); %Getting rid of NAN values

%Getting time data
dateOnly1 = T1{:,"DateLocal"};
dateOnly2 = T2{:,"DateLocal"};
dateOnly3 = T3{:,"DateLocal"};
dateOnly4 = T4{:,"DateLocal"};
dateOnly5 = T5{:,"DateLocal"};

timeOnly1 = T1{:,"TimeLocal"};
timeOnly2 = T2{:,"TimeLocal"};
timeOnly3 = T3{:,"TimeLocal"};
timeOnly4 = T4{:,"TimeLocal"};
timeOnly5 = T5{:,"TimeLocal"};

dateOnly = [dateOnly1; dateOnly2; dateOnly3; dateOnly4; dateOnly5];
timeOnly = [timeOnly1; timeOnly2; timeOnly3; timeOnly4; timeOnly5];
dateOnly = datetime(dateOnly, 'InputFormat',"yyyy/MM/dd");
time = dateOnly + timeOnly;

%Truncate time to match with data without nan values
timeLog = (logVec(:,1) .* logVec(:,2) .* logVec(:,3) .* logVec(:,4) .* logVec(:,5)) == 1;
time = time(timeLog);


%Subtract IRBcc from UVBCc to get brown carbon, normalize with UVBCc
%This gives you an approximate amount of brown carbon in the sample
%Use the POST data at the last columns in the data files

%Keep all 5 channels, get black carbon

%% Analysis
%Calculating brown carbon
brownCarb = (dataTrunc(:,1) - dataTrunc(:,5)) ./ dataTrunc(:,1); %Normalized

%% Plotting
%Plotting the wavelength concentrations over time
figure();
plot(time, dataTrunc(:,1));
hold on
plot(time, dataTrunc(:,2));
plot(time, dataTrunc(:,3));
plot(time, dataTrunc(:,4));
plot(time, dataTrunc(:,5));

xlabel('Time');
ylabel('Absorption');
legend('UVBCc', 'IRBCc');

%Plotting brown carbon
figure();
plot(time, brownCarb);




