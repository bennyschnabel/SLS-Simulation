clc; clear all; close all;

%% Add folders to search path

addpath('Laser model');
addpath('Latex');
addpath('Manual');
addpath('Material model');
addpath('Plots');
addpath('Reports');
addpath('STL file');
addpath('Thermal model');
addpath('Useful functions');

%% Start timer

tic;

%% Load all required parameters

% Get all required laser parameters
laserParameter = getLaserParameter();
% Get all required thermal parameters
thermalParameter = getThermalParameter();

%% STL file import

% Selection window for STL-file
stlFolder = dir('**/*.STL');
allStlFiles = {stlFolder.name};
[indx,tf] = listdlg('PromptString','Select a STL-file:',...
    'SelectionMode','single',...
    'ListString',allStlFiles, ...
    'Name','File Selection');

% Set selected STL-file
stlFileName = strjoin(allStlFiles(indx));

stlFileModel = stlread(stlFileName);
[val,idx] = max([stlFileModel.vertices]);
% Get the max length of the STL file [m]
L = max(val) * 10^-3;

% Display STL file name in console
disp(stlFileName)
disp('-------------------')

%% Input window for parameters

prompt = {'Enter number of Nodes [-]:','Enter Laser power [W]:','Enter Laser speed [m/s]:','Enter cooling time [s]:'};
title = 'Input model parameter';
dims = [1 50];
definput = {num2str(thermalParameter.numberOfNodes),num2str(laserParameter.laserPower), ...
    num2str(laserParameter.laserSpeed),num2str(thermalParameter.coolingtime)};
userInputParameter = inputdlg(prompt,title,dims,definput);

%% Create report files

% Create txt file
fileDate = datestr(now,'YYYY-mm-DD-HH-MM-SS');
txtFileName = [fileDate, '-', stlFileName(1:end-4), '-Report', '.txt'];
savePath = './Reports/';
txtFileID = fopen([savePath txtFileName],'wt');

% Write data to txt-file
fprintf(txtFileID, 'STL file name: %s\n', stlFileName);
fprintf(txtFileID, '-----------------------\n');

% Create excel-file
excelFileName = [fileDate, '-', stlFileName(1:end-4), '.xlsx'];
excelHeader = {'Layer no', 'Laser exposure time', 'Maximum temperature', 'Minimum temperature'};
xlswrite(excelFileName, excelHeader, 'Tabelle1')

%% Laser model

% Wave length [m]
lambda = laserParameter.waveLength * 10^-6;
% Raw beam radius at focusing lens [m]
r_0 = laserParameter.rawBeamRadius * 10^-3;
% Focal length [m]
f = laserParameter.focalLength * 10^-3;
% Distance to focal point [m]
b = laserParameter.distanceFocalPoint * 10^-3;
% Laser power [W]
%P = laserParameter.laserPower;
P = str2double(cell2mat(userInputParameter(2)));
% Laser speed [m/s]
%v = laserParameter.laserSpeed;
v = str2double(cell2mat(userInputParameter(3)));

r = sqrt(0.^2 + 0.^2);

% Beam divergence angle [-]
theta = computateBeamDivergenceAngle(lambda, r_0);
% Focal point radius [m]
r_f = computateFocalPointRadius(f, theta);
% Heat flux intensity at the lense [W/m^2]
q_0 = computateHeatFluxIntensityLense(P, r_0, r);
% Heat flux intensity at the focal point [W/m^2]
q_f = computateHeatFluxIntensityFocalPoint(P, r_0, lambda, f, r);
% Workpiece radius [m]
r_w = computateWorkpieceRadius(f, r_0, r_f, b);
% Heat flux intensity at the workpiece [W/m^2]
q_w = computateHeatFluxIntensityWorkpiece(r_0, r_w, q_0);

% Display the heat flux intensity in a figure (true or false)
displayHeatFluxIntensityFigure = 'false';
switch displayHeatFluxIntensityFigure
    case 'true'
        % [fig] = plotHeatFluxIntensity(axisScale, exportAsPDF, P, r_0, r_w)
        % exportAsPDF (true or false)
        plotHeatFluxIntensity(0.02, 'false', P, r_0, r_w);
    case 'false'
    otherwise
        disp('Error: displayHeatFluxIntensityFigure')
end

% Write data to txt-file
fprintf(txtFileID, 'Wave length: %.4f mm\n', lambda * 10^3);
fprintf(txtFileID, 'Raw beam radius at focusing lens: %.2f mm\n', r_0 * 10^3);
fprintf(txtFileID, 'Focal length: %.2f mm\n', f * 10^3);
fprintf(txtFileID, 'Distance to focal point: %.2f mm\n', b * 10^3);
fprintf(txtFileID, 'Laser power: %.2f W\n', P);
fprintf(txtFileID, 'Laser speed: %.2f m/s\n', v);
fprintf(txtFileID, 'Heat flux intensity at the workpiece: %.2f MW/m^2\n', q_w * 10^-6);

%% Thermal model

% Number of nodes [-]
%n = thermalParameter.numberOfNodes;
n = str2double(cell2mat(userInputParameter(1)));
% Layer thickness [m]
s = computateLayerThickness(L, n);
% Powderbed temperature [K]
T_powderbed = thermalParameter.powderbedTemperature;
% Chamber temperature [K]
T_chamber = thermalParameter.chamberTemperature;

% Cooling time [s]
%t_cooling = thermalParameter.coolingtime;
t_cooling = str2double(cell2mat(userInputParameter(4)));

% Write data to txt-file
fprintf(txtFileID, 'Number of nodes (layers): %d\n', n);
fprintf(txtFileID, 'Nodes thickness: %0.3f mm\n', s*10^3);
fprintf(txtFileID, 'Powderbed temperature: %.2f °C\n', T_powderbed-273.15);
fprintf(txtFileID, 'Chamber temperature: %.2f °C\n', T_chamber-273.15);
fprintf(txtFileID, 'Cooling time per layer: %0.3f s\n', t_cooling);

%% Material model

[R,T,A] = computateReflectionTransmissionAbsorption(s * 10^3);

% Write data to txt-file
fprintf(txtFileID, 'Reflection: %.2f, transmission: %0.2f, absorption: %0.2f\n', R, T, A);

%% Conversion of the STL file into the voxel model

% Create voxel model
voxelModel = voxelise(n,n,n,stlFileName,'xyz');

% Number of grid point to increase the distance to the edge
voxelModel(n+1:n+2,:,:) = 0;
voxelModel(:,n+1:n+2,:) = 0;
voxelModel(:,:,n+1:n+2) = 0;
voxelModel = circshift(voxelModel,[1 1 1]);

% Rotate Voxel- Matrix along z axis
rotateZAxis = '0';

switch rotateZAxis
    case '0'
        voxelModel = rot90(voxelModel,0);
    case '90'
        voxelModel = rot90(voxelModel,1);
    case '180'
        voxelModel = rot90(voxelModel,3);
    case '270'
        voxelModel = rot90(voxelModel,2);
    otherwise 
        disp('Error: rotateZAxis')
end

% Display the voxel model in a figure (true or false)
displayVoxelModelFigure = 'false';
switch displayVoxelModelFigure
    case 'true'
        % [fig] = plotVoxelModel(voxelModel, n, exportAsPDF)
        % exportAsPDF (true or false)
        plotVoxelModel(voxelModel, n, 'false');
    case 'false'
    otherwise
        disp('Error: displayVoxelModelFigure')
end

%% Plot export settings

% Set new value for number of nodes depending on the distance to edge
n_new = max(size(voxelModel));

% Build meshgrid for plot
[x,y,z] = meshgrid(0:L/(n_new-1):L,0:L/(n_new-1):L,0:L/(n_new-1):L);
region = [0,L,0,L,0,L];
xSliced = linspace(0, L, n);
ySliced = linspace(0, L, n);
zSliced = linspace(0, L, n);

%%%%%%%%%%%%%%%%%%%%%
%% Heat simulation %%
%%%%%%%%%%%%%%%%%%%%%

%% Build initial condition

T0 = zeros(n_new,n_new,n_new);
for i = 1 : n_new
    for j = 1 : n_new
        for k = 1 : n_new
            T0(i,j,k) = T_powderbed;
        end
    end
end

%% Initial heating of first layer

LayerShift = circshift(voxelModel,[0 0 -2]);
activeLayer = LayerShift(:,:,n_new);

% Laser time per layer
t_Laser = s * sum(activeLayer(:)) / v;
t_Laser_mean = t_Laser;

i = 1;

[Temp, maxT, minT] = computateHeatEquation3D(t_Laser, q_w, T0, T_chamber, T_powderbed, ...
    activeLayer, LayerShift, s, L, n_new, A);

% Export plot of layer
fin = LayerShift .* Temp;
[plot] = plotSimulation(fin, x, y, z, xSliced, ySliced, region, i, stlFileName);

% Collect temperature arrays
TemperatureArray{i} = fin;

% Display layer and temperature information
layerNumber = ['Layer: ', num2str(i), '; laser exposure time: ', num2str(t_Laser), ' s'];
disp(layerNumber)
layerNumberMaxTemperature = ['Layer: ', num2str(i), '; maximum temperature: ', num2str(maxT-273.15), ' °C'];
disp(layerNumberMaxTemperature)
layerNumberMinTemperature = ['Layer: ', num2str(i), '; minimum temperature: ', num2str(minT-273.15), ' °C'];
disp(layerNumberMinTemperature)
disp('-------------------')

% Write data to txt-file
fprintf(txtFileID, '---------------------------\n');
fprintf(txtFileID, 'Layer no: %d\n', i);
fprintf(txtFileID, 'Laser exposure time: %0.3f s\n', t_Laser);
fprintf(txtFileID, 'Maximum temperature: %0.3f °C\n', maxT-273.15);
fprintf(txtFileID, 'Minimum temperature: %0.3f °C\n', minT-273.15);

% Write data to excel-file-array
excelData = {num2str(i), t_Laser, maxT-273.15, minT-273.15};


%% Loop to simulate the rest of the layers

while i < n
    i = i + 1;
    
    % Cooling while moving down
    [Temp, ~, ~] = computateHeatEquation3D(t_cooling, 0, Temp, T_chamber, T_powderbed, ...
        activeLayer, LayerShift, s, L, n_new, A);
    
    % Moving down
    LayerShift = circshift(LayerShift,[0 0 -1]);
    activeLayer = LayerShift(:,:,n_new);
    
    % Laser time per layer
    t_Laser = s * sum(activeLayer(:)) / v;
    t_Laser_mean = t_Laser_mean + t_Laser;
    
    % Heating
    [Temp, maxT, minT] = computateHeatEquation3D(t_Laser, q_w, Temp, T_chamber, T_powderbed, ...
        activeLayer, LayerShift, s, L, n_new, A);
    
    fin = LayerShift .* Temp;
    [plot] = plotSimulation(fin, x, y, z, xSliced, ySliced, region, i, stlFileName);
    
    % Collect temperature arrays
    TemperatureArray{i} = fin;
    
    % Display layer and temperature information
    layerNumber = ['Layer: ', num2str(i), '; laser exposure time: ', num2str(t_Laser), ' s'];
    disp(layerNumber)
    layerNumberMaxTemperature = ['Layer: ', num2str(i), '; maximum temperature : ', num2str(maxT-273.15), ' °C'];
    disp(layerNumberMaxTemperature)
    layerNumberMinTemperature = ['Layer: ', num2str(i), '; minimum temperature: ', num2str(minT-273.15), ' °C'];
    disp(layerNumberMinTemperature)
    disp('-------------------')
    
    % Write data to txt-file
    fprintf(txtFileID, '---------------------------\n');
    fprintf(txtFileID, 'Layer no: %d\n', i);
    fprintf(txtFileID, 'Laser exposure time: %0.3f s\n', t_Laser);
    fprintf(txtFileID, 'Maximum temperature: %0.3f °C\n', maxT-273.15);
    fprintf(txtFileID, 'Minimum temperature: %0.3f °C\n', minT-273.15);
    
    % Write data to excel-file-array
    excelData(end+1,:) = {num2str(i), t_Laser, maxT-273.15, minT-273.15};
end

%% Display final information

nodesNumber = ['Number of nodes (layers): ', num2str(n)];
laserTime = ['Average laser time per layer: ', num2str(t_Laser_mean/n), ' s'];
averageTime = ['Average runtime: ', num2str(toc/60), ' min'];

disp(nodesNumber)
disp(laserTime)
disp(averageTime)

%% Combine PDFs into one file

stlFileNameShortened = stlFileName(1:end-4);
pdfToCombine = cell(1,n);

for j = 1 : n
    fileName2 = [stlFileNameShortened, '-Layer', num2str(j)];
    singlePDF = [fileName2, '.pdf'];
    pdfToCombine{j} = singlePDF;
end

combinedPDF = [fileDate, '-', stlFileNameShortened, '-Plot', '.pdf'];
append_pdfs(combinedPDF, pdfToCombine{:});

for j = 1 : n
    delete(pdfToCombine{j})
end

%% Write data to txt- and excel-files and close them

% Write data to txt-file
fprintf(txtFileID, '---------------------------\n');
fprintf(txtFileID, 'Average laser time per layer: %0.3f s\n', t_Laser_mean/n);
fprintf(txtFileID, 'Average runtime: %0.3f min\n', toc/60);

fclose(txtFileID);

% Write data to excel-file
xlswrite(excelFileName, excelData, 'Tabelle1', 'A2')

%% Evaluation of temperature

fileName = [fileDate, '-', stlFileNameShortened];
[fig] = plotEvaluationOfSimulation(fileName, stlFileNameShortened, fileDate);
evaluationFileName = [fileDate, '-', stlFileNameShortened, '-Evaluation', '.pdf'];

%% Plot for movie

% Create a movie plot (true or false)
createVideoPlot = 'true';
switch createVideoPlot
    case 'true'
        plotSimulationForVideoExport(TemperatureArray, ...
            n_new, x, y, z, xSliced, ySliced, region, ...
            stlFileNameShortened, fileDate);
    case 'false'
    otherwise
        disp('Error: createVideoPlot')
end

%% Plot eigenvalues of temperature matrix

% Create a plot of the eigenvalues (true or false)
createEigenvaluesPlot = 'false';
switch createEigenvaluesPlot
    case 'true'
        % [fig] = plotEigenvalues(temperatureArray, exportAsPDF)
        % exportAsPDF (true or false)
        fig = plotEigenvalues(TemperatureArray, 'true', ...
            stlFileNameShortened, fileDate);
    case 'false'
    otherwise
        disp('Error: createEigenvaluesPlot')
end

%% Export Excel-file as Latex table

% Export excel-file as Latex table (true or false)
createLatexTable = 'false';
switch createLatexTable
    case 'true'
        exportAsLatexTable(fileName)
    case 'false'
    otherwise
        disp('Error: createLatexTable')
end

%% Move files to folder 'Reports'

movefile(excelFileName, 'Reports')
movefile(combinedPDF, 'Reports')
movefile(evaluationFileName, 'Reports')