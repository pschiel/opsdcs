local function landedAndNearFriendlyAirbase(unitName)
	local unit = Unit.getByName(unitName)
	if unit == nil then return false end
	if not unit:isExist() then return false end
    if not unit:inAir() then return false end

	local airbases = coalition.getAirbases(unit:getCoalition())
    for _, airbase in next, airbases do
        if distanceVec3(airbase:getPoint(), unit:getPoint()) < recon.returnDistance then
            return true
        end
    end

	return false
end
