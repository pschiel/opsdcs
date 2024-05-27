-- Timer display
--
-- works on zone names "race-start" and "race-end"
-- sets user flags "race-started" and "race-ended", available in ME
--
-- example to access final time in ME:
--  condition: FLAG IS TRUE("race-ended")
--  action: DO SCRIPT: trigger.action.outText("Race ended, final time: " .. getTimeString(finalTime), 20, true)

-- configuration
timeDelta = 0.001                      -- time delta for the schedule function
startZoneName = "race-start"           -- name of the start zone
endZoneName = "race-end"               -- name of the finish zone
checkpointPrefix = "race-checkpoint-"  -- prefix of the checkpoint zones
blinkMsgSeconds = 5                    -- blink message duration
showSmokeMarkers = true                -- show smoke markers in start/end zones and checkpoints

-- all globals for easy access in ME
startTime = nil
raceIsRunning = false
startZone = trigger.misc.getZone(startZoneName)
endZone = trigger.misc.getZone(endZoneName)
player = world.getPlayer()
lastCheckpoint = 0
lastCheckpointTime = nil
numCheckpoints = 1

-- show smoke in start/end zones and checkpoints
function showSmoke()
    -- start/end red
    startZone.point.y = land.getHeight({x = startZone.point.x, y = startZone.point.z})
    endZone.point.y = land.getHeight({x = endZone.point.x, y = endZone.point.z})
    trigger.action.smoke(startZone.point, trigger.smokeColor.Red)
    trigger.action.smoke(endZone.point, trigger.smokeColor.Red)
    -- checkpoints green
    for _, zone in pairs(env.mission.triggers.zones) do
        if string.sub(zone.name, 1, string.len(checkpointPrefix)) == checkpointPrefix then
            local y = land.getHeight({x = zone.x, y = zone.y})
            trigger.action.smoke({x = zone.x, y = y, z = zone.y}, trigger.smokeColor.Green)
            numCheckpoints = numCheckpoints + 1
        end
    end
end
 
-- fancy format display
function getTimeString(time)
    local minutes = math.floor(time / 60)
    local seconds = math.floor(time % 60)
    local milliseconds = (time * 1000) % 1000
    local str = string.format("%02d:%02d:%03d", minutes, seconds, milliseconds)  
    return str
end

-- scheduled timer function
function raceTimer()
    local playerPos = player:getPoint()
    local playerInStartZone = (playerPos.x - startZone.point.x)^2 + (playerPos.z - startZone.point.z)^2 < startZone.radius^2
    local playerInEndZone = (playerPos.x - endZone.point.x)^2 + (playerPos.z - endZone.point.z)^2 < endZone.radius^2
    local playerInNextCheckpointZone = false
    local nextCheckpointZone = trigger.misc.getZone(checkpointPrefix .. (lastCheckpoint + 1))
    if nextCheckpointZone ~= nil then
        if (playerPos.x - nextCheckpointZone.point.x)^2 + (playerPos.z - nextCheckpointZone.point.z)^2 < nextCheckpointZone.radius^2 then
            playerInNextCheckpointZone = true
        end
    end

    -- passed checkpoint
    if playerInNextCheckpointZone then
        lastCheckpoint = lastCheckpoint + 1
        lastCheckpointTime = timer.getTime()
    end

    -- race started
    if not raceIsRunning and playerInStartZone then
        raceIsRunning = true
        startTime = timer.getTime()
        trigger.action.setUserFlag("race-started", 1)
        lastCheckpoint = 0
        lastCheckpointTime = startTime
    end

    -- race ended
    if raceIsRunning and playerInEndZone then
        raceIsRunning = false
        finalTime = timer.getTime() - startTime
        trigger.action.setUserFlag("race-ended", 1)
        trigger.action.outText("Total time:    " .. getTimeString(finalTime), 20, true)
        trigger.action.outText("Checkpoint:  " .. getTimeString(finalTime) .. "  [" .. numCheckpoints .. "/" .. numCheckpoints .. "]", 20)
        trigger.action.outText("RACE ENDED", 20)
    end

    -- display
    if raceIsRunning then
        -- line 1: total time
        local line1 = "Total time:    " .. getTimeString(timer.getTime() - startTime)
        -- line 2: checkpoint time
        local line2 = " "
        if lastCheckpoint > 0 then
            line2 = "Checkpoint:  " .. getTimeString(lastCheckpointTime - startTime) .. "  [" .. lastCheckpoint .. "/" .. numCheckpoints .. "]"
        end
        -- line 3: blinking message
        local line3 = " "
        local msSinceCheckpoint = (timer.getTime() - lastCheckpointTime) * 1000
        if msSinceCheckpoint < blinkMsgSeconds * 1000 and msSinceCheckpoint % 1000 < 500 then
            if lastCheckpoint == 0 then
                line3 = "RACE STARTED"
            else
                line3 = "CHECKPOINT " .. lastCheckpoint .. " REACHED"
            end
        end
        trigger.action.outText(line1, 20, true)
        trigger.action.outText(line2, 20)
        trigger.action.outText(line3, 20)
    end

    timer.scheduleFunction(raceTimer, {}, timer.getTime() + timeDelta)
end

if showSmokeMarkers then
    showSmoke()
end
timer.scheduleFunction(raceTimer, {}, timer.getTime() + timeDelta)
