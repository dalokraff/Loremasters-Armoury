local mod = get_mod("Loremasters-Armoury")
local limit = 3

mod.achievement_list = {
	test_1_completed = false, 
}

-- for cheevo,finished in pairs(achievement_list) do
-- 	cheevo = mod:get(cheevo) or false
-- end

-- {
-- 	reward_type = item, hat, weapon_skin, currency, frame, skin, keep_decoration_painting
-- 	item_name = 
-- 	weapon_skin_name =
-- 	decoration_name = 

-- }

mod.achievement_rewards = {
	test_1 = {
		reward_type = "weapon_skin",
		weapon_skin_name = "we_longbow_skin_06_runed_01",
	}, 
}

AchievementTemplates.achievements.test_1 = {
	name = "test_1",
	display_completion_ui = true,
	icon = "kerillian_elf_bow_antlersong_limbs_autumn_icon",
	desc = "test_1_desc",
	completed = function (statistics_db, stats_id)
		
		local cheevo = "test_1_completed"
		local finished = mod:get(cheevo)

		if (mod.complete >= limit) or finished then
			mod:set(cheevo, true)
			mod:echo('COMPLETED!!!')
			return true
		end

		return false
	end,
	progress = function (statistics_db, stats_id)
		local count = mod.complete

		local cheevo = "test_1_completed"
		local finished = mod:get(cheevo) 
		if finished then
			count = limit
		end

		count = math.min(count, limit)

		return {
			count,
			limit
		}
	end
}

AchievementTemplates.achievements.test_2 = {
	name = "test_2",
	display_completion_ui = true,
	icon = "achievement_trophy_helmgart_lord_1",
	desc = "test_2_desc",
	completed = function (statistics_db, stats_id)
		return statistics_db:get_persistent_stat(stats_id, "killed_lord_as_last_player_standing") > 0
	end
}


-- for k,v in pairs (UIAtlasHelper._ui_atlas_settings["achievement_trophy_helmgart_lord_1"]) do
-- 	mod:echo(v)
-- end

-- mod:echo(UIAtlasHelper._ui_atlas_settings["achievement_trophy_helmgart_lord_1"])

-- UIAtlasHelper._ui_atlas_settings["test_1"] = 