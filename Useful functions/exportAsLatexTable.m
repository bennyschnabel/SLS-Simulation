function [] = exportAsLatexTable(fileName)
    % [] = exportAsLatexTable(fileName)
    % 
    % Plotting the simulation
    %
    
    fileType = '.xlsx';
    file = [fileName, fileType];
    excelEvaluationMatrix = xlsread(file);
    layerNo = excelEvaluationMatrix(:,1);
    laserTime = excelEvaluationMatrix(:,2);
    maxTemp = excelEvaluationMatrix(:,3);
    minTemp = excelEvaluationMatrix(:,4);

    fileName = [fileName, '.txt'];
    savePath = './Latex/';
    fileID = fopen([savePath fileName],'wt');
    
    b = '\num{';
    c = '\si{\second}';
    d = '\si{\celsius}';
    e = '\\';
    
    i = 1;
    
    while i <= length(layerNo)
        fprintf(fileID, '%s%i} & %s%0.4f} %s & %s%0.4f} %s & %s%0.4f} %s %s \n', b, layerNo(i), b, laserTime(i), c, b, maxTemp(i), d, b, minTemp(i), d, e);
        i = i + 1;
    end
    
    fclose(fileID);
end