local mod = get_mod("Loremasters-Armoury")
mod:dofile("scripts/mods/Loremasters-Armoury/string_dict")

local mod_text_ids = {
	mod_description = {
		en = "Loremasters-Armoury description",
	},
	mod_name = {
		en = "Loremaster's Armoury",
	},
	choose_char_hat = {
		en = "Choose Hat for Character",
	},
	choose_skin = {
		en = "Choose active skin"
	},
	choose_wep = {
		en = "Choose Weapon",
	},
	choose_char_armor = {
		en = "Choose Character Skin"
	},
	choose_hat = {
		en = "Choose Hat",
	},
	pick_wep = {
		en = "Pick Weapon",
	},
	krub = {
		en = "Kruber",
	},
	bard = {
		en = "Bardin",
	},
	salt = {
		en = "Saltspyre",
	},
	elf = {
		en = "Kerrilian",
	},
	wiz = {
		en = "Sienna",
	},
	bret_sword_shield = {
		en = "Breton Long Sword and Shield",
	},
	emp_spear_shield = {
		en = "Empire Spear and Shield",
	},
	emp_sword_shield = {
		en = "Empire Sword and Shield",
	},
	emp_mace_shield = {
		en = "Empire Mace and Shield",
	},
	elf_spear_shield = {
		en = "High Elf Spear and Shield",
	},
	dwarf_axe_shield = {
		en = "Dwarf Axe and Shield"
	},
	dwarf_ham_shield = {
		en = "Dwarf Hammer and Shield"
	},
	elf_hm_hat_1001 = {
		en = "Windrunner's helm",
	},
	elf_bow = {
		en = "Elf Longbow",
	},
	emp_sword = {
		en = "Empire Sword",
	},
	default = {
		en = "default",
	},
	test_1 = {
		en = "test achievement",
	},
	test_1_desc = {
		en = "test description",
	},
	main_quest_desc = {
		en = "Complete all relavent Sub Quests.",
	},
	main_quest = {
		en = "Main Quest",
	},
	sub_quest_prologue_desc = {
		en = "Read the message at Loremaster's Armoury message board to learn more about the upcoming task."
	},
	sub_quest_prologue = {
		en = "Loremaster's Message",
	},
	sub_quest_prologue_reward_name = {
		en = "Loremaster's Message",
	},
	sub_quest_prologue_reward_desc = {
		en = "Message from the Loremaster that sets you on your new journey. Blaze a trail.",
	},
	sub_quest_01_desc = {
		en = "On your travels slay 500 skaven.",
	},
	sub_quest_01 = {
		en = "Fight against the Infestation",
	},
	sub_quest_01_reward_name = {
		en = "Myrmidia's Favour",
	},
	sub_quest_01_reward_desc = {
		en = "The goddess of war, beauty and honour guides your path.",
	},
	sub_quest_02_desc = {
		en = "On your travels slay 500 chaos worshippers.",
	},
	sub_quest_02 = {
		en = "Fight against the Corruption",
	},
	sub_quest_02_reward_name = {
		en = "Myrmidia's Favour",
	},
	sub_quest_02_reward_desc = {
		en = "The goddess of war, beauty and honour guides your path.",
	},
	sub_quest_03_desc = {
		en = "Find Loremaster's Armoury lost shipment in Righteous Stand.",
	},
	sub_quest_03 = {
		en = "A Favour for the Loremaster I",
	},
	sub_quest_03_reward_name = {
		en = "Loremaster's Armoury Shipping Crate",
	},
	sub_quest_03_reward_desc = {
		en = "A sturdy wooden shipping crate sent from Loremaster's Armoury in Altdorf. Looks like some Imperial official took a great care in placing various purity seals all over it... just in case.",
	},
	sub_quest_04_desc = {
		en = "Find Loremaster's Armoury lost shipment in Convocation of Decay.",
	},
	sub_quest_04 = {
		en = "A Favour for the Loremaster II",
	},
	sub_quest_04_reward_name = {
		en = "Loremaster's Armoury Shipping Crate",
	},
	sub_quest_04_reward_desc = {
		en = "A sturdy wooden shipping crate sent from Loremaster's Armoury in Altdorf. Looks like some Imperial official took a great care in placing various purity seals all over it... just in case.",
	},
	sub_quest_05_desc = {
		en = "Find Loremaster's Armoury lost shipment in Empire in Flames.",
	},
	sub_quest_05 = {
		en = "A Favour for the Loremaster III",
	},
	sub_quest_05_reward_name = {
		en = "Loremaster's Armoury Shipping Crate",
	},
	sub_quest_05_reward_desc = {
		en = "A sturdy wooden shipping crate sent from Loremaster's Armoury in Altdorf. Looks like some Imperial official took a great care in placing various purity seals all over it... just in case.",
	},
	sub_quest_06_desc = {
		en = "Complete Athel Yelnuli after retrieving 3 Tomes and 2 Grimoires.",
	},
	sub_quest_06 = {
		en = "Calming the Winds",
	},
	sub_quest_06_reward_name = {
		en = "Myrmidia's Favour",
	},
	sub_quest_06_reward_desc = {
		en = "The goddess of war, beauty and honour guides your path.",
	},
	sub_quest_07_desc = {
		en = "Search Blood in the Darkness for The Chronica Reiklandorum.",
	},
	sub_quest_07 = {
		en = "The Librarian",
	},
	sub_quest_07_reward_name = {
		en = "Chronica Reiklandorum",
	},
	sub_quest_07_reward_desc = {
		en = "This dust and mold covered chronicle contains records of significat events that took place between ages 2294 and 2471 I.C. in Grand Principality of Reikland. Though a great number of pages are no longer legible, there is still a lot of history preserved here.",
	},
	sub_quest_08_desc = {
		en = "Retreive the mysterious artifact from Burblespue Halescourge.",
	},
	sub_quest_08 = {
		en = "That Belongs in a Museum!",
	},
	sub_quest_08_reward_name = {
		en = "Corrupted Power Stone",
	},
	sub_quest_08_reward_desc = {
		en = "Ancient Power Stone corrupted by the Chaos sorcerer Burblespue Halescourge to serve his vile deeds, spreading illness and despair... not to mention the putrid smell.",
	},
	sub_quest_09_desc = {
		en = "Cleanse the corrupted artifact at the altar in The Citadel of Eternity.",
	},
	sub_quest_09 = {
		en = "An Overdue Restoration",
	},
	sub_quest_09_reward_name = {
		en = "Power Stone of Azyr",
	},
	sub_quest_09_reward_desc = {
		en = "Restored by the power of Gods, this ancient Power Stone hums calmly with the potent energy of Azyr once again.",
	},
	sub_quest_10_desc = {
		en = "Pray at the Shrine of Myrmidia in Pilgrimage Chamber of Taal's Horn Keep.",
	},
	sub_quest_10 = {
		en = "Blessing of the Sun",
	},
	sub_quest_10_reward_name = {
		en = "Myrmidia's Blessing",
	},
	sub_quest_10_reward_desc = {
		en = "The goddess rewards your vailant and honourable deeds.",
	},

	locked_hidden_quest = {
		en = "This quest is locked until the previous one is compelted",
	},
	LA_crate = {
		en = "Shipping Crate",
	},
	reikbuch = {
		en = "Chronica Reiklandorum",
	},
	magic_gem = {
		en = "Power Stone of Azyr",
	},
	magic_gem_nurgle = {
		en = "Corrupted Power Stone",
	},
	locked = {
		en = "",
	},
	LA_crate_pickup = {
		en = "Picked up a missing Shipment Crate",
	},
	LA_magic_gem_pickup = {
		en = "Picked up The Lost Artifact",
	},
	LA_reikbuch_pickup = {
		en = "Picked up The Chronica Reiklandorum",
	},
	reikbuch_desc = {
		en = "This dust and mold covered chronicle contains records of significat events that took place between ages 2294 and 2471 I.C. in Grand Principality of Reikland. Though a great number of pages are no longer legible, there is still a lot of history preserved here.",
	},
	magic_gem_desc = {
		en = "Restored by the power of Gods, this ancient Power Stone hums calmly with the potent energy of Azyr once again.",
	},
	magic_gem_nurgle_desc = {
		en = "Ancient Power Stone corrupted by the Chaos sorcerer Burblespue Halescourge to serve his vile deeds, spreading illness and despair... not to mention the putrid smell.",
	},
	LA_read_action = {
		en = "Read",
	},
	LA_message_board = {
		en = "Letter Archive",
	},
	LA_message_board_action = {
		en = "Search"
	},
	LA_loremaster_message_small = {
		en = "Small Letter"
	},
	LA_loremaster_message_medium = {
		en = "Medium Letter"
	},
	LA_loremaster_message_large = {
		en = "Large Letter"
	},
	letter_recieved = {
		en = "Recieved a letter from\nthe Loremaster.\nRead it to advance the quest."
	},	

}

for id,text in pairs(mod.name_strings_id) do
	if not mod_text_ids[id] then
		mod_text_ids[id] = {}
	end
	mod_text_ids[id]['zh'] = text
	mod_text_ids[id]['en'] = text
	mod_text_ids[id]['fr'] = text
	mod_text_ids[id]['de'] = text
	mod_text_ids[id]['it'] = text
	mod_text_ids[id]['pl'] = text
	mod_text_ids[id]['br-pt'] = text
	mod_text_ids[id]['ru'] = text
	mod_text_ids[id]['es'] = text
end


local game_localize = Managers.localizer
for _,skin in pairs(mod.vanilla_game_strings) do
	
	local pattern = "_rightHand"
    local new_name = string.gsub(skin, pattern, "")
	
	local skin_name = tostring(skin).."_name"
	if not mod_text_ids[skin] then
		mod_text_ids[skin] = {}
	end
	local translation = game_localize:_base_lookup(ItemMasterList[new_name].display_name)--game_localize:_base_lookup(skin_name) or game_localize:_base_lookup("display_name_"..tostring(skin)) or game_localize:_base_lookup(tostring(skin))
	mod_text_ids[skin]['zh'] = translation
	mod_text_ids[skin]['en'] = translation
	mod_text_ids[skin]['fr'] = translation
	mod_text_ids[skin]['de'] = translation
	mod_text_ids[skin]['it'] = translation
	mod_text_ids[skin]['pl'] = translation
	mod_text_ids[skin]['br-pt'] = translation
	mod_text_ids[skin]['ru'] = translation
	mod_text_ids[skin]['es'] = translation
end


return mod_text_ids