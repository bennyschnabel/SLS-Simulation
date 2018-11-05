function [theta] = computateBeamDivergenceAngle(lambda, r_0)
    % [theta] = computateBeamDivergenceAngle(lambda, r0)
    %
    % Bachelor thesis equation number: (-)
    % 
    % Calculation of the beam divergence angle.
    %
    
    theta = (4 * lambda) / (pi * 2 * r_0);
end