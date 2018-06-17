% Modelling, simulation and experimental validation of heat transfer in selective laser melting of the polymeric material PA12
function lambda = heatConductivity(theta)
    lambda = 0.078 + (0.23 ./ (1 + 10.^(20 - 0.12 * theta)));
end