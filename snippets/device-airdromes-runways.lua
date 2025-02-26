local terrain = require("terrain")
local airdromes = get_terrain_related_data("Airdromes")
for _, airdrome in pairs(airdromes) do
    -- airdrome.id
    -- airdrome.code
    -- airdrome.display_name
    -- airdrome.reference_point.x
    -- airdrome.reference_point.y
    -- airdrome.reference_point_geo.lat
    -- airdrome.reference_point_geo.lon
    -- airdrome.roadnet
    for _, beacon in pairs(airdrome.beacons) do
        -- beacon.beaconId
        -- beacon.runwayId
        -- beacon.runwayName
        -- beacon.runwaySide
    end
    local runways = terrain.getRunwayList(airdrome.roadnet)
    for _, runway in pairs(runways) do
        -- runway.course
        -- runway.edge1name
        -- runway.edge1x
        -- runway.edge1y
        -- runway.edge2name
        -- runway.edge2x
        -- runway.edge2y
    end
end
