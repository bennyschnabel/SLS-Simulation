function [T,maxT, it] = computateHeatEquation3D(tFinal, q_w, u0, T_air, T_bed)
    % [T,maxT, it] = computateHeatEquation3D(tFinal, q_w, u0, T_air, T_bed)
    %
    % Bachelor thesis equation number: ()
    % 
    %
    %
    
    %% Parameters
    
    % Get thermal parameters
    thermalParameter = getThermalParameter();
    
    a = computateThermalDiffusivity(184.3) * 10^5;
    Lx = thermalParameter.lengthOfDomainInX;
    Ly = thermalParameter.lengthOfDomainInY;
    Lz = thermalParameter.lengthOfDomainInZ;
    nx = thermalParameter.numberOfNodesInX;
    ny = thermalParameter.numberOfNodesInY;
    nz = thermalParameter.numberOfNodesInZ;
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
    q(nx-1,:,:) = q_w/thermalParameter.layerThickness;
    
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
        %q(nx-1:nx,:) = 0;
        %q(nx-1:nx,:,:) = q_w/thermalParameter.layerThickness;
        
         % forward euler solver
         %u = finiteDifferenceMethod2D(uo,nx,ny,Dx,Dy,dt,q,rho,c_p);
         u = finiteDifferenceMethod3D(uo,nx,ny,nz,Dx,Dy,Dz,dt,q,rho,c_p);
         T = u;
         
         % set BCs
         u(1,:,:) = T_bed;
         u(:,1,:) = T_bed;
         T(:,:,1) = T_bed;
         u(:,ny,:) = T_bed ;
         u(:,:,nz) = T_bed ;
         
         if q_w == 0
             u(nx,:,:) = T_air;
         else
             u(nx,:,:) = uo(nx-1,:,:);
         end
         
         % compute time step
         if t + dt > tFinal
             dt = tFinal - t; 
         end
         
         % Update iteration counter and time
         it = it + 1; t = t + dt;
         
         if maxT < max(max(T))
             maxT = max(T(:,:,:));
         else
             maxT = maxT;
         end
         
         % Real-time plot
         displayLivePlot='hide';
         
         switch displayLivePlot
             case 'show'
                 disp('')
                 if mod(it,100)
                     hold on
                     slice(x,y,z,T - 273.15,xSliced,Inf,zSliced);
                     axis(region);
                     %view(0,90)
                     titlePlot = ['Elapsed time: ' num2str(t) ' s'];
                     title(titlePlot)
                     cb = colorbar;
                     ylabel(cb, '°C')
                     xlabel('x [m]')
                     ylabel('y [m]')
                     zlabel('z [m]')
                     shading interp
                     drawnow
                 end
             case 'hide'
                 disp('')
             otherwise
                 disp('')
         end
    end
    %{
    fig = figure(1);
    surf(x,y,u-273.15)
    view(0,90)
    titlePlot = ['Elapsed time: ' num2str(t) ' s'];
    title(titlePlot)
    xlabel('x [m]')
    ylabel('y [m]')
    zlabel('°C')
    cb = colorbar;
    ylabel(cb, '°C')
    shading interp
    orient(fig,'landscape')
    print(fig,'-bestfit','Test','-dpdf','-r0');
    %}