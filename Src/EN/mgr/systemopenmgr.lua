pg = pg or {}
pg.SystemOpenMgr = singletonClass("SystemOpenMgr")
slot1 = true
slot2 = pg.open_systems_limited

function pg.SystemOpenMgr.Init(slot0, slot1)
	print("initializing SystemOpenMgr manager...")
	slot1()
end

slot3 = pm.Facade.sendNotification

function pm.Facade.sendNotification(slot0, slot1, slot2, slot3)
	if slot0 and slot1 == GAME.LOAD_SCENE and getProxy(PlayerProxy) then
		slot6 = slot2.context.mediator.__cname

		if slot4:getData() then
			slot7, slot8 = pg.SystemOpenMgr:GetInstance():isOpenSystem(slot5.level, slot6)

			if not slot7 then
				pg.TipsMgr:GetInstance():ShowTips(slot8)

				return
			end
		end
	end

	slot1(slot0, slot1, slot2, slot3)
end

slot4 = {
	13
}

function pg.SystemOpenMgr.isOpenSystem(slot0, slot1, slot2)
	for slot6, slot7 in pairs(slot0.all) do
		if not table.contains(slot1, slot7) and slot0[slot7].mediator == slot2 and slot1 < slot0[slot7].level then
			return false, i18n("no_open_system_tip", slot0[slot7].name, slot0[slot7].level)
		end
	end

	return true
end

function pg.SystemOpenMgr.notification(slot0, slot1)
	if not slot0 then
		return
	end

	if slot0:getLevelCfg(slot1, getProxy(PlayerProxy).getData(slot2)) and not table.contains(slot1, slot4.id) and slot4 and slot3.guideIndex < slot4.guid_end_id and pg.GuideMgr2.ENABLE_GUIDE == false and not pg.MsgboxMgr.GetInstance()._go.activeSelf then
		slot0.active = true

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			modal = true,
			hideNo = true,
			hideClose = true,
			content = i18n("open_system_tip", slot4.name),
			onYes = function ()
				slot0:doSystemGuide(slot1.id)
			end
		})
	end
end

function pg.SystemOpenMgr.getLevelCfg(slot0, slot1, slot2)
	for slot7, slot8 in pairs(slot3) do
		if slot0[slot8].level <= slot1 then
			return slot9
		end
	end
end

function pg.SystemOpenMgr.doSystemGuide(slot0, slot1)
	slot2 = pg.open_systems_limited[slot1]
	slot4 = getProxy(PlayerProxy).getData(slot3)
	slot0.active = nil

	if slot0:canPlaySystemGuide(slot1) then
		slot0.curCfg = slot2

		pg.GuideMgr2:GetInstance():Reset()

		if slot4.guideIndex < slot2.guidId then
			slot0:doNextSystemGuide(slot5, true)
		else
			slot0:doNextSystemGuide(slot4.guideIndex)
		end

		if getProxy(ContextProxy).getCurrentContext(slot6).scene ~= SCENE[slot2.scene] then
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE[slot2.scene])
		else
			pg.GuideMgr2:GetInstance():dispatch({
				viewComponent = slot7.viewComponent.__cname,
				event = slot7.viewComponent.__cname
			})
		end
	end
end

function pg.SystemOpenMgr.doNextSystemGuide(slot0, slot1, slot2)
	if slot0.curCfg.guid_end_id <= slot1 and not slot2 then
		pg.GuideMgr2:GetInstance():AbortGuide("system guide finished")

		return
	end

	pg.GuideMgr2:GetInstance():updateSystemGuideStep((slot2 and slot1) or require("GameCfg.guide.G" .. slot1).nextId)
end

function pg.SystemOpenMgr.canPlaySystemGuide(slot0, slot1)
	slot5 = false

	if getProxy(PlayerProxy).getData(slot3).guideIndex < pg.open_systems_limited[slot1].guid_end_id and pg.GuideMgr2.ENABLE_GUIDE == false and not pg.MsgboxMgr.GetInstance()._go.activeSelf and not pg.StoryMgr.GetInstance():isActive() and slot2.level <= slot4.level then
		slot5 = true
	end

	return slot5
end

return
