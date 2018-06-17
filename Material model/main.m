clc;

%% 
theta = 0 : 0.1 : 250;
cp = heatCapacity(theta);
lambda = heatConductivity(theta);
%rho = density(theta);

%% Plot

xh1 = [0,184.3];
yh1 = [700,700]; % constant

xv = [184.3,184.3]; % constant
yv = [700,1020];

xh2 = [184.3, 250];
yh2 = [1020,1020]; % constant

fig = figure('Name','Dichte');
plot(xh1,yh1,'r',xv,yv,'r',xh2,yh2, 'r', 'LineWidth', 1);
axis([0 250 0 1200]);
xlabel('Temperatur [$^\circ C$]','Interpreter','latex');
ylabel('Dichte [$\frac{kg}{m^3}$]','Interpreter','latex')
grid on;
orient(fig,'landscape');
print(fig,'-bestfit','Dichte','-dpdf','-r0');

fig = figure('Name','Spezifische Wärmekapazität');
plot(theta, cp, 'r', 'LineWidth', 1);
xlabel('Temperatur [$^\circ C$]','Interpreter','latex');
ylabel('Spezifische W\"armekapazit\"at $\left[ \frac{kJ}{kg \cdot K} \right]$','Interpreter','latex')
grid on;
orient(fig,'landscape');
print(fig,'-bestfit','SpezifischeWaermekapazitaet','-dpdf','-r0');

fig = figure('Name','Wärmeleitfähigkeit');
plot(theta, lambda, 'r', 'LineWidth', 1);
xlabel('Temperatur [$^\circ C$]','Interpreter','latex');
ylabel('W\"armeleitf\"ahigkeit [$\frac{W}{m \cdot K}$]','Interpreter','latex');
grid on;
orient(fig,'landscape');
print(fig,'-bestfit','Waermeleitfaehigkeit','-dpdf','-r0');

%{
fig = figure('Name','Materialmodell');
p = uipanel('Parent',fig,'BorderType','none'); 
p.Title = 'Materialmodell'; 
p.TitlePosition = 'centertop'; 
p.FontSize = 12;
p.FontWeight = 'bold';

ax1 = subplot(2,2,1,'Parent',p);
plot(theta, cp, 'r', 'LineWidth', 1);
xlabel('Temperatur [$^\circ C$]','Interpreter','latex');
ylabel('Spezifische W\"armekapazit\"at $\left[ \frac{kJ}{kg \cdot K} \right]$','Interpreter','latex')
grid on;
title('Subplot 1');

ax2 = subplot(2,2,2,'Parent',p);
plot(theta, lambda, 'r', 'LineWidth', 1);
xlabel('Temperatur [$^\circ C$]','Interpreter','latex');
ylabel('W\"armeleitf\"ahigkeit [$\frac{W}{m \cdot K}$]','Interpreter','latex')
grid on;
title('Subplot 1');

ax3 = subplot(2,2,3,'Parent',p);
plot(theta, 4);
xlabel('Temperatur [$^\circ C$]','Interpreter','latex');
ylabel('W\"armeleitf\"ahigkeit [$\frac{W}{m K}$]','Interpreter','latex')
grid on;
title('Subplot 1');

orient(fig,'landscape');
print(fig,'-bestfit','Materialmodell','-dpdf', '-painters');
%}