%% This script will save all of the figures to a directory

%% Saving Figures to a directory
FigList = findobj(allchild(0), 'flat', 'Type', 'figure');


cd('C:\Users\Thomas\Documents\MATLAB\GitHub\SPUR\CASA_InLab\CASA_InLab\FreshSmoke\Plots');


strings = {'SizeDist_background'; 'NumConc_background'; 'VolumeConc_background'; 'MaxSize_background'; 'RH_background'};
strings = flip(strings);


for i = 1:length(FigList)
    currFig = FigList(i);
    figName = num2str(get(currFig, 'Number'));
    set(0, 'CurrentFigure', currFig);
    saveas(currFig, strcat(strings{i}, '.png'));   
end


%% Coming back

cd('C:\Users\Thomas\Documents\MATLAB\GitHub\SPUR\CASA_InLab\CASA_InLab\FreshSmoke\MATLABFiles');


