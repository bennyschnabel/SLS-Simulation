function [A, b, U0, x, hx] = semidiskrete_formulierung(xmin, xmax, Alpha, u0, N)
% Berechnet die semidiskrete Ortsdiskretisierung von Beispiel 10.5

if ~isequal(size(xmin), [1 1]) || ~isequal(size(xmax), [1 1]) || xmin >= xmax
    error('[xmin, xmax] muss ein Intervall sein')
end

if ~isequal(size(Alpha), [1 1])
    error('Alpha muss eine 1 x 1 Matrix sein')
end

if ~isa(u0, 'function_handle') || nargin(u0) ~= 1
    error('u0 muss eine Funktion u0 = @(x) ... sein')
end

if ~isequal(size(N), [1 1]) || N <= 0
    error('N muss eine nat. Zahl sein')
end

% Definiere die Orts-Schrittweite hx
hx = (xmax - xmin) / (N + 1);

% Definiere die Punkte x in [xmin, xmax]
x = xmin + (0 : N + 1) * hx;

% Definiere die Matrix A
A = Alpha / hx ^ 2  * (diag(2 * ones(N, 1)) - diag(ones(N - 1, 1), 1) - diag(ones(N - 1, 1), -1));

% Definiere den Vektor b
b = zeros(N, 1);

% Definiere den Startvektor U0 in den inneren Punkten x(2), ..., x(N + 1)
U0 = u0(x(2 : end - 1))';

end % end function semidiskrete_formulierung