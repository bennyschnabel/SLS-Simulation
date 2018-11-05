function [a] = computateThermalDiffusivity(theta)
    % [a] = computateThermalDiffusivity(theta)
    %
    % Bachelor thesis equation number: (2.6)
    % 
    % Calculation of the thermal diffusivity for PA 2200. 
    % The input temperature must be specified in degrees Celsius.
    % The thermal diffusivity has the unit m^2 / s.
    %
    
    a = computateHeatConductivity(theta) ./ (computateDensity(theta) .* computateHeatCapacity(theta)); 
end