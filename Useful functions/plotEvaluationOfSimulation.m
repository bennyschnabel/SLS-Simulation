function [fig] = plotEvaluationOfSimulation(fileName, stlName, fileDate)
    % [fig] = plotSimulation(fin, x, y, z, xSliced, ySliced, zSliced, region, savePath, fileDate, i)
    % 
    % Plotting the simulation
    %
    
    set(groot, 'defaultAxesTickLabelInterpreter','tex');
    set(groot, 'defaultLegendInterpreter','tex');
    set(groot,'defaultTextInterpreter','tex');
    %fileName = 'Teil2-2018-09-18-09-55-11';
    fileType = '.xlsx';
    file = [fileName, fileType];
    A = xlsread(file);
    layerNo = A(:,1);
    laserTime = A(:,2);
    maxTemp = A(:,3);
    minTemp = A(:,4);

    fig = figure;
    left_color = [0 0 0];
    right_color = [0 0 0];
    set(fig,'defaultAxesColorOrder',[left_color; right_color]);
    hold on;

    xlabel('Layer no')
    yyaxis left
    ylabel('Temperature [{}^{\circ}C]', 'Interpreter','tex')
    plot(layerNo, maxTemp, layerNo, minTemp, '--', 'LineWidth', 2)

    yyaxis right
    ylabel('Time [s]')
    plot(layerNo, laserTime, ':', 'LineWidth', 2)
    legend('Maximum temperature','Minimum temperature','Laser exposure time','Location','Best')
    grid on;
    hold off;
    axis tight;

    fileName = [fileDate, '-', stlName, '-Evaluation'];
    orient(fig,'landscape')
    print(fig,'-bestfit',fileName,'-dpdf','-r0')