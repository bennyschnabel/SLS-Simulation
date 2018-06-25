function [q_w] = computateHeatFluxIntensityWorkpiece(r_0, r_w, q_0)
    % [q_w] = computateHeatFluxIntensityWorkpiece(r_0, r_w, q_0)
    %
    % Bachelor thesis equation number: ()
    % 
    % Calculation of the heat flux intensity at the workpiece.
    % The heat flux intensity has the unit W/m^2.
    %
    
    q_w = (r_0/r_w).^2 * q_0;