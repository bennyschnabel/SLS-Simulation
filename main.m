clear variables; close all; clc;

%% Add folders to search path
%addpath('Component model');
addpath('Laser model');
addpath('Material model');
addpath('Thermal model');
addpath('STL file');
addpath('Useful functions');

tic;

%% STL file import

stlName = 'Teil2.STL';
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

layerThickness = maxLengthOfSTLModel / nx;

T_powderbed = thermalParameter.powderbedTemperature;
T_chamber = thermalParameter.chamberTemperature;

%% STL model

% Create Voxel- Matrix
[gridOUTPUT] = VOXELISE(nx,ny,nz,stlName,'xyz');

% Rotate Matrix
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
        % Uncomment for pdf export
        %orient(fig,'landscape')
        %print(fig,'-bestfit','displaySTLPlot','-dpdf','-r0')
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
% Laser Speed [m/s]
v = laserParameter.laserSpeed;

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

%% Material model

%theta = 0 : 0.01 : 250;
%plotMaterialParameter(theta,computateHeatCapacity(theta), 'Heat capacity');
%plotMaterialParameter(theta,computateHeatConductivity(theta), 'Heat conductivity');
%plotMaterialParameter(theta,computateThermalDiffusivity(theta), 'Thermal diffusivity');

%[R,T,A] = computateReflectionTransmissionAbsorption(s);

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
t_Laser = layerThickness * sum(firstLayer(:)) / v;
t_Laser_mean = t_Laser;

[Temp, maxT,j] = computateHeatEquation3D(t_Laser, q_w_max, u0, T_chamber, T_powderbed, ...
    firstLayer, LayerShift, layerThickness, Lx, Ly, Lz, nx, ny, nz);
i = 1;

while i < nx
    disp(i)
    % Cooling while moving down
    %{
    [Temp, maxT,j] = computateHeatEquation3D(1*10^-10, 0, Temp, T_chamber, T_powderbed, ...
        firstLayer, LayerShift, Lx, Ly, Lz, nx, ny, nz);
    %}
    
    % Moving down
    LayerShift = circshift(LayerShift,[0 0 -1]);
    firstLayer = LayerShift(:,:,nz);
    
    % Laser time per layer
    t_Laser = layerThickness * sum(firstLayer(:)) / v;
    t_Laser_mean = t_Laser_mean + t_Laser;
    
    % Heating
    [Temp, maxT,j] = computateHeatEquation3D(t_Laser, q_w_max, Temp, T_chamber, T_powderbed, ...
        firstLayer, LayerShift, layerThickness, Lx, Ly, Lz, nx, ny, nz);
    
    i = i + 1;
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
nodesNumber = ['Number of nodes: ', num2str(nx)];
laserTime = ['Average laser time per layer: ', num2str(t_Laser_mean/nx), ' s'];
averageTime = ['Average runtime: ', num2str(toc/60), ' min'];

disp(nodesNumber)
disp(laserTime)
disp(averageTime)
