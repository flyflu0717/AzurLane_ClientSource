ys = ys or {}
slot1 = class("BattleBuffCount", ys.Battle.BattleBuffEffect)
ys.Battle.BattleBuffCount = slot1
slot1.__name = "BattleBuffCount"

function slot1.Ctor(slot0, slot1)
	slot0.super.Ctor(slot0, slot1)
end

function slot1.SetArgs(slot0, slot1, slot2)
	slot0._countTarget = slot0._tempData.arg_list.countTarget or 1
	slot0._countType = slot0._tempData.arg_list.countType

	slot0:ResetCount()
end

function slot1.onTrigger(slot0, slot1, slot2)
	slot0.super.onTrigger(slot0, slot1, slot2)

	slot0._count = slot0._count + 1

	if slot0._countTarget <= slot0._count then
		slot1:TriggerBuff(slot1.Battle.BattleConst.BuffEffectType.ON_BATTLE_BUFF_COUNT, {
			buffFX = slot0
		})
	end
end

function slot1.GetCountType(slot0)
	return slot0._countType
end

function slot1.ResetCount(slot0)
	slot0._count = 0
end

return
