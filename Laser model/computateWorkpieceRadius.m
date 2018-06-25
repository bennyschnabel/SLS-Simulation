function [r_w] = computateWorkpieceRadius(f, r_0, r_f, a)
    % [r_w] = computateWorkpieceRadius(f, r_0, r_f, a)
    %
    % Bachelor thesis equation number: ()
    % 
    % Calculation of the workpiece radius.
    % The workpiece point radius has the unit m.
    %
    
    r_w = (f * r_f + a * (r_0 - r_f)) / f;