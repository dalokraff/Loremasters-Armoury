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
    emp_zweihander = {
        en = "Empire Greatsword"
    },
    bret_sword = {
        en = "Bretonnian Longsword"
    },
    wizard_sword = {
        en = "Wizard's Sword"
    },
    wizard_flame_sword = {
        en = "Fire Sword"
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
		en = "Complete the following quests to receive the reward.",
	},
	main_quest = {
		en = "Where Does Thy Faith Lead",
	},
    main_quest_log = {
        en = "Where Does Thy Faith Lead"
    },
    main_01 = {
        en = "Where Does Thy Faith Lead"
    },
    main_01_desc = {
        en = "During one of your visits to Loremaster's Armoury in Altdorf, the Loremaster reluctantly gave you a sealed magical scroll together with an ancient looking sword shrouded in mysterious history. Though you will probably never learn the true story of this blade, there at least may be a way to renew its once lost power and restore the honour so foolishly tainted by the sword's previous wielder."
    },
    main_01_signature = {
        en = "Loremaster's Armoury"
    },
    read_new_message = {
        en = "Read the latest message from the Loremaster to complete"
    },
	sub_quest_prologue_desc = {
		en = "Read the message at Loremaster's Armoury message board to learn more about the upcoming task."
	},
	sub_quest_prologue = {
		en = "Loremaster's Message",
	},
	sub_quest_prologue_reward_name = {
		en = "Sealed Magical Scroll",
	},
	sub_quest_prologue_reward_desc = {
		en = "This magical scroll was given to you by the Loremaster during your last visit to the Armoury. For what purpose you do not know, and the glimmering seal is resisting your touch, preventing you from opening it... at least for now.",
	},
	sub_quest_prologue_message = {
		en = "Loremaster's Message",
	},
	sub_quest_01_desc = {
		en = "On your travels slay 1500 skaven.",
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
		en = "On your travels slay 1500 chaos worshippers.",
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
		en = "Find Loremaster's Armoury stolen crate in Righteous Stand.",
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
		en = "Find Loremaster's Armoury stolen crate in Convocation of Decay.",
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
		en = "Find Loremaster's Armoury stolen crate in Empire in Flames.",
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
	sub_quest_crate_tracker_message = {
		en = "Finders Keepers?",
	},
	sub_quest_06_desc = {
		en = "Complete Athel Yenlui after retrieving 3 Tomes and 2 Grimoires.",
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
		en = "Calming the Winds",
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
		en = "The Librarian",
	},
	sub_quest_08_desc = {
		en = "Retrieve the lost Power Stone from Burblespue Halescourge.",
	},
	sub_quest_08 = {
		en = "That Belongs in a Museum!",
	},
	sub_quest_08_reward_name = {
		en = "Corrupted Power Stone",
	},
	sub_quest_08_reward_desc = {
		en = "Ancient Power Stone corrupted by the Chaos sorcerer Burblespue Halescourge to serve his vile deeds, spreading illness and despair... not to mention putrid smell.",
	},
	sub_quest_08_message = {
		en = "That Belongs in a Museum!",
	},
	sub_quest_09_desc = {
		en = "Cleanse the corrupted Power Stone at the grand altar in The Citadel of Eternity.",
	},
	sub_quest_09 = {
		en = "An Overdue Restoration",
	},
	sub_quest_09_reward_name = {
		en = "Power Stone of Azyr",
	},
	sub_quest_09_reward_desc = {
		en = "Restored by the power of Gods, this ancient Power Stone hums calmly with the potent energy of Azyr once more.",
	},
	sub_quest_09_message = {
		en = "An Overdue Restoration",
	},
	sub_quest_10_desc = {
		en = "Perform the ritual at the Shrine of Myrmidia inside Pilgrimage Chamber of Taal's Horn Keep.",
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
		en = "Picked up the missing Shipping Crate",
	},
	LA_magic_gem_pickup = {
		en = "Picked up the Lost Artifact",
	},
	LA_reikbuch_pickup = {
		en = "Picked up the Chronica Reiklandorum",
	},
	reikbuch_desc = {
		en = "This dust and mold covered chronicle contains records of significat events that took place between ages 2294 and 2471 I.C. in Grand Principality of Reikland. Though a great number of pages are no longer legible, there is still a lot of history preserved here.",
	},
	magic_gem_desc = {
		en = "Restored by the power of Gods, this ancient Power Stone hums calmly with the potent energy of Azyr once more.",
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
		en = "Search",
	},
	LA_loremaster_message_small = {
		en = "Small Letter",
	},
	LA_loremaster_message_medium = {
		en = "Medium Letter",
	},
	LA_loremaster_message_large = {
		en = "Large Letter",
	},
	letter_recieved = {
		en = "Recieved a letter from\nthe Loremaster.\nRead it to advance the quest.",
	},
	LA_locked_reward_desc = {
		en = "This reward is locked until the previous quest is completed.",
	},
	LA_locked_reward_name = {
		en = "Locked",
	},
	sub_quest_prologue_message_desc = {
		en = "Aethyr yenlui,\n\nI hope you did not run into any trouble on your way back, one can never know what you may encounter in these trying times. I received news about the missing caravan, transporting several of my shipping crates from Altdorf, and though it saddens me to say this… what I feared the most turned out to be true.\n\nThe caravan was ambushed shortly after passing Osburg. No survivors. From what was left after the ambush, I can say with certainty that the Skaven were behind it. I am sure there is no need for me to say that, I will not suffer arms and armour from Loremaster's Armoury being in possession of these disgusting creatures, and neither should you. Since I am rather busy at the moment, I require your assistance in this matter.\n\nGo and search areas occupied by Skaven or their Northlander allies. Locate the missing shipping crates and take them back to your keep. Also, do not forget to kill as many of these abominations as you can. Gods know the world will be a better place without them.\n\n- go with Hoeth's blessings",
	},
    sub_quest_crate_tracker_message_desc = {
        en = "I am pleased to know my crates made it safely to your keep, at least now will their contents be put into proper use.\n\nWith that taken care of, there is something I did not tell you when you were here. That sword I gave you… it used to have a potent magical enchantment flowing through it. The details explaining why it is no longer so are not important. What is important however, is that this enchantment was merely made dormant – meaning that it can still be revitalized… if you know how it was negated in the first place.\n\nI already prepared everything necesarry in the scroll I gave you, but there is one final task that must be performed by you: the blade’s new wielder. First, you will need to obtain a potent source of stable magical power. I gave it some thought and I believe there may be an artifact you could use. Unfortunately I was unable to locate its position.\n\nIt appears something is disturbing the flow of Aethyr around the waystone of Athel Yenlui, making it impossible to perform an accurate divination ritual. Go to the temple and see what is causing the disturbance, we need the Winds calm if I am to help you find the artifact. While you are there… recover any old scripts you can find, I would like to have a look at those.",
    },
    sub_quest_06_message_desc = {
        en = "Well done indeed, I felt an immediate change in the currents of magic. Whatever you did back at the temple, it stabilized the waystone and calmed the turbulent flow of Aethyr throughout the Reikland. Now that I think about it… next time you come across a disturbed Asur ritual site, it would be for the best if you merely scout the location, identify the issue, and then report back to me. Hoeth be praised you did not cause more harm meddling with things that surpass your comprehension.\n\nNevertheless, I was able to perform my divination ritual, but something is wrong. Usually, items of this magical magnitude always leave a noticeable mark – you can imagine it as a lighthouse shining against the dark moonless sky. A skilled mage should easily find their way towards it. This one however, is dim. Not only that but the metaphorical light is being bent, twisted, warped… misguiding whoever would try to follow it.\n\nWe will need more information to help us solve this puzzle. While I look for a way through this magical labyrinth, you visit the library inside the abandoned keep near Castle Drachenfels... what is left of it. See if you can find any texts containing historical records of this area. Hopefully it will shed some light on what is happening.",
    },
    sub_quest_07_message_desc = {
        en = "This is both fascinating and concerning... if we compare my findings with the historical records you were able to recover, I am quite confident we are indeed dealing with one of the missing Power Stones. The records suggest this could be the stone that was stolen from the Celestial College in Altdorf by a rogue wizard 172 years ago. Witch Hunters’ reports say that he was pursued all the way northeast to Erengrad in Kislev, where he eventually found his doom at a rather disturbing ritual site. The stone was never recovered.\n\nFrom that point, your guess is almost as good as mine. I would say the stone was taken by some cult leader and eventually found its way to Norsca, moving between chieftains until finally resting in hands of a sorcerer who saw its potential. Almost two centuries later and the very same Power Stone has made it back to the Reikland, except it is not what it used to be.\n\nNow with the final piece of the puzzle in place, and the magical labyrinth bested, I am certain that the Power Stone is in the possession of some powerful Chaos sorcerer who is currently somewhere in Helmgart. You must know that place very well by now, therefore I leave it to you to find him and recover the Power Stone. Be careful, I shall aid you whenever I can, but you will still need to do the heavy lifting yourselves. Isha be with you.",
    },
    sub_quest_08_message_desc = {
        en = "By the Gods, it is worse than I expected… this Nurgle corruption runs deep. The prime Elven wards still hold, but they are very weak. I am uncertain whether it is even possible to cleanse this corruption and return the Power Stone to its original strength. Certainly not here… but we cannot give up. There may still be hope, though everything comes at a cost.\n\nThat withered Kislevite friend of yours reluctantly told me about your expeditions to the Chaos Wastes. Foolish if you ask me, but at least it gives us opportunities we would not otherwise have. Legends tells of an ancient place, of great power within the heart of the Chaos Wastes: The Citadel of Eternity. Apparently you've already heard of it, or so I am told. There is a chance that the power focused at the grand altar atop of the Citadel may be enough to cleanse this corruption, and if not completely renew its power, then at least restore enough of it to suit our needs.\n\nVenture into the Chaos Wastes and find The Citadel of Eternity. Place the Power Stone atop the grand altar and prove your worth. You will be on your own this time, I cannot aid you out there. Be careful and may all the merciful Gods watch over you.",
    },
    sub_quest_09_message_desc = {
        en = "I am impressed. At first, I thought all the rumours about you and your group to be nothing more than exaggerated gossip, spread amongst the locals to keep the morale up. It is rare, but I am glad I was mistaken. We need more capable individuals, such as yourself, if we are to prevail and push back the darkness surrounding us.\n\nThat Power Stone has a long history. It was brought from Ulthuan by Loremaster Finreir during the Great War, and was later gifted to the first Patriarch of the Celestial College. In case you did not know, Power Stones are, to put it rather simply, solidified strands of Aethyr – Winds of Magic. Wizards can use them to amplify their magic or cast complex spells that would otherwise be out of the reach of their inherent potential or overwhelm and destroy them outright.\n\nBy channelling this power through a divine focus, the dormant power within the blade will be restored. Place the scroll I gave you next to the Power Stone and the sword at the Altar of Myrmidia inside the Pilgrimage Chamber; focus your mind and the magic I weaved into it will do the rest.\n\nGo now, you have earned it. Stop by the Armoury from time to time, there are many deeds that require our attention. Until we meet again. Blessings of Isha upon you.",
    },
    sword_enchantment = {
        en = "Magical Scroll",
    },
    sword_enchantment_action = {
        en = "Place",
    },
	Loremaster_magicscroll_rolled = {
        en = "Sealed Magical Scroll",
	},
	Loremaster_magicscroll_rolled_desc = {
        en = "This magical scroll was given to you by the Loremaster during your last visit to the Armoury. For what purpose you do not know, and the glimmering seal is resisting your touch, preventing you from opening it... at least for now.",
	},
    sub_quest_crate_tracker = {
        en = "Finders Keepers?",
    },
    sub_quest_crate_tracker_desc = {
        en = "Retrieve all the stolen shipping crates.",
    },
	halescourge_buff_chat_message = {
		en = "The Loremaster channels supportive magic your way: +25% CDR, +4 Stamina",
	},
	la_pickup_message = {
		en = "Pickup",
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