return {
	{
		desc = "每5秒回复6点耐久，同类效果取最大值，不可叠加",
		effect_list = {
			{
				type = "BattleBuffCastSkill",
				trigger = {
					"onUpdate"
				},
				arg_list = {
					check_target = "TargetHelpLeastHP",
					skill_id = 30,
					targetMaxHPRatio = 0.99,
					minTargetNumber = 1,
					time = 5,
					target = "TargetSelf",
					group = {
						id = 30,
						level = 1
					}
				}
			}
		}
	},
	time = 0,
	name = "维修Lv1",
	init_effect = "",
	picture = "",
	desc = "每5秒回复6点耐久，同类效果取最大值，不可叠加",
	stack = 1,
	id = 30,
	icon = 30,
	last_effect = "Health",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				check_target = "TargetHelpLeastHP",
				skill_id = 30,
				targetMaxHPRatio = 0.99,
				minTargetNumber = 1,
				time = 5,
				target = "TargetSelf",
				group = {
					id = 30,
					level = 1
				}
			}
		}
	}
}
