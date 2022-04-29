local mod = get_mod("Loremasters-Armoury")

mod.SKIN_LIST = {
    Kruber_Grail_Knight_Bastonne02 = {
        kind = "texture",
        swap_skin = nil,
        textures = {
            "textures/Kruber_Grail_Knight_shield02/custom_reinhard",
             
        },
        swap_hand = "left_hand_unit",
        skip_meshes = {},
    },
    Kruber_bret_shield_basic1_Reynard01 = {
        kind = "texture",
        swap_skin = nil,
        textures = {
            "textures/Kruber_bret_shield_basic1_Reynard01/Kruber_bret_shield_basic1_Reynard01_diffuse",
             
        },
        swap_hand = "left_hand_unit",
        skip_meshes = {},
    },
    Kruber_bret_shield_basic2_Luidhard01 = {
        kind = "texture",
        swap_skin = nil, 
        textures = {
            "textures/Kruber_bret_shield_basic2_Luidhard01/Kruber_bret_shield_basic2_Luidhard01_diffuse",
             
        },
        swap_hand = "left_hand_unit",
        skip_meshes = {},
    },
    Kruber_bret_shield_basic3_Lothar01 = {
        kind = "texture",
        swap_skin = nil, 
        textures = {
            "textures/Kruber_bret_shield_basic3_Lothar01/Kruber_bret_shield_basic3_Lothar01_diffuse",
             
        },
        swap_hand = "left_hand_unit",
        skip_meshes = {},
    },
    Kruber_bret_shield_hero1_Alberic01 = {
        kind = "texture",
        swap_skin = nil, 
        textures = {
            "textures/Kruber_bret_shield_hero1_Alberic01/Kruber_bret_shield_hero1_Alberic01_diffuse",
             
        },
        swap_hand = "left_hand_unit",
        skip_meshes = {},
    },
    Kruber_empire_shield_hero1_Ostermark01 = {
        kind = "texture",
        swap_skin = nil,
        textures = {
            "textures/Kruber_empire_shield_hero1_Ostermark01/Kruber_empire_shield_hero1_Ostermark01_diffuse",
             
        },
        new_units = {
            "units/weapons/player/wpn_es_deus_shield_03/wpn_es_deus_shield_03",
            "units/weapons/player/wpn_es_deus_shield_03/wpn_es_deus_shield_03_3p",
        },
        is_vanilla_unit = true, 
        swap_hand = "left_hand_unit",
        skip_meshes = {},
    },
    Kruber_empire_shield_hero1_Kotbs01 = {
        kind = "texture",
        swap_skin = nil,
        textures = {
            "textures/Kruber_empire_shield_hero1_Kotbs01/Kruber_empire_shield_hero1_Kotbs01_diffuse",
             
        },
        new_units = {
            "units/weapons/player/wpn_es_deus_shield_03/wpn_es_deus_shield_03",
            "units/weapons/player/wpn_es_deus_shield_03/wpn_es_deus_shield_03_3p",
        },
        is_vanilla_unit = true, 
        swap_hand = "left_hand_unit",
        skip_meshes = {},
    },
    Kerillian_elf_shield_basic_Avelorn01 = {
        kind = "texture",
        swap_skin = nil, 
        textures = {
            "textures/Kerillian_elf_shield_basic_Avelorn01/Kerillian_elf_shield_basic_Avelorn01_diffuse",
             
        },
        new_units = {
            "units/weapons/player/wpn_we_shield_01/wpn_we_shield_01",
            "units/weapons/player/wpn_we_shield_01/wpn_we_shield_01_3p",
        },
        is_vanilla_unit = true, 
        swap_hand = "left_hand_unit",
        skip_meshes = {
            skip0 = true,
        },
    },
    Kerillian_elf_shield_basic_Avelorn01_mesh = {
        kind = "unit",
        swap_skin = nil,
        new_units = {
            "units/Kerillian_elf_shield/Kerillian_elf_shield_heroClean_mesh_Avelorn01",
            "units/Kerillian_elf_shield/Kerillian_elf_shield_heroClean_mesh_Avelorn01_3p",
        },
        swap_hand = "left_hand_unit",
    },
    Kerillian_elf_shield_basic2 = {
        kind = "texture",
        swap_skin = nil, 
        textures = {
            "textures/Kerillian_elf_shield_basic2_Griffongate01/Kerillian_elf_shield_basic2_Griffongate01_diffuse",
             
        },
        swap_hand = "left_hand_unit",
        skip_meshes = {
            skip0 = true,
        },
    },
    Kerillian_elf_shield_basic2_mesh = {
        kind = "unit",
        swap_skin = nil, 
        new_units = {
            "units/Kerillian_elf_shield/Kerillian_elf_shield_basic2_mesh_Griffongate01",
            "units/Kerillian_elf_shield/Kerillian_elf_shield_basic2_mesh_Griffongate01_3p",
        },
        swap_hand = "left_hand_unit",
    },
    test_unit = {
        kind = "unit",
        new_units = {
            "units/shield",
            "units/shield_3p",
        },
        swap_hand = "left_hand_unit",
        swap_skin = nil,
    },
    Kerillian_elf_shield_heroClean_Saphery01 = {
        kind = "unit",
        new_units = {
            "units/Kerillian_elf_shield/Kerillian_elf_shield_heroClean_mesh",
            "units/Kerillian_elf_shield/Kerillian_elf_shield_heroClean_mesh_3p",
        },
        swap_hand = "left_hand_unit",
        swap_skin = nil,
    },
    Kerillian_elf_shield_heroClean_Caledor01 = {
        kind = "unit",
        new_units = {
            "units/Kerillian_elf_shield/Kerillian_elf_shield_heroClean_mesh_Caledor01",
            "units/Kerillian_elf_shield/Kerillian_elf_shield_heroClean_mesh_Caledor01_3p",
        },
        swap_hand = "left_hand_unit",
        swap_skin = nil,
    },
    Kerillian_elf_shield_heroClean_Avelorn02 = {
        kind = "unit",
        new_units = {
            "units/Kerillian_elf_shield/Kerillian_elf_shield_heroClean_mesh_Avelorn02",
            "units/Kerillian_elf_shield/Kerillian_elf_shield_heroClean_mesh_Avelorn02_3p",
        },
        swap_hand = "left_hand_unit",
        swap_skin = nil,
    },
    Kerillian_elf_shield_basicClean = {
        kind = "unit",
        new_units = {
            "units/Kerillian_elf_shield/Kerillian_elf_shield_basicClean_mesh_Eataine01",
            "units/Kerillian_elf_shield/Kerillian_elf_shield_basicClean_mesh_Eataine01_3p",
        },
        swap_hand = "left_hand_unit",
        swap_skin = nil,
    },
    Kerillian_elf_shield_basic2_Eaglegate01 = {
        kind = "unit",
        new_units = {
            "units/Kerillian_elf_shield/Kerillian_elf_shield_basicClean_mesh_Eaglegate01",
            "units/Kerillian_elf_shield/Kerillian_elf_shield_basicClean_mesh_Eaglegate01_3p",
        },
        swap_hand = "left_hand_unit",
        swap_skin = nil,
    },
    Kerillian_elf_shield_basicClean_Saphery01 = {
        kind = "unit",
        new_units = {
            "units/Kerillian_elf_shield/Kerillian_elf_shield_basicClean_mesh_Saphery01",
            "units/Kerillian_elf_shield/Kerillian_elf_shield_basicClean_mesh_Saphery01_3p",
        },
        swap_hand = "left_hand_unit",
        swap_skin = nil,
    },
    Kerillian_elf_shield_basicClean_Caledor01 = {
        kind = "unit",
        new_units = {
            "units/Kerillian_elf_shield/Kerillian_elf_shield_basicClean_mesh_Caledor01",
            "units/Kerillian_elf_shield/Kerillian_elf_shield_basicClean_mesh_Caledor01_3p",
        },
        swap_hand = "left_hand_unit",
        swap_skin = nil,
    },
    Kerillian_elf_shield_heroClean_Eataine01 = {
        kind = "unit",
        new_units = {
            "units/Kerillian_elf_shield/Kerillian_elf_shield_heroClean_mesh_Eataine01",
            "units/Kerillian_elf_shield/Kerillian_elf_shield_heroClean_mesh_Eataine01_3p",
        },
        swap_hand = "left_hand_unit",
        swap_skin = nil,
    },
    Kruber_empire_shield_basic1 = {
        kind = "unit",
        new_units = {
            "units/empire_shield/Kruber_Empire_shield01_mesh",
            "units/empire_shield/Kruber_Empire_shield01_mesh_3p",
        },
        swap_hand = "left_hand_unit",
        swap_skin = nil,
    },
    Kruber_empire_shield_basic1_Ostermark01 = {
        kind = "unit",
        new_units = {
            "units/empire_shield/Kruber_Empire_shield01_mesh_Ostermark01",
            "units/empire_shield/Kruber_Empire_shield01_mesh_Ostermark01_3p",
        },
        swap_hand = "left_hand_unit",
        swap_skin = nil,
    },
    Kruber_empire_shield_basic2 = {
        kind = "unit",
        new_units = {
            "units/empire_shield/Kruber_Empire_shield02_mesh",
            "units/empire_shield/Kruber_Empire_shield02_mesh_3p",
        },
        swap_hand = "left_hand_unit",
        swap_skin = nil,
    },
    Kruber_empire_shield_basic2_Kotbs01 = {
        kind = "unit",
        new_units = {
            "units/empire_shield/Kruber_Empire_shield02_mesh_Kotbs01",
            "units/empire_shield/Kruber_Empire_shield02_mesh_Kotbs01_3p",
        },
        swap_hand = "left_hand_unit",
        swap_skin = nil,
    },
    Kruber_empire_shield_basic2_Middenheim = {
        kind = "unit",
        new_units = {
            "units/empire_shield/Kruber_Empire_shield02_mesh_Middenheim01",
            "units/empire_shield/Kruber_Empire_shield02_mesh_Middenheim01_3p",
        },
        swap_hand = "left_hand_unit",
        swap_skin = nil,
    },
    Kruber_empire_shield_basic3_Middenheim01 = {
        kind = "unit",
        new_units = {
            "units/empire_shield/Kruber_Empire_shield_spear01_mesh",
            "units/empire_shield/Kruber_Empire_shield_spear01_mesh_3p",
        },
        swap_hand = "left_hand_unit",
        swap_skin = nil,
    },
    Kerillian_elf_hat_Windrunner_Avelorn = {
        kind = "texture",
        swap_skin = nil,
        textures = {
            "textures/Kerillian_Wildrunner_helm/Avelorn/Kerillian_Wildrunner_helm_Avelorn_diffuse",
             
        },
        new_units = {
            "units/beings/player/way_watcher_maiden_guard/headpiece/ww_mg_hat_12",
        },
        is_vanilla_unit = true, 
        swap_hand = "hat",
        skip_meshes = {},
    },
    Kerillian_elf_hat_Windrunner_Caledor = {
        kind = "texture",
        swap_skin = nil,
        textures = {
            "textures/Kerillian_Wildrunner_helm/Caledor/Kerillian_Wildrunner_helm_Caledor_diffuse",
             
        },
        new_units = {
            "units/beings/player/way_watcher_maiden_guard/headpiece/ww_mg_hat_12",
        },
        is_vanilla_unit = true, 
        swap_hand = "hat",
        skip_meshes = {},
    },
    Kerillian_elf_hat_Windrunner_Chrace = {
        kind = "texture",
        swap_skin = nil,
        textures = {
            "textures/Kerillian_Wildrunner_helm/Chrace/Kerillian_Wildrunner_helm_Chrace_diffuse",
             
        },
        new_units = {
            "units/beings/player/way_watcher_maiden_guard/headpiece/ww_mg_hat_12",
        },
        is_vanilla_unit = true, 
        swap_hand = "hat",
        skip_meshes = {},
    },
    Kerillian_elf_hat_Windrunner_Cothique = {
        kind = "texture",
        swap_skin = nil,
        textures = {
            "textures/Kerillian_Wildrunner_helm/Cothique/Kerillian_Wildrunner_helm_Cothique_diffuse",
             
        },
        new_units = {
            "units/beings/player/way_watcher_maiden_guard/headpiece/ww_mg_hat_12",
        },
        is_vanilla_unit = true, 
        swap_hand = "hat",
        skip_meshes = {},
    },
    Kerillian_elf_hat_Windrunner_Eataine = {
        kind = "texture",
        swap_skin = nil,
        textures = {
            "textures/Kerillian_Wildrunner_helm/Eataine/Kerillian_Wildrunner_helm_Eataine_diffuse",
             
        },
        new_units = {
            "units/beings/player/way_watcher_maiden_guard/headpiece/ww_mg_hat_12",
        },
        is_vanilla_unit = true, 
        swap_hand = "hat",
        skip_meshes = {},
    },
    Kerillian_elf_hat_Windrunner_Ellyrion = {
        kind = "texture",
        swap_skin = nil,
        textures = {
            "textures/Kerillian_Wildrunner_helm/Ellyrion/Kerillian_Wildrunner_helm_Ellyrion_diffuse",
             
        },
        new_units = {
            "units/beings/player/way_watcher_maiden_guard/headpiece/ww_mg_hat_12",
        },
        is_vanilla_unit = true, 
        swap_hand = "hat",
        skip_meshes = {},
    },
    Kerillian_elf_hat_Windrunner_Nagarythe = {
        kind = "texture",
        swap_skin = nil,
        textures = {
            "textures/Kerillian_Wildrunner_helm/Nagarythe/Kerillian_Wildrunner_helm_Nagarythe_diffuse",
             
        },
        new_units = {
            "units/beings/player/way_watcher_maiden_guard/headpiece/ww_mg_hat_12",
        },
        is_vanilla_unit = true, 
        swap_hand = "hat",
        skip_meshes = {},
    },
    Kerillian_elf_hat_Windrunner_Saphery = {
        kind = "texture",
        swap_skin = nil,
        textures = {
            "textures/Kerillian_Wildrunner_helm/Saphery/Kerillian_Wildrunner_helm_Saphery_diffuse",
             
        },
        new_units = {
            "units/beings/player/way_watcher_maiden_guard/headpiece/ww_mg_hat_12",
        },
        is_vanilla_unit = true, 
        swap_hand = "hat",
        skip_meshes = {},
    },
    Kerillian_elf_hat_Windrunner_Tiranoc = {
        kind = "texture",
        swap_skin = nil,
        textures = {
            "textures/Kerillian_Wildrunner_helm/Tiranoc/Kerillian_Wildrunner_helm_Tiranoc_diffuse",
             
        },
        new_units = {
            "units/beings/player/way_watcher_maiden_guard/headpiece/ww_mg_hat_12",
        },
        is_vanilla_unit = true, 
        swap_hand = "hat",
        skip_meshes = {},
    },
    Kerillian_elf_hat_Windrunner_Yvresse = {
        kind = "texture",
        swap_skin = nil,
        textures = {
            "textures/Kerillian_Wildrunner_helm/Yvresse/Kerillian_Wildrunner_helm_Yvresse_diffuse",
             
        },
        new_units = {
            "units/beings/player/way_watcher_maiden_guard/headpiece/ww_mg_hat_12",
        },
        is_vanilla_unit = true, 
        swap_hand = "hat",
        skip_meshes = {},
    },
    Kruber_KOTBS_hat = {
        kind = "texture",
        swap_skin = nil,
        textures = {
            "textures/Kruber_KOTBS_hat/Kruber_EmpireSoldier_KotBS_helm_diffuse",
            "textures/Kruber_KOTBS_hat/Kruber_EmpireSoldier_KotBS_helm_combined",
            "textures/Kruber_KOTBS_hat/Kruber_EmpireSoldier_KotBS_helm_normal",
        },
        new_units = {
            "units/beings/player/empire_soldier_knight/headpiece/es_k_hat_12",
        },
        is_vanilla_unit = true, 
        swap_hand = "hat",
        skip_meshes = {},
    },
    Kruber_KOTBS_armor = {
        kind = "texture",
        swap_skin = nil,
        cosmetic_key = "skin_es_knight_black_and_gold",
        skin_to_swap = {
            skin_es_knight_black_and_gold = "skin_es_knight_black_and_gold",
        },
        textures = {
            "textures/Kruber_KOTBS_armor/Kruber_EmpireSoldier_KotBS_body_diffuse",
            "textures/Kruber_KOTBS_armor/Kruber_EmpireSoldier_KotBS_body_combined",
            "textures/Kruber_KOTBS_armor/Kruber_EmpireSoldier_KotBS_body_normal",
        },
        new_units = {
            "units/beings/player/empire_soldier_knight/third_person_base/chr_third_person_mesh",
        },
        is_vanilla_unit = true, 
        swap_hand = "armor",
        skip_meshes = {
            skip0 = true,
            skip1 = true,
            skip2 = true,
            skip3 = true,
            skip4 = true,
            skip5 = true,
            skip6 = true,
            skip10= true,
            skip11 = true, 
            skip12 = true,
            skip13 = true,
            skip14 = true,
            skip15 = true,
            skip16 = true,
            skip17 = true,
            skip18 = true,
            skip19 = true,
            skip20 = true,
            skip21 = true,
            skip22 = true,
            skip23 = true,
            skip24 = true,
            skip25 = true,
            skip26 = true,
        },
    },
}

local skin_table_weapons = table.shallow_copy(WeaponSkins.skins)
local skin_table_items = table.clone(ItemMasterList, true)
local skins_to_change = {}

--these mod tables are used split up so the vmf widgets can easily group the skins by weapon type
mod.bret_skins = {
	"es_sword_shield_breton_skin_01",
    "es_sword_shield_breton_skin_02",
    "es_sword_shield_breton_skin_03",
    "es_sword_shield_breton_skin_03_runed_01",
    "es_sword_shield_breton_skin_03_runed_02",
    "es_sword_shield_breton_skin_04",
    -- "es_sword_shield_breton_skin_04_magic_01_magic_01",
    "es_sword_shield_breton_skin_05",
}

mod.empire_spear_shield = {
	"es_deus_01_skin_01",
    "es_deus_01_skin_01_runed",
    "es_deus_01_skin_02_runed",
    "es_deus_01_skin_03_runed",
    "es_deus_01_skin_02",
    "es_deus_01_skin_03",
}

mod.empire_sword_shield = {
	"es_1h_sword_shield_skin_01",
    "es_1h_sword_shield_skin_02",
    "es_1h_sword_shield_skin_02_runed_01",
    "es_1h_sword_shield_skin_03",
    "es_1h_sword_shield_skin_03_runed_01",
    "es_1h_sword_shield_skin_03_runed_02",
    "es_1h_sword_shield_skin_04",
    "es_1h_sword_shield_skin_05",
}

mod.empire_mace_shield = {
	"es_1h_mace_shield_skin_01",
    "es_1h_mace_shield_skin_02",
    "es_1h_mace_shield_skin_02_runed_01",
    "es_1h_mace_shield_skin_03",
    "es_1h_mace_shield_skin_03_runed_01",
    "es_1h_mace_shield_skin_03_runed_02",
    "es_1h_mace_shield_skin_04",
    "es_1h_mace_shield_skin_05",
}

mod.elf_skins = {
	"we_1h_spears_shield_skin_01",
    "we_1h_spears_shield_skin_01_runed_01",
    "we_1h_spears_shield_skin_02",
}

mod.elf_hat_skins = {
	"maidenguard_hat_1001",
}

mod.krub_hat_skins = {
	"knight_hat_1001",
}

mod.krub_armor_skins = {
	"skin_es_knight_black_and_gold",
}

table.append(skins_to_change, mod.bret_skins)
table.append(skins_to_change, mod.empire_spear_shield)
table.append(skins_to_change, mod.empire_sword_shield)
table.append(skins_to_change, mod.empire_mace_shield)
table.append(skins_to_change, mod.elf_skins)
table.append(skins_to_change, mod.elf_hat_skins)
table.append(skins_to_change, mod.krub_hat_skins)
table.append(skins_to_change, mod.krub_armor_skins)

--this mod table is used for the vmf menu localization
mod.vanilla_game_strings = table.clone(skins_to_change, true)

mod.SKIN_CHANGED = {}

for _,skin in pairs(skins_to_change) do
    local unit = nil
    if skin_table_weapons[skin] then
        unit = skin_table_weapons[skin].left_hand_unit
    elseif skin_table_items[skin] then
        unit = skin_table_items[skin].unit
    end
 
    
    local tisch = {
        changed_texture = false,
        changed_model = false,
        unit = unit,
    }
    mod.SKIN_CHANGED[skin] = table.clone(tisch, true)
end

mod.has_old_texture = false

return