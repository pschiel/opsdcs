-- @todo this does nothing yet, just copy pasted some
local parameters = {
    fighter = true,
    radar = true,
    ECM = true,
    refueling = true
}
local chunk = utils.loadfileIn("Scripts/UI/RadioCommandDialogPanel/Config/LockOnAirplane.lua", getfenv())
return utils.verifyChunk(chunk)(8, parameters) -- menuNumber, parameters

-- data.
--     menus
--     pUnit
--     showingOnlyPresentRecepients
--     rootItem.
--         builders
--     menuOther.
--         submenu.
--             items
