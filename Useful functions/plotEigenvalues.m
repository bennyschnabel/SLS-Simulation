function [fig] = plotEigenvalues(temperatureArray, exportAsPDF, fileDate, stlFileName)
    % [fig] = plotEigenvalues(temperatureArray, exportAsPDF, fileDate, stlFileName)
    %
    %
    %
    
    set(groot, 'defaultAxesTickLabelInterpreter','tex');
    set(groot, 'defaultLegendInterpreter','tex');
    set(groot,'defaultTextInterpreter','tex');
    
    [~, b] = size(temperatureArray);
    [o, ~, ~] = size(temperatureArray{1});
    
    i = 1;
    
    fig = figure('Name', 'Eigenvalues', 'NumberTitle', 'off');
    
    hold on
    
    while i <= b
         temp = temperatureArray{i};
         
         j = 1;
         
         while j <= o
             e = eig(temp(:,:,j));
             plot(real(e),imag(e), '*')
             j = j + 1;
         end
         
         i = i + 1;
    end
    
    hold off
    
    xlabel('Re')
    ylabel('Im')
    grid on
    set(gca,'fontsize',12)
    
    switch exportAsPDF
        case 'true'
            orient(fig,'landscape')
            fileName = [fileDate, '-', stlFileName, '-Eigenvalues'];
            print(fig,'-bestfit',fileName,'-dpdf','-r0')
            fileName = [fileDate, '-', stlFileName, '-Eigenvalues.pdf'];
            movefile(fileName, 'Reports')
        case 'false'
            disp('')
        otherwise
            disp('Error')
    end
end