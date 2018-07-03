clc; clear all;
% Definiere xmin, xmax, Alpha, u0, T
xmin = 0;
xmax = 1;
Alpha = 1;
u0 = @(x) exp(-50 * (x - 0.5) .^ 2);
T = 0.1;

% Definiere N, M
N = 99;
M = 10;

% Berechne die semidiskrete Formulierung
[A, b, U0, x, hx] = semidiskrete_formulierung(xmin, xmax, Alpha, u0, N);

% Berechne die Approximation U
U = explizites_euler_verfahren(A, b, T, U0, M, Alpha, hx);

% Plot 
for m = 1 : M
    figure(1),
    plot(x, [0; U(:, m); 0], '-or')
    legend('u_0', 'U^m')
    titlePlot = ['Elapsed time: ' num2str(T / m) ' s'];
    title(titlePlot);
    %xlim([-1, 1])
    %ylim([0, 1])
    pause(0.1)
end
