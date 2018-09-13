% parameter = getThermalParameter()
%
% Function that provides the thermal parameters.
%

function parameter = getThermalParameter()
    a = 25;
    % Number of nodes in x direction
    parameter.numberOfNodesInX = a;
    % Number of nodes in y direction
    parameter.numberOfNodesInY = a;
    % Number of nodes in z direction
    parameter.numberOfNodesInZ = a;
    % Length of domain in x direction [m]
    %parameter.lengthOfDomainInX = 0.1;
    % Length of domain in y direction [m]
    %parameter.lengthOfDomainInY = 0.1;
    % Length of domain in z direction [m]
    %parameter.lengthOfDomainInZ = 0.1;
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
