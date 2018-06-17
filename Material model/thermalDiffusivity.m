% Modelling, simulation and experimental validation of heat transfer in selective laser melting of the polymeric material PA12
function alpha = thermalDiffusivity(theta)
    alpha = heatConductivity(theta) ./ (heatCapacity(theta) * density(theta));    
end