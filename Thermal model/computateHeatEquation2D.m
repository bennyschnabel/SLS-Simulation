function [T] = computateHeatEquation2D(tFinal)
    % [T] = computateHeatEquation2D(tFinal)
    %
    % Bachelor thesis equation number: ()
    % 
    %
    %
    
    %% Parameters
    D = 1.0; % alpha
    L = 0.1; nx = 100; dx = L/(nx-1); 
    W = 0.1; ny = 100; dy = W/(ny-1);
    Dx = D/dx^2; Dy = D/dy^2;
    
    % Build Numerical Mesh
    [x,y] = meshgrid(0:dx:L,0:dy:W);
    
    % Build IC
    %u0 = sin(pi*x).*sin(pi*y);
    u0 = zeros(nx,ny);
    
    % Set Initial time step
    dt0 = 1/(2*D*(1/dx^2+1/dy^2)); % stability condition
    
    %% Solver Loop 
    % load initial conditions
    t=dt0; it=0; u=u0; dt=dt0;
    
    q = zeros(nx,ny);
    
    while t < tFinal
        % RK stages
        uo=u;
        
         % forward euler solver
         u = finiteDifferenceMethod2D(uo,nx,ny,Dx,Dy,dt,q);
         T = u;
         % set BCs
         u(1,:) = 100; u(nx,:) = 200;
         u(:,1) = 100; u(:,ny) = 200;
         
         % compute time step
         if t+dt>tFinal
             dt=tFinal-t; 
         end
         
         % Update iteration counter and time
         it=it+1; t=t+dt;
         
         % plot solution
         
         if mod(it,100)
             figure(1)
             hold on;
             surf(x,y,u);
             view(0,90);
             titlePlot = ['Elapsed time: ' num2str(t) ' s'];
             title(titlePlot);
             cb = colorbar;
             ylabel(cb, 'Temperatur °C'); 
             %axis([0,L,0,W,-1,1]);
             drawnow; 
         end
         
    end
    fig = figure(1);
    surf(x,y,u);
    view(0,90);
    titlePlot = ['Elapsed time: ' num2str(t) ' s'];
    title(titlePlot);
    xlabel('x [m]');
    ylabel('y [m]');
    zlabel('Temperatur °C');
    cb = colorbar;
    ylabel(cb, 'Temperatur °C');
    orient(fig,'landscape');
    print(fig,'-bestfit','Test','-dpdf','-r0');