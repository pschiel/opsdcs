local parameters = {
    fighter = true,
    radar = true,
    ECM = true,
    refueling = true
}
local chunk = utils.loadfileIn("Scripts/UI/RadioCommandDialogPanel/Config/LockOnAirplane.lua", getfenv())
return utils.verifyChunk(chunk)(parameters)
