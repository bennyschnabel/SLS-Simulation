% Function that provides the thermal parameters

function parameter = getThermalParameter()
    % Number of nodes in x direction
    parameter.numberOfNodesInX = 100;
    % Number of nodes in y direction
    parameter.numberOfNodesInY = 100;
    % Number of nodes in z direction
    parameter.numberOfNodesInZ = 40;
    % Length of domain in x direction [m]
    parameter.lengthOfDomainInX = 0.1;
    % Length of domain in y direction [m]
    parameter.lengthOfDomainInY = 0.1;
    % Length of domain in z direction [m]
    parameter.lengthOfDomainInZ = 0.1;
end
