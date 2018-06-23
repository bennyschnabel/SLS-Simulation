function [cp] = computateHeatCapacity(theta)
    % [cp] = computateHeatCapacity(theta)
    %
    % Bachelor thesis equation number: ()
    % 
    % Calculation of the heat capacity for PA 2200. 
    % The input temperature must be specified in degrees Celsius.
    % The heat capacity has the unit J / (kg * K).
    %
    
    cp = 2.650 + (109 ./ (4 * (theta - 184.3).^2 + 5.97));
    cp = cp * 10^3;