slot0 = class("Server", import(".BaseVO"))
slot0.STATUS = {
	REGISTER_FULL = 3,
	VINDICATE = 1,
	NORMAL = 0,
	FULL = 2
}

function slot0.Ctor(slot0, slot1)
	slot0.id = slot1.id
	slot0.host = slot1.host
	slot0.port = slot1.port
	slot0.status = slot1.status or slot0.STATUS.NORMAL
	slot0.name = slot1.name
	slot0.isHot = (slot1.tag_state or 0) == 1
	slot0.isNew = (slot1.tag_state or 0) == 2
	slot0.isLogined = false
	slot0.sortIndex = slot1.sort or slot0.id
end

return slot0
