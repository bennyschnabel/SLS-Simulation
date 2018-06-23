function [e] = plotev(n)
    %  [e] = plotev(n)
    %
    %  This function computes the eigenvalues (e) of 
    %  the matrix and plots them in the complex plane.
    %
    % http://www.cps.brockport.edu/~little/matsys/node21.html
    %
    
    e = eig(n);    % Get the eigenvalues of A
    
    close all    % Closes all currently open figures.
    
    figure(1)
    plot(real(e),imag(e),'r*') %   Plot real and imaginary parts
    xlabel('Real')
    ylabel('Imaginary')
    grid on
    t1 = ['Eigenvalues of a matrix'];% num2str(n)];
    title(t1);