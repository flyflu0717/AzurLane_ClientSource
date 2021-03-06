ys = ys or {}
slot1 = ys.Battle.BattleConst
slot2 = class("BattleLastingAOEData", ys.Battle.BattleAOEData)
ys.Battle.BattleLastingAOEData = slot2
slot2.__name = "BattleLastingAOEData"

function slot2.Ctor(slot0, slot1, slot2, slot3, slot4)
	slot0.super.Ctor(slot0, slot1, slot2, slot3)

	slot0._exitCldFunc = slot4
	slot0._handledList = {}
end

function slot2.Dispose(slot0)
	for slot4, slot5 in pairs(slot0._handledList) do
		slot0._exitCldFunc(slot4)

		slot0._handledList[slot4] = nil
	end

	slot0._exitCldFunc = nil
	slot0._handledList = nil

	slot0.super.Dispose(slot0)
end

function slot2.AppendCldObj(slot0, slot1)
	slot0._cldObjList[#slot0._cldObjList + 1] = slot1
end

function slot2.Settle(slot0)
	slot1 = {}
	slot2 = {}

	for slot6, slot7 in ipairs(slot0._cldObjList) do
		slot2[slot7.UID] = true

		if not slot0._handledList[slot7] then
			slot1[#slot1 + 1] = slot7
			slot0._handledList[slot7] = true
		end
	end

	slot0.SortCldObjList(slot1)
	slot0._cldComponent:GetCldData().func(slot1, obj)

	for slot6, slot7 in pairs(slot0._handledList) do
		if not slot2[slot6.UID] then
			slot0._exitCldFunc(slot6)

			slot0._handledList[slot6] = nil
		end
	end

	slot0._cldObjList = {}
end

return
