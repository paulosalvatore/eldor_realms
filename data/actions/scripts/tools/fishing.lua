local waterIds = {493, 4608, 4609, 4610, 4611, 4612, 4613, 4614, 4615, 4616, 4617, 4618, 4619, 4620, 4621, 4622, 4623, 4624, 4625, 4664, 4665, 4666, 7236, 10499, 15401, 15402}
local shimmerWaterIds = {13547, 13548, 13549, 13550, 13551, 13552}
local lootTrash = {2234, 2238, 2376, 2509, 2667}
local lootCommon = {2152, 2167, 2168, 2669, 7588, 7589}
local lootRare = {2143, 2146, 2149, 7158, 7159}
local lootVeryRare = {7632, 7633, 10220}
local useWorms = true
local conditionOutfit = createConditionObject(CONDITION_OUTFIT)
setConditionParam(conditionOutfit, CONDITION_PARAM_TICKS, 10000)
addOutfitCondition(conditionOutfit, 0, 33, 0, 0, 0, 0, 0)
local conditionEnergy = createConditionObject(CONDITION_ENERGY)
addDamageCondition(conditionEnergy, 1, 1000, -35)

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local targetId = target.itemid
	if not isInArray(waterIds, targetId) or not isInArray(shimmerWaterIds, targetId) then
		return false
	end

	if isInArray(waterIds, targetId) then
		if item.itemid == 2580 then
			if targetId == 10499 then
				local owner = target:getAttribute(ITEM_ATTRIBUTE_CORPSEOWNER)
				if owner ~= 0 and owner ~= player:getId() then
					player:sendTextMessage(MESSAGE_STATUS_SMALL, "You are not the owner.")
					return true
				end

				toPosition:sendMagicEffect(CONST_ME_WATERSPLASH)
				target:remove()

				local rareChance = math.random(1, 100)
				if rareChance == 1 then
					player:addItem(lootVeryRare[math.random(#lootVeryRare)], 1)
				elseif rareChance <= 3 then
					player:addItem(lootRare[math.random(#lootRare)], 1)
				elseif rareChance <= 10 then
					player:addItem(lootCommon[math.random(#lootCommon)], 1)
				else
					player:addItem(lootTrash[math.random(#lootTrash)], 1)
				end
				return true
			end

			if targetId ~= 7236 then
				toPosition:sendMagicEffect(CONST_ME_LOSEENERGY)
			end

			if targetId == 493 or targetId == 15402 then
				return true
			end

			player:addSkillTries(SKILL_FISHING, 1)

			if math.random(1, 100) <= math.min(math.max(10 + (player:getEffectiveSkillLevel(SKILL_FISHING) - 10) * 0.597, 10), 50) then
				if useWorms and not player:removeItem("worm", 1) then
					return true
				end

				if targetId == 15401 then
					target:transform(targetId + 1)
					target:decay()

					if math.random(1, 100) >= 97 then
						player:addItem(15405, 1)
						return true
					end
				elseif targetId == 7236 then
					target:transform(targetId + 1)
					target:decay()

					local rareChance = math.random(1, 100)
					if rareChance == 1 then
						player:addItem(7158, 1)
						return true
					elseif rareChance <= 4 then
						player:addItem(2669, 1)
						return true
					elseif rareChance <= 10 then
						player:addItem(7159, 1)
						return true
					end
				end
				player:addItem("fish", 1)
			end
		elseif item.itemid == 10223 then
			if not player:removeItem(8309, 1) then
				return true
			end

			toPosition:sendMagicEffect(CONST_ME_WATERSPLASH)

			local chance = math.random(1, 100)
			if chance <= 10 then
				player:addItem(10224, 1)
				player:sendTextMessage(MESSAGE_EVENT_ORANGE, '"You have caught one of the elusive mechanical fishes!"')
			elseif chance >= 85 then
				player:sendTextMessage(MESSAGE_EVENT_ORANGE, '"Yikes, That DID hurt!"')
				doAddCondition(player, conditionOutfit)
				doAddCondition(player, conditionEnergy)
			end
		end
	elseif isInArray(shimmerWaterIds, targetId) then
		if item.itemid == 2580 then
			player:addSkillTries(SKILL_FISHING, 1)

			if useWorms and not player:removeItem("worm", 1) then
				return true
			end

			if math.random(1, 100) <= 5 then
				player:addItem(13546, 1)
			end
		end
	end
	return true
end