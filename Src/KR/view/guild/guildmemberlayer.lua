slot0 = class("GuildMemberLayer", import("..base.BaseUI"))

function slot0.setGuildVO(slot0, slot1)
	slot0.guildVO = slot1

	slot0:setMemberVOs(slot1:getSortMember())
end

function slot0.setMemberVOs(slot0, slot1)
	slot0.memberVOs = slot1
end

function slot0.setPlayerVO(slot0, slot1)
	slot0.playerVO = slot1
end

function slot0.getUIName(slot0)
	return "GuildMemberUI"
end

function slot0.init(slot0)
	slot0.Timer = {}
	slot0.rightPanel = slot0:findTF("right_panel")
	slot0.rectView = slot0:findTF("right_panel/rect_view")
	slot0.paintingTF = slot0:findTF("painting")
	slot0.buttonsPanel = slot0:findTF("buttons_panel")
	slot0.infoBtn = slot0:findTF("buttons_panel/info_btn")
	slot0.dutyBtn = slot0:findTF("buttons_panel/duty_btn")
	slot0.fireBtn = slot0:findTF("buttons_panel/fire_btn")
	slot0.impeachBtn = slot0:findTF("buttons_panel/impeach_btn")
	slot0.appiontPanel = slot0:findTF("appoint_panel")

	setActive(slot0.appiontPanel, false)

	slot0.dutyContainer = slot0:findTF("appoint_panel/frame/dutys/container")
	slot0.confirmBtn = slot0:findTF("appoint_panel/frame/confirm")
	slot0.cancelBtn = slot0:findTF("appoint_panel/frame/cancel")
	slot0.nameTF = slot0:findTF("frame/name/Text", slot0.appiontPanel):GetComponent(typeof(Text))
	slot0.iconTF = slot0:findTF("frame/icon_contain/icon", slot0.appiontPanel):GetComponent(typeof(Image))
	slot0.starsTF = slot0:findTF("frame/icon_contain/stars", slot0.appiontPanel)
	slot0.starTF = slot0:findTF("frame/icon_contain/stars/star", slot0.appiontPanel)
	slot0.levelTF = slot0:findTF("frame/icon_contain/lv/Text", slot0.appiontPanel):GetComponent(typeof(Text))
	slot0.proposeTF = slot0:findTF("frame/icon_contain/propose", slot0.appiontPanel)
	slot0.sortBtn = slot0:findTF("right_panel/sort_button")
	slot0.sortPanel = slot0:findTF("right_panel/sort_panel")
	slot0.sortItem = slot0:getTpl("mask/panel/tpl", slot0.sortPanel)
	slot0.sortContainer = slot0:findTF("mask/panel", slot0.sortPanel)
	slot0.ascBtn = slot0:findTF("right_panel/asc_button")
	slot0.sortImgAsc = slot0:findTF("asc", slot0.ascBtn)
	slot0.sortImgDesc = slot0:findTF("desc", slot0.ascBtn)
	slot0.chatPanel = slot0:findTF("painting/chat")

	setActive(slot0.chatPanel, false)
	setActive(slot0.buttonsPanel, false)
end

function slot0.didEnter(slot0)
	slot0:initMembers()
	onButton(slot0, slot0.ascBtn, function ()
		slot0.selectAsc = not slot0.selectAsc

		slot0:sortMembers()
	end, SFX_CANCEL)
	onButton(slot0, slot0.appiontPanel, function ()
		slot0:closeAppointPanel()
	end, SFX_PANEL)
	onButton(slot0, slot0.sortBtn, function ()
		if go(slot0.sortPanel).activeSelf then
			slot0:closeSortPanel()
		else
			slot0:showSortPanel()
		end
	end, SFX_PANEL)
	onButton(slot0, slot0.sortPanel, function ()
		slot0:closeSortPanel()
	end, SFX_PANEL)
end

slot1 = {
	{
		{
			"preOnLineTime"
		},
		"sort_time"
	},
	{
		{
			"level"
		},
		"sort_lv"
	},
	{
		{
			"duty"
		},
		"sort_duty"
	}
}

function slot0.initSortPanel(slot0)
	for slot4, slot5 in ipairs(slot0) do
		slot6 = cloneTplTo(slot0.sortItem, slot0.sortContainer)

		setImageSprite(slot6:Find("Image"), slot7, true)
		onToggle(slot0, slot6, function (slot0)
			if slot0 then
				slot0.sortIndex = slot0

				slot0:sortMembers()
				setActive(slot0.sortPanel, false)
			end
		end, SFX_PANEL)
	end
end

function slot0.initMembers(slot0)
	pg.UIMgr:GetInstance():LoadingOn()

	slot0.rectRect = slot0.rectView:GetComponent("LScrollRect")

	function slot0.rectRect.onInitItem(slot0)
		slot0:onInitItem(slot0)
	end

	function slot0.rectRect.onUpdateItem(slot0, slot1)
		slot0:onUpdateItem(slot0, slot1)
	end

	function slot0.rectRect.onStart()
		pg.UIMgr:GetInstance():LoadingOff()
		pg.UIMgr.GetInstance().LoadingOff:reloadPainting()
	end

	slot0.items = {}

	slot0:sortMembers()
end

function slot0.reloadPainting(slot0)
	for slot4, slot5 in pairs(slot0.items) do
		if slot5.memberVO.id == slot0.memberVOs[1].id then
			triggerButton(slot5.tf)

			break
		end
	end
end

function slot0.createMemberCard(slot0, slot1)
	function slot3(slot0, slot1)
		if slot0.Timer[slot0] then
			slot0.Timer[slot0]:Stop()

			slot0.Timer[slot0] = nil
		end

		slot0.Timer[slot0] = Timer.New(slot1, 1, -1)

		slot0.Timer[slot0]:Start()
		slot0.Timer[slot0].func()
	end

	return {
		go = slot1,
		tf = tf(slot1),
		iconTF = ()["tf"]:Find("icon_contain/icon"):GetComponent(typeof(Image)),
		starsTF = ()["tf"]:Find("icon_contain/stars"),
		starTF = ()["tf"]:Find("icon_contain/stars/star"),
		levelTF = ()["tf"]:Find("icon_contain/lv/Text"):GetComponent(typeof(Text)),
		nameTF = ()["tf"]:Find("name"):GetComponent(typeof(Text)),
		dutyTF = ()["tf"]:Find("duty"):GetComponent(typeof(Image)),
		livenessTF = ()["tf"]:Find("liveness_container/Text"):GetComponent(typeof(Text)),
		onLine = ()["tf"]:Find("online"),
		offLine = ()["tf"]:Find("offline_container"),
		onLineLabel = ()["tf"]:Find("online_label"),
		offLineLabel = ()["tf"]:Find("offline_label"),
		offLineText = ()["tf"]:Find("offline_container/Text"):GetComponent(typeof(Text)),
		maskTF = ()["tf"]:Find("mask"),
		timerTF = ()["tf"]:Find("mask/Text"):GetComponent(typeof(Text)),
		borderTF = ()["tf"]:Find("check_mark"),
		propose = ()["tf"]:Find("icon_contain/propose"),
		update = function (slot0, slot1, slot2, slot3)
			setActive(slot0.borderTF, slot3)

			slot0.memberVO = slot1

			LoadSpriteAsync("qicon/" .. Ship.New({
				configId = slot1.icon,
				skin_id = slot1.skinId,
				propose = slot1.proposeTime
			}).getPainting(slot5), function (slot0)
				if not IsNil(slot0.iconTF) then
					slot0.iconTF.sprite = slot0
				end
			end)
			LoadSpriteAsync("dutyicon/" .. slot1.duty, function (slot0)
				if not IsNil(slot0.dutyTF) then
					slot0.dutyTF.sprite = slot0

					slot0.dutyTF:SetNativeSize()
				end
			end)

			for slot10 = slot0.starsTF.childCount, pg.ship_data_statistics[slot1.icon].star - 1, 1 do
				cloneTplTo(slot0.starTF, slot0.starsTF)
			end

			for slot10 = 1, slot6, 1 do
				setActive(slot0.starsTF:GetChild(slot10 - 1), slot10 <= slot4.star)
			end

			slot0.levelTF.text = slot1.level
			slot0.nameTF.text = slot1.name
			slot0.livenessTF.text = slot1.liveness

			setActive(slot0.onLine, slot1:isOnline())
			setActive(slot0.offLine, not slot1:isOnline())
			setActive(slot0.onLineLabel, slot1:isOnline())
			setActive(slot0.offLineLabel, not slot1:isOnline())
			setActive(slot0.propose, slot5.propose)

			if not slot1:isOnline() then
				slot0.offLineText.text = getOfflineTimeStamp(slot1.preOnLineTime)
			end

			setActive(slot0.maskTF, slot1.duty == GuildMember.DUTY_COMMANDER and slot2:inKickTime())

			if slot1.duty == GuildMember.DUTY_COMMANDER and slot2.inKickTime() then
				slot1(slot1.id, function ()
					if slot0:getKickLeftTime() > 0 then
						slot1.timerTF.text = pg.TimeMgr.GetInstance():DescCDTime(slot0)
					else
						slot1.timerTF.text = ""

						setActive(slot1.maskTF, false)
					end
				end)
			end
		end
	}
end

function slot0.onInitItem(slot0, slot1)
	onButton(slot0, slot0:createMemberCard(slot1).tf, function ()
		setActive(slot0.borderTF, true)

		if slot1.curItemId and slot1.curItemId ~= slot0.memberVO.id and slot1:getItemById(slot1.curItemId) then
			setActive(slot0.borderTF, false)
		end

		slot1:loadPainting(slot0.memberVO)

		slot1.curItemId = slot0.memberVO.id
	end, SFX_PANEL)

	slot0.items[slot1] = slot0.createMemberCard(slot1)
end

function slot0.getItemById(slot0, slot1)
	for slot5, slot6 in pairs(slot0.items) do
		if slot6.memberVO.id == slot1 then
			return slot6
		end
	end
end

function slot0.loadPainting(slot0, slot1)
	slot2 = slot1.duty
	slot3 = slot0.guildVO:getDutyByMemberId(slot0.playerVO.id)

	setActive(slot0.buttonsPanel, true)

	if not slot1.manifesto or slot1.manifesto == "" then
		setActive(slot0.chatPanel, false)
	else
		setActive(slot0.chatPanel, true)
		setText(slot0:findTF("Text", slot0.chatPanel), slot1.manifesto)
	end

	pg.UIMgr:GetInstance():LoadingOn()
	setPaintingPrefabAsync(slot0.paintingTF, Ship.New({
		configId = slot1.icon,
		skin_id = slot1.skinId
	}).getPainting(slot4), "chuanwu", function ()
		pg.UIMgr:GetInstance():LoadingOff()
	end)
	onButton(slot0, slot0.infoBtn, function ()
		slot0:emit(GuildMemberMediator.OPEN_DESC_INFO, slot0)
	end, SFX_PANEL)
	onButton(slot0, slot0.dutyBtn, function ()
		if slot0.id == slot1.playerVO.id then
			return
		end

		slot1:showAppointPanel(slot1.showAppointPanel)
	end, SFX_PANEL)
	onButton(slot0, slot0.fireBtn, function ()
		if slot0.id == slot1.playerVO.id then
			return
		end

		pg.MsgboxMgr:GetInstance():ShowMsgBox({
			content = i18n("guild_fire_tip"),
			onYes = function ()
				slot0:emit(GuildMemberMediator.FIRE, slot1.id)
			end
		})
	end, SFX_PANEL)
	onButton(slot0, slot0.impeachBtn, function ()
		if slot0.id == slot1.playerVO.id then
			return
		end

		pg.MsgboxMgr:GetInstance():ShowMsgBox({
			content = i18n("guild_impeach_tip"),
			onYes = function ()
				slot0:emit(GuildMemberMediator.IMPEACH, slot1.id)
			end
		})
	end, SFX_PANEL)
	setActive(slot0.impeachBtn, slot3 == GuildMember.DUTY_DEPUTY_COMMANDER and slot2 == GuildMember.DUTY_COMMANDER and slot1:isLongOffLine())
	setButtonEnabled(slot0.dutyBtn, (slot3 == GuildMember.DUTY_DEPUTY_COMMANDER or slot3 == GuildMember.DUTY_COMMANDER) and slot3 < slot2)
	setGray(slot0.dutyBtn, not ((slot3 == GuildMember.DUTY_DEPUTY_COMMANDER or slot3 == GuildMember.DUTY_COMMANDER) and slot3 < slot2), true)
	setButtonEnabled(slot0.fireBtn, (slot3 == GuildMember.DUTY_DEPUTY_COMMANDER or slot3 == GuildMember.DUTY_COMMANDER) and slot3 < slot2)
	setGray(slot0.fireBtn, not ((slot3 == GuildMember.DUTY_DEPUTY_COMMANDER or slot3 == GuildMember.DUTY_COMMANDER) and slot3 < slot2), true)
end

slot2 = {
	"commander",
	"deputyCommander",
	"picked",
	"normal"
}

function slot0.showAppointPanel(slot0, slot1)
	slot0.isShowAppoint = true

	pg.UIMgr.GetInstance():BlurPanel(slot0.appiontPanel)
	setActive(slot0.appiontPanel, true)

	if slot0.selectedToggle then
		setActive(slot0.selectedToggle:Find("Image"), false)
	end

	slot3 = slot0.guildVO:getEnableDuty(slot2, slot1.duty)
	slot4 = nil

	for slot8, slot9 in ipairs(slot0) do
		setToggleEnabled(slot10, table.contains(slot3, slot8))
		onToggle(slot0, slot0.dutyContainer:Find(slot9), function (slot0)
			if slot0 then
				slot0 = slot1
				slot2.selectedToggle = slot3
			end
		end, SFX_PANEL)
	end

	slot0.nameTF.text = i18n("guild_set_duty_title", slot1.name)

	setActive(slot0.proposeTF, slot1.propose)
	LoadSpriteAsync("qicon/" .. Ship.New({
		configId = slot1.icon,
		skin_id = slot1.skinId
	}).getPainting(slot6), function (slot0)
		if not IsNil(slot0.iconTF) then
			slot0.iconTF.sprite = slot0
		end
	end)

	for slot11 = slot0.starsTF.childCount, pg.ship_data_statistics[slot1.icon].star - 1, 1 do
		cloneTplTo(slot0.starTF, slot0.starsTF)
	end

	for slot11 = 1, slot7, 1 do
		setActive(slot0.starsTF:GetChild(slot11 - 1), slot11 <= slot5.star)
	end

	slot0.levelTF.text = slot1.level

	onButton(slot0, slot0.confirmBtn, function ()
		slot0:setDuty(slot1.id, )
	end, SFX_CONFIRM)
	onButton(slot0, slot0.cancelBtn, function ()
		slot0:closeAppointPanel()
	end, SFX_CANCEL)
end

function slot0.setDuty(slot0, slot1, slot2)
	slot0:emit(GuildMemberMediator.SET_DUTY, slot1, slot2)
end

function slot0.closeAppointPanel(slot0)
	slot0.isShowAppoint = nil

	pg.UIMgr.GetInstance():UnblurPanel(slot0.appiontPanel, slot0._tf)
	setActive(slot0.appiontPanel, false)
end

function slot0.onUpdateItem(slot0, slot1, slot2)
	if not slot0.items[slot2] then
		slot0:onInitItem(slot2)

		slot3 = slot0.items[slot2]
	end

	slot3:update(slot0.memberVOs[slot1 + 1], slot0.guildVO, slot0.memberVOs[slot1 + 1].id == slot0.curItemId)
end

function slot0.sortMembers(slot0)
	if not slot0.sortIndex then
		slot0.sortIndex = slot0[3]
	end

	slot1 = slot0.sortIndex[1]
	slot2 = slot0.sortIndex[2]

	if slot0.selectAsc then
		table.sort(slot0.memberVOs, function (slot0, slot1)
			if slot0[slot0[1]] == slot1[slot0[1]] then
				return slot1.duty < slot0.duty
			elseif slot0[1] == "duty" then
				return slot1[slot0[1]] < slot0[slot0[1]]
			else
				return slot0[slot0[1]] < slot1[slot0[1]]
			end
		end)
	else
		table.sort(slot0.memberVOs, function (slot0, slot1)
			if slot0[slot0[1]] == slot1[slot0[1]] then
				return slot0.duty < slot1.duty
			elseif slot0[1] == "duty" then
				return slot0[slot0[1]] < slot1[slot0[1]]
			else
				return slot1[slot0[1]] < slot0[slot0[1]]
			end
		end)
	end

	setActive(slot0.sortImgAsc, slot0.selectAsc)
	setActive(slot0.sortImgDesc, not slot0.selectAsc)
	slot0.rectRect:SetTotalCount(#slot0.memberVOs, 0)
	setImageSprite(slot0:findTF("Image", slot0.sortBtn), GetSpriteFromAtlas("ui/guildmemberui_atlas", slot2 .. "_selected"), true)
end

function slot0.showSortPanel(slot0)
	slot0.isShowSortPanel = true

	setActive(slot0.sortPanel, true)

	if not slot0.isInitSort then
		slot0.isInitSort = true

		slot0:initSortPanel()
	end
end

function slot0.closeSortPanel(slot0)
	slot0.isShowSortPanel = nil

	setActive(slot0.sortPanel, false)
end

function slot0.onBackPressed(slot0)
	if slot0.isShowSortPanel then
		slot0:closeSortPanel()
	elseif slot0.isShowAppoint then
		slot0:closeAppointPanel()
	else
		playSoundEffect(SFX_CANCEL)
		slot0:emit(slot0.ON_BACK)
	end
end

function slot0.willExit(slot0)
	slot0:closeAppointPanel()
	slot0:closeSortPanel()

	for slot4, slot5 in pairs(slot0.Timer) do
		slot5:Stop()
	end

	slot0.Timer = nil
end

return slot0
