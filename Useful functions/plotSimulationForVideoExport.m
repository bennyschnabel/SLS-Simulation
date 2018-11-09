function [fig] = plotSimulationForVideoExport(temperatureArray, n_new, x, y, z, xSliced, ySliced, region, stlFileName, fileDate)
    % [fig] = plotSimulationForVideoExport(temperatureArray, n, n_new, x, y, z, xSliced, ySliced, region, stlFileName, fileDate)
    % 
    % Plotting the simulation
    %
    
    [~, b] = size(temperatureArray);
    [o, p, q] = size(temperatureArray{1});
    nameMatrix = zeros(o,p,q);
    
    videoFileName = [fileDate, '-', stlFileName];
    
    v = VideoWriter(videoFileName, 'Uncompressed AVI');
    % Number of frames to display per second
    v.FrameRate = 2;
    % A percentage from 0 through 100
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
    
    stlName = stlFileName(1:end-4);
    
    while i <= b
        Temp = temperatureArray{i};
        nameMatrix(:,:,b-j:b) = Temp(:,:,b+2-j:b+2);
        plotSimulationPNG(nameMatrix, x, y, z, xSliced, ySliced, region, i, stlFileName);
        
        fileName = [stlName, '-Layer', num2str(i), '.png'];
        
        img = imread(fileName);
        
        writeVideo(v,img)
        
        delete(fileName)
        
        videoInformation = ['Creating video frame ', num2str(i), ' of ', num2str(b)];
        disp(videoInformation)
        
        i = i + 1;
        j = j + 1;
    end
    
    close(v)
    disp('End video function')
    disp('--------------------')
    
    videoFileName = [fileDate, '-', stlFileName, '.avi'];
    
    movefile(videoFileName, 'Reports')
end