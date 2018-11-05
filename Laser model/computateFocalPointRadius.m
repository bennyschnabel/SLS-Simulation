function [r_f] = computateFocalPointRadius(f, theta)
    % [r_f] = computateFocalPointRadius(f, theta)
    %
    % Bachelor thesis equation number: (3.1)
    % 
    % Calculation of the focal point radius.
    % The focal point radius has the unit m.
    %
    
    r_f = (f * theta) / 2;
end