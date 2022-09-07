local mod = get_mod("Loremasters-Armoury")

local limit = 3
AchievementTemplates.achievements.test_1 = {
	name = "test_1",
	display_completion_ui = true,
	icon = "armoury_icon",
	desc = "test_1_desc",
	completed = function (statistics_db, stats_id)
		if mod.complete >= limit then
			return true
		end

		return false
	end,
	progress = function (statistics_db, stats_id)
		local count = mod.complete

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