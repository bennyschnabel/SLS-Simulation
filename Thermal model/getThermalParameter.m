% parameter = getThermalParameter()
%
% Function that provides the thermal parameters.
%

function parameter = getThermalParameter()
    % Number of nodes
    parameter.numberOfNodes = 5;
    % Chamber temperature [K]
    parameter.chamberTemperature = 273.15 + 175.0;
    % Powderbed temperature [K]
    parameter.powderbedTemperature = 273.15 + 163.0;
    % [Temperature based on paper!!!]
    %parameter.powderbedTemperature = 273.15 + 140.0;
    
    % Boltzmann constant [J/K]
    parameter.boltzmannConstant = 1.3806504 * 10^-23;
    % Speed of light [m/s]
    parameter.speedOfLight = 299792458;
    % Planck constant [Js]
    parameter.planckConstant = 6.62606896 * 10^-34;
    
    % Cooling time [s]
    parameter.coolingtime = 0.01;
end
