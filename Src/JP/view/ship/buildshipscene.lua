slot0 = class("BuildShipScene", import("..base.BaseUI"))
slot0.PAGE_BUILD = 1
slot0.PAGE_QUEUE = 2
slot0.PAGE_EXCHANGE = 3
slot0.PAGE_UNSEAM = 4
slot0.PROJECTS = {
	SPECIAL = "special",
	ACTIVITY = "new",
	HEAVY = "heavy",
	LIGHT = "light"
}

function slot0.getCreateId(slot0, slot1)
	if slot1 == slot0.PROJECTS.ACTIVITY then
		if slot0.activity and not slot0.activity:isEnd() then
			return slot0.activity:getConfig("config_id")
		end
	elseif slot1 == slot0.PROJECTS.LIGHT then
		return 2
	elseif slot1 == slot0.PROJECTS.HEAVY then
		return 3
	elseif slot1 == slot0.PROJECTS.SPECIAL then
		return 1
	end
end

slot0.BUILD_TYPE_NORMAL = 1
slot0.BUILD_TYPE_ACTIVITY = 2

function slot0.getUIName(slot0)
	return "buildShipUI"
end

function slot0.setActivity(slot0, slot1)
	slot0.activity = slot1

	slot0:removeActTimer()

	if slot0.activity and not slot0.activity:isEnd() then
		if slot0.curProjectName == slot0.PROJECTS.ACTIVITY then
			slot0:switchProject(slot0.PROJECTS.ACTIVITY)
		end

		slot0.activityTimer = Timer.New(function ()
			slot0:removeActTimer()
			slot0.removeActTimer:emit(BuildShipMediator.ON_UPDATE_ACT)
		end, slot0.activity.stopTime - pg.TimeMgr.GetInstance():GetServerTime(), 1)

		slot0.activityTimer:Start()
	end
end

function slot0.removeActTimer(slot0)
	if slot0.activityTimer then
		slot0.activityTimer:Stop()

		slot0.activityTimer = nil
	end
end

function slot0.setPlayer(slot0, slot1)
	slot0.player = slot1

	slot0.resPanel:setResources(slot1)
end

function slot0.setUseItem(slot0, slot1)
	slot0.useItem = slot1 or Item.New({
		count = 0,
		id = pg.ship_data_create_material[1].use_item
	})

	setText(slot0.useItemTF, slot0.useItem.count)
end

function slot0.setWorkCount(slot0, slot1)
	slot0.workCount = slot1

	setText(slot0.workCountTF, slot1)
end

function slot0.setStartCount(slot0, slot1)
	slot0.startCount = slot1
end

function slot0.setFlagShip(slot0, slot1)
	slot0.falgShip = slot1
end

function slot0.init(slot0)
	slot0._guiderLoaded = true
	slot0.backBtn = slot0:findTF("bg/blur_container/top/back")
	slot0.togglesPanel = slot0:findTF("bg/blur_container/left_length/toggles")
	slot0.projectTogglesPnael = slot0:findTF("bg/frame/projects")
	slot0.projectBg = slot0:findTF("bg/frame/painting"):GetComponent(typeof(Image))
	slot0.itemsPanel = slot0:findTF("bg/frame/painting/items_bg")
	slot0.blurContainer = slot0:findTF("bg/blur_container")
	slot0.startBtn = slot0:findTF("bg/frame/start_btn")
	slot0.bgTF = slot0:findTF("bg")

	setActive(slot0.bgTF, false)

	slot0.helpBtn = slot0:findTF("bg/frame/help_btn")
	slot0.tip = slot0:findTF("bg/blur_container/left_length/toggles/queue_btn/tip")
	slot0.workCountTF = slot0:findTF("bg/title/value")
	slot0.quickCount = slot0:findTF("bg/quick_count")
	slot0.useItemTF = slot0:findTF("bg/quick_count/value")
	slot0.useItemIconTF = slot0:findTF("bg/quick_count/icon"):GetComponent(typeof(Image))
	slot0.useItemLabelTF = slot0:findTF("bg/quick_count/label"):GetComponent(typeof(Text))
	slot0._topPanel = slot0:findTF("bg/blur_container/top")
	slot0._leftPanel = slot0:findTF("bg/blur_container/left_length")
	slot0._playerResOb = slot0:findTF("bg/blur_container/top/playerRes")
	slot0.resPanel = PlayerResource.New()

	tf(slot0.resPanel._go):SetParent(tf(slot0._playerResOb), false)

	slot0.OverlayMain = pg.UIMgr:GetInstance().OverlayMain

	setParent(slot0.blurContainer, slot0.OverlayMain)

	slot0.materialCfg = pg.ship_data_create_material
	slot0.patingTF = slot0:findTF("bg/painting")
end

function slot0.uiStartAnimating(slot0)
	setAnchoredPosition(slot0._topPanel, {
		y = 84
	})
	setAnchoredPosition(slot0._leftPanel, {
		x = -1 * slot0._leftPanel.rect.width
	})
	shiftPanel(slot0._topPanel, nil, 0, slot2, slot1, true, true)
	shiftPanel(slot0._leftPanel, 0, nil, slot2, slot1, true, true, nil, function ()
		slot0:dispatchUILoaded(true)
	end)

	slot0.tweens = topAnimation(slot0:findTF("bg/left", slot0._topPanel), slot0:findTF("bg/right", slot0._topPanel), slot0:findTF("bg/title_buildship", slot0._topPanel), slot0:findTF("bg/buildship", slot0._topPanel), nil, function ()
		slot0.tweens = nil
	end)
end

function slot0.uiExitAnimating(slot0)
	shiftPanel(slot0._topPanel, nil, 84, slot2, slot1, true, true)
	shiftPanel(slot0._leftPanel, -1 * slot0._leftPanel.rect.width, nil, 0.3, 0, true, true, nil)
end

function slot0.didEnter(slot0)
	onButton(slot0, slot0.quickCount, function ()
		shoppingBatch(61008, {
			id = pg.shop_template[61008].effect_args[1]
		}, 9, "build_ship_quickly_buy_stone")
	end)
	onButton(slot0, slot0.backBtn, function ()
		slot0:uiExitAnimating()

		BuildShipScene.Page = nil
		BuildShipScene.projectName = nil

		BuildShipScene:emit(slot1.ON_BACK, nil, 0.3)
	end, SFX_CANCEL)
	setActive(slot0:findTF("stamp"), getProxy(TaskProxy):mingshiTouchFlagEnabled())

	if LOCK_CLICK_MINGSHI then
		setActive(slot0:findTF("stamp"), false)
	end

	onButton(slot0, slot0:findTF("stamp"), function ()
		getProxy(TaskProxy):dealMingshiTouchFlag(11)
	end, SFX_CONFIRM)
	onButton(slot0, slot0.helpBtn, function ()
		slot9, slot1, slot2, slot3, slot4, slot5 = slot0:getCurHelpContent()
		slot6 = nil

		pg.MsgboxMgr.GetInstance():ShowHelpWindow({
			helps = {
				{
					info = (not pg.gametip["help_build_" .. slot0] or i18n("help_build_" .. slot0, slot1, slot2, slot3, slot4, slot5)) and i18n("help_build", slot1, slot2, slot3, slot4, slot5)
				},
				helpbg = true,
				helpSize = {
					x = 490,
					y = 220
				},
				windowSize = {
					x = 520,
					y = 380
				}
			},
			custom = {
				{
					text = "text_iknow",
					sound = SFX_CANCEL,
					scale = {
						x = 0.85,
						y = 0.85
					}
				}
			}
		})
	end)
	setPaintingPrefabAsync(slot0.patingTF, slot0.falgShip:getPainting(), "build")

	slot0.useItemIconTF.sprite = LoadSprite(slot0.useItem:getConfig("icon"))
	slot0.useItemLabelTF.text = slot0.useItem:getConfig("name")

	slot0:initToggles()

	slot0.page = BuildShipScene.Page or slot0.contextData.page or slot0.PAGE_BUILD

	triggerToggle(slot0.toggles[slot0.page], true)
	slot0:uiStartAnimating()
	PoolMgr.GetInstance():GetUI("al_bg01", true, function (slot0)
		slot0:SetActive(true)
		setParent(slot0, slot0._tf)
		slot0.transform:SetAsFirstSibling()
	end)
end

function slot0.onBackPressed(slot0)
	playSoundEffect(SFX_CANCEL)

	if slot0.isShowbuildMsgBox then
		slot0:closeBuildMsgBox()
	else
		triggerButton(slot0.backBtn)
	end
end

function slot0.initToggles(slot0)
	slot0.toggles = {}

	for slot4 = 1, 4, 1 do
		table.insert(slot0.toggles, slot5)
		onToggle(slot0, slot0.togglesPanel:GetChild(slot4 - 1), function (slot0)
			slot0:switchPage(slot0.switchPage, slot0)
		end, SFX_PANEL)
	end
end

function slot0.switchPage(slot0, slot1, slot2)
	if slot1 == slot0.PAGE_UNSEAM then
		if slot2 then
			slot0:emit(BuildShipMediator.OPEN_DESTROY)
		end
	elseif slot1 == slot0.PAGE_QUEUE then
		if slot2 then
			slot0:emit(BuildShipMediator.OPEN_PROJECT_LIST)
		else
			slot0:emit(BuildShipMediator.REMOVE_PROJECT_LIST)
		end
	elseif slot1 == slot0.PAGE_EXCHANGE then
		if slot2 then
			slot0:emit(BuildShipMediator.OPEN_EXCHANGE)
		else
			slot0:emit(BuildShipMediator.CLOSE_EXCHANGE)
		end
	elseif slot1 == slot0.PAGE_BUILD then
		setActive(slot0.bgTF, slot2)
		slot0:initBuildPanel()
	end

	BuildShipScene.Page = (slot1 == slot0.PAGE_UNSEAM and BuildShipScene.Page) or slot1
end

function slot0.initBuildPanel(slot0)
	if slot0.isInitBuild then
		return
	end

	slot0.isInitBuild = true
	slot0.tagsTF = slot0:findTF("bg/frame/prints/tag")
	slot0.descsTF = slot0:findTF("bg/frame/prints/print_down")

	slot0:initProjectToggles()
end

function slot0.updateActivityBuildPage(slot0)
	if slot0.curProjectName == slot0.PROJECTS.ACTIVITY then
		triggerToggle(slot0.projectToggles[slot0.PROJECTS.LIGHT], true)
	end

	setActive(slot0.projectToggles[slot0.PROJECTS.ACTIVITY], slot0.activity and not slot0.activity:isEnd())
end

function slot0.initProjectToggles(slot0)
	slot0.projectToggles = {}

	for slot4, slot5 in pairs(slot0.PROJECTS) do
		slot0.projectToggles[slot5] = slot0.projectTogglesPnael:Find(slot5)

		onToggle(slot0, slot0.projectTogglesPnael.Find(slot5), function (slot0)
			if slot0 then
				if slot0 == slot1.PROJECTS.ACTIVITY and (not slot2.activity or slot2.activity:isEnd()) then
					setActive(slot3, false)
				else
					slot2:switchProject(slot0)
				end
			end
		end, SFX_PANEL)
	end

	setActive(slot0.projectToggles[slot0.PROJECTS.ACTIVITY], slot0.activity)

	if pg.GuideMgr2:GetInstance().ENABLE_GUIDE then
		slot0.projectName = slot0.contextData.projectName or slot0.PROJECTS.LIGHT
	else
		slot0.projectName = BuildShipScene.projectName or slot0.contextData.projectName or (slot0.activity and slot0.PROJECTS.ACTIVITY) or slot0.PROJECTS.HEAVY
	end

	triggerToggle(slot0.projectToggles[slot0.projectName], true)
end

function slot0.notifacation(slot0, slot1)
	setActive(slot0.tip, slot1 > 0)
end

function slot0.getCurHelpContent(slot0)
	return slot0:getCreateId(slot0.curProjectName), slot0.materialCfg[slot0.getCreateId(slot0.curProjectName)].name, slot0.materialCfg[slot0.getCreateId(slot0.curProjectName)].probability[1] / 100, slot0.materialCfg[slot0.getCreateId(slot0.curProjectName)].probability[2] / 100, slot0.materialCfg[slot0.getCreateId(slot0.curProjectName)].probability[3] / 100, slot0.materialCfg[slot0.getCreateId(slot0.curProjectName)].probability[4] / 100
end

function slot0.switchProject(slot0, slot1)
	slot0.curProjectName = slot1
	BuildShipScene.projectName = slot1

	eachChild(slot0.tagsTF, function (slot0)
		setActive(slot0, go(slot0).name == slot0)
	end)
	eachChild(slot0.descsTF, function (slot0)
		setActive(slot0, go(slot0).name == slot0)
	end)

	slot0.projectBg.sprite = LoadSprite((getProxy(ActivityProxy).getBuildBgActivityByID(slot3, slot0.materialCfg[slot0:getCreateId(slot1)].id) and slot4) or "loadingbg/bg_" .. slot2.icon)

	for slot9 = 1, 2, 1 do
		slot11 = nil

		updateDrop(slot0.itemsPanel:GetChild(slot9 - 1):Find("bg"), (slot9 ~= 1 or {
			count = slot2.number_1,
			type = DROP_TYPE_ITEM,
			id = slot2.use_item
		}) and {
			id = 1,
			type = DROP_TYPE_RESOURCE,
			count = slot2.use_gold
		})
	end

	slot6 = pg.item_data_statistics[slot2.use_item].name

	onButton(slot0, slot0.startBtn, function ()
		slot0:showBuildMsgBox({
			max = math.max(MAX_BUILD_WORK_COUNT - slot0.startCount, 1),
			name = slot1.name,
			price = slot1.use_gold,
			itemCount = slot1.number_1,
			buildId = slot1.id
		})
	end, SFX_UI_BUILDING_STARTBUILDING)
end

function slot0.showBuildMsgBox(slot0, slot1)
	slot0.buildShipCount = 0
	slot0.info = slot1
	slot0.isShowbuildMsgBox = true

	if not slot0.isInitBuildMsgBox then
		slot0.isInitBuildMsgBox = true
		slot0.buildMsgBoxPanel = slot0:findTF("build_msg")
		slot0.buildConfirmBtn = findTF(slot0.buildMsgBoxPanel, "window/bg/button_container/ok_btn")
		slot0.buildCountNext = findTF(slot0.buildMsgBoxPanel, "window/bg/sliders/calc_panel/right_arr")
		slot6 = findTF(slot0.buildMsgBoxPanel, "window/bg/sliders/calc_panel/value_bg/Text"):GetComponent(typeof(Text))
		slot7 = findTF(slot0.buildMsgBoxPanel, "window/bg/sliders/content"):GetComponent(typeof(Text))

		function updateCount(slot0)
			slot0.buildShipCount = math.min(math.max(1, slot0), slot0.info.max)
			slot0.text = slot0.buildShipCount
			slot2 = tonumber(slot0.info.itemCount) * slot0.buildShipCount
			slot3 = COLOR_GREEN

			if slot0.player.gold < tonumber(slot0.info.price) * slot0.buildShipCount or slot0.useItem.count < slot2 then
				slot3 = COLOR_RED
			end

			slot2.text = i18n("build_ship_tip", slot0.buildShipCount, slot0.info.name, slot1, slot2, slot3)
		end

		onButton(slot0, slot2, function ()
			slot0:closeBuildMsgBox()
		end, SFX_PANEL)
		onButton(slot0, slot3, function ()
			slot0:closeBuildMsgBox()
		end, SFX_PANEL)
		onButton(slot0, slot5, function ()
			updateCount(slot0.info.max)
		end, SFX_PANEL)
		onButton(slot0, slot0.buildCountNext, function ()
			updateCount(slot0.buildShipCount + 1)
		end, SFX_PANEL)
		onButton(slot0, findTF(slot0.buildMsgBoxPanel, "window/bg/sliders/calc_panel/left_arr"), function ()
			updateCount(slot0.buildShipCount - 1)
		end, SFX_PANEL)
	end

	triggerButton(slot0.buildCountNext)

	slot2 = pg.ship_data_create_material[slot1.buildId]

	onButton(slot0, slot0.buildConfirmBtn, function ()
		print("buidId：" .. slot0.buildId .. "-- build count : " .. slot1.buildShipCount)

		if slot2.type == slot3.BUILD_TYPE_ACTIVITY then
			slot1:emit(BuildShipMediator.ACT_ON_BUILD, slot1.activity.id, slot0.buildId, slot1.buildShipCount)
		elseif slot2.type == slot3.BUILD_TYPE_NORMAL then
			slot1:emit(BuildShipMediator.ON_BUILD, slot0.buildId, slot1.buildShipCount)
		end

		slot1:closeBuildMsgBox()
	end, SFX_UI_BUILDING_STARTBUILDING)
	setActive(slot0.buildMsgBoxPanel, true)
	pg.UIMgr.GetInstance():BlurPanel(slot0.buildMsgBoxPanel)
end

function slot0.closeBuildMsgBox(slot0)
	if slot0.isShowbuildMsgBox then
		slot0.isShowbuildMsgBox = nil

		setActive(slot0.buildMsgBoxPanel, false)
		pg.UIMgr.GetInstance():UnblurPanel(slot0.buildMsgBoxPanel, slot0._tf)
	end
end

function slot0.willExit(slot0)
	setParent(slot0.blurContainer, slot0._tf)

	if slot0.tweens then
		cancelTweens(slot0.tweens)
	end

	slot0:closeBuildMsgBox()

	if slot0.resPanel then
		slot0.resPanel:exit()

		slot0.resPanel = nil
	end

	slot0:removeActTimer()
end

return slot0
