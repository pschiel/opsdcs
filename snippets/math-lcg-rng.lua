-- lua math.random is either broken or extremely bad, and offers no seeding
-- this is a basic implementation of LCG RNG

--- Sets the LCG seed
--- @param seed number @optional seed (default: current time in seconds)
function lcg_randomseed(seed)
    lcg_seed = seed or timer.getTime()
    lcg_a = 1664525
    lcg_c = 1013904223
    lcg_m = 4294967296
end

--- Generates a random number between 0 and 1
--- @return number @random number
function lcg_random()
    if lcg_seed == nil then lcg_randomseed() end
    lcg_seed = (lcg_a * lcg_seed + lcg_c) % lcg_m
    return lcg_seed / lcg_m
end
