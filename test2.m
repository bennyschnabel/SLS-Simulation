filename = 'AuswertungSimulationTeil2Nodes50.xlsx';
A = xlsread(filename);
layerNo = A(:,1);
laserTime = A(:,2);
maxTemp = A(:,3);
minTemp = A(:,4);

set(groot, 'defaultAxesTickLabelInterpreter','latex'); set(groot, 'defaultLegendInterpreter','latex');

fig = figure;
left_color = [0 0 0];
right_color = [0 0 0];
set(fig,'defaultAxesColorOrder',[left_color; right_color]);
hold on;

xlabel('Layer no')
yyaxis left
ylabel('Temperature [°C]')
plot(layerNo, maxTemp, layerNo, minTemp, '--')

yyaxis right
ylabel('Time [s]')
plot(layerNo, laserTime, ':')
legend('Maximum temperature','Minimum temperature','Laser exposure time','Location','northwest')
hold off;