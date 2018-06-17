function q0 = computateHeatFluxIntensityLense(Q0, r0, r)
    q0 = ((3 * Q0)/(pi * r0^2)) * exp(-((3 * r^2) / (r0^2)));
end