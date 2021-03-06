slot0 = class("FleetSkill", import(".BaseVO"))
slot0.SystemCommanderNeko = 1
slot0.TypeMoveSpeed = "move_speed"
slot0.TypeHuntingLv = "hunt_lv"
slot0.TypeAmbushDodge = "ambush_dodge"
slot0.TypeAirStrikeDodge = "airfight_doge"
slot0.TypeStrategy = "strategy"
slot0.TypeBattleBuff = "battle_buff"
slot0.TypeAttack = "attack"
slot0.TypeTorpedoPowerUp = "torpedo_power_up"
slot0.TriggerDDCount = "dd_count"
slot0.TriggerDDHead = "dd_head"
slot0.TriggerAroundEnemy = "around_enemy"
slot0.TriggerVanCount = "vang_count"
slot0.TriggerNekoPos = "pos"
slot0.TriggerAroundLand = "around_land"
slot0.TriggerAroundCombatAlly = "around_combat_ally"
slot0.TriggerShipCount = "count"
slot0.TriggerInSubTeam = "insubteam"

function slot0.Ctor(slot0, slot1, slot2)
	slot0.system = slot1
	slot0.id = slot2
	slot0.configId = slot0.id
end

function slot0.GetSystem(slot0)
	return slot0.system
end

function slot0.bindConfigTable(slot0)
	if slot0:GetSystem() == slot0.SystemCommanderNeko then
		return pg.commander_skill_effect_template
	end
end

function slot0.GetType(slot0)
	if slot0:GetSystem() == slot0.SystemCommanderNeko then
		return slot0:getConfig("effect_type")
	end
end

function slot0.GetArgs(slot0)
	if slot0:GetSystem() == slot0.SystemCommanderNeko then
		return slot0:getConfig("args")
	end
end

function slot0.GetTriggers(slot0)
	if slot0:GetSystem() == slot0.SystemCommanderNeko then
		return slot0:getConfig("condition")
	end
end

function slot0.triggerSkill(slot0, slot1)
	return _.reduce(slot2, nil, function (slot0, slot1)
		slot3 = slot1:GetArgs()

		if slot1:GetType() == FleetSkill.TypeBattleBuff then
			table.insert(slot0 or {}, slot3[1])

			return slot0 or 
		end
	end), _.filter(slot0:findSkills(slot1), function (slot0)
		return _.any(slot1, function (slot0)
			return slot0[1] == FleetSkill.TriggerInSubTeam and slot0[2] == 1
		end) == slot0:getFleetType() == FleetType.Submarine and _.all(slot0:GetTriggers(), function (slot0)
			return slot0.NoneChapterFleetCheck(slot0.NoneChapterFleetCheck, , slot0)
		end)
	end)
end

function slot0.NoneChapterFleetCheck(slot0, slot1, slot2)
	slot4 = getProxy(BayProxy)

	if slot2[1] == FleetSkill.TriggerDDCount then
		slot5 = slot4:getShipByTeam(slot0, TeamType.Vanguard)

		return slot2[2] <= #_.filter(fleetShips, function (slot0)
			return slot0:getShipType() == ShipType.QuZhu
		end) and slot6 <= slot2[3]
	elseif slot3 == FleetSkill.TriggerDDHead then
		return #slot4:getShipByTeam(slot0, TeamType.Vanguard) > 0 and slot5[1]:getShipType() == ShipType.QuZhu
	elseif slot3 == FleetSkill.TriggerVanCount then
		return slot2[2] <= #slot4:getShipByTeam(slot0, TeamType.Vanguard) and #slot5 <= slot2[3]
	elseif slot3 == FleetSkill.TriggerShipCount then
		return slot2[3] <= #_.filter(slot4:getShipsByFleet(slot0), function (slot0)
			return table.contains(slot0[2], slot0:getShipType())
		end) and #slot5 <= slot2[4]
	elseif slot3 == FleetSkill.TriggerNekoPos then
		slot5 = slot0:findCommanderBySkillId(slot1.id)

		for slot9, slot10 in pairs(slot0:getCommanders()) do
			if slot5.id == slot10.id and slot9 == slot2[2] then
				return true
			end
		end
	elseif slot3 == FleetSkill.TriggerInSubTeam then
		return true
	else
		return false
	end
end

return slot0
