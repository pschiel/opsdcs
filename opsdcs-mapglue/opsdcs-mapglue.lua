OpsdcsMapglue = {
    logging = true,
}

-- net.missionlist_get parse, unique theatres
-- glue borders: lat/lng of maps, must overlap, out of old, in new -> swap
-- function for map switch, grab/replace full unit/group
--    out of old, in new (who in MP?)
--    radio, when possible
--    trigger->function

-- MP:
--   before switch: save oldmap.new, replace in missionlist, remove client/player slot (get data before)
--      replace client/player slots (no wp, just modded position, heading)
--      set time
-- option: time of first mission, or real time

--[[


non-dynamic clients:

1) you put missions in mission list, max 1 per map, e.g.:
   - first.miz (Syria)
   - bla.miz (Iraq)
   - pg.miz (Persian Gulf)

2) to retain originals:
   - all missions altered/saved get prefixed, e.g. glue.first.miz
   - on save, mission list gets adjusted, e.g. first.miz -> glue.first.miz

2) hook detects all used maps in list and creates transitions zones (overlapping)
   - min/max lat/lng editable in script

3) options for transitions:
   - automatic (player)
   - automatic (any client)
   - automatic (specific client)
   - radio menu (when in transition zone)
   - radio menu (debug and for gm, any transition)
   - in ME trigger (via global lua function, any transition)

4) transition logic:
   - save current mission (e.g. glue.first.miz)
   - extract all player/client data from current mission
   - load/unzip target mission, (e.g. bla.miz)
   - optional mission modifications:
     - set mission date to last mission end date
     - set mission date to real time
   - optional player/client modifications (require same unit name over missions):
     - fix position and route coordinates, speed, heading
     - fix payload (pylons, fuel, ammo)
     - remove unit when dead
   - save mission with prefix, e.g. "glue.bla.miz", and replace in mission list
   - run target mission

dynamic clients:

- save is still needed for time

Bug: dynamic spawn clients are saved as Rookie npc
Fix: don't save group ids >= 1.000.000

Bug: spawned units via coalition.addGroup don't keep unit/group names
Workaround: remove all generic named units, custom respawn npcs (have spawn code already)


workarounds:
- on load, destroy all units > 1.000.000
- unit ids are correctly saved -> dont use names

 --]]

function OpsdcsMapglue:log(message, ...)
    if self.logging then
        log.info("[opsdcs-mapglue] " .. string.format(message, ...))
    end
end

function OpsdcsMapglue:onMissionLoadEnd()
    local missionName = DCS.getMissionName()
    self:log("onMissionLoadEnd: %s", missionName)
    dofile([[E:\Work\dcs\opsdcs\opsdcs-mapglue\temp.lua]])
end

DCS.setUserCallbacks({ 
    onSimulationStart = function() end,
    onSimulationStop = function() end,
    onSimulationFrame = function() end,
    onSimulationPause = function() end,
    onSimulationResume = function() end,
    onMissionLoadBegin = function() end,
    onMissionLoadEnd = function() OpsdcsMapglue:onMissionLoadEnd() end,
    onPlayerConnect = function(id) end,
    onPlayerDisconnect = function(id) end,
    onPlayerStart = function(id) end,
    onPlayerStop = function(id) end,
    onPlayerChangeSlot = function(id) end,
    onPlayerTryConnect = function(addr, ucid, name, id) end,
    onPlayerTrySendChat = function(id, message, all) end,
    onPlayerTryChangeSlot = function(id, side, slot) end,
    onGameEvent = function(a, b, c, d, e) end,
    onShowBriefing = function() end,
    onShowGameMenu = function() end,
    onTriggerMessage = function(message, duration, clearView) end,
    onRadioMessage = function(message, duration) end,
    onChatMessage = function(message, id) end,
    onShowRadioMenu = function(id) end,
    onNetConnect = function(id) end,
    onNetDisconnect = function() end,
    onNetMissionChanged = function(missionName) end,
    onActivatePlane = function(a, b, c, d, e) end,
    onATCClientStatusUpdated = function() end,
})
