function [q_f] = computateHeatFluxIntensityFocalPoint(P, r_0, lambda, f, r)
    % [q_f] = computateHeatFluxIntensityFocalPoint(P, r_0, lambda, f, r)
    %
    % Bachelor thesis equation number: ()
    % 
    % Calculation of the heat flux intensity at the focal point.
    % The heat flux intensity has the unit W/m^2.
    %
    
    q_f = ((3 * P * pi * r_0.^2)./(lambda.^2 * f.^2)) * exp(-((3 * r.^2) / (r_0.^2)));