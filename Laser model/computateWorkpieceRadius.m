function [r_w] = computateWorkpieceRadius(f, r_0, r_f, b)
    % [r_w] = computateWorkpieceRadius(f, r_0, r_f, b)
    %
    % Bachelor thesis equation number: (3.5)
    % 
    % Calculation of the workpiece radius.
    % The workpiece point radius has the unit m.
    %
    
    r_w = (f * r_f + b * (r_0 - r_f)) / f;
end