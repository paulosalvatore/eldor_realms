local config = {
	[901] = {1, 5},
	[902] = {2, 6},
	[903] = {3, 7},
	[904] = {4, 8}
}

function onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()

	if not player then
		return
	end

	if config[item.actionid] ~= nil then
		if not isInArray(config[item.actionid], player:getVocation():getId()) then
			player:sendCancelMessage("Voc� precisa ser um " .. Vocation(config[item.actionid][1]):getName() .. " para passar.")
		else
			return
		end
	end

	if position.x == fromPosition.x and position.y == fromPosition.y and fromPosition.z == position.z then
		player:teleportarJogador(player:getTown():getTemplePosition(), true)
		return false
	end

	player:teleportTo(fromPosition, true)
	return true
end