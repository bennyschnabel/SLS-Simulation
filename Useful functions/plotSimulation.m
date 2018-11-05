function [fig] = plotSimulation(fin, x, y, z, xSliced, ySliced, region, i, stlName)
    % [fig] = plotSimulation(fin, x, y, z, xSliced, ySliced, region, i, stlName)
    % 
    % Plotting the simulation
    %
    
    set(groot, 'defaultAxesTickLabelInterpreter','tex');
    set(groot, 'defaultLegendInterpreter','tex');
    set(groot,'defaultTextInterpreter','tex');
    
    fig = figure(1);
    fin(fin == 0) = NaN;
    h = slice(x,y,z,fin-273.15,xSliced,ySliced,Inf);
    axis(region);
    set(h,'EdgeColor','none')
    set(gca,'xtick',[])
    set(gca,'ytick',[])
    set(gca,'ztick',[])
    xlabel('x')
    ylabel('y')
    zlabel('z')
    cb = colorbar;
    ylabel(cb, '{}^{\circ}C', 'Interpreter','tex')
    alpha(h,0.2);
    set(gca,'fontsize',12)
    
    stlName = stlName(1:end-4);
    fileName = [stlName, '-Layer', num2str(i)];
    orient(fig,'landscape')
    print(fig,'-bestfit',fileName,'-dpdf','-r0')
end