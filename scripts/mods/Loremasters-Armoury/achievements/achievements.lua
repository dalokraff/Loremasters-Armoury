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

-- AchievementTemplates.achievements.test_1 = {
-- 	name = "test_1",
-- 	display_completion_ui = true,
-- 	icon = "kerillian_elf_bow_antlersong_limbs_autumn_icon",
-- 	desc = "test_1_desc",
-- 	completed = function (statistics_db, stats_id)
		
-- 		local cheevo = "test_1_completed"
-- 		local finished = mod:get(cheevo)

-- 		if (mod.complete >= limit) or finished then
-- 			mod:set(cheevo, true)
-- 			mod:echo('COMPLETED!!!')
-- 			return true
-- 		end

-- 		return false
-- 	end,
-- 	progress = function (statistics_db, stats_id)
-- 		local count = mod.complete

-- 		local cheevo = "test_1_completed"
-- 		local finished = mod:get(cheevo) 
-- 		if finished then
-- 			count = limit
-- 		end

-- 		count = math.min(count, limit)

-- 		return {
-- 			count,
-- 			limit
-- 		}
-- 	end
-- }

-- AchievementTemplates.achievements.test_2 = {
-- 	name = "test_2",
-- 	display_completion_ui = true,
-- 	icon = "achievement_trophy_helmgart_lord_1",
-- 	desc = "test_2_desc",
-- 	completed = function (statistics_db, stats_id)
-- 		return statistics_db:get_persistent_stat(stats_id, "killed_lord_as_last_player_standing") > 0
-- 	end
-- }


mod.main_quest = {
	sub_quest_prologue = false,
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

mod.main_quest_completed = false
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
	icon = "la_mq01_quest_main_icon",
	desc = "main_quest_desc",
	completed = function (statistics_db, stats_id)
		
		-- if mod.main_quest[sub_01] and mod.main_quest[sub_01] and mod.main_quest[sub_01] then
		-- 	return true
		-- end
		for _, quest in pairs(mod.main_quest) do
			if not quest then
				mod.main_quest_completed = false 
				return false
			end
		end

		mod.locked_skins.Kruber_KOTBS_empire_sword_01 = false
		mod.locked_skins.Kruber_KOTBS_empire_zweihander_01 = false
		mod.locked_skins.Kruber_KOTBS_bret_sword_01 = false
		mod.locked_skins.Kruber_KOTBS_wizard_sword_01 = false

		mod.main_quest_completed = true
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

AchievementTemplates.achievements.sub_quest_prologue = {
	name = "sub_quest_prologue",
	display_completion_ui = true,
	icon = "la_mq01_quest_prelude_icon",
	desc = "sub_quest_prologue_desc",
	completed = function (statistics_db, stats_id)
		
		if mod:get("sub_quest_prologue".."_letter_read") then
			AchievementTemplates.achievements.sub_quest_01.name = "sub_quest_01"
			AchievementTemplates.achievements.sub_quest_01.desc = "sub_quest_01_desc"
			AchievementTemplates.achievements.sub_quest_01.icon = "la_mq01_quest_sub1_icon"
			AchievementTemplates.achievements.sub_quest_02.name = "sub_quest_02"
			AchievementTemplates.achievements.sub_quest_02.desc = "sub_quest_02_desc"
			AchievementTemplates.achievements.sub_quest_02.icon = "la_mq01_quest_sub2_icon"
			AchievementTemplates.achievements.sub_quest_03.name = "sub_quest_03"
			AchievementTemplates.achievements.sub_quest_03.desc = "sub_quest_03_desc"
			AchievementTemplates.achievements.sub_quest_03.icon = "la_mq01_quest_sub3_icon"
			AchievementTemplates.achievements.sub_quest_04.name = "sub_quest_04"
			AchievementTemplates.achievements.sub_quest_04.desc = "sub_quest_04_desc"
			AchievementTemplates.achievements.sub_quest_04.icon = "la_mq01_quest_sub4_icon"
			AchievementTemplates.achievements.sub_quest_05.name = "sub_quest_05"
			AchievementTemplates.achievements.sub_quest_05.desc = "sub_quest_05_desc"
			AchievementTemplates.achievements.sub_quest_05.icon = "la_mq01_quest_sub5_icon"
			mod.LA_quest_rewards.sub_quest_01.item_name = "sub_quest_01_reward"
			mod.LA_quest_rewards.sub_quest_02.item_name = "sub_quest_02_reward"
			mod.LA_quest_rewards.sub_quest_03.item_name = "sub_quest_03_reward"
			mod.LA_quest_rewards.sub_quest_04.item_name = "sub_quest_04_reward"
			mod.LA_quest_rewards.sub_quest_05.item_name = "sub_quest_05_reward"
			mod.main_quest.sub_quest_prologue = true
			return true
		end

		return false
	end,
}


local total_kills_sub_quest_one = 1500
AchievementTemplates.achievements.sub_quest_01 = {
	name = "locked",
	display_completion_ui = true,
	icon = "la_quest_lock_icon",
	desc = "locked_hidden_quest",
	completed = function (statistics_db, stats_id)
		
		--kill 500 rats with specific skin
		if mod:get("sub_quest_01") >= total_kills_sub_quest_one then
			mod.main_quest.sub_quest_01 = true
		end

		return mod.main_quest.sub_quest_01
	end,
	progress = function (statistics_db, stats_id)
		local collected = mod:get("sub_quest_01")
		if mod:get("sub_quest_01") > total_kills_sub_quest_one and mod:get("sub_quest_prologue".."_letter_read") then
			collected = total_kills_sub_quest_one
		end

		-- if not mod:get("sub_quest_01".."_letter_read") then
		-- 	return { }
		-- end

		return {
			collected,
			total_kills_sub_quest_one,
		}
	end,
}

local total_kills_sub_quest_two = 1500
AchievementTemplates.achievements.sub_quest_02 = {
	name = "locked",
	display_completion_ui = true,
	icon = "la_quest_lock_icon",
	desc = "locked_hidden_quest",
	completed = function (statistics_db, stats_id)
		
		--kill 500 nosrcans with specific skin
		if mod:get("sub_quest_02") >= total_kills_sub_quest_two then
			mod.main_quest.sub_quest_02 = true
		end

		return mod.main_quest.sub_quest_02
	end,
	progress = function (statistics_db, stats_id)
		local collected = mod:get("sub_quest_02")
		if mod:get("sub_quest_02") > total_kills_sub_quest_two and mod:get("sub_quest_prologue".."_letter_read") then
			collected = total_kills_sub_quest_two
		end

		-- if not mod:get("sub_quest_01".."_letter_read") then
		-- 	return {}
		-- end

		return {
			collected,
			total_kills_sub_quest_two,
		}
	end,
}

AchievementTemplates.achievements.sub_quest_03 = {
	name = "locked",
	display_completion_ui = true,
	icon = "la_quest_lock_icon",
	desc = "locked_hidden_quest",
	completed = function (statistics_db, stats_id)
		
		if mod:get("sub_quest_03") then
			mod.main_quest.sub_quest_03 = true
			return true
		end

		return false
	end
}

AchievementTemplates.achievements.sub_quest_04 = {
	name = "locked",
	display_completion_ui = true,
	icon = "la_quest_lock_icon",
	desc = "locked_hidden_quest",
	completed = function (statistics_db, stats_id)
		
		if mod:get("sub_quest_04") then
			mod.main_quest.sub_quest_04 = true
			return true
		end

		return false
	end
}

AchievementTemplates.achievements.sub_quest_05 = {
	name = "locked",
	display_completion_ui = true,
	icon = "la_quest_lock_icon",
	desc = "locked_hidden_quest",
	completed = function (statistics_db, stats_id)
		
		if mod:get("sub_quest_05") then
			if mod:get("sub_quest_05".."_letter_read") then
				if mod:get("sub_quest_04") then
					if mod:get("sub_quest_03") then
						AchievementTemplates.achievements.sub_quest_06.name = "sub_quest_06"
						AchievementTemplates.achievements.sub_quest_06.desc = "sub_quest_06_desc"
						AchievementTemplates.achievements.sub_quest_06.icon = "la_mq01_quest_sub6_icon"
						mod.LA_quest_rewards.sub_quest_06.item_name = "sub_quest_06_reward"
						mod.main_quest.sub_quest_05 = true
					end
				end
			end
			return true
		end

		return false
	end,
	requirements = function (statistics_db, stats_id)
		local reqs = {}

		if mod:get("sub_quest_05") then
			table.insert(reqs, {
				name = "read_new_message",
				completed = mod:get("sub_quest_05".."_letter_read")
			})
		end

		return reqs
	end
	
}

AchievementTemplates.achievements.sub_quest_06 = {
	name = "locked",
	display_completion_ui = true,
	icon = "la_quest_lock_icon",
	desc = "locked_hidden_quest",
	completed = function (statistics_db, stats_id)
		
		if mod:get("sub_quest_06") and mod:get("sub_quest_06".."_letter_read") then
			AchievementTemplates.achievements.sub_quest_07.name = "sub_quest_07"
			AchievementTemplates.achievements.sub_quest_07.desc = "sub_quest_07_desc"
			AchievementTemplates.achievements.sub_quest_07.icon = "la_mq01_quest_sub7_icon"
			mod.LA_quest_rewards.sub_quest_07.item_name = "sub_quest_07_reward"
			mod.main_quest.sub_quest_06 = true
			return true
		end

		return false
	end,
	requirements = function (statistics_db, stats_id)
		local reqs = {}

		if mod:get("sub_quest_06") then
			table.insert(reqs, {
				name = "read_new_message",
				completed = mod:get("sub_quest_06".."_letter_read")
			})
		end

		return reqs
	end
}

AchievementTemplates.achievements.sub_quest_07 = {
	name = "locked",
	display_completion_ui = true,
	icon = "la_quest_lock_icon",
	desc = "locked_hidden_quest",
	completed = function (statistics_db, stats_id)
		
		if mod:get("sub_quest_07") and mod:get("sub_quest_07".."_letter_read") then
			AchievementTemplates.achievements.sub_quest_08.name = "sub_quest_08"
			AchievementTemplates.achievements.sub_quest_08.desc = "sub_quest_08_desc"
			AchievementTemplates.achievements.sub_quest_08.icon = "la_mq01_quest_sub8_icon"
			mod.LA_quest_rewards.sub_quest_08.item_name = "sub_quest_08_reward"
			mod.main_quest.sub_quest_07 = true
			return true
		end

		return false
	end,
	requirements = function (statistics_db, stats_id)
		local reqs = {}

		if mod:get("sub_quest_07") then
			table.insert(reqs, {
				name = "read_new_message",
				completed = mod:get("sub_quest_07".."_letter_read")
			})
		end

		return reqs
	end
}

AchievementTemplates.achievements.sub_quest_08 = {
	name = "locked",
	display_completion_ui = true,
	icon = "la_quest_lock_icon",
	desc = "locked_hidden_quest",
	completed = function (statistics_db, stats_id)
		
		if mod:get("sub_quest_08") and mod:get("sub_quest_08".."_letter_read") then
			AchievementTemplates.achievements.sub_quest_09.name = "sub_quest_09"
			AchievementTemplates.achievements.sub_quest_09.desc = "sub_quest_09_desc"
			AchievementTemplates.achievements.sub_quest_09.icon = "la_mq01_quest_sub9_icon"
			mod.LA_quest_rewards.sub_quest_09.item_name = "sub_quest_09_reward"
			mod.main_quest.sub_quest_08 = true
			return true
		end

		return false
	end,
	requirements = function (statistics_db, stats_id)
		local reqs = {}

		if mod:get("sub_quest_08") then
			table.insert(reqs, {
				name = "read_new_message",
				completed = mod:get("sub_quest_08".."_letter_read")
			})
		end

		return reqs
	end
}

AchievementTemplates.achievements.sub_quest_09 = {
	name = "locked",
	display_completion_ui = true,
	icon = "la_quest_lock_icon",
	desc = "locked_hidden_quest",
	completed = function (statistics_db, stats_id)
		
		if mod:get("sub_quest_09") and mod:get("sub_quest_09".."_letter_read") then
			AchievementTemplates.achievements.sub_quest_10.name = "sub_quest_10"
			AchievementTemplates.achievements.sub_quest_10.desc = "sub_quest_10_desc"
			AchievementTemplates.achievements.sub_quest_10.icon = "la_mq01_quest_sub10_icon"
			mod.LA_quest_rewards.sub_quest_10.item_name = "sub_quest_10_reward"
			mod.main_quest.sub_quest_09 = true
			return true
		end

		return false
	end,
	requirements = function (statistics_db, stats_id)
		local reqs = {}

		if mod:get("sub_quest_09") then
			table.insert(reqs, {
				name = "read_new_message",
				completed = mod:get("sub_quest_09".."_letter_read")
			})
		end

		return reqs
	end
}

AchievementTemplates.achievements.sub_quest_10 = {
	name = "locked",
	display_completion_ui = true,
	icon = "la_quest_lock_icon",
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
