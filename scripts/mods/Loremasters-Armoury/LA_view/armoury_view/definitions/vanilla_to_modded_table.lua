local mod = get_mod("Loremasters-Armoury")

local vanilla_to_modded_skins = {
    main_hand = {
        we_sword = {},
        bw_dagger = {},
        es_repeating_handgun = {},
        es_1h_flail = {},
        dw_2h_hammer = {},
        dr_steam_pistol = {},
        dw_1h_hammer = {},
        wh_crossbow = {},
        wh_1h_hammer = {},
        we_dual_dagger = {},
        we_dual_sword = {},
        we_crossbow = {},
        we_javelin = {},
        we_dual_sword_dagger = {},
        bw_1h_flail_flaming = {},
        wh_dual_hammer = {},
        es_2h_heavy_spear = {},
        dw_2h_axe = {},
        bw_flamethrower_staff = {},
        bw_fireball_staff = {},
        bw_1h_sword = {
            Kruber_KOTBS_wizard_sword_01 = "Blade of the Forgotten Knight",
            Kruber_KOTBS_wizard_sword_01_gold = "Incandescens",
        },
        we_2h_axe = {},
        es_1h_mace_shield = {},
        dw_crossbow = {},
        wh_1h_falchion = {},
        dw_drakegun = {},
        we_1h_axe = {},
        dr_dual_wield_hammers = {},
        bw_deus_01 = {},
        dr_deus_01 = {},
        bw_1h_flaming_sword = {
            Kruber_KOTBS_wizard_sword_01_flame = "Blade of the Forgotten Knight",
            Kruber_KOTBS_wizard_sword_01_flame_gold = "Incandescens",
        },
        wh_1h_axe = {},
        we_hagbane = {},
        es_bastard_sword = {
            Kruber_KOTBS_bret_sword_01 = "Blade of the Forgotten Knight",
            Kruber_KOTBS_bret_sword_01_gold = "Incandescens",
        },
        bw_1h_crowbill = {},
        we_1h_spears_shield = {},
        dw_1h_hammer_shield = {},
        we_longbow = {},
        es_dual_wield_hammer_sword = {},
        bw_spear_staff = {},
        dw_grudge_raker = {},
        we_spear = {},
        es_longbow = {},
        wh_hammer_book = {},
        es_blunderbuss = {},
        wh_brace_of_pistols = {},
        es_1h_sword = {
            Kruber_KOTBS_empire_sword_01 = "Blade of the Forgotten Knight",
            Kruber_KOTBS_empire_sword_01_gold = "Incandescens",
        },
        es_halberd = {},
        we_deus_01 = {},
        wh_hammer_shield = {},
        es_2h_hammer = {},
        es_deus_01 = {},
        dw_drake_pistol = {},
        we_shortbow = {},
        dw_1h_axe = {},
        dw_1h_axe_shield = {},
        es_2h_sword = {
            Kruber_KOTBS_empire_zweihander_01 = "Blade of the Forgotten Knight",
            Kruber_KOTBS_empire_zweihander_01_gold = "Incandescens",
        },
        wh_deus_01 = {},
        bw_beam_staff = {},
        es_1h_sword_shield = {
            Kruber_KOTBS_empire_sword_01 = "Blade of the Forgotten Knight",
            Kruber_KOTBS_empire_sword_01_gold = "Incandescens",
        },
        dw_handgun = {},
        wh_2h_billhook = {},
        wh_repeating_crossbow = {},
        es_handgun = {},
        we_life_staff = {},
        es_1h_mace = {},
        bw_1h_mace = {},
        es_2h_sword_exe = {},
        dw_2h_pick = {},
        wh_2h_sword = {
            Kruber_KOTBS_empire_zweihander_01 = "Blade of the Forgotten Knight",
            Kruber_KOTBS_empire_zweihander_01_gold = "Incandescens",
        },
        wh_flail_shield = {},
        es_sword_shield_breton = {
            Kruber_KOTBS_bret_sword_01 = "Blade of the Forgotten Knight",
            Kruber_KOTBS_bret_sword_01_gold = "Incandescens",
        },
        wh_repeating_pistol = {},
        bw_conflagration_staff = {},
        dw_dual_axe = {},
        wh_dual_wield_axe_falchion = {},
        wh_fencing_sword = {},
        dr_2h_cog_hammer = {},
        wh_2h_hammer = {},
        dr_1h_throwing_axes = {},
        we_2h_sword = {},
        bw_ghost_scythe = {},
        bw_necromancy_staff = {},
    },
    off_hand = {
        we_sword = {},
        bw_dagger = {},
        es_repeating_handgun = {},
        es_1h_flail = {},
        dw_2h_hammer = {},
        dr_steam_pistol = {},
        dw_1h_hammer = {},
        wh_crossbow = {},
        wh_1h_hammer = {},
        we_dual_dagger = {},
        we_dual_sword = {},
        we_crossbow = {},
        we_javelin = {},
        we_dual_sword_dagger = {},
        bw_1h_flail_flaming = {},
        wh_dual_hammer = {},
        es_2h_heavy_spear = {},
        dw_2h_axe = {},
        bw_flamethrower_staff = {},
        bw_fireball_staff = {},
        bw_1h_sword = {},
        we_2h_axe = {},
        es_1h_mace_shield = {
            Kruber_empire_shield_basic2 = "Wolfenburg Guard Shield",
            Kruber_empire_shield_basic3_Middenheim01 = "The White Wolf (spear)",
            Kruber_empire_shield_basic2_Middenheim = "The White Wolf",
            Kruber_empire_shield_hero1_Kotbs01 = "Sol Invictus (spear)",
            Kruber_empire_shield_basic2_Kotbs01 = "Sol Invictus",
            Kruber_empire_shield_basic1_Ostermark01 = "Shield of Ostermark Spearman (Sergeant's mesh)",
            Kruber_empire_shield_hero1_Ostermark01 = "Shield of Ostermark Spearman",
            Kruber_empire_shield_basic1 = "Reikland Captain's Shield",
        },
        dw_crossbow = {},
        wh_1h_falchion = {},
        dw_drakegun = {},
        we_1h_axe = {},
        dr_dual_wield_hammers = {},
        bw_deus_01 = {},
        dr_deus_01 = {},
        bw_1h_flaming_sword = {},
        wh_1h_axe = {},
        we_hagbane = {},
        es_bastard_sword = {},
        bw_1h_crowbill = {},
        we_1h_spears_shield = {
            Kerillian_elf_shield_heroClean_Avelorn02 = "Shield of the Maiden Guard",
            Kerillian_elf_shield_basic2_mesh = "Griffon Gate Sentry-Shield",
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
        },
        dw_1h_hammer_shield = {
            Bardin_dwarf_shield_basicClean_KarakNorn01 = "Karak Norn Karinak",
            Bardin_dwarf_shield_heroClean_KarakNorn01 = "Karak Norn Karinak (Runic)",
        },
        we_longbow = {
            we_longbow_skin_06 = {
                Kerillian_elf_bow_Antlersong_Autumn = "Song of Delliandra",
            },
            we_longbow_skin_06_runed_01 = {
                Kerillian_elf_bow_Antlersong_Autumn_runed01 = "Song of Delliandra Runed",
            },
            we_longbow_skin_06_runed_02 = {
                Kerillian_elf_bow_Antlersong_Autumn_runed02 = "Song of Delliandra Runed",
            },
        },
        es_dual_wield_hammer_sword = {},
        bw_spear_staff = {},
        dw_grudge_raker = {},
        we_spear = {},
        es_longbow = {},
        wh_hammer_book = {},
        es_blunderbuss = {},
        wh_brace_of_pistols = {},
        es_1h_sword = {},
        es_halberd = {},
        we_deus_01 = {},
        wh_hammer_shield = {},
        es_2h_hammer = {},
        es_deus_01 = {
            Kruber_empire_shield_basic2 = "Wolfenburg Guard Shield",
            Kruber_empire_shield_basic3_Middenheim01 = "The White Wolf (spear)",
            Kruber_empire_shield_basic2_Middenheim = "The White Wolf",
            Kruber_empire_shield_hero1_Kotbs01 = "Sol Invictus (spear)",
            Kruber_empire_shield_basic2_Kotbs01 = "Sol Invictus",
            Kruber_empire_shield_basic1_Ostermark01 = "Shield of Ostermark Spearman (Sergeant's mesh)",
            Kruber_empire_shield_hero1_Ostermark01 = "Shield of Ostermark Spearman",
            Kruber_empire_shield_basic1 = "Reikland Captain's Shield",
        },
        dw_drake_pistol = {},
        we_shortbow = {},
        dw_1h_axe = {},
        dw_1h_axe_shield = {
            Bardin_dwarf_shield_basicClean_KarakNorn01 = "Karak Norn Karinak",
            Bardin_dwarf_shield_heroClean_KarakNorn01 = "Karak Norn Karinak (Runic)",
        },
        es_2h_sword = {},
        wh_deus_01 = {},
        bw_beam_staff = {},
        es_1h_sword_shield = {
            Kruber_empire_shield_basic2 = "Wolfenburg Guard Shield",
            Kruber_empire_shield_basic3_Middenheim01 = "The White Wolf (spear)",
            Kruber_empire_shield_basic2_Middenheim = "The White Wolf",
            Kruber_empire_shield_hero1_Kotbs01 = "Sol Invictus (spear)",
            Kruber_empire_shield_basic2_Kotbs01 = "Sol Invictus",
            Kruber_empire_shield_basic1_Ostermark01 = "Shield of Ostermark Spearman (Sergeant's mesh)",
            Kruber_empire_shield_hero1_Ostermark01 = "Shield of Ostermark Spearman",
            Kruber_empire_shield_basic1 = "Reikland Captain's Shield",
        },
        dw_handgun = {},
        wh_2h_billhook = {},
        wh_repeating_crossbow = {},
        es_handgun = {},
        we_life_staff = {},
        es_1h_mace = {},
        bw_1h_mace = {},
        es_2h_sword_exe = {},
        dw_2h_pick = {},
        wh_2h_sword = {},
        wh_flail_shield = {},
        es_sword_shield_breton = {
            Kruber_Grail_Knight_Bastonne02 = "The Scale of Smearghus",
            Kruber_bret_shield_basic1_Reynard01 = "Protecteur d'Arden",
            Kruber_bret_shield_basic2_Luidhard01 = "Le Faucon Rouge",
            Kruber_bret_shield_basic3_Lothar01 = "Knight Shield of the Golden Hart",
            Kruber_bret_shield_hero1_Alberic01 = "Bastion de la Tempete",
        },
        wh_repeating_pistol = {},
        bw_conflagration_staff = {},
        dw_dual_axe = {},
        wh_dual_wield_axe_falchion = {},
        wh_fencing_sword = {},
        dr_2h_cog_hammer = {},
        wh_2h_hammer = {},
        dr_1h_throwing_axes = {},
        we_2h_sword = {},
        bw_ghost_scythe = {},
        bw_necromancy_staff = {},
    },
}

vanilla_to_modded_skins["outfits"] = {}
for item_name, item_data in pairs(ItemMasterList) do
    if item_data.item_type == "skin" or item_data.item_type == "hat" then
        vanilla_to_modded_skins.outfits[item_name] = {}
    end
end

-- vanilla_to_modded_skins.outfits.maidenguard_hat_1001 = {
--     Kerillian_elf_hat_Windrunner_Avelorn = "Knight helm of Avelorn",
--     Kerillian_elf_hat_Windrunner_Caledor = "Knight helm of Caledor",
--     Kerillian_elf_hat_Windrunner_Chrace = "Knight helm of Chrace",
--     Kerillian_elf_hat_Windrunner_Cothique = "Knight helm of Cothique",
--     Kerillian_elf_hat_Windrunner_Eataine = "Knight helm of Eataine",
--     Kerillian_elf_hat_Windrunner_Ellyrion = "Knight helm of Ellyrion",
--     Kerillian_elf_hat_Windrunner_Nagarythe = "Knight helm of Nagarythe",
--     Kerillian_elf_hat_Windrunner_Saphery = "Knight helm of Saphery",
--     Kerillian_elf_hat_Windrunner_Tiranoc = "Knight helm of Tiranoc",
--     Kerillian_elf_hat_Windrunner_Yvresse = "Knight helm of Yvresse",
-- }

-- vanilla_to_modded_skins.outfits.knight_hat_1001 = {
--     Kruber_KOTBS_hat = "Blessed Helm of the Blazing Sun",
-- }

for hat_name,hat_data in pairs(mod.elf_hats) do
    vanilla_to_modded_skins.outfits[hat_name] = table.clone(hat_data, false)
end
for hat_name,hat_data in pairs(mod.krub_hats) do
    vanilla_to_modded_skins.outfits[hat_name] = table.clone(hat_data, false)
end

vanilla_to_modded_skins.outfits.skin_es_knight_black_and_gold = {
    Kruber_KOTBS_armor = "Blessed Plate of the Blazing Sun",
}

vanilla_to_modded_skins.outfits.skin_es_questingknight = {
    Kruber_GK_devoted_armor = "Coat of the Devoted Knight",
    Kruber_GK_valiant_armor = "Coat of the Valiant Knight",
}
vanilla_to_modded_skins.outfits.skin_es_questingknight_black_and_gold = {
    Kruber_GK_devoted_armor = "Coat of the Devoted Knight",
    Kruber_GK_valiant_armor = "Coat of the Valiant Knight",
}
vanilla_to_modded_skins.outfits.skin_es_questingknight_black_and_yellow = {
    Kruber_GK_devoted_armor = "Coat of the Devoted Knight",
    Kruber_GK_valiant_armor = "Coat of the Valiant Knight",
}
vanilla_to_modded_skins.outfits.skin_es_questingknight_blue_and_white = {
    Kruber_GK_devoted_armor = "Coat of the Devoted Knight",
    Kruber_GK_valiant_armor = "Coat of the Valiant Knight",
}
vanilla_to_modded_skins.outfits.skin_es_questingknight_yellow_and_white = {
    Kruber_GK_devoted_armor = "Coat of the Devoted Knight",
    Kruber_GK_valiant_armor = "Coat of the Valiant Knight",
}

vanilla_to_modded_skins.outfits.skin_ww_waywatcher_1001 = {
    Ker_Autumn_Weave_Armor = "Herald of Autumn",
}

return vanilla_to_modded_skins