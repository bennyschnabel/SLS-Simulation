% parameter = getLaserParameter()
%
% Function that provides the laser parameters.
%

function parameter = getLaserParameter()
    % Stefan-Boltzmann constant [W/(m^2 K^4)]
    parameter.stefanBoltzmanConstant = 5.670367 * 10^-8;
    % Focal length [mm]
    parameter.focalLength = 120.0;
    % Wave length [ym]
    parameter.waveLength = 10.63;
    % Laser power [W]
    parameter.laserPower = 30.0;
    % Raw beam radius at focusing lens [mm]
    parameter.rawBeamRadius = 16.0;
    % Distance to focal point [mm]
    parameter.distanceFocalPoint  = 10.0;
end
