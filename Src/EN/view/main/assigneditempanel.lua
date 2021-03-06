slot0 = class("AssignedItemPanel")

function slot0.Ctor(slot0, slot1, slot2)
	pg.DelegateInfo.New(slot0)

	slot0._go = slot1
	slot0._tf = tf(slot1)
	slot0.isInited = false
	slot0.selectedVO = nil
	slot0.count = 1
	slot0.view = slot2
	slot0.scrollTxts = {}
end

function slot0.findTF(slot0, slot1)
	return findTF(slot0._tf, slot1)
end

function slot0.show(slot0)
	setActive(slot0._tf, true)
	pg.UIMgr.GetInstance():BlurPanel(slot0._tf)
end

function slot0.hide(slot0)
	setActive(slot0._tf, false)

	slot0.selectedVO = nil
	slot0.itemVO = nil
	slot0.count = 1

	pg.UIMgr.GetInstance():UnblurPanel(slot0._tf, slot0.view._tf)

	if slot0.selectedItem then
		triggerToggle(slot0.selectedItem, false)
	end

	slot0.selectedItem = nil
end

function slot0.init(slot0)
	slot0.isInited = true
	slot0.itemTF = slot0:findTF("got/scroll/list/item")
	slot0.itemContainer = slot0:findTF("got/scroll/list")
	slot0.ulist = UIItemList.New(slot0.itemContainer, slot0.itemTF)
	slot0.cancelBtn = slot0:findTF("actions/cancel_button")
	slot0.confirmBtn = slot0:findTF("actions/compose_button")
	slot0.rightArr = slot0:findTF("count/right")
	slot0.leftArr = slot0:findTF("count/left")
	slot0.maxBtn = slot0:findTF("count/max")
	slot0.valueText = slot0:findTF("count/value")
	slot0.itemTF = slot0:findTF("item")
	slot0.nameTF = slot0:findTF("item/name_container/name")
	slot0.descTF = slot0:findTF("item/desc")

	onButton(slot0, slot0.rightArr, function ()
		if not slot0.itemVO then
			return
		end

		slot0.count = math.min(slot0.count + 1, slot0.itemVO.count)

		slot0:updateValue()
	end)
	onButton(slot0, slot0.leftArr, function ()
		if not slot0.itemVO then
			return
		end

		slot0.count = math.max(slot0.count - 1, 1)

		slot0:updateValue()
	end)
	onButton(slot0, slot0.maxBtn, function ()
		if not slot0.itemVO then
			return
		end

		slot0.count = slot0.itemVO.count

		slot0:updateValue()
	end, SFX_PANEL)
	onButton(slot0, slot0.cancelBtn, function ()
		slot0:hide()
	end, SFX_PANEL)
	onButton(slot0, slot0.confirmBtn, function ()
		if not slot0.selectedVO or not slot0.itemVO or slot0.count <= 0 then
			return
		end

		slot0.view:emit(EquipmentMediator.ON_USE_ITEM, slot0.itemVO.id, slot0.count, slot0.selectedVO)
		slot0.view.emit:hide()
	end, SFX_PANEL)
end

function slot0.updateValue(slot0)
	setText(slot0.valueText, slot0.count)

	for slot5 = 1, slot0.itemContainer.childCount, 1 do
		setText(slot0.itemContainer:GetChild(slot5 - 1).Find(slot6, "icon_bg/count"), slot0.count)
	end
end

function slot0.update(slot0, slot1)
	slot0.itemVO = slot1

	if not slot0.isInited then
		slot0:init()
	end

	slot0.selectedItem = nil

	slot0.ulist:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			updateDrop(slot2, slot4)

			slot5 = slot2:Find("name_mask/name")
			slot6 = slot2:Find("icon_bg/count")

			onToggle(slot1, slot2, function (slot0)
				if slot0 then
					slot0.selectedVO = slot1:getTempCfgTable().usage_arg[slot2 + 1]

					setText(slot2 + 1, slot0.count * slot4[3])

					slot0.selectedItem = slot5
				end
			end, SFX_PANEL)

			slot7 = ScrollTxt.New(slot2:Find("name_mask"), slot2:Find("name_mask/name"))

			slot7:setText(({
				type = slot0[slot1 + 1][1],
				id = slot0[slot1 + 1][2],
				count = slot0[slot1 + 1][3]
			})["cfg"].name)
			table.insert(slot1.scrollTxts, slot7)
		end
	end)
	slot0.ulist:align(#slot1:getConfig("display_icon"))
	slot0:updateValue()
	updateDrop(slot0.itemTF, {
		type = DROP_TYPE_ITEM,
		id = slot1.id,
		count = slot1.count
	})
	setText(slot0.nameTF, slot1:getConfig("name"))
	setText(slot0.descTF, slot1:getConfig("display"))
end

function slot0.dispose(slot0)
	pg.DelegateInfo.Dispose(slot0)

	if slot0.scrollTxts and #slot0.scrollTxts > 0 then
		for slot4, slot5 in pairs(slot0.scrollTxts) do
			slot5:destroy()
		end
	end
end

return slot0
