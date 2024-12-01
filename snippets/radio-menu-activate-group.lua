-- basic radio menu command example, activates a group and removes the command again

function someCommandCallback()
    trigger.action.activateGroup(Group.getByName("Aerial-2"))
    missionCommands.removeItem(myMenuitem)
end

myMenuitem = missionCommands.addCommand("Activate group", nil, someCommandCallback)
