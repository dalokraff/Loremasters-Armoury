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
	sub_quest_04 = false,
	sub_quest_05 = false,
	sub_quest_06 = false,
	sub_quest_07 = false,
	sub_quest_08 = false,
	sub_quest_09 = false,
	sub_quest_10 = false,
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
		
		-- if mod.main_quest[sub_01] and mod.main_quest[sub_01] and mod.main_quest[sub_01] then
		-- 	return true
		-- end
		for _, quest in pairs(mod.main_quest) do
			if not quest then 
				return false
			end
		end

		
		return true
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


-- AchievementManager._achievement_completed("sub_quest_01")
-- mod:echo(Managers.state.achievement:_achievement_completed("sub_quest_01"))
-- for k,v in pairs(AchievementTemplates.achievements) do 
-- 	mod:echo(k)
-- end
-- mod:echo(AchievementTemplates.achievements["sub_quest_01"])

local num_shields_needed = 3


local total_kills_sub_quest_one = 500
AchievementTemplates.achievements.sub_quest_01 = {
	name = "sub_quest_01",
	display_completion_ui = true,
	icon = "quest_icon_empty",
	desc = "sub_quest_01_desc",
	completed = function (statistics_db, stats_id)
		
		--kill 500 rats with specific skin
		if mod:get("sub_quest_01") >= total_kills_sub_quest_one then
			mod.main_quest.sub_quest_01 = true
		end

		return mod.main_quest.sub_quest_01
	end,
	progress = function (statistics_db, stats_id)
		local collected = mod:get("sub_quest_01")
		if mod:get("sub_quest_01") > total_kills_sub_quest_one then
			collected = total_kills_sub_quest_one
		end

		return {
			collected,
			total_kills_sub_quest_one,
		}
	end,
}

local total_kills_sub_quest_two = 500
AchievementTemplates.achievements.sub_quest_02 = {
	name = "sub_quest_02",
	display_completion_ui = true,
	icon = "quest_icon_empty",
	desc = "sub_quest_02_desc",
	completed = function (statistics_db, stats_id)
		
		--kill 500 nosrcans with specific skin
		if mod:get("sub_quest_02") >= total_kills_sub_quest_two then
			mod.main_quest.sub_quest_02 = true
		end

		return mod.main_quest.sub_quest_02
	end,
	progress = function (statistics_db, stats_id)
		local collected = mod:get("sub_quest_02")
		if mod:get("sub_quest_02") > total_kills_sub_quest_two then
			collected = total_kills_sub_quest_two
		end

		return {
			collected,
			total_kills_sub_quest_two,
		}
	end,
}

AchievementTemplates.achievements.sub_quest_03 = {
	name = "sub_quest_03",
	display_completion_ui = true,
	icon = "la_mq01_quest_sub3_icon",
	desc = "sub_quest_03_desc",
	completed = function (statistics_db, stats_id)
		
		if mod:get("sub_quest_03") then
			mod.main_quest.sub_quest_03 = true
			return true
		end

		return false
	end
}

AchievementTemplates.achievements.sub_quest_04 = {
	name = "sub_quest_04",
	display_completion_ui = true,
	icon = "la_mq01_quest_sub4_icon",
	desc = "sub_quest_04_desc",
	completed = function (statistics_db, stats_id)
		
		if mod:get("sub_quest_04") then
			mod.main_quest.sub_quest_04 = true
			return true
		end

		return false
	end
}

AchievementTemplates.achievements.sub_quest_05 = {
	name = "sub_quest_05",
	display_completion_ui = true,
	icon = "la_mq01_quest_sub5_icon",
	desc = "sub_quest_05_desc",
	completed = function (statistics_db, stats_id)
		
		if mod:get("sub_quest_05") then
			AchievementTemplates.achievements.sub_quest_06.desc = "sub_quest_06_desc"
			mod.LA_quest_rewards.sub_quest_06.item_name = "sub_quest_06_reward"
			mod.main_quest.sub_quest_05 = true
			return true
		end

		return false
	end
}

AchievementTemplates.achievements.sub_quest_06 = {
	name = "sub_quest_06",
	display_completion_ui = true,
	icon = "quest_icon_empty",
	desc = "locked_hidden_quest",
	completed = function (statistics_db, stats_id)
		
		if mod:get("sub_quest_06") then
			AchievementTemplates.achievements.sub_quest_07.desc = "sub_quest_07_desc"
			mod.LA_quest_rewards.sub_quest_07.item_name = "sub_quest_07_reward"
			mod.main_quest.sub_quest_06 = true
			return true
		end

		return false
	end
}

AchievementTemplates.achievements.sub_quest_07 = {
	name = "sub_quest_07",
	display_completion_ui = true,
	icon = "quest_icon_empty",
	desc = "locked_hidden_quest",
	completed = function (statistics_db, stats_id)
		
		if mod:get("sub_quest_07") then
			AchievementTemplates.achievements.sub_quest_08.desc = "sub_quest_08_desc"
			mod.LA_quest_rewards.sub_quest_08.item_name = "sub_quest_08_reward"
			mod.main_quest.sub_quest_07 = true
			return true
		end

		return false
	end
}

AchievementTemplates.achievements.sub_quest_08 = {
	name = "sub_quest_08",
	display_completion_ui = true,
	icon = "quest_icon_empty",
	desc = "locked_hidden_quest",
	completed = function (statistics_db, stats_id)
		
		if mod:get("sub_quest_08") then
			AchievementTemplates.achievements.sub_quest_09.desc = "sub_quest_09_desc"
			mod.LA_quest_rewards.sub_quest_09.item_name = "sub_quest_09_reward"
			mod.main_quest.sub_quest_08 = true
			return true
		end

		return false
	end
}

AchievementTemplates.achievements.sub_quest_09 = {
	name = "sub_quest_09",
	display_completion_ui = true,
	icon = "quest_icon_empty",
	desc = "locked_hidden_quest",
	completed = function (statistics_db, stats_id)
		
		if mod:get("sub_quest_09") then
			AchievementTemplates.achievements.sub_quest_10.desc = "sub_quest_10_desc"
			mod.LA_quest_rewards.sub_quest_10.item_name = "sub_quest_10_reward"
			mod.main_quest.sub_quest_09 = true
			return true
		end

		return false
	end
}

AchievementTemplates.achievements.sub_quest_10 = {
	name = "sub_quest_10",
	display_completion_ui = true,
	icon = "quest_icon_empty",
	desc = "locked_hidden_quest",
	completed = function (statistics_db, stats_id)
		
		if mod:get("sub_quest_10") then
			mod.main_quest.sub_quest_10 = true
			return true
		end

		return false
	end
}

--"locked_hidden_quest"
