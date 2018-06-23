clc;

%% 
theta = 0 : 0.1 : 250;
cp = heatCapacity(theta) * 10^-3;
lambda = heatConductivity(theta);
theta1 = 0 : 0.001 : 184.2;
a1 = thermalDiffusivity(theta1);
theta2 = 184.4 : 0.001 : 250;
a2 = thermalDiffusivity(theta2);

%% heatCapacity
fig = figure();
plot(theta,cp,'-k','LineWidth',1.5,...
    'MarkerFaceColor',[0 0 0]);
grid on;
xlabel('Temperatur GC','FontSize', 12);
ylabel('Spezifische Wärmekapazität KG K','FontSize', 12);
set(gca,'fontsize',12);
xlim([0 250]);
ylim([0 22]);
print('heatCapacity','-dsvg');

%% heatConductivity
fig = figure();
plot(theta,lambda,'-k','LineWidth',1.5,...
    'MarkerFaceColor',[0 0 0]);
grid on;
xlabel('Temperatur GC','FontSize', 12);
ylabel('Spezifische Wärmekapazität KG K','FontSize', 12);
set(gca,'fontsize',12);
xlim([0 250]);
ylim([0 0.35]);
print('heatConductivity','-dsvg');

%% density
fig = figure();
xh1 = [0,184.3];
yh1 = [700,700]; % constant

xv = [184.3,184.3]; % constant
yv = [700,1020];

xh2 = [184.3, 250];
yh2 = [1020,1020]; % constant
plot(xh1,yh1,'-k',xv,yv,'-k',xh2,yh2,'-k','LineWidth',1.5,...
    'MarkerFaceColor',[0 0 0]);
grid on;
xlabel('Temperatur GC','FontSize', 12);
ylabel('Spezifische Wärmekapazität KG K','FontSize', 12);
set(gca,'fontsize',12);
xlim([0 250]);
ylim([0 1100]);
print('density','-dsvg');

%% thermalDiffusivity
fig = figure();
plot(theta1,a1,'-k','LineWidth',1.5,...
    'MarkerFaceColor',[0 0 0]);
hold on;
plot(184.3,thermalDiffusivity(184.3),'-k','LineWidth',1.5,...
    'MarkerFaceColor',[0 0 0]);
hold on;
plot(theta2,a2,'-k','LineWidth',1.5,...
    'MarkerFaceColor',[0 0 0]);
hold off;
grid on;
xlabel('Temperatur GC','FontSize', 12);
ylabel('Spezifische Wärmekapazität KG K','FontSize', 12);
set(gca,'fontsize',12);
xlim([0 250]);
ylim([0 0.2*10^-6]);
print('thermalDiffusivity','-dsvg');

%% Plot
%{
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

%}