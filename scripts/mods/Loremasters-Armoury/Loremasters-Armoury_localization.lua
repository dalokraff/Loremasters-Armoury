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
		en = "Search Blood in the Darkness for The Chronica Reiklandorum.",
	},
	sub_quest_07 = {
		en = "The Librarian",
	},
	sub_quest_08_desc = {
		en = "Retreive the mysterious artifact from Burblespue Halescourge.",
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
		en = "Shipping Crate",
	},
	reikbuch = {
		en = "Chronica Reiklandorum",
	},
	magic_gem = {
		en = "Stone of X",
	},
	magic_gem_nurgle = {
		en = "Corrupted Stone of X",
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
		en = "Fashion plays a more important role in a Reiklander's social life than in most other provinces. The peasantry, of course, care little for such fripperies, but amongst the growing middle classes the correct sleeves, shoes, and colours are matters of great import. The Reiklander nobility tend to set the fashion for a season, leaving it to the merchant and other 'grubby tradesmen' to copy their new styles as fast as they can. [1a]The presence of the Imperial Court in Altdorf has only served to exacerbate these tendencies. Recent vogues have included Bretonnian styles, the 'new rustic', and most recently a return to simple militaristic clothing reminiscent of an earlier era. Slashed sleeves, elaborate codpieces, and reliquary charms remain as fashionable as ever.[1a]	At their worst, Reiklanders are arrogant, overbearing, and drunken slaves to fashion. Notorious for their ability to celebrate at the drop of a hat, the image of the beribboned Reiklander sot is a popular stereotype amongst the rest of the Empire. In certain places the small black insects that plague an ill-kept taproom are known as 'Reikflies' as they can detect the smallest amount of ale unerringly.[1a] The people of many of the other Imperial provinces are suspicious of the fashionable, cosmopolitan nature of the Reikland men, claiming that they are effeminate and womanish for caring so much about what they wear. Curiously, Reiklander men also have a reputation as wife-stealing, pig-buggering philanderers.[1a] More than one Talabeclander husband has found his woman seduced by the charming words and dashing look of a Reiklander dandy. Reiklander women, meanwhile, are known for their beauty, as well as unbearably vain personality.[1a] Loud, outspoken, and often smug about the imagined superiority of their opinions, Reiklanders are traditionally known to be controlling and strongly opinionated. Their lack of stamina is also a welcome source for vituperative and malicious comments amongst the other peoples of the Empire. [1a]The Reiklander tendency to want to finish a task quickly and then come home is well known. Indeed, as war increasingly consumes the Empire, Reiklanders have flocked to the Emperor's banner, so much so that there have been worries that there would be no one be at home to tend to the fields and bring in the harvest.[1a] Although they honour all the gods, Reiklanders generally see Sigmar as their special patron, for he was once one of them. Other popular deities of the Old World Pantheon in Reikland include Dyrath, a regional name for Rhya, whom Reiklanders of Vorbergland honour as the goddess of fertility, and Shallya, whose temples and hospices are frequent recipients of gifts and bequests of wealthy Reiklanders.[1a] ",
	},
	magic_gem_desc = {
		en = "",
	},
	magic_gem_nurgle_desc = {
		en = "",
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