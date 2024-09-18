local grp = Group.getByName("g1")
local ctrl = grp:getController()
ctrl:setOption(AI.Option.Ground.id.ALARM_STATE, AI.Option.Ground.val.ALARM_STATE.RED)
ctrl:setOption(AI.Option.Ground.id.ROE, AI.Option.Ground.val.ROE.OPEN_FIRE)

local tgt = Unit.findByName("u1")
local pos = tgt:getPoint()
local newTask = {
    id = "FireAtPoint",
    params = {
        x = pos.x,
        y = pos.z,
        expendQty = 3,
        expendQtyEnabled = false,
        weaponType = 52613349374,
        alt_type = 1,
        templateId = "",
        counterbattaryRadius = 0,
        zoneRadius = 0
    }
}
ctrl:setTask(newTask)
