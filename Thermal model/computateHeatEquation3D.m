function [T,maxT, minT] = computateHeatEquation3D(tFinal, q_w, u0, T_chamber, T_bed, layer, layerShift, s, L, n, A)
    % [T,maxT, minT] = computateHeatEquation3D(tFinal, q_w, u0, T_chamber, T_bed, layer, layerShift, s, L, n, A)
    %
    % Bachelor thesis equation number: ()
    % 
    %
    %
    
    %% Parameters
    
    % Get thermal parameters
    %thermalParameter = getThermalParameter();
    
    a = computateThermalDiffusivity(184.3) * 10^3;
    h = L/(n-1);
    D = a/h^2;
    
    rho =  computateDensity(184.3);
    c_p = computateHeatCapacity(184.3);
    
    sigma = computateStefanBoltzmannConstant;
    if isnan(A)
        A = 1;
    else
        A = A;
    end
    % Set Initial time step
    dt0 = 1/(2*a*(1/h^2+1/h^2+1/h^2)); % stability condition
    %disp(dt0)
    
    if dt0 > 1 * 10^-3
        dt0 = 1 * 10^-5;
    else
        dt0 = dt0;
        disp('Caution: System is not stable!!')
    end
    
    %% Solver Loop 
    % load initial conditions
    t=dt0; it=0; u=u0; dt=dt0;

    q = zeros(n,n,n);
    q(:,:,n-1) = layer;
    q(:,:,n-1) = q(:,:,n-1) * (q_w/s);
    
    maxT = 0;
    minT = 1 * 10^5;
    
    while t < tFinal
        % RK stages
        uo=u;
        u = finiteDifferenceMethod3D(uo,n,D,dt,q,rho,c_p,sigma,A);
        T = u;
        
        % set BCs
        u(1,:,:) = T_bed;
        u(:,1,:) = T_bed;
        u(:,:,1) = T_bed;
        u(n,:,:) = T_bed ;
        u(:,n,:) = T_bed ;
        
        if q_w == 0
            u(:,:,n) = T_chamber;
        else
            u(:,:,n) = uo(:,:,n-1);
        end
         
         % compute time step
         if t + dt > tFinal
             dt = tFinal - t; 
         end
         
         % Update iteration counter and time
         it = it + 1; t = t + dt;
         
         heatedLayer = layerShift .* T;
         heatedLayer(heatedLayer == 0) = NaN;
         
         if maxT < max(max(heatedLayer(:,:,n)))
             maxT = max(max(heatedLayer(:,:,n)));
         else
             maxT = maxT;
         end
    end
    
    if minT > min(min(heatedLayer(:,:,n)))
        minT = min(min(heatedLayer(:,:,n)));
    else
        minT = minT;
    end
end