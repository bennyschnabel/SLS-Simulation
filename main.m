clear variables; close all; clc;

%% Add folders to search path
addpath('Laser model');
addpath('Material model');
addpath('Thermal model');
addpath('STL files');

%% Material model

% Get laser parameters
materialParameter = getMaterialParameter();
materialDesignation = materialParameter.materialDesignation;
layerThickness = materialParameter.layerThickness;

%% Laser model

% Get laser parameters and define
laserParameter = getLaserParameter();
stefanBoltzmanConstant = laserParameter.stefanBoltzmanConstant; % [W/(m^2 K^4)]
focalLength = laserParameter.focalLength * 10^-3; % [m]
waveLength = laserParameter.waveLength * 10^-6; % [m]
rawBeamRadius = laserParameter.rawBeamRadius * 10^-3; % [m]
distanceFocalPoint = laserParameter.distanceFocalPoint * 10^-3; % [m]
laserPower = laserParameter.laserPower; % [W]

% Calculation 

beamDivergenceAngle = computateBeamDivergenceAngle(waveLength, rawBeamRadius);
focalPointRadius = computateFocalPointRadius(focalLength, beamDivergenceAngle); % [m]
workpieceRadius = computateWorkpieceRadius(focalLength, rawBeamRadius, ...
                  focalPointRadius, distanceFocalPoint); % [m]
heatFluxIntensityLense = computateHeatFluxIntensityLense(laserPower, rawBeamRadius, 0); % [W/m^2]
heatFluxIntensityFocalPoint = computateHeatFluxIntensityFocalPoint(laserPower, ...
                              rawBeamRadius, waveLength, focalLength, 0); % [W/m^2]
heatFluxIntensityWorkpiece = computateHeatFluxIntensityWorkpiece(rawBeamRadius, ...
                             workpieceRadius, heatFluxIntensityLense); % [W/m^2]


%% Thermal model

% Get thermal parameters
thermalParameter = getThermalParameter();

% Length of domain in x direction
lengthOfDomainInX = thermalParameter.lengthOfDomainInX; % [m]
% Length of domain in y direction
lengthOfDomainInY = thermalParameter.lengthOfDomainInX; % [m]
% Number of nodes in x direction
numberOfNodesInX = thermalParameter.numberOfNodesInX;
% Number of nodes in y direction
numberOfNodesInY = thermalParameter.numberOfNodesInY;

% Build IC - Room temperature
roomTemperature = 25;

initialCondition = zeros(numberOfNodesInX,numberOfNodesInY);

for i = 1 : numberOfNodesInX
    for j = 1 : numberOfNodesInY
        initialCondition(i,j) = roomTemperature;
    end
end

[temperature, x, y, t, maxT, minT] = computateHeatEquation2D(lengthOfDomainInX, lengthOfDomainInY, ...
    numberOfNodesInX, numberOfNodesInY, heatFluxIntensityWorkpiece, layerThickness, ...
    initialCondition);

%% Plot

fig = figure();
surf(x,y,temperature);
view(0,90);
cb = colorbar;
ylabel(cb, '°C');
title(['Elapsed time: ' num2str(t) ' s']);
xlabel('x [m]');
ylabel('y [m]');
zlabel('Temprature');
orient(fig,'landscape');
print(fig,'-bestfit','Test','-dpdf','-r0');

%% Print

fprintf('Material %s\n', materialDesignation);
qwork = heatFluxIntensityWorkpiece * 10^-6; 
fprintf('Laser heat flux intensity at workpice q_w = %s MW/(m^2)\n', num2str(qwork));
fprintf('Thermal diffusivity of %s is %s * 10^-6 m^2/s\n', materialDesignation, num2str(sprintf('%.4f ', thermalDiffusivity(20) * 10^6)));
fprintf('Max temperature t_max = %s °C\n', num2str(maxT));
fprintf('Min temperature t_min = %s °C\n', num2str(minT));