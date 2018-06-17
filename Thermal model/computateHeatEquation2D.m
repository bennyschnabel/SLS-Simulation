function [T, x, y, t, maxT, minT] = computateHeatEquation2D(Lx, Ly, nx, ny, qw, s, T0)
     %% 1-Inputs section
     
     dx = Lx / (nx - 1);
     dy = Ly / (ny - 1);
     
     % Alpha Start !!!
     roomTemperature = 25;
     constantTemperature = 184.3;
     alpha = thermalDiffusivity(constantTemperature) * 10^5;
     q = zeros(nx,ny);
     q(nx-1,:) = qw/s;
     
     b = 1 / (heatCapacity(constantTemperature) * density(constantTemperature));
     
     Dx = alpha/dx^2;
     Dy = alpha/dy^2;
     
     % end time
     tFinal = 2.0;
     
     % For colorbar
     T_min = 0;
     T_max = 0;
     
     % For report
     maxT = 0;
     minT = roomTemperature;

     % Set Initial time step
     %dt0 = 1/(2*alpha *(1/dx^2+1/dy^2)); % stability condition
     dt0 = 0.0001;
     
     % Build Numerical Mesh
     [x,y] = meshgrid(0:dx:Lx,0:dy:Ly);
     
     %% Finite difference section
     
     t=dt0; it=0; T=T0; dt=dt0;
     
     while t < tFinal
         T0 = T;
         
         T = zeros(size(T0));
         
         if t < 0.02 % Lasertime
             titlePlot = ['Elapsed time: ' num2str(t) ' s - Heating on'];
             for j = 1:ny
                 for i = 1:nx
                     if(i>1 && i<nx && j>1 && j<ny)
                         T(i,j) = T0(i,j) ...
                             + dt * Dx * (T0(i+1,j) - 2 * T0(i,j) + T0(i-1,j)) ...
                             + dt * Dy * (T0(i,j+1) - 2 * T0(i,j) + T0(i,j-1)) ...
                             + dt * b * q(i,j);
                     else
                         T(i,j)= T0(i,j);
                     end
                 end
             end
         else
             titlePlot = ['Elapsed time: ' num2str(t) ' s - Heating off'];
             for j = 1:ny
                 for i = 1:nx
                     if(i>1 && i<nx && j>1 && j<ny)
                         T(i,j) = T0(i,j) ...
                             + dt * Dx * (T0(i-1,j) - 2 * T0(i,j) + T0(i+1,j)) ...
                             + dt * Dy * (T0(i,j-1) - 2 * T0(i,j) + T0(i,j+1));
                     else
                         T(i,j)= T0(i,j);
                     end
                 end
             end
         end

         % set BCs
         T(1,:) = roomTemperature;%roomTemperature; 
         T(nx,:) = T0(nx-1,:);
         T(:,1) = roomTemperature;%roomTemperature; 
         T(:,ny) = roomTemperature;
         
         % compute time step
         if t + dt > tFinal
             dt = tFinal - t; 
         end
         
         % Update iteration counter and time
         it = it + 1;
         t = t + dt;
         
         if maxT < max(max(T))
             maxT = max(max(T));
         else
             maxT = maxT;
         end
         
         if minT > min(min(T))
             minT = min(min(T));
         else
             minT = minT;
         end
         
         T_min = min(min(T));
         T_max = max(max(T));
         
         % Real-time plot
         realTimePlot='yes';
         
         switch realTimePlot
             case 'yes'
                 if mod(it,100)
                     fig = figure(1);
                     %subplot(1,2,1)
                     hold on
                     surf(x,y,T);
                     view(0,90);
                     caxis([T_min T_max]);
                     cb = colorbar;
                     title(titlePlot);
                     ylabel(cb, '°C');
                     xlabel('x [m]');
                     ylabel('y [m]');
                     zlim([T_min T_max]);
                     zlabel('Temprature');
                     %frame = getframe(gcf);
                     drawnow;
                     %{
                     hold off
                     subplot(1,2,2)
                     hold on
                     scatter(t,T(ceil((nx)),ceil((ny)/2)),'g.');
                     hold on
                     line(t,T(ceil((nx)),ceil((ny)/2)));
                     axis tight; xlabel('Time iterations');
                     axis tight; ylabel('Temperature');
                     legend('x = 0.05, y = 0.1 ','Location','northwest')
                     drawnow;
                     hold off
                     %}
                 end
             case 'no'
                 disp('');
         end
     end
end
