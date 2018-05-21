local potions = {
	[8473] = {health = {650, 850}, mana = {}, level = 130, vocations = {4, 8}, emptyPot = 7635},
	[7591] = {health = {425, 575}, mana = {}, level = 80, vocations = {4, 8}, emptyPot = 7635},
	[7590] = {health = {}, mana = {150, 250}, level = 80, vocations = {1, 2, 5, 6}, emptyPot = 7635},
	[8472] = {health = {250, 350}, mana = {100, 200}, level = 80, vocations = {3, 7}, emptyPot = 7635},
	[7588] = {health = {250, 350}, mana = {}, level = 50, vocations = {3, 4, 7, 8}, emptyPot = 7634},
	[7589] = {health = {}, mana = {115, 185}, level = 50, vocations = {1, 2, 3, 5, 6, 7}, emptyPot = 7634},
	[7618] = {health = {125, 175}, mana = {}, level = 1, vocations = {}, emptyPot = 7636},
	[7620] = {health = {}, mana = {75, 125}, level = 1, vocations = {}, emptyPot = 7636},
	[8704] = {health = {20, 125}, mana = {}, level = 1, vocations = {}},
	[8474] = {emptyPot = 7636},
}

local potionAntidote = 8474
local antidote = createCombatObject()
setCombatParam(antidote, COMBAT_PARAM_TYPE, COMBAT_HEALING)
setCombatParam(antidote, COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
setCombatParam(antidote, COMBAT_PARAM_TARGETCASTERORTOPMOST, TRUE)
setCombatParam(antidote, COMBAT_PARAM_AGGRESSIVE, false)
setCombatParam(antidote, COMBAT_PARAM_DISPEL, CONDITION_POISON)

local exhaust = Condition(CONDITION_EXHAUST_HEAL)
exhaust:setParameter(CONDITION_PARAM_TICKS, (configManager.getNumber(configKeys.EX_ACTIONS_DELAY_INTERVAL) - 100))

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target == nil or not target:isPlayer() then
		return true
	end

	if player:getCondition(CONDITION_EXHAUST_HEAL) then
		player:sendTextMessage(MESSAGE_STATUS_SMALL, Game.getReturnMessage(RETURNVALUE_YOUAREEXHAUSTED))
		return true
	end

	if potions[item.itemid] then
		local potion = potions[item.itemid]

		if item.itemid == potionAntidote then
			if(doCombat(target, antidote, numberToVariant(target)) == LUA_ERROR) then
				return false
			end
		else
			local msg = ""

			if (#potion.vocations > 0) and not isInArray(potion.vocations, target:getVocation():getId()) then
				local vocacoes = ""

				for i = 1, #potion.vocations/2 do
					local vocationName = string.lower(tostring(Vocation(potion.vocations[i]):getName())).."s"

					if i == 1 then
						vocacoes = vocationName
					elseif i < #potion.vocations/2 then
						vocacoes = vocacoes..", "..vocationName
					else
						vocacoes = vocacoes.." e "..vocationName
					end
				end
				msg = msg.."Essa po��o s� pode ser usada por "..vocacoes
			end

			if target:getLevel() < potion.level or msg ~= "" then
				msg = msg.." de level "..potion.level.." ou mais"
			end

			if player:getGroup():getId() >= 2 then
				msg = ""
			end

			if msg ~= "" then
				msg = msg.."."
				target:say(msg, TALKTYPE_MONSTER_SAY)
				return true
			end

			local health_min = potion.health[1] or 0
			local health_max = potion.health[2] or 0
			local mana_min = potion.mana[1] or 0
			local mana_max = potion.mana[2] or 0
			local health = item:getName():match("health: (.-)]")
			local mana = item:getName():match("mana: (.-)]")

			if health ~= nil then
				health_min = health
				health_max = health
			end

			if mana ~= nil then
				mana_min = mana
				mana_max = mana
			end

			if not doTargetCombatHealth(0, target, COMBAT_HEALING, health_min, health_max, CONST_ME_MAGIC_BLUE) or not doTargetCombatMana(0, player, mana_min, mana_max, CONST_ME_MAGIC_BLUE) then
				return false
			end
		end

		player:addCondition(exhaust)
		target:say("Aaaah...", TALKTYPE_MONSTER_SAY)
		item:remove(1)

		if potion.emptyPot ~= nil then
			player:addItem(potion.emptyPot, 1)
		end
	end
	return true
end