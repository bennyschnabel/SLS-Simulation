function [T] = finiteDifferenceMethod2D(T0,nx,ny,Dx,Dy,dt,q,rho,c_p)
    % [T] = finiteDifferenceMethod2D(T0,nx,ny,Dx,Dy,dt,q,rho,c_p)
    %
    % Bachelor thesis equation number: ()
    % 
    %
    %
    
    sigma = computateStefanBoltzmannConstant;
    e = 1;

    for j = 1:ny
        for i = 1:nx
             if(i>1 && i<nx && j>1 && j<ny)
                 T(i,j) = T0(i,j) ...
                     + dt * Dx * (T0(i+1,j) - 2 * T0(i,j) + T0(i-1,j)) ...
                     + dt * Dy * (T0(i,j+1) - 2 * T0(i,j) + T0(i,j-1)) ...
                     + dt * q(i,j) ./ (rho * c_p) ...
                     + dt * (e * sigma * T0(i,j)^4) / (rho * c_p);
             else
                 T(i,j) = T0(i,j);
             end
        end
    end