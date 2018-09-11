clear variables; close all; clc;

%% Add folders to search path
addpath('Laser model');
addpath('Material model');
addpath('Reports');
addpath('STL file');
addpath('Thermal model');
addpath('Useful functions');

tic;

%% Create report

fileDate = datestr(now,'DD-mm-YYYY-HH-MM-SS');
fileName = ['Report-', fileDate, '.txt'];
savePath = './Reports/';
fileID = fopen([savePath fileName],'wt');

%% STL file import

stlName = 'Teil4.STL';
% Display STL file name in console
disp(stlName)
% Write data to report
fprintf(fileID, 'STL file name: %s\n', stlName);
fprintf(fileID, '-----------------------\n');
% Get the max length of the STL file
stlModel  = stlread(stlName);
[val,idx] = max([stlModel.vertices]);
maxLengthOfSTLModel = max(val) * 10^-3;

%% Thermal model

thermalParameter = getThermalParameter();

Lx = maxLengthOfSTLModel;
Ly = maxLengthOfSTLModel;
Lz = maxLengthOfSTLModel;
nx = thermalParameter.numberOfNodesInX;
ny = thermalParameter.numberOfNodesInY;
nz = thermalParameter.numberOfNodesInZ;
dx = Lx/(nx-1);
dy = Ly/(ny-1);
dz = Lz/(nz-1);

nodesThickness = maxLengthOfSTLModel / nx;

T_powderbed = thermalParameter.powderbedTemperature;
T_chamber = thermalParameter.chamberTemperature;

% Write data to report
fprintf(fileID, 'Number of nodes (layers): %d\n', nx);
fprintf(fileID, 'Nodes thickness: %0.3f mm\n', nodesThickness*10^3);
fprintf(fileID, 'Powderbed temperature: %.2f °C\n', T_powderbed-273.15);
fprintf(fileID, 'Chamber temperature: %.2f °C\n', T_chamber-273.15);

%% STL model

% Create Voxel- Matrix
[gridOUTPUT] = VOXELISE(nx,ny,nz,stlName,'xyz');

% Rotate Voxel- Matrix along z axis

rotateZAxis = '0';

switch rotateZAxis
    case '0'
        gridOUTPUT = rot90(gridOUTPUT,0);
    case '90'
        gridOUTPUT = rot90(gridOUTPUT,1);
    case '180'
        gridOUTPUT = rot90(gridOUTPUT,3);
    case '270'
        gridOUTPUT = rot90(gridOUTPUT,2);
    otherwise 
        disp('')
end
        
%gridOUTPUT = rot90(gridOUTPUT,1);

% Show Voxel plot (show or hide)
displaySTLPlot = 'hide';

switch displaySTLPlot
    case 'show'
        disp('')
        fig = figure();
        [vol_handle] = VoxelPlotter(gridOUTPUT,1);
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

% Get all required laser parameters
laserParameter = getLaserParameter();

% Wave length [m]
lambda = laserParameter.waveLength * 10^-6;
% Raw beam radius at focusing lens [m]
r_0 = laserParameter.rawBeamRadius * 10^-3;
% Focal length [m]
f = laserParameter.focalLength * 10^-3;
% Distance to focal point [m]
b = laserParameter.distanceFocalPoint * 10^-3;
% Laser power [W]
P = laserParameter.laserPower;
% Laser speed [m/s]
v = laserParameter.laserSpeed;

% Write data to report
fprintf(fileID, 'Wave length: %.2f mm\n', lambda * 10^3);
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
%plotMaterialParameter(theta,computateHeatCapacity(theta), 'Heat capacity');
%plotMaterialParameter(theta,computateHeatConductivity(theta), 'Heat conductivity');
%plotMaterialParameter(theta,computateThermalDiffusivity(theta), 'Thermal diffusivity');

[R,T,A] = computateReflectionTransmissionAbsorption(nodesThickness);

% Write data to report
fprintf(fileID, 'Reflection: %.2f, transmission: %0.2f, absorption: %0.2f\n', R, T, A);

%% Heat simulation

% Build IC
u0 = zeros(nx,ny,nz);
for i = 1 : nx
    for j = 1 : ny
        for k = 1 : nz
            u0(i,j,k) = T_powderbed;
        end
    end
end

% Initial heating

LayerShift = circshift(gridOUTPUT,[0 0 -1]);
firstLayer = LayerShift(:,:,nz);

% Laser time per layer
t_Laser = nodesThickness * sum(firstLayer(:)) / v;
t_Laser_mean = t_Laser;

% Display layer and time information
i = 1;
layerNumber = ['Layer: ', num2str(i), '; laser exposure time: ', num2str(t_Laser), ' s'];
disp(layerNumber)

[Temp, maxT] = computateHeatEquation3D(t_Laser, q_w_max, u0, T_chamber, T_powderbed, ...
    firstLayer, LayerShift, nodesThickness, Lx, Ly, Lz, nx, ny, nz);

% Display layer and temperature information
layerNumberTemperature = ['Layer: ', num2str(i), '; maximum temperature: ', num2str(maxT-273.15), ' °C'];
disp(layerNumberTemperature)
disp('-------------------')

% Write data to report
fprintf(fileID, '---------------------------\n');
fprintf(fileID, 'Layer no: %d\n', i);
fprintf(fileID, 'Laser exposure time: %0.3f s\n', t_Laser);
fprintf(fileID, 'Maximum temperature: %0.3f °C\n', maxT-273.15);

while i < 1%nx
    i = i + 1;
    
    % Cooling while moving down
    %{
    [Temp, maxT,j] = computateHeatEquation3D(1*10^-10, 0, Temp, T_chamber, T_powderbed, ...
        firstLayer, LayerShift, Lx, Ly, Lz, nx, ny, nz);
    %}
    
    % Moving down
    LayerShift = circshift(LayerShift,[0 0 -1]);
    firstLayer = LayerShift(:,:,nz);
    
    % Laser time per layer
    t_Laser = nodesThickness * sum(firstLayer(:)) / v;
    t_Laser_mean = t_Laser_mean + t_Laser;
    
    % Display layer and time information
    layerNumber = ['Layer: ', num2str(i), '; laser exposure time: ', num2str(t_Laser), ' s'];
    disp(layerNumber)

    % Heating
    [Temp, maxT] = computateHeatEquation3D(t_Laser, q_w_max, Temp, T_chamber, T_powderbed, ...
        firstLayer, LayerShift, nodesThickness, Lx, Ly, Lz, nx, ny, nz);
    
    % Display layer and temperature information
    layerNumberTemperature = ['Layer: ', num2str(i), '; maximum temperature : ', num2str(maxT-273.15), ' °C'];
    disp(layerNumberTemperature)
    disp('-------------------')
    
    % Write data to report
    fprintf(fileID, '---------------------------\n');
    fprintf(fileID, 'Layer no: %d\n', i);
    fprintf(fileID, 'Laser exposure time: %0.3f s\n', t_Laser);
    fprintf(fileID, 'Maximum temperature: %0.3f °C\n', maxT-273.15);
end

% Build meshgrid for plot
[x,y,z] = meshgrid(0:dx:Lx,0:dy:Ly,0:dz:Lz);
region = [0,Lx,0,Ly,0,Lz];

fin = gridOUTPUT .* Temp;

fig = figure();
fin(fin == 0) = NaN;
slice(x,y,z,fin-273.15,Lx/2,Ly/2,Lz/2);
axis(region);
xlabel('x [m]')
ylabel('y [m]')
zlabel('z [m]')
cb = colorbar;
ylabel(cb, '°C')
orient(fig,'landscape')
print(fig,'-bestfit','displaySimulationPlot','-dpdf','-r0')

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