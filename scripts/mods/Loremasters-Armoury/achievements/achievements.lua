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


mod.main_quest = {
	sub_quest_01 = false,
	sub_quest_02 = false, 
	sub_quest_03 = false,
}
-- mod:echo(#main_quest)
-- local num_completed = 0
-- for name, quest in pairs(main_quest) do
-- 	if quest then
-- 		num_completed = num_completed + 1
		
-- 	end
-- 	mod:echo(name)
	
-- end
AchievementTemplates.achievements.main_quest = {
	name = "main_quest",
	-- display_completion_ui = true,
	icon = "loremaster_test_icon",
	desc = "main_quest_desc",
	completed = function (statistics_db, stats_id)
		
		if mod.main_quest[sub_01] and mod.main_quest[sub_01] and mod.main_quest[sub_01] then
			return true
		end
		
		return false
	end,
	progress = function (statistics_db, stats_id)
		local num_completed = 0
		local num_quests = 0
		for _, quest in pairs(mod.main_quest) do
			if quest then
				num_completed = num_completed + 1
			end
			num_quests = num_quests + 1
		end

		return {
			num_completed,
			num_quests,
		}
	end,
	requirements = function (statistics_db, stats_id)
		local reqs = {}

		for quest_name, quest in pairs(mod.main_quest) do

			table.insert(reqs, {
				name = quest_name,
				completed = quest
			})
		end

		return reqs
	end


}


local num_shields_needed = 3
AchievementTemplates.achievements.sub_quest_01 = {
	name = "sub_quest_01",
	display_completion_ui = true,
	icon = "quest_icon_empty",
	desc = "sub_quest_01_desc",
	completed = function (statistics_db, stats_id)
		
		if mod:get("num_shields_collected") >= num_shields_needed then
			mod.main_quest.sub_quest_01 = true
		end

		return mod.main_quest.sub_quest_01
	end,
	progress = function (statistics_db, stats_id)
		local collected = mod:get("num_shields_collected")
		if mod:get("num_shields_collected") > 3 then
			collected = 3
		end

		return {
			collected,
			num_shields_needed,
		}
	end,
}

AchievementTemplates.achievements.sub_quest_02 = {
	name = "sub_quest_02",
	display_completion_ui = true,
	icon = "quest_icon_empty",
	desc = "sub_quest_02_desc",
	completed = function (statistics_db, stats_id)
		
		return mod.main_quest.sub_quest_02
	end
}

AchievementTemplates.achievements.sub_quest_03 = {
	name = "sub_quest_03",
	display_completion_ui = true,
	icon = "quest_icon_empty",
	desc = "sub_quest_03_desc",
	completed = function (statistics_db, stats_id)
	
		return mod.main_quest.sub_quest_03
	end
}


-- for k,v in pairs (UIAtlasHelper._ui_atlas_settings["achievement_trophy_helmgart_lord_1"]) do
-- 	mod:echo(v)
-- end

-- mod:echo(UIAtlasHelper._ui_atlas_settings["achievement_trophy_helmgart_lord_1"])

-- UIAtlasHelper._ui_atlas_settings["test_1"] = 