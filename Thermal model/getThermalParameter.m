% parameter = getThermalParameter()
%
% Function that provides the thermal parameters.
%

function parameter = getThermalParameter()
    % Number of nodes in x direction
    parameter.numberOfNodesInX = 200;
    % Number of nodes in y direction
    parameter.numberOfNodesInY = 200;
    % Length of domain in x direction [m]
    parameter.lengthOfDomainInX = 0.2;
    % Length of domain in y direction [m]
    parameter.lengthOfDomainInY = 0.2;
    % Layer thickness [m]
    parameter.layerThickness = 2 * 10^-4;
    % Chamber temperature [K]
    parameter.chamberTemperature = 273.15+155.0;
    % Powderbed temperature [K]
    parameter.powderbedTemperature = 273.15+163.0;
    
    % Boltzmann constant [J/K]
    parameter.boltzmannConstant = 1.3806504 * 10^-23;
    % Speed of light [m/s]
    parameter.speedOfLight = 299792458;
    % Planck constant [Js]
    parameter.planckConstant = 6.62606896 * 10^-34;
end
