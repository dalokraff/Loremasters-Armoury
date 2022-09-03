local mod = get_mod("Loremasters-Armoury")
mod:dofile("scripts/mods/Loremasters-Armoury/skin_list")

local desc_strings = {
    Kruber_Grail_Knight_Bastonne02 = "The current ruler, Duke Bohemond Beastslayer, is a lineal descendant of Gilles le Breton; the first Royarch of Bretonnia and a founding Duke of the fabled Dukedom of Bastonne.",
    Kruber_bret_shield_basic1_Reynard01 = "Reynard Le Chasseur, also known as Reynard the Hunter, is a famous knightly hunter from the Dukedom of Artois - a land of forested wilderness known as the Forest of Arden.",
    Kruber_bret_shield_basic2_Luidhard01 = "Having the most tranquil lands, this Dukedom is far from a paradise, for without any external threats to unify the people of Aquitaine, they often fall into inner strife; peasant revolutions and small civils wars being an all too common occurrence.",
    Kruber_bret_shield_basic3_Lothar01 = "Gold hart on a sable field is the crest of Lothar, a late descendant of Duke Hagen, the current ruler of Dukedom of Gisoreux.",
    Kruber_bret_shield_hero1_Alberic01 = "The Lady's domain ends where the water runs salt; it is here, where that of the tempestuous sea-god Manann's begins.",
    Kruber_empire_shield_hero1_Ostermark01 = "Bordering Kislev to the north and Sylvania to the south, the grim lands of Ostermark are scarred by a long history of invasions, disasters and lawless reavers.",
    Kruber_empire_shield_hero1_Kotbs01 = "Dedicated to Myrmidia, human goddess of war, Knights of the Blazing Sun value ability and accomplishment above all, often wielding weapons enchanted with the divine flames of their goddess.",
    Kruber_empire_shield_basic3_Middenheim01 = "Ulric protects his own.",
    Kruber_empire_shield_basic1 = "The symbol of Ostland is the bull - stubborn and dependable, just like the people of Ostland themselves.",
    Kruber_empire_shield_basic1_Ostermark01 = "Bordering Kislev to the north and Sylvania to the south, the grim lands of Ostermark are scarred by a long history of invasions, disasters and lawless reavers.",
    Kruber_empire_shield_basic2 = "Where march you, men of Reikland, where carry you halberds and swords? We march to war for our Emperor and Sigmar, our saviour and lord.",
    Kruber_empire_shield_basic2_Kotbs01 = "Dedicated to Myrmidia, human goddess of war, Knights of the Blazing Sun value ability and accomplishment above all, often wielding weapons enchanted with the divine flames of their goddess.",
    Kruber_empire_shield_basic2_Middenheim = "Ulric protects his own.",
    Kerillian_elf_shield_basic_Avelorn01 = "In time of need, every city musters its force to help in Ulthuan's defense.",
    Kerillian_elf_shield_basic_Avelorn01_mesh = "In time of need, every city musters its force to help in Ulthuan's defense.",
    Kerillian_elf_shield_heroClean_Saphery01 = "Aside from powerful mages, the enchanted land of Saphery is also home to Swordmasters of Hoeth, who dedicate their lives to study of meditation and deadly martial arts.",
    Kerillian_elf_shield_heroClean_Caledor01 = "Woe betide he who encounters an army of Caledor on the march, for it will surely be the last battle he ever fights.",
    Kerillian_elf_shield_heroClean_Avelorn02 = "Avelorn is the spiritual heart of Ulthuan, for it is here that the Everqueen holds court.",
    Kerillian_elf_shield_basic2 = "Being the oldest great mountain fortress of Ulthuan, facing hundreds of sieges over thousands of years, the Griffon Gate has never fallen to its attackers.",
    Kerillian_elf_shield_basic2_mesh = "Being the oldest great mountain fortress of Ulthuan, facing hundreds of sieges over thousands of years, the Griffon Gate has never fallen to its attackers.",
    Kerillian_elf_shield_basic2_Eaglegate01 = "Should a soldier survive his duty at one of the great fortresses of Ulthuan, he will thereafter be treated with respect by commoner and noble alike.",
    Kerillian_elf_shield_basicClean = "Phoenixes - the chosen messengers of the Creator God - are a popular symbols among the folk of Eataine, who believe that is was Asuryan who lifted Ulthuan from ocean's depths.",
    Kerillian_elf_shield_basicClean_Saphery01 = "Aside from powerful mages, the enchanted land of Saphery is also home to Swordmasters of Hoeth, who dedicate their lives to study of meditation and deadly martial arts.",
    Kerillian_elf_shield_heroClean_Eataine01 = "Phoenixes - the chosen messengers of the Creator God - are a popular symbols among the folk of Eataine, who believe that is was Asuryan who lifted Ulthuan from ocean's depths.",
    Kerillian_elf_shield_basicClean_Caledor01 = "Woe betide he who encounters an army of Caledor on the march, for it will surely be the last battle he ever fights.",
    Kerillian_elf_shield_basicClean_Chrace01 = "Red is the dominant colour of Chracian heraldry, signifying the blood its people spill, not only in the defence of their own land, but for all Ulthuan.",
    Kerillian_elf_shield_heroClean_Chrace01 = "Red is the dominant colour of Chracian heraldry, signifying the blood its people spill, not only in the defence of their own land, but for all Ulthuan.",
    Kerillian_elf_hat_Windrunner_Avelorn = "Still well preserved even after centuries of combat, this masterfully crafted helm bears colours of the kingdom of Avelorn.",
    Kerillian_elf_hat_Windrunner_Caledor = "Still well preserved even after centuries of combat, this masterfully crafted helm bears colours of the kingdom of Caledor",
    Kerillian_elf_hat_Windrunner_Chrace = "Still well preserved even after centuries of combat, this masterfully crafted helm bears colours of the kingdom of Chrace",
    Kerillian_elf_hat_Windrunner_Cothique = "Still well preserved even after centuries of combat, this masterfully crafted helm bears colours of the kingdom of Cothique",
    Kerillian_elf_hat_Windrunner_Eataine = "Still well preserved even after centuries of combat, this masterfully crafted helm bears colours of the kingdom of Eataine",
    Kerillian_elf_hat_Windrunner_Ellyrion = "Still well preserved even after centuries of combat, this masterfully crafted helm bears colours of the kingdom of Ellyrion",
    Kerillian_elf_hat_Windrunner_Nagarythe = "Still well preserved even after centuries of combat, this masterfully crafted helm bears colours of the kingdom of Nagarythe",
    Kerillian_elf_hat_Windrunner_Saphery = "Still well preserved even after centuries of combat, this masterfully crafted helm bears colours of the kingdom of Saphery",
    Kerillian_elf_hat_Windrunner_Tiranoc = "Still well preserved even after centuries of combat, this masterfully crafted helm bears colours of the kingdom of Tiranoc",
    Kerillian_elf_hat_Windrunner_Yvresse = "Still well preserved even after centuries of combat, this masterfully crafted helm bears colours of the kingdom of Yvresse",
    Ker_Autumn_Weave_Armor = "Tirsyth, the Ashenhall, is a High Realm of Athel Loren encased in eternal autumn. Elves who live there revere life's end as fervently as they do its start, erecting moonstone statues of the departed to remember and honour their deceased kin.",
    Kerillian_Evercrown_helm_AutumnHerald = "High-status waywatcher's mask, worn by a warrior skilled in the myriad ways of silent death.",
    Kerillian_Evercrown_helm_GreenHerald = "High-status waywatcher's mask, worn by a warrior skilled in the myriad ways of silent death.",
    Kerillian_HornOfKurnous_helm_Beaststalker = "Antlered hood, symbolising dedication to Kurnous, God of the Hunt. Seldom worn by elf-maids.",
    Kerillian_HornOfKurnous_helm_Frostwatcher = "Antlered hood, symbolising dedication to Kurnous, God of the Hunt. Seldom worn by elf-maids.", 
    Kerillian_HornOfKurnous_helm_Nightstalker = "Antlered hood, symbolising dedication to Kurnous, God of the Hunt. Seldom worn by elf-maids.",
    Kerillian_HornOfKurnous_helm_Purified = "Showing proper respect to the Pale Queen might call her into acton, and this save your soul from the clutches of chaos.",
    Kerillian_elf_bow_Antlersong_Autumn = "Under the perennially auburn leaves of the mighty guardian Delliandra, the forest grows and grows eternally.",
    Kerillian_elf_bow_Antlersong_Autumn_runed01 = "Under the perennially auburn leaves of the mighty guardian Delliandra, the forest grows and grows eternally.",
    Kruber_KOTBS_hat = "There is a subtle touch of elven magic upon this helm, protecting its wearer's mind and enhancing their senses. A favour from an old friend?",
    Kruber_KOTBS_armor = "To accomplish any task - to defeat any foe, all that is needed is a keen eye, a sharp mind and the favour of the Goddess.",
    Kruber_Hippogryph_helm_black = "Helmet of an audacious knight, acclaimed valiant after slaying a mighty beast.",
    Kruber_Hippogryph_helm_blue = "Helmet of an audacious knight, acclaimed valiant after slaying a mighty beast.",
    Kruber_Hippogryph_helm_red = "Helmet of an audacious knight, acclaimed valiant after slaying a mighty beast.",
    Kruber_Hippogryph_helm_white = "Helmet of an audacious knight, acclaimed valiant after slaying a mighty beast.",
    Kruber_Pureheart_helm_black = "Helm of a valiant hero. Several valiant heroes, in fact, because the wearers have something of knack for finding fatal trouble.",
    Kruber_Pureheart_helm_red = "Helm of a valiant hero. Several valiant heroes, in fact, because the wearers have something of knack for finding fatal trouble.",
    Kruber_Pureheart_helm_white = "Helm of a valiant hero. Several valiant heroes, in fact, because the wearers have something of knack for finding fatal trouble.",
    Kruber_Pureheart_helm_yellow = "Helm of a valiant hero. Several valiant heroes, in fact, because the wearers have something of knack for finding fatal trouble.",
    Kruber_Worthy_helm_black = "A knight's headpiece, as stalwart and true as he who dons it.",
    Kruber_Worthy_helm_red = "A knight's headpiece, as stalwart and true as he who dons it.",
    Kruber_Worthy_helm_white = "A knight's headpiece, as stalwart and true as he who dons it.",
    Kruber_Worthy_helm_yellow = "A knight's headpiece, as stalwart and true as he who dons it.",
    Kruber_SunsetBonnet_helm_Middenland = "Remnant of a Middenland uniform, sported by a huntsman whose flamboyance outweigh his stealth.",
    Kruber_SunsetBonnet_helm_Nuln = "Remnant of a Nuln uniform, sported by a huntsman whose flamboyance outweigh his stealth.",
    Kruber_SunsetBonnet_helm_Reikwald = "Remnant of a Reikwald uniform, sported by a huntsman whose flamboyance outweigh his stealth.",
    Kruber_SunsetBonnet_helm_Stirland = "Remnant of a Stirland uniform, sported by a huntsman whose flamboyance outweigh his stealth.",
    Bardin_dwarf_shield_basicClean_KarakNorn01 = "The uppermost levels of Karak Norn tower high above the Loren Forest, allowing the Dwarfs to monitor the activities of the Wood Elves, albeit from a considerable distance.",
    Bardin_dwarf_shield_heroClean_KarakNorn01 = "The uppermost levels of Karak Norn tower high above the Loren Forest, allowing the Dwarfs to monitor the activities of the Wood Elves, albeit from a considerable distance.",
    Kruber_KOTBS_empire_sword_01 = "Placeholder description.",
}

local name_strings = {}

--these mod name tables are spilt up so the keys can be used by vmf widgets
--the order of shields only matters for vmf menu and it is displayed as the reverse
mod.bret_shields = {
	Kruber_Grail_Knight_Bastonne02 = "The Scale of Smearghus",
    Kruber_bret_shield_basic1_Reynard01 = "Protecteur d'Arden",
    Kruber_bret_shield_basic2_Luidhard01 = "Le Faucon Rouge",
    Kruber_bret_shield_basic3_Lothar01 = "Knight Shield of the Golden Hart",
    Kruber_bret_shield_hero1_Alberic01 = "Bastion de la Tempete",
}

mod.empire_shields = {
    Kruber_empire_shield_basic2 = "Wolfenburg Guard Shield",    
    Kruber_empire_shield_basic3_Middenheim01 = "The White Wolf (spear)",
    Kruber_empire_shield_basic2_Middenheim = "The White Wolf",
    Kruber_empire_shield_hero1_Kotbs01 = "Sol Invictus (spear)",
    Kruber_empire_shield_basic2_Kotbs01 = "Sol Invictus",
    Kruber_empire_shield_basic1_Ostermark01 = "Shield of Ostermark Spearman (Sergeant's mesh)",
    Kruber_empire_shield_hero1_Ostermark01 = "Shield of Ostermark Spearman",
    Kruber_empire_shield_basic1 = "Reikland Captain's Shield",
}

mod.elf_shields = {
    Kerillian_elf_shield_heroClean_Avelorn02 = "Shield of the Maiden Guard",
    Kerillian_elf_shield_basic2_mesh = "Griffon Gate Sentry-Shield", 
    -- Kerillian_elf_shield_basic2 = "Griffon Gate Sentry-Shield",
    Kerillian_elf_shield_basic2_Eaglegate01 = "Eagle Gate Sentry-Shield",
    Kerillian_elf_shield_heroClean_Caledor01 = "Dragon Shield of Caledor (Noble)",
    Kerillian_elf_shield_basicClean_Caledor01 = "Dragon Shield of Caledor",
    Kerillian_elf_shield_heroClean_Chrace01 = "Endri-Isalt (Noble)",
    Kerillian_elf_shield_basicClean_Chrace01 = "Endri-Isalt",
    Kerillian_elf_shield_heroClean_Saphery01 = "Cython-Ildir-Minaith (Noble)",
    Kerillian_elf_shield_basicClean_Saphery01 = "Cython-Ildir-Minaith",
    Kerillian_elf_shield_basic_Avelorn01_mesh = "Avelorn Levy-Shield (new mesh)",
    Kerillian_elf_shield_basic_Avelorn01 = "Avelorn Levy-Shield",
    Kerillian_elf_shield_heroClean_Eataine01 = "Avalu-Asur (Noble)",
    Kerillian_elf_shield_basicClean = "Avalu-Asur",
}

mod.dwarf_shields = {
    Bardin_dwarf_shield_basicClean_KarakNorn01 = "Karak Norn Karinak",
    Bardin_dwarf_shield_heroClean_KarakNorn01 = "Karak Norn Karinak (Runic)",
}

mod.elf_bows = {
    we_longbow_skin_06 = {
        Kerillian_elf_bow_Antlersong_Autumn = "Song of Delliandra",
    },
    we_longbow_skin_06_runed_01 = {
        Kerillian_elf_bow_Antlersong_Autumn_runed01 = "Song of Delliandra Runed",
    },
    we_longbow_skin_06_runed_02 = {
        Kerillian_elf_bow_Antlersong_Autumn_runed01 = "Song of Delliandra Runed",
    },
}

mod.elf_hats = {
    maidenguard_hat_1001 = {
        Kerillian_elf_hat_Windrunner_Avelorn = "Knight helm of Avelorn",
        Kerillian_elf_hat_Windrunner_Caledor = "Knight helm of Caledor",
        Kerillian_elf_hat_Windrunner_Chrace = "Knight helm of Chrace",
        Kerillian_elf_hat_Windrunner_Cothique = "Knight helm of Cothique",
        Kerillian_elf_hat_Windrunner_Eataine = "Knight helm of Eataine",
        Kerillian_elf_hat_Windrunner_Ellyrion = "Knight helm of Ellyrion",
        Kerillian_elf_hat_Windrunner_Nagarythe = "Knight helm of Nagarythe",
        Kerillian_elf_hat_Windrunner_Saphery = "Knight helm of Saphery",
        Kerillian_elf_hat_Windrunner_Tiranoc = "Knight helm of Tiranoc",
        Kerillian_elf_hat_Windrunner_Yvresse = "Knight helm of Yvresse",
    },
    waywatcher_hat_0011 = {
        Kerillian_Evercrown_helm_AutumnHerald = "Evercrown (Autumn)",
        Kerillian_Evercrown_helm_GreenHerald = "Evercrown (Evergreen)",
    },
    waywatcher_hat_0001 = {
        Kerillian_HornOfKurnous_helm_Beaststalker = "Horn of Kurnous (Beaststalker)",
        Kerillian_HornOfKurnous_helm_Frostwatcher = "Horn of Kurnous (Frostwatcher)", 
        Kerillian_HornOfKurnous_helm_Nightstalker = "Horn of Kurnous (Nightstalker)",
        Kerillian_HornOfKurnous_helm_Purified = "Horn of Kurnous (Purified)",
    }
}

mod.krub_hats = {
    knight_hat_1001 = {
        Kruber_KOTBS_hat = "Blessed Helm of the Blazing Sun",
    },
    questing_knight_hat_0003 = {
        Kruber_Hippogryph_helm_black = "Hippogryph Helm (Outcast)",
        Kruber_Hippogryph_helm_blue = "Hippogryph Helm (Gallant)",
        Kruber_Hippogryph_helm_red = "Hippogryph Helm (Valiant)",
        Kruber_Hippogryph_helm_white = "Hippogryph Helm (Purified)",
    },
    questing_knight_hat_0001 = {
        Kruber_Pureheart_helm_black = "Pureheart Helm (Outcast)",
        Kruber_Pureheart_helm_red = "Pureheart Helm (Valiant)",
        Kruber_Pureheart_helm_white = "Pureheart Helm (Purified)",
        Kruber_Pureheart_helm_yellow = "Pureheart Helm (Paladin)",
    },
    questing_knight_hat_0000 = {
        Kruber_Worthy_helm_black = "Helm of the Worthy (Outcast)",
        Kruber_Worthy_helm_red = "Helm of the Worthy (Valiant)",
        Kruber_Worthy_helm_white = "Helm of the Worthy (Purified)",
        Kruber_Worthy_helm_yellow = "Helm of the Worthy (Paladin)",
    },
    huntsman_hat_0001 = {
        Kruber_SunsetBonnet_helm_Middenland = "Sunset Bonnet (Middenland)",
        Kruber_SunsetBonnet_helm_Nuln = "Sunset Bonnet (Nuln)",
        Kruber_SunsetBonnet_helm_Reikwald = "Sunset Bonnet (Reikwald)",
        Kruber_SunsetBonnet_helm_Stirland = "Sunset Bonnet (Stirland)",
    },
}

mod.krub_armors = {
    Kruber_KOTBS_armor = "Blessed Plate of the Blazing Sun",
}

mod.ker_armors = {
    Ker_Autumn_Weave_Armor = "Herald of Autumn",
}

mod.empire_swords = {
    Kruber_KOTBS_empire_sword_01 = "Placeholder name.",
}

--merges all the upbove tables together to be used for another mod table that is sent to the localization hook
for k,v in pairs(mod.bret_shields) do
    name_strings[k] = v
end
for k,v in pairs(mod.empire_shields) do
    name_strings[k] = v
end
for k,v in pairs(mod.elf_shields) do
    name_strings[k] = v
end
for k,v in pairs(mod.dwarf_shields) do
    name_strings[k] = v
end
for k,helm in pairs(mod.elf_hats) do
    for variant,name in pairs(helm) do 
        name_strings[variant] = name
    end
end
for k,helm in pairs(mod.krub_hats) do
    for variant,name in pairs(helm) do 
        -- mod:echo(tostring(variant)..":     "..tostring(name))
        name_strings[variant] = name
    end
    -- mod:echo(tostring(k)..":     "..tostring(helm))
end
for k,weapon in pairs(mod.elf_bows) do
    for variant,name in pairs(weapon) do 
        name_strings[variant] = name
    end
end
for k,v in pairs(mod.krub_armors) do
    name_strings[k] = v
end
for k,v in pairs(mod.ker_armors) do
    name_strings[k] = v
end
--copies the name_strings table to be used in a mod table for the vmf menu localization
mod.name_strings_id = {}
for k,v in pairs(name_strings) do
    mod.name_strings_id[k] = v
end

for k,v in pairs(mod.empire_swords) do
    name_strings[k] = v
end


local desc = {}
local name = {}
-- local skin_table = table.clone(WeaponSkins.skins)
local skin_table = table.clone(ItemMasterList, true)

for skin, data in pairs(mod.SKIN_CHANGED) do
    local description = skin_table[skin].description
    local heiss = skin_table[skin].display_name
    
    desc[description] = skin
    name[heiss] = skin
end

mod.dict = {}
mod.helper_dict = {}
for k,v in pairs(desc) do
    mod.dict[k] = table.clone(desc_strings, true)
end
for k,v in pairs(name) do
    mod.dict[k] = table.clone(name_strings, true)
end

for k,v in pairs(desc) do
    mod.helper_dict[k] = v
end
for k,v in pairs(name) do
    mod.helper_dict[k] = v
end