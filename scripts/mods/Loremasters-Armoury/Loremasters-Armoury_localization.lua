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
	sub_quest_prologue_message = {
		en = "Loremaster's Message",
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
	sub_quest_05_message = {
		en = "The Second Message",
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
	sub_quest_06_message = {
		en = "The Third Message",
	},
	sub_quest_07_desc = {
		en = "Search Blood in the Darkness for the Chronica Reiklandorum.",
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
	sub_quest_07_message = {
		en = "The Fourth Message",
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
	sub_quest_08_message = {
		en = "The Fifth Message",
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
	sub_quest_09_message = {
		en = "The Final Message",
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
	main_quest_reward_name = {
		en = "Incandescens",
	},
	main_quest_reward_desc = {
		en = "Loremaster's Armoury Skin"
	},
	info_text_la_mq01_reward = {
		en = "Weapon Illusion that can be applied to any of the matching types. Use the Loremaster's Armoury mod menu to apply the illusion",
	},
	la_mq01_reward_description = {
		en = "With the power once lost now finally renewed again, in hands of worthy wielder, this blade shall cleanse its name.",
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
	LA_locked_reward_desc = {
		en = "This reward is locked until the previous quest is completed.",
	},
	LA_locked_reward_name = {
		en = "Locked",
	},
	sub_quest_prologue_message_desc = {
		en = "Aethyr yenlui,\n\nI hope you did not run into any trouble on your way back, one can never know what they may encounter in these trying times. I received news about the missing caravan that was transporting several of my shipping crates from Altdorf, and though it saddens me to say this… what I feared the most turned out to be true.\n\nThe caravan was ambushed shortly after passing Osburg. No survivors, and from what was left after the ambush, I can say with certainty that Skaven were behind it. I am sure there is no need for me to say that arms and armour from Loremaster's Armoury in possession of these disgusting creatures is something I will not suffer, and neither should you. Since I am rather busy at the moment, I require your assistance in this matter.\n\nGo and search areas occupied by Skaven or their Northlander allies. Locate the missing shipping crates and take them back to your keep. Also, do not forget to kill as many of these abominations as you can. Gods know the world will be a better place without them.\n\n- go with Hoeth's blessings",
	},
    sub_quest_05_message_desc = {
        en = "I am pleased to know my crates made it safely to your keep, at least now will their contents be put into proper use.\n\nWith all the trouble caused by the caravan going missing, there is something I forgot to tell you. That sword I gave you… it used to have a potent magical enchantment flowing through it. The details explaining why it is no longer so are not important. What is important however, is that this enchantment was merely made dormant – meaning that it can still be revitalized… if you know how it was negated in the first place.\n\nI already performed most of the necessary steps back in my workshop, leaving one final task that has to be done by you: the blade’s new wielder. First, you will need to obtain a potent source of stable magical power. I have given it some thought and I believe there may be an artifact that you could use. Unfortunately I was unable to locate its position.\n\nIt appears something is disturbing the flow of Aethyr around the waystone of Athel Yenlui, making it impossible to perform an accurate divination ritual. Go to the temple and see what is causing the disturbance, we need the Winds calm if I am to help you find the artifact. Also while you are there… recover any old scripts you are able to find, I would like to have a look at those."
    },
    sub_quest_06_message_desc = {
        en = "Well done indeed, I felt the immediate change in currents of magic. Whatever you did back at the temple, it stabilized the waystone and calmed the turbulent flow of Aethyr throughout Reikland. Now that I think about it… next time you come across a disturbed Asur ritual site, it would be for the best if you merely scout the location, identify the issue, and then report back to me. Hoeth be praised that you did not cause more harm than good when meddling with things that surpass your comprehension.\n\nNevertheless, I was able to perform my divination ritual, but something is wrong. Usually, items of magical potential, such as this one should be, leave a noticeable mark – you could think of it as a lighthouse shining against a moonless sky. Skilled mage should easily find a way towards it. This one however, is dim. Not only that but our metaphorical light is being bent, twisted, warped… misguiding whoever is trying to follow it.\n\nWe will need more information to help us solve this puzzle. While I look for a way through this magical labyrinth, you visit the library inside the abandoned keep near Castle Drachenfels. What is left of it. See if you can find any texts containing historical records of this area. Hopefully it will shed some light on what might have happened to it."
    },
    sub_quest_07_message_desc = {
        en = "This is both fascinating and concerning... if we compare my findings with the historical records you were able to recover, I am quite confident when I say that we are indeed dealing with one of the missing Power Stones… as I expected. The records indicate that this could be the stone that was stolen from the Celestial College in Altdorf by a rogue wizard 86 years ago. Witch Hunter’s reports say that he was pursued all the way northeast to Erengrad in Kislev where he eventually found is doom at a rather disturbing ritual site. The stone was never recovered.\n\nFrom that point, your guess is almost as good as mine. I would say the stone was taken by some cult leader and eventually found its way to Norsca, moving between various chieftains until finally resting in hands of a sorcerer who saw its potential. Not even a century later and the very same Power Stone is back in Reikland, except it is not what it used to be.\n\nNow with the final piece of the puzzle in place, and the magical labyrinth bested, I am certain that the Power Stone is in possession of some powerful Chaos sorcerer who is currently somewhere in Helmgart. You must know that place very well by now, therefore I leave it to you to find him and recover the Power Stone. Be careful, I shall aid you however I can, but you will still need to do the heavy lifting yourselves. Isha be with you."
    },
    sub_quest_08_message_desc = {
        en = "By the Gods, it is worse than I expected… this Nurgle corruption runs deep. The original Elven wards still hold, but they are very weak. I am uncertain whether it is at all possible to cleanse this corruption and return the Power Stone to its original strength. Certainly not here… but we cannot give up. There may still be hope, though everything comes at a cost.\n\nThat withered Kislevite friend of yours reluctantly told me about your expeditions to the Chaos Wastes. Foolish if you ask me, but at least it gives us opportunities we would not have otherwise. Legends tell of an ancient place of great power within the heart of the Chaos Wastes: The Citadel of Eternity. I am sure you have heard of it by now, or so I am told. There is a chance that the power focused at the grand altar at the top of the Citadel could be powerful enough to cleanse this corruption, and if not completely renew its power, then at least restore enough of it for our needs.\n\nVenture into the Chaos Wastes and find The Citadel of Eternity. Place the Power Stone atop of the grand altar and prove you worth. You will be on your own this time, I cannot aid you out there. Be careful and may all the merciful Gods watch over you."
    },
    sub_quest_09_message_desc = {
        en = "I am impressed. At first, I thought all the rumours about you and your group to be nothing more than exaggerated gossip, spread among the locals to keep the morale up. It is rare, but I am glad I was mistaken. We need more capable individuals, such as yourself, if we are to prevail and push back the darkness closing in on us.\n\nThat Power Stone? For you it may be a living piece of history. For me… a reminder of events from not too long ago. Originally brought from Ulthuan by Loremaster Finreir during the Great War, it was later gifted to the first Patriarch of the Celestial College. In case you did not know, Power Stones are, to put it rather simply, solidified strands of Aethyr – Winds of Magic. Wizards can use them to amplify their magic or cast complex spells that would otherwise be out of reach of their inherent potential or overwhelm and destroy them outright.\n\nBy channelling this power through a focus, the dormant power within the blade will be restored. Place the Power Stone with the sword on the Altar of Myrmidia inside your Pilgrim’s Chamber. Focus your mind on the sword and the magic I weaved into the blade will do the rest.\n\nGo now, you have earned it. Feel free to stop by the Armoury from time to time, there is much more deeds that require our attention. Until we meet again. Blessings of Isha upon you."
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