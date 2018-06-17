function rho = density(theta)
    if theta < 184.3
        rho = 700;
    elseif theta >= 184.3
        rho = 1020;
    end
end