slot0 = class("SelectTechnologyLayer", import("..base.BaseUI"))

function slot0.getUIName(slot0)
	return "SelectTechnologyUI"
end

function slot0.setPlayer(slot0, slot1)
	slot0.playerVO = slot1

	if slot0._resPanel then
		slot0._resPanel:setResources(slot1)
	end
end

function slot0.init(slot0)
	pg.UIMgr:GetInstance():OverlayPanel(slot0._tf)

	slot0.bg = slot0:findTF("frame/bg")
	slot0.topPanel = slot0:findTF("frame/top")
	slot0.bluePrintBtn = slot0:findTF("blueprint_btn", slot0.bg)
	slot0.bluePrintBtnTip = slot0.bluePrintBtn:Find("word/tip")
	slot0.technologyBtn = slot0:findTF("technology_btn", slot0.bg)
	slot0.technologyBtnTip = slot0.technologyBtn:Find("word/tip")
	slot0.fleetBtn = slot0:findTF("fleet_btn", slot0.bg)
	slot0.fleetBtnTip = slot0:findTF("word/tip", slot0.fleetBtn)
	slot0.helpBtn = slot0:findTF("help_btn")
	slot0.lockedTpl = slot0:findTF("lockedTpl")
	slot0._playerResOb = slot0:findTF("top/playerRes")
	slot0._resPanel = PlayerResource.New()

	tf(slot0._resPanel._go):SetParent(tf(slot0._playerResOb), false)

	slot0.backBtn = slot0:findTF("top/back")

	onButton(slot0, slot0.fleetBtn, function ()
		slot0:emit(TechnologyConst.OPEN_TECHNOLOGY_TREE_SCENE)
	end)

	if not OPEN_TEC_TREE_SYSTEM then
		setActive(slot0.fleetBtn, false)
	end
end

function slot0.didEnter(slot0)
	slot0:checkSystemOpen("ShipBluePrintMediator", slot0.bluePrintBtn)
	slot0:checkSystemOpen("TechnologyMediator", slot0.technologyBtn)
	onButton(slot0, slot0.bluePrintBtn, function ()
		slot0:emit(SelectTechnologyMediator.ON_BLUEPRINT)
	end, SFX_PANEL)
	onButton(slot0, slot0.technologyBtn, function ()
		slot0:emit(SelectTechnologyMediator.ON_TECHNOLOGY)
	end, SFX_PANEL)
	onButton(slot0, slot0.backBtn, function ()
		slot0:emit(slot1.ON_BACK)
	end, SFX_CANCEL)
	onButton(slot0, slot0.helpBtn, function ()
		if pg.gametip[(pg.SystemOpenMgr:GetInstance():isOpenSystem(slot0.playerVO.level, "ShipBluePrintMediator") and "help_technolog") or "help_technolog0"] then
			pg.MsgboxMgr.GetInstance():ShowHelpWindow({
				helps = pg.gametip[slot1].tip
			})
		end
	end, SFX_PANEL)
end

function slot0.checkSystemOpen(slot0, slot1, slot2)
	slot3 = pg.SystemOpenMgr:GetInstance():isOpenSystem(slot0.playerVO.level, slot1)

	setActive(slot0:findTF("word", slot2), slot3)
	setGray(slot2, not slot3)

	slot2:GetComponent(typeof(Image)).color = Color.New(1, 1, 1, (slot3 and 1) or 0.7)

	if slot0:findTF("locked", slot2) then
		setActive(slot4, false)
	end

	if not slot3 then
		if not slot0.LockedTF then
			cloneTplTo(slot0.lockedTpl, slot2).localPosition = Vector3.zero

			setActive(cloneTplTo(slot0.lockedTpl, slot2), true)
		else
			setActive(slot4, false)
		end
	end
end

function slot0.notifyTechnology(slot0, slot1)
	setActive(slot0.technologyBtnTip, slot1)
end

function slot0.notifyBlueprint(slot0, slot1)
	setActive(slot0.bluePrintBtnTip, slot1)
end

function slot0.notifyFleet(slot0, slot1)
	setActive(slot0.fleetBtnTip, slot1)
end

function slot0.willExit(slot0)
	if slot0._resPanel then
		slot0._resPanel:exit()

		slot0._resPanel = nil
	end
end

return slot0
