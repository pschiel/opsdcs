local myData = {
	currentMissionName = ""
}

local exampleHook = {}

function exampleHook.onPlayerConnect(playerId)
	local playerName = net.get_player_info(playerId, 'name')
	local message = 'helo ' .. playerName .. ' current mission: ' .. myData.currentMissionName
	net.send_chat_to(message, playerId)
end

function exampleHook.onMissionLoadBegin()
	myData.currentMissionName = DCS.getMissionName()
end

DCS.setUserCallbacks(exampleHook)
