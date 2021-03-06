slot0 = class("resumeLayer", import("..base.BaseUI"))

function slot0.getUIName(slot0)
	return "resumeUI"
end

function slot0.setPlayerVO(slot0, slot1)
	slot0.player = slot1
end

function slot0.init(slot0)
	slot0.frame = slot0:findTF("frame")
	slot0.resumeIcon = slot0:findTF("frame/icon_bg/frame/icon"):GetComponent(typeof(Image))
	slot0.resumeLv = slot0:findTF("frame/icon_bg/lv/Text"):GetComponent(typeof(Text))
	slot0.resumeName = slot0:findTF("frame/icon_bg/name_bg/Text"):GetComponent(typeof(Text))
	slot0.resumeInfo = slot0:findTF("frame/info")
	slot0.resumeEmblem = slot0:findTF("frame/emblem")
	slot0.resumeRank = slot0:findTF("frame/emblem/Text"):GetComponent(typeof(Text))
	slot0.resumeStars = slot0:findTF("frame/icon_bg/stars")
	slot0.resumeStar = slot0:findTF("frame/icon_bg/stars/star")
end

function slot0.didEnter(slot0)
	slot0:display(slot0.player)
	onButton(slot0, slot0._tf, function ()
		slot0:emit(slot1.ON_CLOSE)
	end, SOUND_BACK)
end

slot1 = {
	{
		value = "shipCount",
		type = 1,
		tag = i18n("friend_resume_ship_count")
	},
	{
		type = 3,
		tag = i18n("friend_resume_collection_rate"),
		value = {
			"collectionCount"
		}
	},
	{
		value = "attackCount",
		type = 1,
		tag = i18n("friend_resume_attack_count")
	},
	{
		type = 2,
		tag = i18n("friend_resume_attack_win_rate"),
		value = {
			"attackCount",
			"winCount"
		}
	},
	{
		value = "pvp_attack_count",
		type = 1,
		tag = i18n("friend_resume_manoeuvre_count")
	},
	{
		type = 2,
		tag = i18n("friend_resume_manoeuvre_win_rate"),
		value = {
			"pvp_attack_count",
			"pvp_win_count"
		}
	},
	{
		value = "collect_attack_count",
		type = 1,
		tag = i18n("friend_event_count")
	}
}

function slot0.display(slot0, slot1)
	if slot0.contextData.parent then
		setParent(slot0._tf, slot0.contextData.parent)
	else
		pg.UIMgr.GetInstance():BlurPanel(slot0._tf)
	end

	slot2 = SeasonInfo.getMilitaryRank(slot1.score, slot1.rank)

	LoadImageSpriteAsync("emblem/" .. slot3, slot0.resumeEmblem)

	slot0.resumeName.text = slot1.name
	slot0.resumeLv.text = slot1.level
	slot4 = pg.ship_data_statistics[slot1.icon]

	if LoadSprite("qicon/" .. slot1:getPainting()) then
		slot0.resumeIcon.sprite = slot5
	else
		slot0.resumeIcon.sprite = GetSpriteFromAtlas("heroicon/unknown", "")
	end

	for slot9, slot10 in ipairs(slot0) do
		slot11 = slot0.resumeInfo:GetChild(slot9 - 1)

		setText(slot11:Find("tag"), slot10.tag)

		slot12 = slot11:Find("value")

		if slot10.type == 1 then
			setText(slot12, slot0.player[slot10.value])
		elseif slot10.type == 2 then
			setText(slot12, string.format("%0.2f", math.max(slot0.player[slot10.value[2]], 0) / math.max(slot0.player[slot10.value[1]], 1) * 100) .. "%")
		elseif slot10.type == 3 then
			setText(slot12, string.format("%0.2f", (slot0.player[slot10.value[1]] or 1) / getProxy(CollectionProxy):getCollectionTotal() * 100) .. "%")
		end
	end

	for slot10 = slot0.resumeStars.childCount, slot4.star - 1, 1 do
		cloneTplTo(slot0.resumeStar, slot0.resumeStars)
	end

	for slot10 = 1, slot4.star, 1 do
		setActive(slot0.resumeStars:GetChild(slot10 - 1), slot10 <= slot4.star)
	end
end

function slot0.willExit(slot0)
	if slot0.contextData.parent then
	else
		pg.UIMgr.GetInstance():UnblurPanel(slot0._tf, pg.UIMgr:GetInstance().UIMain)
	end
end

return slot0
