function [R,T,A] = computateReflectionTransmissionAbsorption(s)
    % [R,T,A] = computateReflectionTransmissionAbsorption(s)
    %
    % Bachelor thesis figure number: 2.15
    % 
    % Reflectance, transmittance and absorptivity for Polyamide 12
    % The input layer thickness must be specified in millimeter.
    %
    
    if s == 0.2
        R = 0.06;
        T = 0.009;
        A = 0.931;
    elseif s == 0.3
        R = 0.04;
        T = 0.007;
        A = 0.953;
    elseif s == 0.4
        R = 0.05;
        T = 0.006;
        A = 0.944;
    elseif s == 0.5
        R = 0.04;
        T = 0.006;
        A = 0.954;
    elseif s == 0.6
        R = 0.05;
        T = 0.006;
        A = 0.944;
    elseif s == 0.7
        R = 0.05;
        T = 0.006;
        A = 0.944;
    elseif s == 0.8
        R = 0.04;
        T = 0.006;
        A = 0.954;
    elseif s == 0.9
        R = 0.05;
        T = 0.006;
        A = 0.944;
    elseif s == 1.0
        R = 0.05;
        T = 0.006;
        A = 0.944;
    elseif s == 1.5
        R = 0.05;
        T = 0.006;
        A = 0.944;
    elseif s == 2.0
        R = 0.05;
        T = 0.006;
        A = 0.944;
    else
        R = NaN;
        T = NaN;
        A = NaN;
        disp('R, T, A not set due to not defined layer thickness');
    end
end