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
		en = "Complete Sub Quests 1-10 to receive the reward.",
	},
	main_quest = {
		en = "Main Quest",
	},
	sub_quest_01_desc = {
		en = "sub_quest_01_desc",
	},
	sub_quest_01 = {
		en = "Fight against the Infestation",
	},
	sub_quest_02_desc = {
		en = "sub_quest_02_desc",
	},
	sub_quest_02 = {
		en = "Fight against the Corruption",
	},
	sub_quest_03_desc = {
		en = "Find Loremaster's Armoury lost shipment in Righteous Stand.",
	},
	sub_quest_03 = {
		en = "A Favour for the Loremaster I",
	},
	sub_quest_04_desc = {
		en = "Find Loremaster's Armoury lost shipment in Convocation of Decay.",
	},
	sub_quest_04 = {
		en = "A Favour for the Loremaster II",
	},
	sub_quest_05_desc = {
		en = "Find Loremaster's Armoury lost shipment in Empire in Flames.",
	},
	sub_quest_05 = {
		en = "A Favour for the Loremaster III",
	},
	sub_quest_06_desc = {
		en = "Complete Athel Yelnuli after retrieving 3 Tomes and 2 Grimoires.",
	},
	sub_quest_06 = {
		en = "Calming the Winds",
	},
	sub_quest_07_desc = {
		en = "Search Blood in the Darkness for the Reikland chronicle.",
	},
	sub_quest_07 = {
		en = "The Librarian",
	},
	sub_quest_08_desc = {
		en = "Retreive the mysterious artifact from Bödvarr Ribspreader in The War Camp.",
	},
	sub_quest_08 = {
		en = "That Belongs in a Museum!",
	},
	sub_quest_09_desc = {
		en = "Cleanse the corrupted artifact at the altar in The Citadel of Eternity.",
	},
	sub_quest_09 = {
		en = "An Overdue Restoration",
	},
	sub_quest_10_desc = {
		en = "Pray at the Shrine of Myrmidia in Pilgrimage Chamber of Taal's Horn Keep.",
	},
	sub_quest_10 = {
		en = "Blessing of the Sun",
	},

	locked_hidden_quest = {
		en = "This quest is locked until the previous one is compelted",
	},
	LA_crate = {
		en = "Shipping Crate"
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
	local skin_name = tostring(skin).."_name"
	if not mod_text_ids[skin] then
		mod_text_ids[skin] = {}
	end
	local translation = game_localize:_base_lookup(ItemMasterList[skin].display_name)--game_localize:_base_lookup(skin_name) or game_localize:_base_lookup("display_name_"..tostring(skin)) or game_localize:_base_lookup(tostring(skin))
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