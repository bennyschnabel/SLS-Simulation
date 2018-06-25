function [fig] = plotMaterialParameter(theta,functionName, labelName)
    % [fig] = plotMaterialParameter(theta,func)
    % 
    % Plotting the material functions
    %
    
    fig = figure();
    plot(theta,functionName,'-k','LineWidth',1.5,'MarkerFaceColor',[0 0 0])
    xlabel('Temperatur °C','FontSize', 12)
    ylabel(labelName,'FontSize', 12)
    grid on
    set(gca,'fontsize',12)
    print(labelName,'-dsvg')