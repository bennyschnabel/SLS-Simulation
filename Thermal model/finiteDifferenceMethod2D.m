function [T] = finiteDifferenceMethod2D(T0,nx,ny,Dx,Dy,dt,q)
    % [T] = finiteDifferenceMethod2D(u,nx,ny,Dx,Dy,S,dt)
    %
    % Bachelor thesis equation number: ()
    % 
    %
    %
    
    T = zeros(size(T0));
    
    for j = 1:ny
        for i = 1:nx
             if(i>1 && i<nx && j>1 && j<ny)
                 T(i,j) = T0(i,j) ...
                     + dt * Dx * (T0(i+1,j) - 2 * T0(i,j) + T0(i-1,j)) ...
                     + dt * Dy * (T0(i,j+1) - 2 * T0(i,j) + T0(i,j-1)) ...
                     + dt * 1 * q(i,j);
             else
                 T(i,j) = T0(i,j);
             end
        end
    end