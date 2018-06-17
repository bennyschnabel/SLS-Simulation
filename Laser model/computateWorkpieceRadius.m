function rw = computateWorkpieceRadius(f, r0, rf, a)
    rw = (f * rf + a * (r0 - rf)) / f;
end