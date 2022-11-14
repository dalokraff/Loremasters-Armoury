local mod = get_mod("Loremasters-Armoury")

mod.sub_quest_modifiers = {
	main_01 = {
		sub_quest_08 = {
			sub_quest_08_cdr_buff = {
				name = "sub_quest_08_cdr_buff",
				icon = "la_ui_quest_modificator01_icon",
				desc = "desc",
			},
			halescourge_boss_debuff = {
				name = "halescourge_boss_debuff",
				icon = "la_ui_quest_modificator02_icon",
				desc = "desc",
			},
		}
	}
}

local test_buff_templates = {
	sub_quest_08_cdr_buff = {
		buffs = {
			{
				max_stacks = 1,
				icon = "la_buff_01_icon",
				multiplier = 1.2,
				stat_buff = "cooldown_regen",
			}
		}
	},
    sub_quest_08_stamina_buff = {
		buffs = {
			{
				max_stacks = 1,
				-- icon = "la_buff_01_icon",
				stat_buff = "max_fatigue",
				apply_on = "equip",
				bonus = 2,
			}
		}
	},
	sub_quest_08_heatgen_buff = {
		buffs = {
			{
				max_stacks = 1,
				-- icon = "la_buff_01_icon",
				stat_buff = "reduced_overcharge",
				multiplier = -0.3,
			}
		}
	}
}

for buff_name, data in pairs(test_buff_templates) do
    BuffTemplates[buff_name] = data
end

BuffUtils.copy_talent_buff_names(test_buff_templates)