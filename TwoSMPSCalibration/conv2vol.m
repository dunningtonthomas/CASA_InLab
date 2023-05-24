function [ sizingdv ] = conv2vol( sizingdata )
%% Converts sizing data in units of dN/dlogDp into units of dV/dlogdDp
% Should either be merged data or individual APS/SMPS data sets
% Units are um^3/cm^3

% Create array to hold data
sizingdv = sizingdata;

% Convert to dV using formula: dV = dN*pi/6*Dp^3
[~,c] = size(sizingdata);
for i = 1:c
    sizingdv{3,i} = cell(0); %Delete dN data first to prevent errors
    Dp = sizingdata{2,i}./1000;
    sizingdv{3,i} = sizingdata{3,i}*(pi/6).*Dp.^3;
end

end
