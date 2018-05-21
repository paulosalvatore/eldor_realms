function Player:onBrowseField(position)
	return true
end

function Player:onLook(thing, position, distance)
	local utf8 = require("data/lib/utf8")
	local description = utf8.convert("You see " .. thing:getDescription(distance))

	if LOOK_MARRIAGE_DESCR and thing:isCreature() then
		if thing:isPlayer() then
			description = description .. self:pegarDescricaoCasamento(thing)
		end
	end

	if thing:isItem() and thing:getActionId() == 2900 then
		description = "You see Julia.\n"
		if(self:getStorageValue(2900) == 2) then
			description = description.."She's resting now."
		else
			description = description.."Seems like she's sick."
		end
	elseif thing:isItem() and thing:getActionId() == 3200 and (thing.itemid == 7787 or thing.itemid == 7788) then
		description =  "You see a bed.\nJefrey is sleeping there."
	end

	if self:getGroup():getAccess() then
		if thing:isItem() then
			description = string.format("%s\nItem ID: %d", description, thing:getId())

			local actionId = thing:getActionId()
			if actionId ~= 0 then
				description = string.format("%s, Action ID: %d", description, actionId)
			end

			local uniqueId = thing:getAttribute(ITEM_ATTRIBUTE_UNIQUEID)
			if uniqueId > 0 and uniqueId < 65536 then
				description = string.format("%s, Unique ID: %d", description, uniqueId)
			end

			local itemType = thing:getType()

			local transformEquipId = itemType:getTransformEquipId()
			local transformDeEquipId = itemType:getTransformDeEquipId()
			if transformEquipId ~= 0 then
				description = string.format("%s\nTransforms to: %d (onEquip).", description, transformEquipId)
			elseif transformDeEquipId ~= 0 then
				description = string.format("%s\nTransforms to: %d (onDeEquip).", description, transformDeEquipId)
			end

			local decayId = itemType:getDecayId()
			if decayId ~= -1 then
				description = string.format("%s\nDecay to: %d", description, decayId)
			end
		elseif thing:isCreature() then
			local str = "%s\nHealth: %d / %d"
			if thing:getMaxMana() > 0 then
				str = string.format("%s, Mana: %d / %d", str, thing:getMana(), thing:getMaxMana())
			end
			description = string.format(str, description, thing:getHealth(), thing:getMaxHealth()) .. "."
		end

		local position = thing:getPosition()
		description = string.format(
			"%s\nPosition: %d, %d, %d.",
			description, position.x, position.y, position.z
		)

		if thing:isCreature() then
			if thing:isPlayer() then
				description = string.format("%s\nIP: %s.", description, Game.convertIpToString(thing:getIp()))
			end
		end
	end
	self:sendTextMessage(MESSAGE_INFO_DESCR, description)
end

function Player:onLookInBattleList(creature, distance)
	local description = "You see " .. creature:getDescription(distance)
	if self:getGroup():getAccess() then
		local str = "%s\nHealth: %d / %d"
		if creature:getMaxMana() > 0 then
			str = string.format("%s, Mana: %d / %d", str, creature:getMana(), creature:getMaxMana())
		end
		description = string.format(str, description, creature:getHealth(), creature:getMaxHealth()) .. "."

		local position = creature:getPosition()
		description = string.format(
			"%s\nPosition: %d, %d, %d.",
			description, position.x, position.y, position.z
		)

		if creature:isPlayer() then
			description = string.format("%s\nIP: %s.", description, Game.convertIpToString(creature:getIp()))
		end
	end
	self:sendTextMessage(MESSAGE_INFO_DESCR, description)
end

function Player:onLookInTrade(partner, item, distance)
	self:sendTextMessage(MESSAGE_INFO_DESCR, "You see " .. item:getDescription(distance))
end

function Player:onLookInShop(itemType, count)
	local modificarItemPeso = modificarItensPeso[itemType:getId()]

	if modificarItemPeso then
		local peso = modificarItemPeso

		if peso == 0 then
			peso = itemType:getWeight()
		end

		local description = "You see " .. itemType:getArticle() .. " " .. itemType:getName() .. ".\nIt weighs " .. formatarPeso(peso) .. "."
		self:sendTextMessage(MESSAGE_INFO_DESCR, description)
		return false
	end

	return true
end

function Player:onMoveItem(item, count, fromPosition, toPosition, fromCylinder, toCylinder)
	local tile = Tile(toPosition)

	if tile and tile:getHouse() ~= nil then
		if tile:getItemCount() == 9 then
			self:sendCancelMessage("N�o � poss�vel adicionar mais itens a esse local.")

			return false
		else
			local peso = item:getWeight()
			local pesoMaximo = 1500000
			local itens = tile:getItems()

			if itens then
				for i = 1, #itens do
					peso = peso + itens[i]:getWeight()
				end
			end

			if peso > pesoMaximo then
				self:sendCancelMessage("N�o � poss�vel adicionar mais itens a esse local.")

				return false
			end
		end
	end

	local verificarItem = false
	if isInArray(itensMovimentoDesativado, item:getActionId()) then
		verificarItem = true
	elseif item:isContainer() then
		for k, actionId in pairs(itensMovimentoDesativado) do
			if #item:getAllItemsByAction(false, actionId) > 0 then
				verificarItem = true
			end
		end
	end

	local movimentoBloqueado = false
	if verificarItem then
		movimentoBloqueado = true
		if fromPosition.x == CONTAINER_POSITION and toPosition.x == CONTAINER_POSITION then
			if toCylinder:isItem() then
				if item:getTopParent() == toCylinder:getTopParent() then
					movimentoBloqueado = false
				end
			end
		end
	end

	if toPosition.x == CONTAINER_POSITION then
		local containerId = toPosition.y - 64
		local container = self:getContainerById(containerId)
		if not container then
			return true
		end

		local itemId = container:getId()
		if itemId == ITEM_REWARD_CONTAINER or itemId == ITEM_REWARD_CHEST then
			movimentoBloqueado = true
		end

		local tile = Tile(container:getPosition())
		for _, item in ipairs(tile:getItems()) do
			if item:getAttribute(ITEM_ATTRIBUTE_CORPSEOWNER) == 2^31 - 1 and item:getName() == container:getName() then
				movimentoBloqueado = true
			end
		end
	end

	if item:getAttribute(ITEM_ATTRIBUTE_CORPSEOWNER) == 2^31 - 1 then
		movimentoBloqueado = true
	end

	if movimentoBloqueado then
		self:sendCancelMessage("Voc� n�o pode mover esse item.")
		return false
	end

	return true
end

function Player:onMoveCreature(creature, fromPosition, toPosition)
	return true
end

function Player:onTurn(direction)
	if self:getDirection() == direction and self:getGroup():getAccess() then

		local nextPosition = self:getPosition()

		nextPosition:getNextPosition(direction)

		self:teleportTo(nextPosition, true)
	end

	return true
end

function Player:onTradeRequest(target, item)
	if getCreatureCondition(self, CONDITION_SPELLCOOLDOWN, 160) then
		self:sendCancelMessage("Voc� est� ocupado.")
		return false
	end

	if item:isContainer() then
		for k, actionId in pairs(itensMovimentoDesativado) do
			verificarItens = item:getAllItemsByAction(false, actionId)
			if #verificarItens > 0 then
				self:sendCancelMessage("Voc� n�o pode trocar esse item.")
				return false
			end
		end
	end

	if isInArray(itensMovimentoDesativado, item:getActionId()) then
		self:sendCancelMessage("Voc� n�o pode trocar esse item.")
		return false
	end

	return true
end

function Player:onTradeAccept(target, item, targetItem)
	return true
end

local soulCondition = Condition(CONDITION_SOUL, CONDITIONID_DEFAULT)
soulCondition:setTicks(4 * 60 * 1000)
soulCondition:setParameter(CONDITION_PARAM_SOULGAIN, 1)

local function useStamina(player)
	local staminaMinutes = player:getStamina()

	if staminaMinutes == 0 then
		return
	end

	local playerId = player:getId()
	local currentTime = os.time()
	local timePassed = currentTime - nextUseStaminaTime[playerId]

	if timePassed <= 0 then
		return
	end

	if timePassed > 60 then
		if staminaMinutes > 2 then
			staminaMinutes = staminaMinutes - 2
		else
			staminaMinutes = 0
		end
		nextUseStaminaTime[playerId] = currentTime + 120
	else
		staminaMinutes = staminaMinutes - 1
		nextUseStaminaTime[playerId] = currentTime + 60
	end

	player:setStamina(staminaMinutes)
end

function Player:onGainExperience(source, exp, rawExp)
	if not source or source:isPlayer() then
		return exp
	end

	-- Soul regeneration
	local vocation = self:getVocation()

	if self:getSoul() < vocation:getMaxSoul() and exp >= self:getLevel() then
		soulCondition:setParameter(CONDITION_PARAM_SOULTICKS, vocation:getSoulGainTicks() * 1000)
		self:addCondition(soulCondition)
	end

	-- Apply experience stage multiplier
	exp = exp * Game.getExperienceStage(self:getLevel())

	-- Stamina modifier
	if configManager.getBoolean(configKeys.STAMINA_SYSTEM) then
		useStamina(self)

		local staminaMinutes = self:getStamina()

		if staminaMinutes > 2400 and self:isPremium() then
			exp = exp * 1.5
		elseif staminaMinutes <= 840 then
			exp = exp * 0.5
		end
	end

	return exp
end

function Player:onLoseExperience(exp)
	return exp
end

function Player:onGainSkillTries(skill, tries)
	if APPLY_SKILL_MULTIPLIER == false then
		return tries
	end

	if skill == SKILL_MAGLEVEL then
		return tries * configManager.getNumber(configKeys.RATE_MAGIC)
	end

	return tries * configManager.getNumber(configKeys.RATE_SKILL)
end
