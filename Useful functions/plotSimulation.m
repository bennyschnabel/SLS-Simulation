function [fig] = plotSimulation(fin, x, y, z, xSliced, ySliced, zSliced, region, savePath, fileDate, i)
    % [fig] = plotSimulation(fin, x, y, z, xSliced, ySliced, zSliced, region, savePath, fileDate, i)
    % 
    % Plotting the simulation
    %
    
    fig = figure();
    fin(fin == 0) = NaN;
    h = slice(x,y,z,fin-273.15,xSliced,ySliced,Inf);
    axis(region);
    set(h,'edgecolor','none')
    set(gca,'xtick',[])
    set(gca,'ytick',[])
    set(gca,'ztick',[])
    xlabel('x')
    ylabel('y')
    zlabel('z')
    cb = colorbar;
    ylabel(cb, '°C')
    fileName = [savePath, 'SimulationPlotLayer-', num2str(i), '-', fileDate];
    orient(fig,'landscape')
    print(fig,'-bestfit',fileName,'-dpdf','-r0')