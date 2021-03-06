slot0 = class("ChallengePreCombatMediator", import("..base.ContextMediator"))
slot0.ON_START = "ChallengePreCombatMediator:ON_START"
slot0.ON_SWITCH_FLEET = "ChallengePreCombatMediator:ON_SWITCH_FLEET"
slot0.ON_OP = "ChallengePreCombatMediator:ON_OP"
slot0.ON_UPDATE_FLEET = "ChallengePreCombatMediator:ON_UPDATE_FLEET"

function slot0.register(slot0)
	slot2 = getProxy(ChallengeProxy).getCurrentChallengeInfo(slot1)

	slot0:bind(slot0.ON_UPDATE_FLEET, function (slot0, slot1)
		slot0:getCurrentChallengeInfo().fleet = slot1

		slot0:updateChallenge(slot0.getCurrentChallengeInfo())
	end)
	slot0:bind(slot0.ON_START, function (slot0)
		slot1:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_CHALLENGE,
			stageId = slot0:getChallengeStageID()
		})
	end)
	slot0:bind(slot0.ON_OP, function (slot0, slot1)
		slot0:sendNotification(GAME.CHALLENGE_STRATEGY, slot1)
	end)
	slot0.viewComponent:setPlayerInfo(getProxy(PlayerProxy):getData())
	slot0:display(true)
end

function slot0.listNotificationInterests(slot0)
	return {
		PlayerProxy.UPDATED,
		GAME.BEGIN_STAGE_ERRO,
		GAME.CHAPTER_OP_DONE,
		GAME.BEGIN_STAGE_DONE,
		ChallengeProxy.CHALLENGE_UPDATED
	}
end

function slot0.handleNotification(slot0, slot1)
	slot3 = slot1:getBody()

	if slot1:getName() == PlayerProxy.UPDATED then
		slot0.viewComponent:setPlayerInfo(getProxy(PlayerProxy):getData())
	elseif slot2 == GAME.BEGIN_STAGE_ERRO then
		if slot3 == 3 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				content = i18n("battle_preCombatMediator_timeout"),
				onYes = function ()
					slot0.viewComponent:emit(BaseUI.ON_CLOSE)
				end
			})
		end
	elseif slot2 == GAME.CHAPTER_OP_DONE then
		if slot3.type == ChapterConst.OpStrategy or slot3.type == ChapterConst.OpRepair or slot3.type == ChapterConst.OpRequest then
			slot0:display()
		end
	elseif slot2 == GAME.BEGIN_STAGE_DONE then
		slot0:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, slot3)
	elseif slot2 == ChallengeProxy.CHALLENGE_UPDATED then
		slot0:display(false)
	end
end

function slot0.display(slot0, slot1)
	slot0.viewComponent:updateChallenge(getProxy(ChallengeProxy).getCurrentChallengeInfo(slot2), slot1)
end

return slot0
