function [T,maxT] = computateHeatEquation3D(tFinal, q_w, u0, T_air, T_bed, layer, layerShift, layerThickness, Lx, Ly, Lz, nx, ny, nz)
    % [T,maxT] = computateHeatEquation3D(tFinal, q_w, u0, T_air, T_bed)
    %
    % Bachelor thesis equation number: ()
    % 
    %
    %
    
    %% Parameters
    
    % Get thermal parameters
    %thermalParameter = getThermalParameter();
    
    a = computateThermalDiffusivity(184.3) * 10^6;
    dx = Lx/(nx-1);
    dy = Ly/(ny-1);
    dz = Lz/(nz-1);
    Dx = a/dx^2;
    Dy = a/dy^2;
    Dz = a/dz^2;
    
    rho =  computateDensity(184.3);
    c_p = computateHeatCapacity(184.3);
    
    % Build Numerical Mesh
    [x,y,z] = meshgrid(0:dx:Lx,0:dy:Ly,0:dz:Lz);

    % Set Initial time step
    dt0 = 1/(2*a*(1/dx^2+1/dy^2+1/dz^2)); % stability condition
    
    if dt0 > 1 * 10^-3
        dt0 = 1 * 10^-5;
    else
        dt0 = dt0;
    end
    
    %% Solver Loop 
    % load initial conditions
    t=dt0; it=0; u=u0; dt=dt0;
    
    q = zeros(nx,ny,nz);
    q(:,:,nz-1) = layer;
    q(:,:,nz-1) = q(:,:,nz-1) * (q_w/layerThickness);
    
    maxT = 0;
    
    iter = tFinal / dt0;
    iterA = iter / nx;
    
    % Set plot region
    region = [0,Lx,0,Ly,0,Lz]; 

    xSliced = linspace(0.1, Lx, 5);
    ySliced = linspace(0.1, Ly, 5);
    zSliced = linspace(0.1, Lz, 5);
    
    while t < tFinal
        % RK stages
        uo=u;
        u = finiteDifferenceMethod3D(uo,nx,ny,nz,Dx,Dy,Dz,dt,q,rho,c_p);
        T = u;
        
        % set BCs
        u(1,:,:) = T_bed;
        u(:,1,:) = T_bed;
        u(:,:,1) = T_bed;
        u(nx,:,:) = T_bed ;
        u(:,ny,:) = T_bed ;
         
         if q_w == 0
             u(:,:,nz) = T_air;
         else
             u(:,:,nz) = uo(:,:,nz-1);
         end
         
         % compute time step
         if t + dt > tFinal
             dt = tFinal - t; 
         end
         
         % Update iteration counter and time
         it = it + 1; t = t + dt;
         
         heatedLayer = layerShift .* T;
         heatedLayer(heatedLayer == 0) = NaN;
         
         if maxT < max(max(heatedLayer(:,:,nz)))
             maxT = max(max(heatedLayer(:,:,nz)));
         else
             maxT = maxT;
         end
         
         % Real-time plot
         displayLivePlot='hide';
         
         switch displayLivePlot
             case 'show'
                 disp('')
                 if mod(it,100)
                     fin = layerShift .* T;
                     fin(fin == 0) = NaN;
                     slice(x,y,z,fin-273.15,Lx/2,Ly/2,Lz/2);
                     axis(region);
                     titlePlot = ['Elapsed time: ' num2str(t) ' s']; 
                     title(titlePlot); 
                     cb = colorbar;
                     ylabel(cb, '°C');
                     drawnow;
                 end
             case 'hide'
                 disp('')
             otherwise
                 disp('')
         end
    end