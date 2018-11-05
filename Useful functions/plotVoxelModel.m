function [fig] = plotVoxelModel(voxelModel, n, exportAsPDF)
    % [fig] = plotVoxelModel(voxelModel, n, exportAsPDF)
    % 
    % Plotting the voxel model
    %
    
    set(groot, 'defaultAxesTickLabelInterpreter','tex');
    set(groot, 'defaultLegendInterpreter','tex');
    set(groot,'defaultTextInterpreter','tex');
    
    fig = figure('Name', 'Voxel model', 'NumberTitle', 'off');
    vol_handle = voxelPlotter(voxelModel,1);
    alpha(0.8)
    az = -37;
    el = 30;
    view(az, el)
    xlabel('[x]')
    ylabel('[y]')
    zlabel('[z]')
    grid on
    set(gca,'xlim',[0 n+2], 'ylim',[0 n+2], 'zlim',[0 n+2])
    set(gca,'XTick',[])
    set(gca,'YTick',[])
    set(gca,'ZTick',[])
    set(gca,'fontsize',12)
    
    switch exportAsPDF
        case 'true'
            orient(fig,'landscape')
            print(fig,'-bestfit','VoxelModel','-dpdf','-r0')
            movefile('VoxelModel.pdf', 'Plots')
        case 'false'
            disp('')
        otherwise
            disp('Error')
    end
end