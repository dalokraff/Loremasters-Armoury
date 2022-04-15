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
    Kerillian_elf_shield_heroClean_Saphery01 = "Cython-Ildir-Minaith (Noble)",
    Kerillian_elf_shield_basicClean_Saphery01 = "Cython-Ildir-Minaith",
    Kerillian_elf_shield_basic_Avelorn01_mesh = "Avelorn Levy-Shield (new mesh)",
    Kerillian_elf_shield_basic_Avelorn01 = "Avelorn Levy-Shield",
    Kerillian_elf_shield_heroClean_Eataine01 = "Avalu-Asur (Noble)",
    Kerillian_elf_shield_basicClean = "Avalu-Asur",
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

--copies the name_strings table to be used in a mod table for the vmf menu localization
mod.name_strings_id = {}
for k,v in pairs(name_strings) do
    mod.name_strings_id[k] = v
end


local desc = {}
local name = {}
local skin_table = table.shallow_copy(WeaponSkins.skins)

for skin, data in pairs(mod.SKIN_CHANGED) do
    local description = skin_table[skin].description
    local heiss = skin_table[skin].display_name
    
    desc[description] = skin
    name[heiss] = skin
end

mod.dict = {}
mod.helper_dict = {}
for k,v in pairs(desc) do
    mod.dict[k] = table.shallow_copy(desc_strings)
end
for k,v in pairs(name) do
    mod.dict[k] = table.shallow_copy(name_strings)
end

for k,v in pairs(desc) do
    mod.helper_dict[k] = v
end
for k,v in pairs(name) do
    mod.helper_dict[k] = v
end