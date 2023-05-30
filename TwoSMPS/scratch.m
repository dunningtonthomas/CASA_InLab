%% Clean Up
close all; clear; clc


%% Testing Stuff


data = rand(100,1)*10; %Random number from 0 to 10
edges = [1 3 5 7 9];


N = histcounts(data,edges);



% 
% cellArr
% 
% cellArr(5,:) = data;
% 
% for i = 1:length(cellArr(1,:))
%     
%    cellArr{5,i} = data(i); 
% end
% 
% x = 1:5;
% y = 6:10;
% z = [x,y];



