function [T] = finiteDifferenceMethod3D(T0,n,D,dt,q,rho,c_p, sigma, A)
    % [T] = finiteDifferenceMethod3D(T0,n,D,dt,q,rho,c_p, sigma, A)
    %
    % Bachelor thesis equation number: ()
    % 
    %
    %

    for k = 1 : n
        for j = 1 : n
            for i = 1 : n
                if(i>1 && i<n && j>1 && j<n && k>1 && k<n)
                    T(i,j,k) = T0(i,j,k) ...
                        + dt * D * (T0(i-1,j,k) - 2 * T0(i,j,k) + T0(i+1,j,k)) ...
                        + dt * D * (T0(i,j-1,k) - 2 * T0(i,j,k) + T0(i,j+1,k)) ...
                        + dt * D * (T0(i,j,k-1) - 2 * T0(i,j,k) + T0(i,j,k+1)) ...
                        + dt * q(i,j,k) ./ (rho * c_p) ...
                        + dt * (A * sigma * T0(i,j,k).^4) ./ (rho * c_p);
                else
                    T(i,j,k)= T0(i,j,k);
                end
            end
        end
    end
end