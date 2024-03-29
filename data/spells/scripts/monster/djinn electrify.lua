local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ENERGYHIT)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_ENERGY)

local condition = Condition(CONDITION_ENERGY)
condition:setParameter(CCONDITION_PARAM_DELAYED, true)
condition:addDamage(3, 10000, -25)
combat:addCondition(condition)

function onCastSpell(creature, var)
	return combat:execute(creature, var)
end