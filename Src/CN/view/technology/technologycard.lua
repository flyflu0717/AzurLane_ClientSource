slot0 = class("TechnologyCard")

function slot0.Ctor(slot0, slot1, slot2)
	slot0.view = slot2

	pg.DelegateInfo.New(slot0)

	slot0._tf = slot1
	slot0.go = go(slot1)
	slot0.itemTpl = slot1:Find("equipment_tpl")
	slot0.leftPanel = slot1:Find("left_panel")
	slot0.nameTxt = findTF(slot0.leftPanel, "name"):GetComponent(typeof(Text))
	slot0.awards = findTF(slot0.leftPanel, "awards")
	slot0.startBtn = findTF(slot0.leftPanel, "start_btn")
	slot0.finishedLabel = findTF(slot0.leftPanel, "finished_label")
	slot0.conditionL = findTF(slot0.leftPanel, "condition")
	slot0.stopBtn = findTF(slot0.leftPanel, "stop_btn")
	slot0.timeL = findTF(slot0.leftPanel, "time")
	slot0.timeLTxt = findTF(slot0.leftPanel, "time/Text"):GetComponent(typeof(Text))
	slot0.timeLSlider = findTF(slot0.leftPanel, "time/time_slider"):GetComponent(typeof(Slider))
	slot0.conditionLTxt = findTF(slot0.leftPanel, "condition/Text"):GetComponent(typeof(Text))
	slot0.conditionLSlider = findTF(slot0.leftPanel, "condition/time_slider"):GetComponent(typeof(Slider))
	slot0.conditionLSliderTxt = findTF(slot0.leftPanel, "condition/time_slider/Text"):GetComponent(typeof(Text))
	slot0.rightPanel = slot1:Find("right_panel")
	slot0.descTxt = findTF(slot0.rightPanel, "desc/Text"):GetComponent(typeof(Text))
	slot0.timeTxt = findTF(slot0.rightPanel, "time/Text"):GetComponent(typeof(Text))
	slot0.consumeContainer = findTF(slot0.rightPanel, "consume/res")
	slot0.conditionPanel = findTF(slot0.rightPanel, "condition")
	slot0.conditionTxt = findTF(slot0.rightPanel, "condition/Text"):GetComponent(typeof(Text))
end

function slot0.updateAll(slot0, slot1)
	slot0.technologyVO = slot1

	slot0:updateRightPanel()
	slot0:updateLeftPanel()
end

function slot0.updateLeftPanel(slot0)
	slot0.nameTxt.text = slot0.technologyVO:getConfig("name")

	for slot6 = slot0.awards.childCount, #slot0.technologyVO:getConfig("drop_client") - 1, 1 do
		cloneTplTo(slot0.itemTpl, slot0.awards)
	end

	for slot6 = 1, slot0.awards.childCount, 1 do
		setActive(slot0.awards:GetChild(slot6 - 1), slot6 <= #slot2)

		if slot6 <= #slot2 then
			updateDrop(slot7:Find("bg"), {
				type = slot2[slot6][1],
				id = slot2[slot6][2],
				count = slot2[slot6][3]
			})
		end
	end

	slot0:updateState()
end

function slot0.updateState(slot0)
	setActive(slot0.startBtn, slot0.technologyVO:getState() == Technology.STATE_IDLE)
	setActive(slot0.finishedLabel, slot1 == Technology.STATE_FINISHED)
	setActive(slot0.conditionL, slot1 == Technology.STATE_STARTING)
	setActive(slot0.timeL, slot1 == Technology.STATE_STARTING)
	setActive(slot0.stopBtn, slot1 == Technology.STATE_STARTING)
	slot0:removeTimer()
	removeOnButton(slot0._tf)

	if slot1 == Technology.STATE_IDLE then
		onButton(slot0, slot0.startBtn, function ()
			pg.MsgboxMgr:GetInstance():ShowMsgBox({
				content = i18n("blueprint_build_consume", getDropInfo(slot0.technologyVO:getConfig("consume"))),
				onYes = function ()
					slot0.view:emit(TechnologyMediator.ON_START, slot0.technologyVO.id)
				end
			})
		end, SFX_PANEL)
	else
		if slot1 == Technology.STATE_STARTING then
			slot2 = slot0.technologyVO:getFinishTime()

			function slot3()
				slot0:removeTimer()
				slot0.removeTimer.view:emit(TechnologyMediator.ON_TIME_OVER, slot0.technologyVO.id)

				slot0.removeTimer.view.emit.timeLTxt.text = "00:00:00"
				slot0.removeTimer.view.emit.timeLTxt.timeLSlider.value = 1
			end

			slot0.startingTimer = Timer.New(function ()
				if slot0 - pg.TimeMgr:GetInstance():GetServerTime() < 0 then
					slot1()
				else
					slot2.timeLTxt.text = pg.TimeMgr:GetInstance():DescCDTime(slot0 - slot0)
					slot2.timeLSlider.value = (slot0 - slot0) / slot2.technologyVO:getConfig("time")
				end
			end, 1, -1)

			slot0.startingTimer:Start()
			slot0.startingTimer.func()
			setActive(slot0.conditionL, slot0.technologyVO:hasCondition())

			if slot0.technologyVO.hasCondition() then
				slot6 = slot0:getTaskById(slot5)
				slot0.conditionLTxt.text = slot6:getConfig("desc")
				slot0.conditionLSlider.value = slot6.progress / slot6:getConfig("target_num")
				slot0.conditionLSliderTxt = slot6.progress .. "/" .. slot6:getConfig("target_num")
			end

			onButton(slot0, slot0.stopBtn, function ()
				pg.MsgboxMgr:GetInstance():ShowMsgBox({
					content = i18n("blueprint_stop_tip"),
					onYes = function ()
						slot0.view:emit(TechnologyMediator.ON_STOP, slot0.technologyVO.id)
					end
				})
			end, SFX_PANEL)

			return
		end

		if slot1 == Technology.STATE_FINISHED then
			onButton(slot0, slot0._tf, function ()
				slot0.view:emit(TechnologyMediator.ON_FINISHED, slot0.technologyVO.id)
			end, SFX_PANEL)
		end
	end
end

function slot0.getTaskById(slot0, slot1)
	return getProxy(TaskProxy):getTaskById(slot1) or Task.New({
		id = slot1
	})
end

function slot0.updateRightPanel(slot0)
	slot0.descTxt.text = slot0.technologyVO:getConfig("des")
	slot0.timeTxt.text = pg.TimeMgr.GetInstance():DescCDTime(slot1)

	for slot7 = slot0.consumeContainer.childCount, #slot0.technologyVO:getConfig("consume") - 1, 1 do
		cloneTplTo(slot0.itemTpl, slot0.consumeContainer)
	end

	for slot7 = 1, slot0.consumeContainer.childCount, 1 do
		setActive(slot0.consumeContainer:GetChild(slot7 - 1), slot7 <= #slot2)

		if slot7 <= #slot2 then
			updateDrop(slot8:Find("bg"), {
				type = slot2[slot7][1],
				id = slot2[slot7][2],
				count = slot2[slot7][3]
			})
		end
	end

	setActive(slot0.conditionPanel, slot0.technologyVO:hasCondition())

	if slot0.technologyVO.hasCondition() then
		slot0.conditionTxt.text = slot0:getTaskById(slot5):getConfig("desc")
	end
end

function slot0.removeTimer(slot0)
	if slot0.startingTimer then
		slot0.startingTimer:Stop()

		slot0.startingTimer = nil
	end
end

function slot0.clear(slot0)
	slot0:removeTimer()
	pg.DelegateInfo.Dispose(slot0)
end

return slot0
