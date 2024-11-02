function lcg_randomseed(seed)
    lcg_seed = seed or timer.getTime()
    lcg_a = 1664525
    lcg_c = 1013904223
    lcg_m = 2^32
end

function lcg_random()
    lcg_seed = (lcg_a * lcg_seed + lcg_c) % lcg_m
    return lcg_seed / lcg_m
end
