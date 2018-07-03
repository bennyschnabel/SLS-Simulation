clear variables; close all; clc;

%% Add folders to search path
addpath('Laser model');
addpath('Material model');
addpath('Thermal model');
addpath('Useful functions');

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
a = laserParameter.distanceFocalPoint * 10^-3;
% Laser power [W]
P = laserParameter.laserPower;
% Laser Speed [m/s]
v = laserParameter.laserSpeed;

axisscale = 0.02;

x = -axisscale : 0.001 : axisscale;
y = -axisscale : 0.001 : axisscale;

[X,Y] = meshgrid(x,y);

r = sqrt(X.^2 + Y.^2);

%P = [0: 1 : 30];

% Calculation of the beam divergence angle [-]
theta = computateBeamDivergenceAngle(lambda, r_0);
% Calculation of the focal point radius [m]
r_f = computateFocalPointRadius(f, theta);
% Calculation of the workpiece radius [m]
r_w = computateWorkpieceRadius(f, r_0, r_f, a);
% Calculation of the heat flux intensity at the lense [W/m^2]
q_0 = computateHeatFluxIntensityLense(P, r_0, r);
% Calculation of the heat flux intensity at the focal point [W/m^2]
q_f = computateHeatFluxIntensityFocalPoint(P, r_0, lambda, f, r);
% Calculation of the heat flux intensity at the workpiece [W/m^2]
q_w = computateHeatFluxIntensityWorkpiece(r_0, r_w, q_0);
% Calculation of the maximal heat flux intensity at the workpiece [W/m^2]
q_w_max = max(max(q_w));

%plotLaserFunctions(X,Y,q_w * 10^-6,axisscale,'Wärmestromdichte q_w xy', 'pdf');

%% Material model

%theta = 0 : 0.01 : 250;
%plotMaterialParameter(theta,computateHeatCapacity(theta), 'Heat capacity');
%plotMaterialParameter(theta,computateHeatConductivity(theta), 'Heat conductivity');
%plotMaterialParameter(theta,computateThermalDiffusivity(theta), 'Thermal diffusivity');

%% Thermal model

thermalParameter = getThermalParameter();

Lx = thermalParameter.lengthOfDomainInX;
Ly = thermalParameter.lengthOfDomainInY;
nx = thermalParameter.numberOfNodesInX;
ny = thermalParameter.numberOfNodesInY;
dx = Lx/(nx-1);
dy = Ly/(ny-1);
T_powderbed = thermalParameter.powderbedTemperature;
T_chamber = thermalParameter.chamberTemperature;

% Laser time
t_Laser = Lx / v;

% Build IC

u0 = zeros(size(nx,ny));

for i = 1 : nx
    for j = 1 : ny
        u0(i,j) = T_powderbed;
    end
end

% Initial heating

[Temp, maxT,j] = computateHeatEquation2D(t_Laser, q_w_max, u0, T_chamber,T_powderbed);
a = Temp(ny-10:ny,nx/2-20:nx/2+20);
disp(j);
dispTest = ['Heating: ',num2str(maxT-273.15),'°C'];
disp(dispTest)
i = 1;
%{
while i < 5
    disp(i)
    [Temp, maxT] = computateHeatEquation2D(5.0, 0, Temp, T_chamber,T_powderbed);
    disp1 = ['Cooling: ',num2str(maxT-273.15),'°C'];
    disp(disp1)
    [Temp, maxT] = computateHeatEquation2D(t_Laser, q_w_max, Temp, T_chamber,T_powderbed);
    a = [a; Temp(ny-10:ny,nx/2-20:nx/2+20)];
    disp2 = ['Heating: ',num2str(maxT-273.15),'°C'];
    disp(disp2)
    circshift(Temp,2,2);
    i = i + 1;
end

a = a - 273.15;
%}
%% Plot

[x,y] = meshgrid(0:dx:Lx,0:dy:Ly);

fig = figure(1);
surf(x,y,Temp-273.15);
view(0,90);
%titlePlot = ['Elapsed time: ' num2str(t) ' s'];
%title(titlePlot);
xlabel('x [m]');
ylabel('y [m]');
zlabel('Temperatur °C');
cb = colorbar;
ylabel(cb, 'Temperatur °C');
orient(fig,'landscape');
print(fig,'-bestfit','Test','-dpdf','-r0');
disp(maxT-273.15);
