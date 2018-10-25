clc;
[m, n] = size(videoTemp);
[o, p, q] = size(videoTemp{1});
tempSchicht = zeros(o,p,q);

for i = 1 : szX
    for j = 1 : szY
        for k = 1 : szZ
            tempSchicht(i,j,k) = NaN;
        end
    end
end


i = 1;
j = 0;
%Temp = videoTemp{i};
%tempSchicht(:,:,i) = Temp(:,:,n);
%[plot] = plotSimulation(tempSchicht, x, y, z, xSliced, ySliced, zSliced, region, savePath, fileDate, i, stlName);

while i <= n
    Temp = videoTemp{i};
    tempSchicht(:,:,1:i) = Temp(:,:,n+2-j:n+2);
    disp(i);
    [plot] = plotSimulation(tempSchicht, x, y, z, xSliced, ySliced, zSliced, region, savePath, fileDate, i, stlName);
    i = i + 1;
    j = j + 1;
end

%% Combine PDFs into one

pdfToCombine = cell(1,n);

for j = 1 : n
    fileName2 = ['T', '-Layer', num2str(j)];
    singlePDF = [fileName2, '.pdf'];
    pdfToCombine{j} = singlePDF;
end

combinedPDF = [fileDate, '-Video-PDF', num2str(j), '.pdf'];
append_pdfs(combinedPDF, pdfToCombine{:});

for j = 1 : nx
    delete(pdfToCombine{j})
end
%}