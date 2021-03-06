slot0 = class("EquipUpgradeLayer", import("..base.BaseUI"))
slot0.CHAT_DURATION_TIME = 0.3

function slot0.getUIName(slot0)
	return "EquipUpgradeUI"
end

function slot0.setItems(slot0, slot1)
	slot0.itemVOs = slot1
end

function slot0.init(slot0)
	slot0.UIMgr = pg.UIMgr.GetInstance()

	slot0.UIMgr:BlurPanel(slot0._tf)

	slot0.mask = slot0:findTF("mask")
	slot0.equipmentList = slot0:findTF("main/equipment_list")
	slot0.equipmentContain = slot0:findTF("equipments", slot0.equipmentList)
	slot0.equipmentTpl = slot0:getTpl("equiptpl", slot0.equipmentContain)

	setActive(slot0.equipmentList, false)

	slot0.equipmentPanel = slot0:findTF("main/equipment_panel")
	slot0.materialPanel = slot0:findTF("main/material_panel")
	slot0.startBtn = slot0:findTF("start_btn", slot0.materialPanel)
	slot0.notActiveBtn = slot0:findTF("not_active", slot0.startBtn)
	slot0.finishPanel = slot0:findTF("finish_panel")

	setActive(slot0.finishPanel, false)

	slot0.overLimit = slot0:findTF("materials/limit", slot0.materialPanel)

	setText(slot0.overLimit, i18n("equipment_upgrade_overlimit"))

	slot0.materialsContain = slot0:findTF("materials/materials", slot0.materialPanel)
	slot0.uiMain = pg.UIMgr:GetInstance().UIMain
	slot0.Overlay = pg.UIMgr:GetInstance().OverlayMain
	slot0.isShowUnique = table.contains(EquipmentInfoMediator.SHOW_UNIQUE, 5)
end

function slot0.updateRes(slot0, slot1)
	slot0.playerVO = slot1
end

function slot0.didEnter(slot0)
	if slot0:findTF("ShipInfoUI2(Clone)", slot0.uiMain) and isActive(slot1) then
		slot0.common = slot0:findTF("common", slot0.Overlay)

		SetParent(slot0.common, slot1)
	end

	onButton(slot0, slot0.mask, function ()
		slot0:emit(slot1.ON_CLOSE)
	end, SFX_CANCEL)
	slot0:updateAll()
end

function slot0.updateAll(slot0)
	if slot0.contextData.shipVO then
		setActive(slot0.equipmentList, true)
		slot0:displayEquipments()
		triggerButton(slot0.equipmentTFs[slot0.contextData.pos])
	else
		slot0:updateEquipment()
		slot0:updateMaterials()
	end
end

function slot0.displayEquipments(slot0)
	slot0.equipmentTFs = {}

	removeAllChildren(slot0.equipmentContain)

	for slot5, slot6 in ipairs(slot0.contextData.shipVO.equipments) do
		if slot6 then
			slot7 = cloneTplTo(slot0.equipmentTpl, slot0.equipmentContain)

			updateEquipment(slot7, slot6)
			setActive(slot8, false)

			if slot0:isMaterialEnough(slot6) and slot6.config.next ~= 0 then
				setActive(slot8, true)
				blinkAni(slot8, 0.5)
			end

			onButton(slot0, slot7, function ()
				setActive(slot0.equipmentTFs[slot0.contextData.pos]:Find("selected"), false)
				slot1(slot0.equipmentTFs[slot0.contextData.pos]:Find("tip"), slot0:isMaterialEnough(slot1:getEquip(slot0.contextData.pos)) and slot1:getEquip(slot0).config.next ~= 0)

				slot0.contextData.pos = slot0.equipmentTFs[slot0.contextData.pos].Find("tip")
				slot0.contextData.equipmentId = slot0.isMaterialEnough(slot1.getEquip(slot0.contextData.pos)) and slot1.getEquip(slot0).config.next ~= 0.id
				slot0.contextData.equipmentVO = slot0.isMaterialEnough(slot1.getEquip(slot0.contextData.pos)) and slot1.getEquip(slot0).config.next ~= 0

				setActive(slot0.equipmentTFs[slot0.contextData.pos]:Find("selected"), true)
				setActive(slot0.equipmentTFs[slot0.contextData.pos]:Find("tip"), false)
				slot0:updateEquipment()
				slot0:updateMaterials()
			end, SFX_PANEL)

			slot0.equipmentTFs[slot5] = slot7
		end
	end
end

function slot0.isMaterialEnough(slot0, slot1)
	slot2 = true

	if not slot1.config.trans_use_item then
		return false
	end

	for slot7 = 1, #slot3, 1 do
		if defaultValue(slot0.itemVOs[slot3[slot7][1]], {
			count = 0
		}).count < slot3[slot7][2] then
			slot2 = false
		end
	end

	return slot2
end

function slot0.updateEquipment(slot0)
	slot0.contextData.equipmentId = slot0.contextData.equipmentVO.id

	slot0:updateAttrs(slot0:findTF("attrs", slot0.equipmentPanel), slot2, (slot0.contextData.equipmentVO.config.next > 0 and Equipment.New({
		id = slot2.config.next
	})) or nil)

	slot4 = findTF(slot0.equipmentPanel, "name_container/name"):GetComponent(typeof(Text))
	slot4.text = slot2.config.name
	slot4.fontSize = 24 - (string.len(slot4.text) - 10) / 10

	setActive(findTF(slot0.equipmentPanel, "name_container/unique"), slot2:isUnique() and slot0.isShowUnique)
	updateEquipment(setActive, slot2)

	slot6 = Equipment.canUpgrade(slot2.id)

	setActive(slot0.notActiveBtn, not slot6)
	setButtonEnabled(slot0.startBtn, slot6)
	setActive(slot0.overLimit, not slot6)
end

function slot0.updateAttrs(slot0, slot1, slot2, slot3)
	slot4 = slot2:GetProperties()
	slot5 = (slot3 and slot3:GetProperties()) or nil
	slot6 = 0

	function slot7(slot0)
		setActive(slot3, slot1)
		setActive(findTF(slot2, "lock"), not (slot1 + 1))

		if slot1 + 1 then
			slot5 = findTF(slot3, "tag")
			slot6 = findTF(slot3, "from")
			slot7 = findTF(slot3, ">")
			slot8 = findTF(slot3, "to")

			setActive(slot9, false)

			slot10 = nil

			if slot3.config.type ~= EquipType.Equipment and slot1.type == AttributeType.Reload then
				slot11 = nil

				if slot4.contextData.shipVO then
					setText(slot5, AttributeType.Type2Name(AttributeType.CD))

					slot11 = slot4.contextData.shipVO:calcWeaponCD(slot3)
					slot10 = (slot5 and slot4.contextData.shipVO:calcWeaponCD(slot5)) or nil
				else
					setText(slot5, i18n("cd_normal"))

					slot11 = slot3:getWeaponCD()
					slot10 = (slot5 and slot5:getWeaponCD()) or nil
					slot12 = 0
				end

				if slot10 then
					setActive(slot9, true)

					slot12 = slot10 - slot11
				end

				slot13 = (math.abs(slot12) < 0.01 and math.abs(slot12) ~= 0 and "%.3f") or "%.2f"

				setText(slot6, slot14 .. "s" .. i18n("word_secondseach"))

				if slot10 then
					setText(slot8, slot15 .. "s" .. i18n("word_secondseach"))
					setText(slot9, string.format(slot13, slot14 - string.format(slot13, slot10)))
				else
					setText(slot8, "")
					setText(slot9, "")
				end
			else
				setText(slot6, slot1.value)
				setText(slot5, AttributeType.Type2Name(slot1.type))

				if (slot6 and slot6[slot0]) or nil then
					if type(slot1.value) == "number" and slot10.value ~= slot1.value then
						setActive(slot9, true)
						setText(slot9, slot10.value - slot1.value)
					elseif string.match(slot1.value, "%d+") ~= string.match(slot10.value, "%d+") then
						setActive(slot9, true)
						setText(slot9, slot12 - slot11)
					end

					setText(slot8, slot10.value)
				end
			end

			setActive(slot8, slot10)
			setActive(slot7, slot10)
		end
	end

	if slot2.config.type == EquipType.Equipment then
		for slot11 = 1, 2, 1 do
			slot7(slot11)
		end
	else
		for slot11 = 1, 4, 3 do
			slot7(slot11)
		end
	end
end

function slot0.updateMaterials(slot0)
	slot1 = true
	slot4 = slot0.contextData.equipmentVO.config.trans_use_gold

	removeAllChildren(slot0.materialsContain)

	if not slot0.contextData.equipmentVO.config.trans_use_item then
		return
	end

	for slot8 = 1, #slot3, 1 do
		updateItem(slot10, Item.New({
			id = slot3[slot8][1]
		}))

		slot12 = defaultValue(slot0.itemVOs[slot3[slot8][1]], {
			count = 0
		}).count .. "/" .. slot3[slot8][2]

		if defaultValue(slot0.itemVOs[slot3[slot8][1]], ).count < slot3[slot8][2] then
			slot12 = setColorStr(slot11.count, COLOR_RED) .. "/" .. slot3[slot8][2]
			slot1 = false
		end

		setActive(slot13, true)
		setText(slot13, slot12)
		onButton(slot0, slot10, function ()
			slot0:emit(slot1.ON_ITEM, )
		end, SFX_PANEL)
	end

	for slot8 = #slot3 + 1, 3, 1 do
		setActive(findTF(slot9, "icon_bg"), false)
		setImageColor(findTF(slot9, "bg"), Color.New(0.5, 0.5, 0.5))
	end

	setText(slot0:findTF("cost/consume", slot0.materialPanel), slot4)
	setActive(slot0.startBtn, slot3)
	setActive(slot0.materialsContain, slot5)
	onButton(slot0, slot0.startBtn, function ()
		if not slot0 then
			pg.TipsMgr:GetInstance():ShowTips(i18n("ship_shipUpgradeLayer2_noMaterail"))

			return
		end

		if slot1.playerVO.gold < slot2 then
			GoShoppingMsgBox(i18n("switch_to_shop_tip_2", i18n("word_gold")), ChargeScene.TYPE_ITEM, {
				{
					59001,
					slot2 - slot1.playerVO.gold,
					ChargeScene.TYPE_ITEM
				}
			})

			return
		end

		slot1:emit(EquipUpgradeMediator.EQUIPMENT_UPGRDE)
	end, SFX_UI_DOCKYARD_REINFORCE)
end

function slot0.upgradeFinish(slot0, slot1, slot2)
	SetParent(slot0.finishPanel, slot0.Overlay)
	SetParent(slot0._tf, slot0.uiMain)
	setActive(slot0.finishPanel, true)
	onButton(slot0, slot0.finishPanel, function ()
		setActive(slot0.finishPanel, false)
		SetParent(slot0.finishPanel, slot0._tf)
		SetParent(slot0._tf, slot0.Overlay)
	end, SFX_CANCEL)
	setText(findTF(slot0.finishPanel, "frame/name_container/name"), slot2.config.name)
	setActive(findTF(slot0.finishPanel, "frame/name_container/unique"), slot2:isUnique() and slot0.isShowUnique)
	updateEquipment(setActive, slot2)
	slot0:updateAttrs(slot0:findTF("frame/attrs", slot0.finishPanel), slot1, slot2)
end

function slot0.willExit(slot0)
	slot0.UIMgr:UnblurPanel(slot0._tf, slot0.UImain)
	SetParent(slot0.finishPanel, slot0._tf)

	if slot0.common then
		SetParent(slot0.common, slot0.Overlay)
	end
end

return slot0
