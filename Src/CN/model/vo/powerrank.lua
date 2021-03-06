slot0 = class("PowerRank", import(".BaseVO"))

function slot0.Ctor(slot0, slot1)
	slot0.id = slot1.user_id
	slot0.power = slot1.point
	slot0.name = slot1.name
	slot0.lv = slot1.lv
	slot0.icon = slot1.icon
	slot0.arenaRank = slot1.arena_rank
	slot0.skinId = slot1.skin_id or 0

	if slot0.skinId == 0 and pg.ship_data_statistics[slot0.icon] then
		slot0.skinId = slot2.skin_id
	end

	slot0.remoulded = false

	if slot1.remoulded and slot1.remoulded == 1 then
		slot0.remoulded = true
	end

	slot0.propose = slot1.propose and slot1.propose > 0
	slot0.proposeTime = slot1.propose
end

function slot0.getPainting(slot0)
	return (pg.ship_skin_template[slot0.skinId] and slot1.painting) or "unknown"
end

function slot0.setRank(slot0, slot1)
	slot0.rank = slot1
end

return slot0
