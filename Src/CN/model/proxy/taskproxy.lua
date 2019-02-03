slot0 = class("TaskProxy", import(".NetProxy"))
slot0.TASK_ADDED = "task added"
slot0.TASK_UPDATED = "task updated"
slot0.TASK_REMOVED = "task removed"
slot0.TASK_FINISH = "task finish"
mingshiTriggerId = 1
mingshiActivityId = 21
changdaoActivityId = 10006
changdaoTaskStartId = 5031

function slot0.register(slot0)
	slot0:on(20001, function (slot0)
		slot0.data = {}
		slot0.finishData = {}

		for slot4, slot5 in ipairs(slot0.info) do
			if Task.New(slot5):getConfigTable() ~= nil then
				slot6:display("loaded")

				if slot6:getTaskStatus() ~= 2 then
					slot0.data[slot6.id] = slot6
				else
					slot0.finishData[slot6.id] = slot6
				end
			else
				pg.TipsMgr:GetInstance():ShowTips(i18n("task_notfound_error") .. tostring(slot5.id))
				Debugger.LogWarning("Missing Task Config, id :" .. tostring(slot5.id))
			end
		end

		getProxy(TechnologyProxy):updateBlueprintStates()
	end)
	slot0:on(20002, function (slot0)
		for slot4, slot5 in ipairs(slot0.info) do
			if slot0.data[slot5.id] ~= nil then
				slot6.progress = slot5.progress

				slot0:updateTask(slot6)

				if slot6:getConfig("type") == 10 and slot6:isFinish() then
					slot0:sendNotification(GAME.SUBMIT_TASK, slot6.id)
				end
			end
		end
	end)
	slot0:on(20003, function (slot0)
		if slot0.onAchieved then
			slot0:addTmpTask(slot0)

			return
		end

		for slot4, slot5 in ipairs(slot0.info) do
			slot6 = Task.New(slot5)

			slot0:addTask(slot6)

			if slot6:getConfig("type") == 10 and slot6:isFinish() then
				slot0:sendNotification(GAME.SUBMIT_TASK, slot6.id)
			end
		end
	end)
	slot0:on(20004, function (slot0)
		for slot4, slot5 in ipairs(slot0.id_list) do
			slot0:removeTaskById(slot5)
		end
	end)

	slot0.taskTriggers = {}
end

function slot0.getTaskForBluePrint(slot0, slot1)
	if not slot0:getTaskById(slot1) and slot0.finishData then
		slot2 = slot0:getFinishTaskById(slot1)
	end

	return slot2
end

function slot0.getTasksForBluePrint(slot0)
	slot1 = {}
	slot2 = pairs
	slot3 = slot0.data or {}

	for slot5, slot6 in slot2(slot3) do
		slot1[slot6.id] = slot6
	end

	for slot5, slot6 in pairs(slot0.finishData) do
		slot1[slot6.id] = slot6
	end

	return slot1
end

function slot0.setOnAchieved(slot0, slot1)
	slot0.onAchieved = slot1
end

function slot0.addTmpTask(slot0, slot1)
	slot0.tmpInfo = slot1.info

	for slot5, slot6 in ipairs(slot0.tmpInfo) do
		if pg.task_data_template[slot6.id].story_id then
			slot0.facade:sendNotification(GAME.STORY_UPDATE, {
				storyId = slot8
			})
		end
	end
end

function slot0.addTmpToTask(slot0)
	if not slot0.tmpInfo then
		return
	end

	for slot4, slot5 in ipairs(slot0.tmpInfo) do
		slot0:addTask(Task.New(slot5))
	end

	slot0.tmpInfo = nil
end

function slot0.addTask(slot0, slot1)
	if slot1:getConfigTable() == nil then
		pg.TipsMgr:GetInstance():ShowTips(i18n("task_notfound_error") .. tostring(slot1.id))
		Debugger.LogWarning("Missing Task Config, id :" .. tostring(slot1.id))

		return
	end

	slot0.data[slot1.id] = slot1:clone()

	slot0.data[slot1.id]:display("added")
	slot0.data[slot1.id]:onAdded()
	slot0.facade:sendNotification(slot0.TASK_ADDED, slot1:clone())
end

function slot0.updateTask(slot0, slot1)
	slot0.data[slot1.id] = slot1:clone()
	slot0.data[slot1.id].acceptTime = slot0.data[slot1.id].acceptTime

	slot0.data[slot1.id]:display("updated")
	slot0.facade:sendNotification(slot0.TASK_UPDATED, slot1:clone())
end

function slot0.getTasks(slot0)
	slot1 = {}

	for slot5, slot6 in pairs(slot0.data) do
		table.insert(slot1, slot6)
	end

	return Clone(slot1)
end

function slot0.getTaskById(slot0, slot1)
	if slot0.data[slot1] then
		return slot0.data[slot1]:clone()
	end
end

function slot0.getFinishTaskById(slot0, slot1)
	if slot0.finishData[slot1] then
		return slot0.finishData[slot1]:clone()
	end
end

function slot0.isCompleteTaskById(slot0, slot1)
	if slot0.data[slot1] then
		return slot0.data[slot1]:getTaskStatus() == 1
	end
end

function slot0.getCanReceiveCount(slot0)
	slot1 = 0

	for slot5, slot6 in pairs(slot0.data) do
		if slot6:getConfig("visibility") == 1 and slot6:isFinish() and slot6:isReceive() == false then
			slot1 = slot1 + 1
		end
	end

	return slot1
end

function slot0.getNotFinishCount(slot0, slot1)
	slot2 = slot1 or 3
	slot3 = 0

	for slot7, slot8 in pairs(slot0.data) do
		if slot8:getConfig("type") == slot2 and slot8:isFinish() == false then
			slot3 = slot3 + 1
		end
	end

	return slot3
end

function slot0.removeTask(slot0, slot1)
	slot0:removeTaskById(slot1.id)
end

function slot0.removeTaskById(slot0, slot1)
	if slot0.data[slot1] == nil then
		return
	end

	slot0.finishData[slot1] = slot0.data[slot1]:clone()
	slot0.finishData[slot1].submitTime = pg.TimeMgr.GetInstance():GetServerTime()
	slot0.data[slot1] = nil

	slot0.facade:sendNotification(slot0.TASK_REMOVED, slot2)
end

function slot0.getmingshiTaskID(slot0, slot1)
	for slot6, slot7 in pairs(slot2) do
		if slot7[1] <= slot1 and slot7[2] and not slot0:getTaskById(slot8) and not slot0:getFinishTaskById(slot8) then
			return slot8
		end
	end

	return 0
end

function slot0.dealMingshiTouchFlag(slot0, slot1)
	if not getProxy(ActivityProxy):getActivityById(mingshiActivityId) or slot2:isEnd() then
		return
	end

	slot3 = slot2:getConfig("config_id")

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		hideNo = true,
		content = i18n("mingshi_task_tip_" .. slot1)
	})

	if slot0:getTaskById(slot2:getConfig("config_data")[1]) and slot5:getTaskStatus() < 1 then
		if not slot0.mingshiTouchList then
			slot0.mingshiTouchList = {}
		end

		for slot9, slot10 in pairs(slot0.mingshiTouchList) do
			if slot10 == slot1 then
				return
			end
		end

		for slot9, slot10 in pairs(slot2.data1_list) do
			if slot10 == slot1 then
				return
			end
		end

		table.insert(slot0.mingshiTouchList, slot1)
		slot0:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 2,
			activity_id = mingshiActivityId,
			arg1 = slot1
		})
	end
end

function slot0.mingshiTouchFlagEnabled(slot0)
	if not getProxy(ActivityProxy):getActivityById(mingshiActivityId) or slot1:isEnd() then
		return
	end

	slot2 = tonumber(slot1:getConfig("config_id"))

	if slot0:getTaskById(tonumber(slot1:getConfig("config_data")[1])) and slot4:getTaskStatus() < 1 then
		return true
	end

	if slot0:getTaskById(slot2) or slot0:getFinishTaskById(slot2) then
		return false
	end

	return true
end

function slot0.getActivityTask(slot0, slot1)
	slot3 = pg.TimeMgr.GetInstance()
	slot5 = math.max(slot1.data3, 1)
	slot6 = 0
	slot7, slot8 = nil

	for slot12 = math.max(slot1.data3, 1), math.clamp(slot3:DiffDay(slot1.data1, slot3:GetServerTime()) + 1, 1, #slot1:getConfig("config_data")), 1 do
		slot14, slot15 = nil

		for slot19, slot20 in ipairs(slot13) do
			slot22 = slot0:getFinishTaskById(slot20)

			if slot0:getTaskById(slot20) then
				if not slot14 or slot21:getTaskStatus() == 1 then
					slot14 = slot20
					slot15 = slot21
				end
			elseif slot22 then
				slot5 = slot12
				slot6 = slot19
				slot7 = slot20
				slot8 = slot22
			end
		end

		if slot14 then
			return slot14, slot15
		end
	end

	for slot12 = slot5, slot4, 1 do
		for slot17, slot18 in ipairs(slot13) do
			if (slot5 < slot12 or slot6 < slot17) and not slot0:getFinishTaskById(slot18) then
				return slot18
			end
		end
	end

	return slot7, slot8
end

function slot0.getAcademyTask(slot0, slot1)
	if _.detect(getProxy(ActivityProxy).getActivitiesByType(slot2, ActivityConst.ACTIVITY_TYPE_TASK_LIST), function (slot0)
		return slot0:getTaskShip() and slot1.groupId == slot0
	end) and not slot4:isEnd() then
		return slot0:getActivityTask(slot4)
	end
end

function slot0.isFinishPrevTasks(slot0, slot1)
	if Task.New({
		id = slot1
	}):getConfig("open_need") and type(slot3) == "table" and #slot3 > 0 then
		return _.all(slot3, function (slot0)
			return (slot0:getTaskById(slot0) or slot0:getFinishTaskById(slot0)) and slot0:getTaskById() or slot0:getFinishTaskById():isReceive()
		end)
	end

	return true
end

function slot0.isReceiveTasks(slot0, slot1)
	return _.all(slot1, function (slot0)
		return slot0:getFinishTaskById(slot0) and slot1:isReceive()
	end)
end

function slot0.pushAutoSubmitTask(slot0)
	for slot4, slot5 in pairs(slot0.data) do
		if slot5:getConfig("type") == 10 and slot5:isFinish() then
			slot0:sendNotification(GAME.SUBMIT_TASK, slot5.id)
		end
	end
end

function slot0.triggerClientTasks(slot0)
	slot1 = {}

	for slot5, slot6 in pairs(slot0.data) do
		if slot6:isClientTrigger() then
			table.insert(slot1, slot6)
		end
	end

	return slot1
end

return slot0