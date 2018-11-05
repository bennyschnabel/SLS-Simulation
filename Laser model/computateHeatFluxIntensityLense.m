function [q_0] = computateHeatFluxIntensityLense(P, r_0, r)
    % [q_0] = computateHeatFluxIntensityLense(P, r_0, r)
    %
    % Bachelor thesis equation number: (3.3)
    % 
    % Calculation of the heat flux intensity at the lense.
    % The heat flux intensity has the unit W/m^2.
    %
    
    q_0 = ((3 * P)/(pi * r_0.^2)) * exp(-((3 * r.^2) / (r_0.^2)));
end