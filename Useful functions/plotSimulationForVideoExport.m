function [fig] = plotSimulationForVideoExport(temperatureArray, n, n_new, x, y, z, xSliced, ySliced, region, stlFileName, fileDate)
    % [fig] = plotSimulationForVideoExport(temperatureArray, n, n_new, x, y, z, xSliced, ySliced, region, stlFileName, fileDate)
    % 
    % Plotting the simulation
    %
    
    [~, b] = size(temperatureArray);
    [o, p, q] = size(temperatureArray{1});
    nameMatrix = zeros(o,p,q);
    
    videoFileName = [fileDate, '-', stlFileName, '.avi'];
    
    v = VideoWriter(videoFileName);
    % Number of frames to display per second
    v.FrameRate = 3;
    % A percentage from 0 through 100
    v.Quality = 100;
    open(v)
    
    % Display information
    disp('--------------------')
    disp('Start video function')
    
    for i = 1 : n_new
        for j = 1 : n_new
            for k = 1 : n_new
                nameMatrix(i,j,k) = NaN;
            end
        end
    end
    
    i = 1;
    j = 0;
    
    while i <= b
        Temp = temperatureArray{i};
        nameMatrix(:,:,b-j:b) = Temp(:,:,b+2-j:b+2);
        [plot] = plotSimulation(nameMatrix, x, y, z, xSliced, ySliced, region, i, stlFileName);
        
        frame = getframe(gcf);
        writeVideo(v,frame);
        
        videoInformation = ['Creating video frame ', num2str(i), ' of ', num2str(b)];
        disp(videoInformation)
        
        i = i + 1;
        j = j + 1;
    end
    
    close(v)
    disp('End video function')
    disp('--------------------')
    
    pdfToCombine = cell(1,b);
    
    for j = 1 : b
        fileName2 = ['T', '-Layer', num2str(j)];
        singlePDF = [fileName2, '.pdf'];
        pdfToCombine{j} = singlePDF;
    end
    
    combinedPDF = [fileDate, '-', stlFileName, '-Video', '.pdf'];
    append_pdfs(combinedPDF, pdfToCombine{:});
    
    for j = 1 : n
        delete(pdfToCombine{j})
    end
    
    movefile(videoFileName, 'Reports')
    movefile(combinedPDF, 'Reports')
end