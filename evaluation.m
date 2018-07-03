clc; clear all;

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
%P = laserParameter.laserPower;
P = 0 : 1 : 30;
% Laser Speed [m/s]
v = laserParameter.laserSpeed;

% Calculation of the beam divergence angle [-]
theta = computateBeamDivergenceAngle(lambda, r_0);
% Calculation of the focal point radius [m]
r_f = computateFocalPointRadius(f, theta);
% Calculation of the workpiece radius [m]
%r_w = computateWorkpieceRadius(f, r_0, r_f, b);
% Calculation of the heat flux intensity at the lense [W/m^2]
q_0 = computateHeatFluxIntensityLense(P, r_0, 0);
% Calculation of the heat flux intensity at the workpiece [W/m^2]
%q_w = computateHeatFluxIntensityWorkpiece(r_0, r_w, q_0);

i = 1;
fig = figure();
xlabel('Laserleitung P [W]')
ylabel('Wärmestromdichte q_{W,max} [MW/m^2]')
hold on;

for b  = 0.01 : 0.01 : 0.08
    % Calculation of the workpiece radius [m]
    r_w = computateWorkpieceRadius(f, r_0, r_f, b);
    % Calculation of the heat flux intensity at the workpiece [W/m^2]
    q_w = computateHeatFluxIntensityWorkpiece(r_0, r_w, q_0) * 10^-6;
    plot(P, q_w, 'LineWidth',1)
    Legend{i}=strcat('b=', num2str(b), ' m');
    grid on
    i = i + 1;
end

legend(Legend,'Location','northwest')
hold off

plottype = 'pdf';
    
switch plottype
case 'svg'
print(fig,'abcd','-dsvg')
case 'pdf'
orient(fig,'landscape')
print(fig,'-bestfit','abcd','-dpdf','-r0')
end
