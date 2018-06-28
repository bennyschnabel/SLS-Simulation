function [lambda_max] = computateWiensDisplacementLaw(theta)
    % [lambda_max] = computateWiensDisplacementLaw(theta)
    %
    % Bachelor thesis equation number: ()
    % 
    % Calculation of Wien's displacement law. 
    % The input temperature must be specified in Kelvin.
    % The wavelength has the unit m.
    %
    
    lambda_max = 0.002897768 ./ theta;