function [T] = finiteDifferenceMethod3D(T0,nx,ny,nz,Dx,Dy,Dz,dt,q,rho,c_p)
    % [T] = finiteDifferenceMethod3D(T0,nx,ny,nz,Dx,Dy,Dz,dt,q,rho,c_p)
    %
    % Bachelor thesis equation number: ()
    % 
    %
    %
    
    sigma = computateStefanBoltzmannConstant;
    e = 1 * 10 ^ 0;

    for k = 1 : nz
        for j = 1 : ny
            for i = 1 : nx
                if(i>1 && i<nx && j>1 && j<ny && k>1 && k<nz)
                    T(i,j,k) = T0(i,j,k) ...
                        + dt * Dx * (T0(i-1,j,k) - 2 * T0(i,j,k) + T0(i+1,j,k)) ...
                        + dt * Dy * (T0(i,j-1,k) - 2 * T0(i,j,k) + T0(i,j+1,k)) ...
                        + dt * Dz * (T0(i,j,k-1) - 2 * T0(i,j,k) + T0(i,j,k+1)) ...
                        + dt * q(i,j,k) ./ (rho * c_p) ...
                        + dt * (e * sigma * T0(i,j,k).^4) ./ (rho * c_p);
                else
                    T(i,j,k)= T0(i,j,k);
                end
            end
        end
    end