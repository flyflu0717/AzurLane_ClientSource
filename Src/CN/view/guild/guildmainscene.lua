slot0 = class("GuildMainScene", import("..base.BaseUI"))

function slot0.getUIName(slot0)
	return "GuildMainUI"
end

function slot0.setGuildVO(slot0, slot1)
	slot0.guildVO = slot1
	slot0.logs = slot1.logInfo
end

function slot0.setPlayerVO(slot0, slot1)
	slot0.playerVO = slot1
end

function slot0.setChatMsgs(slot0, slot1)
	slot0.chatMsgs = slot1
end

function slot0.setActivity(slot0, slot1)
	slot0.activity = slot1
end

function slot0.setGuildEvent(slot0, slot1)
	slot0.guildEvent = slot1
end

slot8 = {
	{
		"main",
		i18n("guild_word_home")
	},
	{
		"member",
		i18n("guild_word_member")
	},
	{
		"apply",
		i18n("guild_word_apply")
	},
	{
		"activity",
		i18n("word_activity")
	},
	{
		"boss_activity",
		i18n("word_urgency_event")
	},
	{
		"shop",
		i18n("word_shop")
	},
	{
		"facility",
		i18n("word_facility")
	}
}

function slot0.init(slot0)
	slot0.togglesRoot = slot0:findTF("blur_panel/left_length/tagRoot")
	slot0.applyTip = slot0:findTF("apply/tip", slot0.togglesRoot)
	slot0.back = slot0:findTF("blur_panel/top/title/back")
	slot0.blurPanel = slot0:findTF("blur_panel")
	slot0.overLay = pg.UIMgr:GetInstance().OverlayMain

	setParent(slot0.blurPanel, slot0.overLay)
	setActive(slot1, false)

	slot0.titleApply = slot0:findTF("top/title/bg/title2", slot0.blurPanel)
	slot0.titleFleet = slot0:findTF("top/title/bg/title", slot0.blurPanel)
	slot0.titleText = slot0:findTF("top/title/bg/FLEET", slot0.blurPanel):GetComponent(typeof(Text))
	slot0._bg = slot0:findTF("bg")

	if slot0.bgSprite then
		setImageSprite(slot0._bg, slot0.bgSprite, true)
	end

	slot0._leftLength = findTF(slot0.blurPanel, "left_length")
	slot0._topPanel = findTF(slot0.blurPanel, "top")

	setAnchoredPosition(slot0._topPanel, {
		y = slot0._topPanel.transform.rect.height
	})
	setAnchoredPosition(slot0._leftLength, {
		x = -1 * slot0._leftLength.rect.width
	})
end

function slot0.preload(slot0, slot1)
	if GuildMainMediator.BG then
		GetSpriteFromAtlasAsync(GuildMainMediator.BG, "", function (slot0)
			slot0.bgSprite = slot0

			slot0()
		end)
	else
		slot1()
	end
end

function slot0.uiStartAnimating(slot0)
	shiftPanel(slot0._topPanel, nil, 0, slot2, slot1, true, true)
	shiftPanel(slot0._leftLength, 0, nil, slot2, slot1, true, true)

	slot0.tweens = topAnimation(slot0:findTF("title/bg/left", slot0._topPanel), slot0:findTF("title/bg/right", slot0._topPanel), slot0:findTF("title/bg/title", slot0._topPanel), slot0:findTF("title/bg/FLEET", slot0._topPanel), nil, function ()
		slot0.tweens = nil
	end)
end

function slot0.uiExitAnimating(slot0)
	shiftPanel(slot0._topPanel, nil, slot0._topPanel.rect.height, dur, delay, true, true)
	shiftPanel(slot0._leftLength, -slot0._leftLength.rect.width, nil, dur, delay, true, true)
end

function slot0.updateModifyPanel(slot0)
	slot0.modifyPanel = findTF(slot0.themePanel, "modify_panel")
	slot0.nameInput = findTF(slot0.modifyPanel, "frame/name_container/InputField"):GetComponent(typeof(InputField))
	slot0.factionToggle = findTF(slot0.modifyPanel, "frame/desc_container/faction/switch")
	slot0.policyToggle = findTF(slot0.modifyPanel, "frame/desc_container/policy/switch")
	slot0.manifestoInput = findTF(slot0.modifyPanel, "frame/desc_container/manifesto"):GetComponent(typeof(InputField))
	slot0.confirmBtn = findTF(slot0.modifyPanel, "frame/buttons/confirm_btn")
	slot0.cancelBtn = findTF(slot0.modifyPanel, "frame/buttons/cancel_btn")
	slot0.quitBtn = findTF(slot0.modifyPanel, "frame/buttons/quit_btn")
	slot0.dissolveBtn = findTF(slot0.modifyPanel, "frame/buttons/dissolve_btn")
	slot0.factionMask = findTF(slot0.modifyPanel, "frame/desc_container/faction/mask")
	slot0.costTF = findTF(slot0.modifyPanel, "frame/buttons/confirm_btn/print_container/Text"):GetComponent(typeof(Text))
	slot1 = pg.gameset.modify_guild_cost.key_value or 0
	slot0.costTF.text = 0

	setActive(slot0.modifyPanel, false)
	onButton(slot0, slot0.cancelBtn, function ()
		slot0:closeModifyPanel()
	end, SFX_CANCEL)
	onButton(slot0, slot0.dissolveBtn, function ()
		if slot0.guildVO then
			pg.MsgboxMgr:GetInstance():ShowMsgBox({
				content = i18n("guild_tip_dissolve"),
				onYes = function ()
					slot0:emit(GuildMainMediator.DISSOLVE, slot0.guildVO.id)
				end
			})
		end
	end, SFX_PANEL)
	onButton(slot0, slot0.quitBtn, function ()
		pg.MsgboxMgr:GetInstance():ShowMsgBox({
			content = i18n("guild_tip_quit"),
			onYes = function ()
				slot0:emit(GuildMainMediator.QUIT, slot0.guildVO.id)
			end
		})
	end, SFX_PANEL)
	onButton(slot0, slot0.modifyPanel, function ()
		slot0:closeModifyPanel()
	end, SFX_PANEL)
	onButton(slot0, slot0.confirmBtn, function ()
		slot2 = slot0.manifestoInput.text

		if not slot0.nameInput.text or slot1 == "" then
			pg.TipsMgr:GetInstance():ShowTips(i18n("guild_create_error_noname"))

			return
		end

		if not nameValidityCheck(slot1, 0, 20, {
			"spece_illegal_tip",
			"login_newPlayerScene_name_tooShort",
			"login_newPlayerScene_name_tooLong",
			"err_name_existOtherChar"
		}) then
			return
		end

		if slot1 ~= slot0.guildVO:getName() and getProxy(PlayerProxy):getData():getTotalGem() < pg.gameset.modify_guild_cost.key_value then
			pg.TipsMgr:GetInstance():ShowTips(i18n("common_no_rmb"))

			return
		end

		if not slot2 or slot2 == "" then
			pg.TipsMgr:GetInstance():ShowTips(i18n("guild_create_error_nomanifesto"))

			return
		end

		slot0:setName(slot1)
		slot0:setPolicy(slot0.policy)
		slot0:setFaction(slot0.faction)
		slot0:setManifesto(slot2)

		function slot3()
			if slot0:getPolicy() ~= slot0.guildVO:getPolicy() then
				slot1:emit(GuildMainMediator.MODIFY, 3, slot0:getPolicy(), "")
			end

			if slot0:getManifesto() ~= slot0.guildVO:getManifesto() then
				slot1:emit(GuildMainMediator.MODIFY, 4, 0, slot0:getManifesto())
			end

			if slot0:getName() ~= slot0.guildVO:getName() then
				slot1:emit(GuildMainMediator.MODIFY, 1, 0, slot0:getName())
			end
		end

		if slot0:getFaction() ~= slot0.guildVO:getFaction() then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("guild_faction_change_tip"),
				onYes = function ()
					slot0()
					slot1:emit(GuildMainMediator.MODIFY, 2, slot2:getFaction(), "")
				end
			})
		else
			slot3()
		end
	end, SFX_CONFIRM)
	slot2(slot0.nameInput)
	slot2(slot0.manifestoInput)
	slot0:updateAllLog(slot0.logs)
	slot0:updateAllChat(slot0.chatMsgs)
end

function slot0.didEnter(slot0)
	onButton(slot0, slot0.back, function ()
		if not slot0.loadFinish then
			return
		end

		slot0:uiExitAnimating()
		LeanTween.delayedCall(0.31, System.Action(function ()
			slot0:emit(GuildMainMediator.ON_BACK)
		end))
	end, SOUND_BACK)
	slot0:initTheme()
end

function slot0.updateNotices(slot0, slot1)
	setActive(slot0.applyTip, slot1)
end

function slot0.enterPage(slot0)
	triggerToggle(slot0.toggles[slot0.contextData.page or slot0], true)
end

function slot0.initTheme(slot0)
	slot1 = slot0.guildVO:getFaction()
	slot2 = slot0.guildVO:getMainUIName()

	pg.UIMgr:GetInstance():LoadingOn()

	if not slot0.bgSprite then
		GuildMainMediator.BG = slot0.guildVO:getBgName()

		GetSpriteFromAtlasAsync(GuildMainMediator.BG, "", function (slot0)
			if not IsNil(slot0._bg) then
				setImageSprite(slot0._bg, slot0, true)
			end
		end)
	end

	if not slot0.curFaction or slot0.curFaction ~= slot2 then
		if slot0.themePanel then
			PoolMgr.GetInstance():ReturnUI(slot2, go(slot0.themePanel))
		end

		slot0.themePanel = nil

		PoolMgr.GetInstance():GetUI(slot2, true, function (slot0)
			pg.UIMgr:GetInstance():LoadingOff()

			if slot0.exited then
				PoolMgr.GetInstance():ReturnUI(PoolMgr.GetInstance().ReturnUI, slot0)

				return
			end

			slot0.themePanel = tf(slot0)

			setParent(tf(slot0), slot0:findTF("main"))
			slot0:updateTheme()
			slot0:updateGuildInfo(slot0.guildVO)
			slot0:initToggles()
			slot0:enterPage()
			onNextTick(function ()
				if slot0.exited then
					return
				end

				slot0:uiStartAnimating()
			end)
			slot0:updateAdmin()

			slot0.loadFinish = true
		end)
	else
		slot0:updateGuildInfo(slot0.guildVO)
		pg.UIMgr:GetInstance():LoadingOff()
		slot0:updateAdmin()
	end

	slot0.curFaction = slot2
end

function slot0.onSwitch(slot0, slot1, slot2)
	onToggle(slot0, slot1, function (slot0)
		setActive(slot0:Find("on"), slot0)
		setActive(slot0:Find("off"), not slot0)

		if setActive then
			slot1(slot0)
		end
	end, SFX_PANEL)
end

function slot0.initToggles(slot0)
	slot0.toggles = {}

	for slot4, slot5 in ipairs(slot0) do
		slot0.toggles[slot5[1]] = slot0.togglesRoot:Find(slot6)

		onToggle(slot0, slot0.toggles[slot5[1]], function (slot0)
			if slot0 then
				slot0:openPage(slot0.openPage)
			else
				slot0:closePage(slot0.closePage)
			end
		end, SFX_PANEL)
	end

	slot0:updateEventBtn(getProxy(GuildProxy).eventTip)
	slot1(slot0.toggles[slot1], slot0.activity and not slot0.activity:isEnd())
end

function slot0.updateEventBtn(slot0, slot1)
	if slot0.toggles then
		setActive(slot0.toggles[slot0], slot0.guildEvent and not slot0.guildEvent:isEnd())
		setActive(slot0.toggles[slot0]:Find("tip"), slot1)
	end
end

function slot0.openPage(slot0, slot1)
	if slot0.contextData.page == slot1 then
		return
	end

	setActive(slot0.titleApply, slot1 == slot0)
	setActive(slot0.titleFleet, slot1 == slot1 or slot1 == setActive)

	if slot1 == slot1 then
		setActive(slot0.themePanel, true)

		slot0.titleText.text = "FLEET"
	elseif slot1 == slot2 then
		slot0:emit(GuildMainMediator.OPEN_MEMBER)

		slot0.titleText.text = "FLEET"
	elseif slot1 == slot0 then
		slot0:emit(GuildMainMediator.OPEN_APPLY)

		slot0.titleText.text = "APPLY"
	elseif slot1 == slot3 then
		slot0:emit(GuildMainMediator.OPEN_ACTIVITY)

		slot0.titleText.text = "ACTIVITY"
	elseif slot1 == slot4 then
		slot0:emit(GuildMainMediator.OPEN_BOSS_ACTIVITY, slot0.guildVO.faction)

		slot0.titleText.text = "URGENCY EVENT"
	elseif slot1 == slot5 then
		setParent(slot0.blurPanel, slot0._tf)
		slot0:emit(GuildMainMediator.OPEN_SHOP)

		slot0.titleText.text = "SHOP"
	elseif slot1 == slot6 then
		slot0:emit(GuildMainMediator.OPEN_FACILITY)

		slot0.titleText.text = "FACILITY"
	end

	if slot1 ~= slot5 then
		slot0.contextData.page = slot1
	end
end

function slot0.closePage(slot0, slot1)
	if slot1 == slot0 then
		setActive(slot0.themePanel, false)
		slot0:closeModifyPanel()
	elseif slot1 == slot1 then
		slot0:emit(GuildMainMediator.CLOSE_MEMBER)
	elseif slot1 == slot2 then
		slot0:emit(GuildMainMediator.CLOSE_APPLY)
	elseif slot1 == slot3 then
		slot0:emit(GuildMainMediator.CLOSE_ACTIVITY)
	elseif slot1 == slot4 then
		slot0:emit(GuildMainMediator.CLOSE_BOSS_ACTIVITY)
	elseif slot1 == slot5 then
		setParent(slot0.blurPanel, slot0.overLay)
		slot0:emit(GuildMainMediator.CLOSE_SHOP)
	elseif slot1 == slot6 then
		slot0:emit(GuildMainMediator.CLOSE_FACILITY)
	end
end

function slot0.updateTheme(slot0)
	slot0.nameTF = slot0:findTF("infoPanel/name/Text", slot0.themePanel):GetComponent(typeof(Text))
	slot0.idTF = slot0:findTF("infoPanel/name/IDText", slot0.themePanel):GetComponent(typeof(Text))
	slot0.LevelTF = slot0:findTF("infoPanel/info/lvinfo/LvText", slot0.themePanel):GetComponent(typeof(Text))
	slot0.expTF = slot0:findTF("infoPanel/info/lvinfo/expText", slot0.themePanel):GetComponent(typeof(Text))
	slot0.expSlider = slot0:findTF("infoPanel/info/lvinfo/Slider", slot0.themePanel):GetComponent(typeof(Slider))
	slot0.countTF = slot0:findTF("infoPanel/info/memberinfo/Text", slot0.themePanel):GetComponent(typeof(Text))
	slot0.polity = slot0:findTF("infoPanel/info/polityinfo/Text", slot0.themePanel):GetComponent(typeof(Text))
	slot0.courseinfo = slot0:findTF("infoPanel/info/courseinfo/Text", slot0.themePanel):GetComponent(typeof(Text))
	slot0.announce = slot0:findTF("infoPanel/announce/InputField", slot0.themePanel):GetComponent(typeof(InputField))
	slot0.manifesto = slot0:findTF("infoPanel/desc/Text", slot0.themePanel):GetComponent(typeof(Text))
	slot0.modifyBtn = slot0:findTF("infoPanel/modify", slot0.themePanel)
	slot0.chatContent = slot0:findTF("dialogPanel/list/content", slot0.themePanel)
	slot0.prefabOthers = slot0:findTF("dialogPanel/list/popo_others", slot0.themePanel)
	slot0.prefabSelf = slot0:findTF("dialogPanel/list/popo_self", slot0.themePanel)
	slot0.logContent = slot0:findTF("dialogPanel/system/list/content", slot0.themePanel)
	slot0.prefabPublic = slot0:findTF("dialogPanel/system/popo_public", slot0.themePanel)
	slot0.scroll = slot0:findTF("dialogPanel/system/list", slot0.themePanel):GetComponent(typeof(ScrollRect))
	slot0.scrollChat = slot0:findTF("dialogPanel/list", slot0.themePanel):GetComponent(typeof(ScrollRect))
	slot0.sendBtn = slot0:findTF("dialogPanel/bottom/send", slot0.themePanel)
	slot0.emojiBtn = slot0:findTF("dialogPanel/bottom/emoji", slot0.themePanel)
	slot0.msgInput = slot0:findTF("dialogPanel/bottom/inputbg/input", slot0.themePanel):GetComponent(typeof(InputField))
	slot0.infoPanel = slot0:findTF("infoPanel", slot0.themePanel)
	slot0.dialogPanel = slot0:findTF("dialogPanel", slot0.themePanel)

	setActive(slot0.infoPanel, true)
	setActive(slot0.dialogPanel, true)
	onInputEndEdit(slot0, slot0.announce.gameObject, function (slot0)
		if wordVer(slot0) > 0 then
			pg.TipsMgr:GetInstance():ShowTips(i18n("playerinfo_mask_word"))
			setInputText(slot0.announce, slot0.guildVO.announce)

			return
		end

		if slot0 == "" then
			return
		end

		if slot0 == slot0.guildVO.announce then
			return
		end

		slot0:emit(GuildMainMediator.MODIFY, 5, 0, slot0)
	end)
	onButton(slot0, slot0.modifyBtn, function ()
		slot0:showModifyPanel()
	end, SFX_PANEL)
	onButton(slot0, slot0.sendBtn, function ()
		if wordVer(slot0) > 0 then
			pg.TipsMgr:GetInstance():ShowTips(i18n("playerinfo_mask_word"))

			return
		end

		if slot0 == "" then
			pg.TipsMgr:GetInstance():ShowTips(i18n("guild_msg_is_null"))

			return
		end

		if slot0.chatTimer and pg.TimeMgr.GetInstance():GetServerTime() - slot0.chatTimer < 5 then
			pg.TipsMgr:GetInstance():ShowTips(i18n("dont_send_message_frequently"))

			return
		end

		slot0.chatTimer = pg.TimeMgr.GetInstance():GetServerTime()

		slot0:emit(GuildMainMediator.SEND_MSG, slot0)

		slot0.msgInput.text = ""
	end, SFX_PANEL)
	onButton(slot0, slot0.emojiBtn, function ()
		slot0:emit(GuildMainMediator.OPEN_EMOJI, function (slot0)
			slot0:emit(GuildMainMediator.SEND_MSG, string.gsub(ChatConst.EmojiCode, "code", slot0))
		end)
	end, SFX_PANEL)
	slot0:updateModifyPanel()
end

function slot0.updateAdmin(slot0)
	if IsNil(slot0.themePanel) then
		return
	end

	slot0.announce.interactable = slot0.guildVO:getDutyByMemberId(slot0.playerVO.id) == GuildMember.DUTY_COMMANDER or slot1 == GuildMember.DUTY_DEPUTY_COMMANDER

	setActive(slot0.toggles[slot0], slot1 == GuildMember.DUTY_COMMANDER or slot1 == GuildMember.DUTY_DEPUTY_COMMANDER)
	setActive(slot0.quitBtn, slot1 ~= GuildMember.DUTY_COMMANDER)
	setActive(slot0.dissolveBtn, slot1 == GuildMember.DUTY_COMMANDER)
end

function slot0.showModifyPanel(slot0)
	slot0.isShowModify = true

	setActive(slot0.modifyPanel, true)
	setActive(slot0.infoPanel, false)
	setActive(slot0.dialogPanel, false)

	slot0.nameInput.text = slot0.guildVO:getName()
	slot0.manifestoInput.text = slot0.guildVO.manifesto
	slot0.nameInput.interactable = slot0.guildVO:getDutyByMemberId(slot0.playerVO.id) == GuildMember.DUTY_COMMANDER
	slot0.manifestoInput.interactable = slot0.guildVO.getDutyByMemberId(slot0.playerVO.id) == GuildMember.DUTY_COMMANDER

	setActive(slot0.confirmBtn, slot0.guildVO.getDutyByMemberId(slot0.playerVO.id) == GuildMember.DUTY_COMMANDER)
	setActive(slot0.cancelBtn, slot0.guildVO.getDutyByMemberId(slot0.playerVO.id) == GuildMember.DUTY_COMMANDER)
	setActive(slot0.factionMask, slot0.guildVO:inChangefactionTime())

	if slot0.guildVO:inChangefactionTime() then
		setText(slot0:findTF("timer_container/Text", slot0.factionMask), slot0.guildVO:changeFactionLeftTime())
	end

	slot0.policy = slot0.guildVO:getPolicy()

	slot0:onSwitch(slot0.policyToggle, function (slot0)
		slot0.policy = (slot0 and Guild.POLICY_TYPE_POWER) or Guild.POLICY_TYPE_RELAXATION
	end)

	slot0.faction = slot0.guildVO:getFaction()

	slot0:onSwitch(slot0.factionToggle, function (slot0)
		slot0.faction = (slot0 and Guild.FACTION_TYPE_BLHX) or Guild.FACTION_TYPE_CSZZ
	end)
	triggerToggle(slot0.policyToggle, slot0.guildVO:getPolicy() == Guild.POLICY_TYPE_POWER)
	triggerToggle(slot0.factionToggle, slot0.guildVO:getFaction() == Guild.FACTION_TYPE_BLHX)

	slot0.factionToggle:GetComponent(typeof(Toggle)).interactable = slot1
	slot0.policyToggle:GetComponent(typeof(Toggle)).interactable = slot1
end

function slot0.closeModifyPanel(slot0)
	if slot0.isShowModify then
		slot0.isShowModify = nil

		setActive(slot0.modifyPanel, false)
		setActive(slot0.infoPanel, true)
		setActive(slot0.dialogPanel, true)
	end
end

function slot0.updateGuildInfo(slot0, slot1)
	if IsNil(slot0.themePanel) then
		return
	end

	slot0.nameTF.text = slot1:getName()
	slot0.idTF.text = slot1.id
	slot0.LevelTF.text = slot1.level
	slot0.expTF.text = slot1.exp .. "/" .. slot1:getLevelMaxExp()
	slot0.countTF.text = slot1.memberCount .. "/" .. slot1:getMaxMember()
	slot0.polity.text = slot1:getFactionName()
	slot0.courseinfo.text = slot1:getPolicyName()
	slot0.manifesto.text = slot1.manifesto
	slot0.announce.text = slot1.announce
	slot0.expSlider.value = slot1.exp / math.max(slot1:getLevelMaxExp(), 1)
end

function slot0.updateAllChat(slot0, slot1)
	removeAllChildren(slot0.chatContent)

	slot3 = {}
	slot0.index = math.max(1, #(slot1 or {}) - Guild.CHAT_LOG_MAX_COUNT)

	for slot7 = slot0.index, #slot2, 1 do
		table.insert(slot3, function (slot0)
			slot0:append(slot1[slot2], -1)
			slot0()
		end)
	end

	seriesAsync(slot3, function ()
		onNextTick(function ()
			if not IsNil(slot0.chatContent) then
				scrollToBottom(slot0.chatContent.parent)
			end
		end)
	end)
end

function slot0.append(slot0, slot1, slot2, slot3)
	if IsNil(slot0.themePanel) then
		return
	end

	if slot0.chatContent.childCount >= Guild.CHAT_LOG_MAX_COUNT * 2 then
		slot0:emit(GuildMainMediator.REBUILD_ALL)
	else
		slot0:appendWorld(slot1, slot2)

		if slot3 then
			scrollToBottom(slot0.chatContent.parent)
		end
	end
end

function slot0.appendWorld(slot0, slot1, slot2)
	slot4 = slot0.prefabOthers

	if slot1.player.id == slot0.playerVO.id then
		slot4 = slot0.prefabSelf
	end

	slot6 = ChatBubble.New(slot5)

	if slot2 >= 0 then
		slot6.tf:SetSiblingIndex(slot2)
	end

	slot6:update(slot1)
end

function slot0.updateAllLog(slot0, slot1)
	removeAllChildren(slot0.logContent)

	for slot5, slot6 in ipairs(slot1) do
		slot0:appendLog(slot6)
	end
end

function slot0.appendLog(slot0, slot1, slot2)
	if IsNil(slot0.themePanel) then
		return
	end

	if slot0.logContent.childCount >= 200 then
		slot0:emit(GuildMainMediator.ON_REBUILD_LOG_ALL)
	else
		slot3 = cloneTplTo(slot0.prefabPublic, slot0.logContent)

		if slot2 then
			slot3:SetAsFirstSibling()
		end

		slot4 = slot3:Find("content/text"):GetComponent("RichText")
		slot5 = slot3:Find("content/time"):GetComponent(typeof(Text))
		slot6, slot7 = slot1:getConent()

		if slot1.cmd == GuildLogInfo.CMD_TYPE_GET_SHIP then
			ChatProxy.InjectPublic(slot4, slot6)
		else
			slot4.text = slot6
		end

		slot5.text = slot7
	end
end

function slot0.willExit(slot0)
	if slot0.tweens then
		cancelTweens(slot0.tweens)
	end

	slot0:closeModifyPanel()

	if slot0.themePanel then
		PoolMgr.GetInstance():ReturnUI(slot0.guildVO:getMainUIName(), go(slot0.themePanel))
	end

	setParent(slot0.blurPanel, slot0._tf)
end

return slot0
