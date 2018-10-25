%set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
%set(groot,'defaultTextInterpreter','latex');


fileName1 = '2018-09-19-18-00-12-Teil2';
fileType = '.xlsx';
file1 = [fileName1, fileType];
A = xlsread(file1);
layerNo = A(:,1);
maxTemp1 = A(:,3);

fileName2 = '2018-09-19-18-12-14-Teil2';
file2 = [fileName2, fileType];
B = xlsread(file2);
maxTemp2 = B(:,3);

fileName3 = '2018-09-19-18-23-08-Teil2';
file3 = [fileName3, fileType];
B = xlsread(file3);
maxTemp3 = B(:,3);

fig = figure;
set(0,'DefaultLineLineWidth',1)
set(0, 'defaultLegendInterpreter','latex')
set(0,'defaultTextInterpreter','latex')
set(0, 'defaultAxesTickLabelInterpreter','latex');
plot(layerNo, maxTemp1 ,'-k' ,layerNo ,maxTemp2, '--k', layerNo, maxTemp3, ':k')
xlabel('Layer no','Interpreter','latex')
ylabel('Temperature ${}^{\circ} C$','Interpreter','latex')
legend('v = 3,0 $\frac{m}{s}$','v = 1,0 $\frac{m}{s}$','v = 0,1 $\frac{m}{s}$','Location','Best')
grid on;

orient(fig, 'landscape')
print(fig,'-bestfit', 'ComparisonOfSpeed', '-dpdf', '-r0')