local mod = get_mod("Loremasters-Armoury")

local test_buff_templates = {
	sub_quest_08_cdr_buff = {
		buffs = {
			{
				max_stacks = 1,
				icon = "loremaster_test_icon_old",
				multiplier = 1.25,
				stat_buff = "cooldown_regen",
			}
		}
	},
    sub_quest_08_stamina_buff = {
		buffs = {
			{
				max_stacks = 1,
				icon = "loremaster_test_icon_old",
				stat_buff = "max_fatigue",
				apply_on = "equip",
				bonus = 2,
			}
		}
	}
}

for buff_name, data in pairs(test_buff_templates) do
    BuffTemplates[buff_name] = data
end
-- BuffTemplates["loremasters_02_buff"] = test_buff_templates.loremasters_01_buff
BuffUtils.copy_talent_buff_names(test_buff_templates)


-- local params = {
--     external_optional_duration = 10,
-- }
-- local player = Managers.player:local_player()
-- local player_unit = player.player_unit   
-- local buff_extension = ScriptUnit.extension(player_unit, "buff_system")
-- buff_extension:add_buff("sub_quest_08_cdr_buff", params)
-- buff_extension:add_buff("sub_quest_08_stamina_buff", params)