clear variables; close all; clc;

%% Add folders to search path
addpath('Material model');
addpath('Thermal model');
addpath('Useful functions');

theta = 0 : 0.1 : 250;
%[fig] = plotMaterialParameter(theta,computateHeatCapacity(theta), 'Heat capacity');
%[fig] = plotMaterialParameter(theta,computateHeatConductivity(theta), 'Heat conductivity');
%[fig] = plotMaterialParameter(theta,computateThermalDiffusivity(theta), 'Thermal diffusivity');

T = computateHeatEquation2D(0.1);