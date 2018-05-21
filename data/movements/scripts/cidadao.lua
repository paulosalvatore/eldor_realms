function onStepIn(player, item, position, fromPosition)
	local cidade = Town(item:getActionId() - 4000)
	player:setTown(cidade)
	player:teleportarJogador(cidade:getTemplePosition(), true)
	player:sendTextMessage(MESSAGE_INFO_DESCR, "Voc� se tornou cidad�o de " .. formatarNomeCidade(cidade:getName()) .. ".")
end