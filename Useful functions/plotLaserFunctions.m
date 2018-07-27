function [fig] = plotLaserFunctions(x,y,q,axisscale,labelName,datatype)
    % [fig] = plotMaterialParameter(theta,func)
    % 
    % Plotting the material functions
    %
    
    fig = figure();
    surf(x,y,q,'FaceLighting','gouraud','LineWidth',1);
    %title(labelName)
    xlabel('Position x')
    ylabel('Position y')
    %zlabel('Wärmestromdichte')
    %axis([-axisscale axisscale -axisscale axisscale])
    %view(0,0)
    grid on
    cb = colorbar;
    ylabel(cb, 'MW/m^2')
    set(gca,'fontsize',12)
    
    plottype = datatype;
    
    switch plottype
        case 'svg'
            print(fig,labelName,'-dsvg')
        case 'pdf'
            orient(fig,'landscape')
            print(fig,'-bestfit',labelName,'-dpdf','-r0')
    end
    