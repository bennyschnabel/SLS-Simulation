clear all; clc;
theta = 0 : 0.01 : 250;
disp(length(theta))
for i = 1 : length(theta)
    rho(i) = computateDensity(theta(i));
    %a = computateHeatConductivity(theta) ./ (rho(i) .* computateHeatCapacity(theta));
    disp(length(theta))
    disp(i)
end

set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
set(groot,'defaultTextInterpreter','latex');

fileName = 'DensityNeu';
labelName = '$\left[ \frac{kg}{m^{3}} \right]$';

fig = figure();
plot(theta,rho,'-k','LineWidth',1.5,'MarkerFaceColor',[0 0 0])
    
xlabel('$\left[ {}^{\circ} C \right]$','Interpreter','latex')
ylabel(labelName,'Interpreter','latex')
ylim([0, rho(end)+100]);
grid on
set(gca,'fontsize',12)
%print(fileName,'-dsvg')
    
orient(fig,'landscape')
print(fig,'-bestfit',fileName,'-dpdf','-r0')