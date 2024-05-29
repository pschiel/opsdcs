-- Race Timer and Altitude Scoring
--
-- works on zone names "race-start" and "race-end"
-- sets user flags "race-started" and "race-ended", available in ME
--
-- example to access final time in ME:
--  condition: FLAG IS TRUE("race-ended")
--  action: DO SCRIPT: trigger.action.outText("Race ended, final time: " .. getTimeString(finalTime), 20, true)

-- configuration
timeDelta = 0.01                       -- time delta for the schedule function
startZoneName = "race-start"           -- name of the start zone
endZoneName = "race-end"               -- name of the finish zone
checkpointPrefix = "race-checkpoint-"  -- prefix of the checkpoint zones
blinkMsgSeconds = 5                    -- blink message duration
showSmokeMarkers = true                -- show smoke markers in start/end zones and checkpoints
targetTime = 240                       -- target time in seconds: for balancing time/altitude
maxScoreAltitude = 800                 -- max altitude for score points: 1000 points per second at ground, reduced to 0 at this altitude
                                       -- e.g. if race time is ~100 seconds, you can get max. 100k points (50k at half this altitude)
scorePerSecond = 2000                  -- score per second under targetTime (becomes a penalty over targetTime)
                                       -- should be higher than 1000 (what you can get maximum from altitude per second)

-- all globals for easy access in ME
startTime = nil
raceIsRunning = false
startZone = trigger.misc.getZone(startZoneName)
endZone = trigger.misc.getZone(endZoneName)
lastCheckpoint = 0
lastCheckpointTime = nil
numCheckpoints = 1
player = nil
score = 0

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
            local y = land.getHeight({x = zone.x, y = zone.y}) + 10
            trigger.action.smoke({x = zone.x, y = y, z = zone.y}, trigger.smokeColor.Green)
            numCheckpoints = numCheckpoints + 1
        end
    end
end
 
-- fancy format display
function getTimeString(time)
    local minutes = math.floor(time / 60)
    local seconds = math.floor(time % 60)
    local milliseconds = (time * 100) % 100
    local str = string.format("%02d:%02d:%02d", minutes, seconds, milliseconds)  
    return str
end

-- scheduled timer function
rtTime = timer.getTime()
function raceTimer()
    local playersBlue = coalition.getPlayers(coalition.side.BLUE)
    local playersRed = coalition.getPlayers(coalition.side.RED)
    if #playersBlue > 0 then
        player = playersBlue[1]
    else
        if #playersRed > 0 then
            player = playersRed[1]
        else
            -- no players, check 1 sec later
            timer.scheduleFunction(raceTimer, {}, timer.getTime() + 1)
            return
        end
    end

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
        trigger.action.outSound("sounds/race-checkpoint-" .. lastCheckpoint .. ".ogg")
    end

    -- race started
    if not raceIsRunning and playerInStartZone then
        raceIsRunning = true
        startTime = timer.getTime()
        trigger.action.setUserFlag("race-started", 1)
        lastCheckpoint = 0
        lastCheckpointTime = startTime
        trigger.action.outSound("sounds/race-start.ogg")
    end

    -- race ended
    if raceIsRunning and playerInEndZone then
        lastCheckpoint = lastCheckpoint + 1
        raceIsRunning = false
        finalTime = timer.getTime() - startTime
        trigger.action.setUserFlag("race-ended", 1)
        trigger.action.outText("Total time:    " .. getTimeString(finalTime), 30, true)
        trigger.action.outText("Checkpoint:  " .. getTimeString(finalTime) .. "  [" .. lastCheckpoint .. "/" .. numCheckpoints .. "]", 30)
        trigger.action.outText("RACE ENDED", 30)
        trigger.action.outText("ALTITUDE SCORE:  " .. string.format("%08d", score), 30)
        -- time bonus/penalty
        local timeScore = math.floor(targetTime - finalTime) * scorePerSecond
        score = math.max(score + timeScore, 0)
        -- not all checkpoints, race invalid
        trigger.action.outText("TIME SCORE:  " .. string.format("%08d", timeScore), 30)
        trigger.action.outText(" ", 30)
        if lastCheckpoint < numCheckpoints then
            score = 0
            trigger.action.outText("TOTAL SCORE:  " .. string.format("%08d", score) .. "  [CHECKPOINTS FAILED]", 30)            
        else
            trigger.action.outText("TOTAL SCORE:  " .. string.format("%08d", score), 30)            
        end
        -- not yet
        local ucid = net.get_player_info(tonumber(player:getID()), 'ucid')
        if ucid ~= nil then
            trigger.action.outText("Uploading score, UCID " .. ucid .. "  ... soon(tm)", 30)
        end
        trigger.action.outSound("sounds/race-end.ogg", 0)
    end

    -- display
    if raceIsRunning then
        -- line 1: total time
        local lineTotal = "Total time:    " .. getTimeString(timer.getTime() - startTime)
        -- line 2: checkpoint time
        local lineCheckpointTime = " "
        if lastCheckpoint > 0 then
            lineCheckpointTime = "Checkpoint:  " .. getTimeString(lastCheckpointTime - startTime) .. "  [" .. lastCheckpoint .. "/" .. numCheckpoints .. "]"
        end
        -- line 3: altitude
        local pos = player:getPoint()
        local altPlayer = pos.y
        local altGround = land.getHeight({x = pos.x , y = pos.z})
        local alt = math.floor((altPlayer - altGround) * 3.28084)
        local lineAltitude = "Altitude:  " .. string.format("%04d", alt) .. " ft  [Target: < " .. maxScoreAltitude .. "]"
        -- line 4: points per altitude: delta time based, with penalty for altitude (max penalty at maxScoreAltitude)
        local msPassed = (timer.getTime() - rtTime) * 1000
        if alt < maxScoreAltitude then
            score = score + math.floor(msPassed * (maxScoreAltitude - alt) / maxScoreAltitude)
        end
        local lineScore = "Score:  " .. string.format("%08d", score)
        
        -- line 4: blinking message
        local lineBlinkMsg = " "
        local msSinceCheckpoint = (timer.getTime() - lastCheckpointTime) * 1000
        if msSinceCheckpoint < blinkMsgSeconds * 1000 and msSinceCheckpoint % 1000 < 500 then
            if lastCheckpoint == 0 then
                lineBlinkMsg = "RACE STARTED"
            else
                lineBlinkMsg = "CHECKPOINT " .. lastCheckpoint .. " REACHED"
            end
        end
        trigger.action.outText(lineTotal, 20, true)
        trigger.action.outText(lineCheckpointTime, 20)
        trigger.action.outText(lineAltitude, 20)
        trigger.action.outText(lineScore, 20)
        trigger.action.outText(lineBlinkMsg, 20)
    end

    rtTime = timer.getTime()
    timer.scheduleFunction(raceTimer, {}, timer.getTime() + timeDelta)
end

if showSmokeMarkers then
    showSmoke()
end
timer.scheduleFunction(raceTimer, {}, timer.getTime() + timeDelta)
