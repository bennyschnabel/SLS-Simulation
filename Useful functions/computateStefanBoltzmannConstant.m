function [sigma] = computateStefanBoltzmannConstant
    % [sigma] = computateStefanBoltzmannConstant
    %
    % Bachelor thesis equation number: ()
    % 
    % Calculation of Stefan–Boltzmann constant.
    % The Stefan–Boltzmann constant has the unit W/(m^2*K^4).
    %
    
    thermalParameter = getThermalParameter();
    
    k = thermalParameter.boltzmannConstant;
    c_0 = thermalParameter.speedOfLight;
    h = thermalParameter.planckConstant;
    
    sigma = 2/15 * ((pi^5 * k^4) / (c_0^2 * h^3));