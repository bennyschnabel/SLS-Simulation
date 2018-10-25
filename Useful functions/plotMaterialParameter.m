function [fig] = plotMaterialParameter(theta, functionName, labelName, fileName)
    % [fig] = plotMaterialParameter(theta, functionName, labelName, fileName)
    % 
    % Plotting the material functions
    %
    
    set(groot, 'defaultAxesTickLabelInterpreter','latex');
    set(groot, 'defaultLegendInterpreter','latex');
    set(groot,'defaultTextInterpreter','latex');
    
    fig = figure();
    plot(theta,functionName,'-k','LineWidth',1.5,'MarkerFaceColor',[0 0 0])
    
    xlabel('$\left[ {}^{\circ} C \right]$','Interpreter','latex')
    ylabel(labelName,'Interpreter','latex')
    grid on
    set(gca,'fontsize',12)
    print(fileName,'-dsvg')
    
    orient(fig,'landscape')
    print(fig,'-bestfit',fileName,'-dpdf','-r0')