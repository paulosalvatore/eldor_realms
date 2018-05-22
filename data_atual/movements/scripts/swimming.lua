local outfit = {lookType = 267, lookHead = 0, lookBody = 0, lookLegs = 0, lookFeet = 0, lookTypeEx = 0, lookAddons = 0}

function onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	if(player:getOutfit().lookType ~= outfit.lookType) then
		player:getPosition():sendMagicEffect(CONST_ME_WATERSPLASH)
		doSetCreatureOutfit(player, outfit, -1)
	end

	player:removerDebuffs()
end

function onStepOut(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	local groundId = Tile(player:getPosition()):getGround():getId()
	if groundId < 4620 or groundId > 4625 then
		player:removeCondition(CONDITION_OUTFIT)
	end
end
