clear all; close all; clc;

%% Add folders to search path
addpath('Laser model');
addpath('Material model');
addpath('Reports');
addpath('STL file');
addpath('Thermal model');
addpath('Useful functions');
addpath('Latex');

tic;

%% Load all parameter

% Get all required thermal parameters
thermalParameter = getThermalParameter();
% Get all required laser parameters
laserParameter = getLaserParameter();

%% STL file import

MyFolderInfo = dir('STL file');
%dir **/*.STL
d = dir('**/*.STL');
fn = {d.name};
[indx,tf] = listdlg('PromptString','Select a STL-file:',...
                           'SelectionMode','single',...
                           'ListString',fn, ...
                           'Name','File Selection');

prompt = {'Enter number of Nodes [-]:','Enter Laser power [W]:','Enter Laser speed [m/s]:','Enter cooling time [s]:'};
title = 'Input model parameter';
dims = [1 50];
definput = {num2str(thermalParameter.numberOfNodes),num2str(laserParameter.laserPower), ...
    num2str(laserParameter.laserSpeed),num2str(thermalParameter.coolingtime)};
answer = inputdlg(prompt,title,dims,definput);

%stlName = [strjoin(answer(1)), '.STL'];
stlName = strjoin(fn(indx));
% Display STL file name in console
disp(stlName)
disp('-------------------')
% Get the max length of the STL file
stlModel  = stlread(stlName);
[val,idx] = max([stlModel.vertices]);
maxLengthOfSTLModel = max(val) * 10^-3;

%% Create report and excel-file

fileDate = datestr(now,'YYYY-mm-DD-HH-MM-SS');
fileName = [fileDate, '-', stlName(1:end-4), '-Report', '.txt'];
savePath = './Reports/';
fileID = fopen([savePath fileName],'wt');

% Write data to report
fprintf(fileID, 'STL file name: %s\n', stlName);
fprintf(fileID, '-----------------------\n');

% Write data to excel-file
excelFileName = [fileDate, '-', stlName(1:end-4), '.xlsx'];
excelHeader = {'Layer no', 'Laser exposure time', 'Maximum temperature', 'Minimum temperature'};
xlswrite(excelFileName, excelHeader, 'Tabelle1')

%% Thermal model

Lx = maxLengthOfSTLModel;
Ly = maxLengthOfSTLModel;
Lz = maxLengthOfSTLModel;

nx = str2double(cell2mat(answer(1)));
ny = nx;
nz = ny;
dx = Lx/(nx-1);
dy = Ly/(ny-1);
dz = Lz/(nz-1);

% [m]
nodesThickness = maxLengthOfSTLModel / nx;

T_powderbed = thermalParameter.powderbedTemperature;
T_chamber = thermalParameter.chamberTemperature;

%t_cooling = thermalParameter.coolingtime;
t_cooling = str2double(cell2mat(answer(4)));

% Write data to report
fprintf(fileID, 'Number of nodes (layers): %d\n', nx);
fprintf(fileID, 'Nodes thickness: %0.3f mm\n', nodesThickness*10^3);
fprintf(fileID, 'Powderbed temperature: %.2f °C\n', T_powderbed-273.15);
fprintf(fileID, 'Chamber temperature: %.2f °C\n', T_chamber-273.15);
fprintf(fileID, 'Cooling time per layer: %0.3f s\n', t_cooling);

%% STL model

% Create Voxel- Matrix
[voxelMatrix] = VOXELISE(nx,ny,nz,stlName,'xyz');

% Add zeros to not touch the wall

voxelMatrix(nx+1:nx+2,:,:) = 0;
voxelMatrix(:,nx+1:nx+2,:) = 0;
voxelMatrix(:,:,nx+1:nx+2) = 0;
voxelMatrix = circshift(voxelMatrix,[1 1 1]);

% Rotate Voxel- Matrix along z axis
rotateZAxis = '0';

switch rotateZAxis
    case '0'
        voxelMatrix = rot90(voxelMatrix,0);
    case '90'
        voxelMatrix = rot90(voxelMatrix,1);
    case '180'
        voxelMatrix = rot90(voxelMatrix,3);
    case '270'
        voxelMatrix = rot90(voxelMatrix,2);
    otherwise 
        disp('')
end

% Show Voxel plot (show or hide)
displaySTLPlot = 'hide';

switch displaySTLPlot
    case 'show'
        disp('')
        fig = figure();
        [vol_handle] = VoxelPlotter(voxelMatrix,1);
        alpha(0.8)
        az = -37;
        el = 30;
        view(az, el);
        set(gca,'xlim',[0 nx+1], 'ylim',[0 ny+1], 'zlim',[0 nz+1])
        xlabel('Nodes in x')
        ylabel('Nodes in y')
        zlabel('Nodes in z')
        
        exportSTLPlot = 'false';
        
        switch exportSTLPlot
            case 'true'
                orient(fig,'landscape')
                print(fig,'-bestfit','displaySTLPlot','-dpdf','-r0')
            case 'false'
                disp('')
        end
    case 'hide'
        disp('')
    otherwise
        disp('')     
end

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
P = str2double(cell2mat(answer(2)));
% Laser speed [m/s]
%v = laserParameter.laserSpeed;
v = str2double(cell2mat(answer(3)));

% Write data to report
fprintf(fileID, 'Wave length: %.4f mm\n', lambda * 10^3);
fprintf(fileID, 'Raw beam radius at focusing lens: %.2f mm\n', r_0 * 10^3);
fprintf(fileID, 'Focal length: %.2f mm\n', f * 10^3);
fprintf(fileID, 'Distance to focal point: %.2f mm\n', b * 10^3);
fprintf(fileID, 'Laser power: %.2f W\n', P);
fprintf(fileID, 'Laser speed: %.2f m/s\n', v);

axisscale = 0.02;

x = -axisscale : 0.001 : axisscale;
y = -axisscale : 0.001 : axisscale;

[X,Y] = meshgrid(x,y);

r = sqrt(X.^2 + Y.^2);

% Calculation of the beam divergence angle [-]
theta = computateBeamDivergenceAngle(lambda, r_0);
% Calculation of the focal point radius [m]
r_f = computateFocalPointRadius(f, theta);
% Calculation of the workpiece radius [m]
r_w = computateWorkpieceRadius(f, r_0, r_f, b);
% Calculation of the heat flux intensity at the lense [W/m^2]
q_0 = computateHeatFluxIntensityLense(P, r_0, r);
% Calculation of the heat flux intensity at the focal point [W/m^2]
q_f = computateHeatFluxIntensityFocalPoint(P, r_0, lambda, f, r);
% Calculation of the heat flux intensity at the workpiece [W/m^2]
q_w = computateHeatFluxIntensityWorkpiece(r_0, r_w, q_0);
% Calculation of the maximal heat flux intensity at the workpiece [W/m^2]
q_w_max = max(max(q_w));

%plotLaserFunctions(X, Y, q_w * 10^-6, axisscale, 'Waermestromdichte', 'fig');

% Write data to report
fprintf(fileID, 'Heat flux intensity at the workpiece: %.2f MW/m^2\n', q_w_max * 10^-6);

%% Material model

%theta = 0 : 0.01 : 250;
%plotMaterialParameter(theta, computateHeatCapacity(theta) * 10^-3, '$\left[ \frac{kJ}{kg \cdot K} \right]$' ,'Heat capacity');
%plotMaterialParameter(theta, computateHeatConductivity(theta), '$\left[ \frac{W}{m \cdot K} \right]$' ,'Heat conductivity');
%plotMaterialParameter(theta, computateThermalDiffusivity(theta), '$\left[ \frac{m^{2}}{s} \right]$' ,'Thermal diffusivity');

[R,T,A] = computateReflectionTransmissionAbsorption(nodesThickness);

% Write data to report
fprintf(fileID, 'Reflection: %.2f, transmission: %0.2f, absorption: %0.2f\n', R, T, A);

%% Plot export settings

[szX,szY,szZ] = size(voxelMatrix);

% Build meshgrid for plot
[x,y,z] = meshgrid(0:Lx/(szX-1):Lx,0:Lx/(szY-1):Ly,0:Lx/(szZ-1):Lz);
region = [0,Lx,0,Ly,0,Lz];

numberOfSlices = nx;
xSliced = linspace(0, Lx, numberOfSlices);
ySliced = linspace(0, Ly, numberOfSlices);
zSliced = linspace(0, Lz, numberOfSlices);

%% Evaluation per layer

evaluationMatrix = zeros(nx, 2 * nx);

%% Heat simulation

%% Build initial condition

u0 = zeros(szX,szY,szZ);
for i = 1 : szX
    for j = 1 : szY
        for k = 1 : szZ
            u0(i,j,k) = T_powderbed;
        end
    end
end

%% Initial heating of first layer

LayerShift = circshift(voxelMatrix,[0 0 -2]);
activeLayer = LayerShift(:,:,szZ);

% Laser time per layer
t_Laser = nodesThickness * sum(activeLayer(:)) / v;
t_Laser_mean = t_Laser;

% Display layer and time information
i = 1;
layerNumber = ['Layer: ', num2str(i), '; laser exposure time: ', num2str(t_Laser), ' s'];
disp(layerNumber)

[Temp, maxT, minT] = computateHeatEquation3D(t_Laser, q_w_max, u0, T_chamber, T_powderbed, ...
    activeLayer, LayerShift, nodesThickness, Lx, Ly, Lz, szX, szY, szZ);

% Display layer and temperature information
layerNumberMaxTemperature = ['Layer: ', num2str(i), '; maximum temperature: ', num2str(maxT-273.15), ' °C'];
disp(layerNumberMaxTemperature)
layerNumberMinTemperature = ['Layer: ', num2str(i), '; minimum temperature: ', num2str(minT-273.15), ' °C'];
disp(layerNumberMinTemperature)
disp('-------------------')

% Write data to report
fprintf(fileID, '---------------------------\n');
fprintf(fileID, 'Layer no: %d\n', i);
fprintf(fileID, 'Laser exposure time: %0.3f s\n', t_Laser);
fprintf(fileID, 'Maximum temperature: %0.3f °C\n', maxT-273.15);
fprintf(fileID, 'Minimum temperature: %0.3f °C\n', minT-273.15);

% Write data to excel-file
excelData = {num2str(i), t_Laser, maxT-273.15, minT-273.15};

% Export plot of layer

fin = LayerShift .* Temp;
[plot] = plotSimulation(fin, x, y, z, xSliced, ySliced, zSliced, region, savePath, fileDate, i, stlName);

% Temp-Matrix for video
videoTemp{i} = [fin];

%% Loop to simulate the rest of the layers

while i < nx
    i = i + 1;
    
    % Cooling while moving down
    [Temp, ~, ~] = computateHeatEquation3D(t_cooling, 0, Temp, T_chamber, T_powderbed, ...
        activeLayer, LayerShift, nodesThickness, Lx, Ly, Lz, szX, szY, szZ);

    % Moving down
    LayerShift = circshift(LayerShift,[0 0 -1]);
    activeLayer = LayerShift(:,:,szZ);
    
    % Laser time per layer
    t_Laser = nodesThickness * sum(activeLayer(:)) / v;
    t_Laser_mean = t_Laser_mean + t_Laser;
    
    % Display layer and time information
    layerNumber = ['Layer: ', num2str(i), '; laser exposure time: ', num2str(t_Laser), ' s'];
    disp(layerNumber)

    % Heating
    [Temp, maxT, minT] = computateHeatEquation3D(t_Laser, q_w_max, Temp, T_chamber, T_powderbed, ...
        activeLayer, LayerShift, nodesThickness, Lx, Ly, Lz, szX, szY, szZ);
    
    % Display layer and temperature information
    layerNumberMaxTemperature = ['Layer: ', num2str(i), '; maximum temperature : ', num2str(maxT-273.15), ' °C'];
    disp(layerNumberMaxTemperature)
    layerNumberMinTemperature = ['Layer: ', num2str(i), '; minimum temperature: ', num2str(minT-273.15), ' °C'];
    disp(layerNumberMinTemperature)
    disp('-------------------')
    
    % Write data to report
    fprintf(fileID, '---------------------------\n');
    fprintf(fileID, 'Layer no: %d\n', i);
    fprintf(fileID, 'Laser exposure time: %0.3f s\n', t_Laser);
    fprintf(fileID, 'Maximum temperature: %0.3f °C\n', maxT-273.15);
    fprintf(fileID, 'Minimum temperature: %0.3f °C\n', minT-273.15);
    
    % Write data to excel-file
    excelData(end+1,:) = {num2str(i), t_Laser, maxT-273.15, minT-273.15};
    
    % Export plot of layer
    fin = LayerShift .* Temp;
    [plot] = plotSimulation(fin, x, y, z, xSliced, ySliced, zSliced, region, savePath, fileDate, i, stlName);
    
    videoTemp{i} = [fin];
end

%% Combine PDFs into one

stlName = stlName(1:end-4);
pdfToCombine = cell(1,nx);

for j = 1 : nx
    fileName2 = [stlName, '-Layer', num2str(j)];
    singlePDF = [fileName2, '.pdf'];
    pdfToCombine{j} = singlePDF;
end

combinedPDF = [fileDate, '-', stlName, '-Plot', '.pdf'];
append_pdfs(combinedPDF, pdfToCombine{:});

for j = 1 : nx
    delete(pdfToCombine{j})
end

%% Export completed simulation as plot

%{
fin = circshift(voxelMatrix,[0 0 -2]) .* Temp;
[plot] = plotSimulation(fin, x, y, z, xSliced, ySliced, zSliced, region, savePath, fileDate, i, stlName);
fileName = ['SimulationPlot-', fileDate, '.fig'];
savefig(fileName)
%}

%% Export information
nodesNumber = ['Number of nodes (layers): ', num2str(nx)];
laserTime = ['Average laser time per layer: ', num2str(t_Laser_mean/nx), ' s'];
averageTime = ['Average runtime: ', num2str(toc/60), ' min'];

disp(nodesNumber)
disp(laserTime)
disp(averageTime)

% Write data to report
fprintf(fileID, '---------------------------\n');
fprintf(fileID, 'Average laser time per layer: %0.3f s\n', t_Laser_mean/nx);
fprintf(fileID, 'Average runtime: %0.3f min\n', toc/60);

fclose(fileID);

xlswrite(excelFileName, excelData, 'Tabelle1', 'A2')

fileName = [fileDate, '-', stlName];
[fig] = plotEvaluationOfSimulation(fileName, stlName, fileDate);
evaluationFileName = [fileDate, '-', stlName, '-Evaluation', '.pdf'];

movefile(evaluationFileName, 'Reports')
movefile(excelFileName, 'Reports')
movefile(combinedPDF, 'Reports')