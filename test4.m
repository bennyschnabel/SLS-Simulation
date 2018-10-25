clear all; clc;

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

b = [0.01, 0.02, 0.03, 0.04, 0.05];

c = [];
d = [];

for i = 1 : length(b)
    r_w = computateWorkpieceRadius(f, r_0, r_f, b(i));
    c = [c, r_w];
    q_0 = computateHeatFluxIntensityLense(P, r_0, r);
    q_f = computateHeatFluxIntensityFocalPoint(P, r_0, lambda, f, r);
    q_w = computateHeatFluxIntensityWorkpiece(r_0, r_w, q_0);
    q_w_max = max(max(q_w)) * 10^-6;
    d = [d, q_w_max];
end

%r_w = computateWorkpieceRadius(f, r_0, r_f, b);
% Calculation of the heat flux intensity at the lense [W/m^2]
%q_0 = computateHeatFluxIntensityLense(P, r_0, r);
% Calculation of the heat flux intensity at the focal point [W/m^2]
%q_f = computateHeatFluxIntensityFocalPoint(P, r_0, lambda, f, r);
% Calculation of the heat flux intensity at the workpiece [W/m^2]
%q_w = computateHeatFluxIntensityWorkpiece(r_0, r_w, q_0);
% Calculation of the maximal heat flux intensity at the workpiece [W/m^2]
%q_w_max = max(max(q_w));

set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
set(groot,'defaultTextInterpreter','latex');

fileName = 'QW-b';
labelName = 'W\"armestromdichte $\left[ \frac{MW}{m^{2}} \right]$';

fig = figure();
plot(b * 10^3,d,'-k','LineWidth',1.5,'MarkerFaceColor',[0 0 0])
    
xlabel('Abstand zum Brennpunkt $\left[ mm \right]$','Interpreter','latex')
ylabel(labelName,'Interpreter','latex')
%ylim([0, rho(end)+100]);
grid on
set(gca,'fontsize',12)
    
orient(fig,'landscape')
print(fig,'-bestfit',fileName,'-dpdf','-r0')
