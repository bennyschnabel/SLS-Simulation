function [R,T,A] = computateReflectionTransmissionAbsorption(s)
    % [R,T,A] = computateReflectionTransmissionAbsorption(s)
    %
    % Bachelor thesis equation number: ()
    % 
    % Calculation of the heat capacity for PA 2200. 
    % The input temperature must be specified in degrees Celsius.
    % The heat capacity has the unit J / (kg * K).
    %
    
    if s == 2 * 10^-4
        R = 0.06;
        T = 0.009;
        A = 0.931;
    elseif s == 3 * 10^-4
        R = 0.04;
        T = 0.007;
        A = 0.953;
    elseif s == 4 * 10^-4
        R = 0.05;
        T = 0.006;
        A = 0.44;
    elseif s == 1 * 10^-3
        R = 0.05;
        T = 0.006;
        A = 0.944;
    elseif s == 1.5 * 10^-3
        R = 0.05;
        T = 0.006;
        A = 0.944;
    elseif s == 2 * 10^-3
        R = 0.05;
        T = 0.006;
        A = 0.944;
    else
        R = NaN;
        T = NaN;
        A = NaN;
        disp('R, T, A not defined due to not defined layer thickness');
    end