function [U, ht] = explizites_euler_verfahren(A, b, T, U0, M, Alpha, hx)
% Berechnet eine Approximation der Waermeleitungsgleichung
% mittels explizitem Euler-Verfahren (Satz 10.3).

% Definiere die Zeit-Schrittweite ht
ht = hx ^ 2 / (2 * Alpha);

U = U0;
U(1) = 0;
U(end) = 0;

I = eye(length(A));

for m = 1 : M
    U0 = (I - ht * A) * U0 + ht * b;
    U = [U U0];
end

end % end function explizites_euler_verfahren