function [rho] = computateDensity(theta)
    % [rho] = computateDensity(theta)
    %
    % Bachelor thesis equation number: ()
    % 
    % Calculation of the density for PA 2200. 
    % The input temperature must be specified in degrees Celsius.
    % The density has the unit kg / m^3.
    %
    
    if theta < 184.3
        rho = 700;
    elseif theta >= 184.3
        rho = 1020;
    end