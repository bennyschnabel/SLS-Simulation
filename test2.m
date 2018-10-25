set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
set(groot,'defaultTextInterpreter','latex');

a=voxelMatrix;

fig = figure();

j = 0;
i = 1;
k = 5;
while i <= nx/k
    B = circshift(a,[0 0 -j]);
    [vol_handle] = VoxelPlotter(B,1);
    set(gca,'xlim',[0 nx+2], 'ylim',[0 ny+2], 'zlim',[0 nz+5])
    xlabel('x')
    ylabel('y')
    zlabel('z')
    alpha(1.0)
    az = -37;
    el = 30;
    view(az, el);
    
    orient(fig,'landscape')
    namePDF = ['newDisplaySTLPlot-', num2str(i)];
    print(fig,'-bestfit',namePDF,'-dpdf','-r0')
    i = i + 1;
    j = j + k;
end

B = circshift(a,[0 0 -20]);
[vol_handle] = VoxelPlotter(B,1);
set(gca,'xlim',[0 nx+2], 'ylim',[0 ny+2], 'zlim',[0 nz+2])
xlabel('x')
ylabel('y')
zlabel('z')
alpha(1.0)
az = -37;
el = 30;
view(az, el);

orient(fig,'landscape')
print(fig,'-bestfit','displaySTLPlot-4','-dpdf','-r0')

%{
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
%}