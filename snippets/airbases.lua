local a = Airbase.getByName("Beirut-Rafic Hariri")

-- list of: fDistToRW, Term_Index, Term_Index_0, Term_Type, TO_AC (false=available), vTerminalPos (pos)
local p = a:getParking()
-- * AIRBASE.TerminalType.Runway = 16: Valid spawn points on runway.
-- * AIRBASE.TerminalType.HelicopterOnly = 40: Special spots for Helicopers.
-- * AIRBASE.TerminalType.Shelter = 68: Hardened Air Shelter. Currently only on Caucaus map.
-- * AIRBASE.TerminalType.OpenMed = 72: Open/Shelter air airplane only.
-- * AIRBASE.TerminalType.OpenBig = 104: Open air spawn points. Generally larger but does not guarantee large aircraft are capable of spawning there.
-- * AIRBASE.TerminalType.OpenMedOrBig = 176: Combines OpenMed and OpenBig spots.
-- * AIRBASE.TerminalType.HelicopterUsable = 216: Combines HelicopterOnly, OpenMed and OpenBig.
-- * AIRBASE.TerminalType.FighterAircraft = 244: Combines Shelter. OpenMed and OpenBig spots. So effectively all spots usable by fixed wing aircraft.

local pa = a:getParking(true)
-- pos
local dtp = a:getDispatcherTowerPos()
trigger.action.smoke(dtp.pos, trigger.smokeColor.White)
-- ?
local n = a:getNearest():getName()
-- list of: course, length, Name, position, width
local r = a:getRunways()

for i = 1, #p do
    local c
    if p[i].fDistToRW == 0 then
        c = trigger.smokeColor.Blue
    elseif p[i].TO_AC == false then
        c = trigger.smokeColor.Red
    else
        c = trigger.smokeColor.Green
    end
    trigger.action.smoke(p[i].vTerminalPos, c)
end

return { a, p, dtp, n, r }