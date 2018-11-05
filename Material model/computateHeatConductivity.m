function [kappa] = computateHeatConductivity(theta)
    % [kappa] = computateHeatConductivity(theta)
    %
    % Bachelor thesis equation number: (2.5)
    % 
    % Calculation of the heat conductivity for PA 2200. 
    % The input temperature must be specified in degrees Celsius.
    % The heat conductivity has the unit W / (m * K).
    %
    
    kappa = 0.078 + (0.23 ./ (1 + 10.^(20 - 0.12 * theta)));
end