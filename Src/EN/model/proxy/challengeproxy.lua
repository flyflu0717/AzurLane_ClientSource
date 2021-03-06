slot0 = class("ChallengeProxy", import(".NetProxy"))
slot0.CHALLENGE_UPDATED = "ChallengeProxy:CHALLENGE_UPDATED"
slot0.PRECOMBAT = "challenge precombat"
slot0.RATE_FACTOR_LEVEL = 1
slot0.RATE_FACTOR_DAMAGE = 2
slot0.RATE_FACTOR_GEAR_SCORE = 3

function slot0.register(slot0)
	slot0.fillConfigData()
	slot0.fillRateConfigData()

	slot0.data = {}

	slot0:on(24001, function (slot0)
		return
	end)
	slot0:on(24006, function (slot0)
		slot0:updateScore(slot0)
	end)
end

function slot0.updateChallenge(slot0, slot1)
	slot0.challengeVO = slot1

	slot0:sendNotification(slot0.CHALLENGE_UPDATED, {
		chapter = slot0.challengeVO:clone()
	})
end

function slot0.updateScore(slot0, slot1)
	slot0.challengeVO:updateBattleScore(slot1)
end

function slot0.stagePass(slot0)
	slot0.challengeVO.challengeLevel = slot0.challengeVO.challengeLevel + 1
end

function slot0.updateActiveChallengeShips(slot0)
	_.each(slot0.challengeVO.fleets, function (slot0)
		slot0:flushShips()
	end)
end

function slot0.clearEdittingFleet(slot0)
	slot0.challengeVO:clearFleet()
	slot0:updateChallenge(slot0.challengeVO)
end

function slot0.recommendChallengeFleet(slot0)
	slot2 = getProxy(BayProxy).getRawData(slot1)
	slot4 = {}
	slot5 = #Challenge.SHIP_TYPE_LIMIT[1]
	slot6 = #Challenge.SHIP_TYPE_LIMIT[2]

	for slot10, slot11 in ipairs(slot3) do
		slot4[#slot4 + 1] = slot11.id

		if pg.ship_data_by_type[slot2[slot11.id].getShipType(slot12)].team_type == TeamType.Main then
			slot5 = slot5 - 1
		elseif slot14 == TeamType.Vanguard then
			slot6 = slot6 - 1
		end
	end

	function slot7(slot0)
		if slot0:getChallengeRecommendShip(slot0, slot0.getChallengeRecommendShip) then
			slot1[#slot1 + 1] = slot1.id
			slot1.id[#slot2 + 1] = {
				id = slot1.id
			}
		end
	end

	for slot11, slot12 in ipairs(Challenge.SHIP_TYPE_LIMIT[1]) do
		if slot12 == -1 then
			slot5 = slot5 - 1
		end
	end

	while slot5 > 0 do
		slot7(TeamType.MainShipType)

		slot5 = slot5 - 1
	end

	for slot11, slot12 in ipairs(Challenge.SHIP_TYPE_LIMIT[2]) do
		if slot12 == -1 then
			slot6 = slot6 - 1
		end
	end

	while slot6 > 0 do
		slot7(TeamType.VanguardShipType)

		slot6 = slot6 - 1
	end

	slot0:updateChallenge(slot0.challengeVO)
end

function slot0.SetPlayerPrefsChallengeFleet(slot0, slot1)
	slot3 = getProxy(BayProxy).getRawData(slot2)
	slot4 = {}

	for slot8 = 1, 4, 1 do
		slot4[#slot4 + 1] = PlayerPrefs.GetInt("challengeShipUID_" .. slot8, nil)
	end

	slot5 = slot1:getShips()

	for slot9, slot10 in ipairs(slot4) do
		if slot10 ~= nil and slot3[slot10] then
			slot5[#slot5 + 1] = {
				id = slot10
			}
		end
	end
end

function slot0.escapeChallenge(slot0)
	slot0:updateChallenge(Challenge.New(slot1))
end

function slot0.fillConfigData()
	slot0.configData = {}

	for slot3, slot4 in ipairs(pg.expedition_challenge_template) do
		if not slot0.configData[slot4.challenge] then
			slot0.configData[slot5] = {}
		end

		slot0.configData[slot5][#slot0.configData[slot5] + 1] = slot4
	end

	for slot4, slot5 in pairs(slot0.configData) do
		table.sort(slot5, function (slot0, slot1)
			return slot0.index < slot1.index
		end)
	end
end

function slot0.fillRateConfigData()
	slot0.rateConfigData = {
		[slot0.RATE_FACTOR_LEVEL] = {}
	}
	slot0.rateConfigData.rateConfigData[slot0.RATE_FACTOR_DAMAGE] = {}
	slot0.rateConfigData.rateConfigData.rateConfigData[slot0.RATE_FACTOR_GEAR_SCORE] = {}

	for slot3, slot4 in pairs(pg.challenge_rate_template) do
		if setmetatable({}, {
			__index = slot4
		}).id then
			slot0.rateConfigData[slot5.type][#slot0.rateConfigData[slot5.type] + 1] = slot5
		end
	end

	table.sort(slot0.rateConfigData[slot0.RATE_FACTOR_LEVEL], slot0)
	table.sort(slot0.rateConfigData[slot0.RATE_FACTOR_DAMAGE], slot0)
	table.sort(slot0.rateConfigData[slot0.RATE_FACTOR_GEAR_SCORE], function (slot0, slot1)
		return slot0.id < slot1.id
	end)
end

function slot0.getCurrentChallengeInfo(slot0)
	if slot0.challengeVO then
		return slot0.challengeVO:clone()
	else
		return Challenge.New({
			max_score = 0,
			ship_list = {},
			multiple_list = {
				1,
				1,
				1
			}
		})
	end
end

function slot0.getChallenge(slot0, slot1)
	return Clone(slot0.configData[slot1])
end

return slot0
