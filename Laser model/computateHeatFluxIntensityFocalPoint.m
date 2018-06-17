function qf = computateHeatFluxIntensityFocalPoint(Q0, r0, lambda, f, r)
    qf = ((3 * Q0 * pi * r0^2)/(lambda^2 * f^2)) * exp(-((3 * r^2) / (r0^2)));
end