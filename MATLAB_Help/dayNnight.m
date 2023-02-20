%% Clean Up
clear; close all; clc;

%% Import Data
load('background_outside_filtered.mat');

%% Analysis
%Goal: Sort the data into day and night time variables
%Use 6pm and 6am as the delimeters
hourData = hour(background_outside_time);
dayTimeLog = hourData >= 6 & hourData < 18; %Daytime beteen 6 and 18 hours, include 6 and not 18

background_outside_time_day = background_outside_time(dayTimeLog);
background_outside_volWater_full_filtered_day = background_outside_volWater_full_filtered(dayTimeLog);
background_outside_Vd_full_filtered_day = background_outside_Vd_full_filtered(dayTimeLog);
background_outside_RH_full_filtered_day = background_outside_RH_full_filtered(dayTimeLog);
background_outside_GF_full_filtered_day = background_outside_GF_full_filtered(dayTimeLog);

background_outside_time_night = background_outside_time(~dayTimeLog);
background_outside_volWater_full_filtered_night = background_outside_volWater_full_filtered(~dayTimeLog);
background_outside_Vd_full_filtered_night = background_outside_Vd_full_filtered(~dayTimeLog);
background_outside_RH_full_filtered_night = background_outside_RH_full_filtered(~dayTimeLog);
background_outside_GF_full_filtered_night = background_outside_GF_full_filtered(~dayTimeLog);

save('background_outside_filtered_day_night.mat', "background_outside_time_day", "background_outside_volWater_full_filtered_day", ...
    "background_outside_Vd_full_filtered_day", "background_outside_RH_full_filtered_day", "background_outside_GF_full_filtered_day", ...
    "background_outside_time_night", "background_outside_volWater_full_filtered_night", "background_outside_Vd_full_filtered_night", ...
    "background_outside_RH_full_filtered_night", "background_outside_GF_full_filtered_night");

