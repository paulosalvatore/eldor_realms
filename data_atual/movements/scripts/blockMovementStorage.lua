local storage = {
	[2901] = {
		storage = 2900,
		valor = 2,
		mensagemErro = "Sua entrada n�o � permitida nesse local."
	},
}

function onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()

	if not player then
		return
	end

	if storage[item.actionid] ~= nil and getPlayerStorageValue(player, storage[item.actionid].storage) ~= storage[item.actionid].valor then
		player:sendCancelMessage(storage[item.actionid].mensagemErro)
	else
		return
	end

	if position.x == fromPosition.x and position.y == fromPosition.y and fromPosition.z == position.z then
		player:teleportarJogador(player:getTown():getTemplePosition(), true)
		return false
	end

	player:teleportTo(fromPosition, true)

	return true
end