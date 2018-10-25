clear all; clc;
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
set(groot,'defaultTextInterpreter','latex');
fileName = 'Teil2-2018-09-18-09-55-11';
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
ylabel('Temperature [C]','interpreter','latex')
plot(layerNo, maxTemp, layerNo, minTemp, '--')

yyaxis right
ylabel('Time [s]')
plot(layerNo, laserTime, ':')
legend('Maximum temperature','Minimum temperature','Laser exposure time','Location','northeast')
grid on;
hold off;

fileName = fileName(~isspace(fileName));
orient(fig,'landscape')
print(fig,'-bestfit',fileName,'-dpdf','-r0')