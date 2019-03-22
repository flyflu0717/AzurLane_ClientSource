pg = pg or {}
pg.strategy_data_template = {
	{
		buff_id = 100,
		name = "単縦陣",
		type = 1,
		id = 1,
		icon = "1",
		desc = "次の戦闘で、全艦火力・雷装+15%、回避-10%。",
		arg = {}
	},
	{
		buff_id = 110,
		name = "複縦陣",
		type = 1,
		id = 2,
		icon = "2",
		desc = "次の戦闘で、全艦回避+30%、火力・雷装-5%。",
		arg = {}
	},
	{
		buff_id = 120,
		name = "輪形陣",
		type = 1,
		id = 3,
		icon = "3",
		desc = "次の戦闘で、全艦対空+20%。",
		arg = {}
	},
	{
		buff_id = 0,
		name = "緊急補修",
		type = 2,
		id = 4,
		icon = "4",
		desc = "戦闘参加可能な艦のHPが10%回復する。",
		arg = {
			healthy,
			10
		}
	},
	[9] = {
		buff_id = 0,
		name = "交換",
		type = 2,
		id = 9,
		icon = "9",
		desc = "隣の交戦中の味方艦隊と位置を交換する",
		arg = {
			exchange
		}
	},
	[10001] = {
		buff_id = 200,
		name = "完全補給",
		type = 1000,
		id = 10001,
		icon = "10001",
		desc = "弾薬満タン、艦隊ダメージ+10%。",
		arg = {}
	},
	[10002] = {
		buff_id = 210,
		name = "弾薬不足",
		type = 1000,
		id = 10002,
		icon = "10002",
		desc = "弾切れ寸前、艦隊ダメージ-50%。",
		arg = {}
	},
	[10011] = {
		buff_id = 220,
		name = "制空権確保",
		type = 1001,
		id = 10011,
		icon = "10011",
		desc = "味方航空攻撃によるダメージが20%アップし、敵航空攻撃によるダメージが10%ダウン（浸水・炎上ダメージを除く）。味方全員の命中が10%アップし、待ち伏せ遭遇率が8%ダウン",
		arg = {
			800
		}
	},
	[10012] = {
		buff_id = 230,
		name = "制空権優勢",
		type = 1001,
		id = 10012,
		icon = "10012",
		desc = "味方航空攻撃によるダメージが12%アップし、敵航空攻撃によるダメージが6%ダウン（浸水・炎上ダメージを除く）。味方全員の命中が5%アップし、待ち伏せ遭遇率が5%ダウン",
		arg = {
			500
		}
	},
	[10013] = {
		buff_id = 240,
		name = "制空拮抗中",
		type = 1001,
		id = 10013,
		icon = "10013",
		desc = "味方航空攻撃によるダメージが6%ダウンし、敵航空攻撃によるダメージが3%ダウン（浸水・炎上ダメージを除く）",
		arg = {
			0
		}
	},
	[10014] = {
		buff_id = 250,
		name = "制空権劣勢",
		type = 1001,
		id = 10014,
		icon = "10014",
		desc = "味方航空攻撃によるダメージが12%ダウンし、敵航空攻撃によるダメージが6%アップ（浸水・炎上ダメージを除く）。味方全員の命中・回避が3%ダウン",
		arg = {
			0
		}
	},
	[10015] = {
		buff_id = 260,
		name = "制空権喪失",
		type = 1001,
		id = 10015,
		icon = "10015",
		desc = "味方航空攻撃によるダメージが20%ダウンし、敵航空攻撃によるダメージが10%アップ（浸水・炎上ダメージを除く）。味方全員の命中・回避が8%ダウン",
		arg = {
			0
		}
	},
	all = {
		1,
		2,
		3,
		4,
		9,
		10001,
		10002,
		10011,
		10012,
		10013,
		10014,
		10015
	}
}

return
