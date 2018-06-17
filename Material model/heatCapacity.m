% Modelling, simulation and experimental validation of heat transfer in selective laser melting of the polymeric material PA12
function c = heatCapacity(theta)
    c = 2.650 + (109 ./ (4 * (theta - 184.3).^2 + 5.97));
    c = c * 10^3;
end