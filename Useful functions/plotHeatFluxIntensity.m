function [fig] = plotHeatFluxIntensity(axisScale, exportAsPDF, P, r_0, r_w)
    % [[fig] = plotHeatFluxIntensity(axisScale, exportAsPDF, P, r_0, r_w)
    % 
    % Plotting the heat flux intensity at the powder bed surface
    %
    
    set(groot, 'defaultAxesTickLabelInterpreter','tex');
    set(groot, 'defaultLegendInterpreter','tex');
    set(groot,'defaultTextInterpreter','tex');
    
    x = -axisScale : 0.001 : axisScale;
    y = -axisScale : 0.001 : axisScale;
    
    [X,Y] = meshgrid(x,y);
    
    r = sqrt(X.^2 + Y.^2);
    
    q_0 = computateHeatFluxIntensityLense(P, r_0, r);
    q_w = computateHeatFluxIntensityWorkpiece(r_0, r_w, q_0);
    
    fig = figure('Name', 'Heat flux intensity', 'NumberTitle', 'off');
    surf(x,y,q_w * 10^-6,'FaceLighting','gouraud','LineWidth',1);
    xlabel('x [m]')
    ylabel('y [m]')
    zlabel('Heat flux intensity [MW/m^{2}]', 'Interpreter','tex')
    grid on
    axis tight
    cb = colorbar;
    ylabel(cb, 'MW/m^{2}', 'Interpreter','tex')
    set(gca,'fontsize',12)
    
    switch exportAsPDF
        case 'true'
            orient(fig,'landscape')
            print(fig,'-bestfit','HeatFluxIntensity','-dpdf','-r0')
            movefile('HeatFluxIntensity.pdf', 'Plots')
        case 'false'
            disp('')
        otherwise
            disp('Error')
    end
end