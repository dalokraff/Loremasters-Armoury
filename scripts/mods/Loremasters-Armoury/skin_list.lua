local mod = get_mod("Loremasters-Armoury")

mod.SKIN_LIST = {
    Kruber_Grail_Knight_Bastonne02 = {
        kind = "texture",
        swap_skin = nil,--"es_sword_shield_breton_skin_03",
        textures = {
            "textures/Kruber_Grail_Knight_shield02/custom_reinhard",
            "textures/Kruber_Grail_Knight_shield02/Kruber_Grail_Knight_shield02_combined",
            "textures/Kruber_Grail_Knight_shield02/Kruber_Grail_Knight_shield02_normal",
        },
        swap_hand = "left_hand_unit",
        skip_meshes = {},
    },
    Kruber_bret_shield_basic1_Reynard01 = {
        kind = "texture",
        swap_skin = nil,--"es_sword_shield_breton_skin_03",
        textures = {
            "textures/Kruber_bret_shield_basic1_Reynard01/Kruber_bret_shield_basic1_Reynard01_diffuse",
            "textures/Kruber_Grail_Knight_shield02/Kruber_Grail_Knight_shield02_combined",
            "textures/Kruber_Grail_Knight_shield02/Kruber_Grail_Knight_shield02_normal",
        },
        swap_hand = "left_hand_unit",
        skip_meshes = {},
    },
    Kruber_bret_shield_basic2_Luidhard01 = {
        kind = "texture",
        swap_skin = nil,--"es_sword_shield_breton_skin_03", 
        textures = {
            "textures/Kruber_bret_shield_basic2_Luidhard01/Kruber_bret_shield_basic2_Luidhard01_diffuse",
            "textures/Kruber_Grail_Knight_shield02/Kruber_Grail_Knight_shield02_combined",
            "textures/Kruber_Grail_Knight_shield02/Kruber_Grail_Knight_shield02_normal",
        },
        swap_hand = "left_hand_unit",
        skip_meshes = {},
    },
    Kruber_bret_shield_basic3_Lothar01 = {
        kind = "texture",
        swap_skin = nil,--"es_sword_shield_breton_skin_03", 
        textures = {
            "textures/Kruber_bret_shield_basic3_Lothar01/Kruber_bret_shield_basic3_Lothar01_diffuse",
            "textures/Kruber_Grail_Knight_shield02/Kruber_Grail_Knight_shield02_combined",
            "textures/Kruber_Grail_Knight_shield02/Kruber_Grail_Knight_shield02_normal",
        },
        swap_hand = "left_hand_unit",
        skip_meshes = {},
    },
    Kruber_bret_shield_hero1_Alberic01 = {
        kind = "texture",
        swap_skin = nil,--"es_sword_shield_breton_skin_03", 
        textures = {
            "textures/Kruber_bret_shield_hero1_Alberic01/Kruber_bret_shield_hero1_Alberic01_diffuse",
            "textures/Kruber_Grail_Knight_shield02/Kruber_Grail_Knight_shield02_combined",
            "textures/Kruber_Grail_Knight_shield02/Kruber_Grail_Knight_shield02_normal",
        },
        swap_hand = "left_hand_unit",
        skip_meshes = {},
    },
    Kruber_empire_shield_hero1_Ostermark01 = {
        kind = "texture",
        swap_skin = nil,--"es_deus_01_skin_03",
        textures = {
            "textures/Kruber_empire_shield_hero1_Ostermark01/Kruber_empire_shield_hero1_Ostermark01_diffuse",
            "textures/Kruber_Grail_Knight_shield02/Kruber_Grail_Knight_shield02_combined",
            "textures/Kruber_Grail_Knight_shield02/Kruber_Grail_Knight_shield02_normal",
        },
        swap_hand = "left_hand_unit",
        skip_meshes = {},
    },
    Kerillian_elf_shield_basic_Avelorn01 = {
        kind = "texture",
        swap_skin = nil,--"we_1h_spears_shield_skin_01", 
        textures = {
            "textures/Kerillian_elf_shield_basic_Avelorn01/Kerillian_elf_shield_basic_Avelorn01_diffuse",
            "textures/Kruber_Grail_Knight_shield02/Kruber_Grail_Knight_shield02_combined",
            "textures/Kruber_Grail_Knight_shield02/Kruber_Grail_Knight_shield02_normal",
        },
        swap_hand = "left_hand_unit",
        skip_meshes = {
            skip0 = true,
        },
    },
    Kerillian_elf_shield_basic_Avelorn01_mesh = {
        kind = "unit",
        swap_skin = nil,--"we_1h_spears_shield_skin_01",
        new_units = {
            "units/Kerillian_elf_shield/Kerillian_elf_shield_heroClean_mesh_Avelorn01",
            "units/Kerillian_elf_shield/Kerillian_elf_shield_heroClean_mesh_Avelorn01_3p",
        },
        swap_hand = "left_hand_unit",
    },
    Kerillian_elf_shield_basic2 = {
        kind = "texture",
        swap_skin = nil,--"we_1h_spears_shield_skin_01", 
        textures = {
            "textures/Kerillian_elf_shield_basic2_Griffongate01/Kerillian_elf_shield_basic2_Griffongate01_diffuse",
            "textures/Kruber_Grail_Knight_shield02/Kruber_Grail_Knight_shield02_combined",
            "textures/Kruber_Grail_Knight_shield02/Kruber_Grail_Knight_shield02_normal",
        },
        swap_hand = "left_hand_unit",
        skip_meshes = {
            skip0 = true,
        },
    },
    Kerillian_elf_shield_basic2_mesh = {
        kind = "unit",
        swap_skin = nil,--"we_1h_spears_shield_skin_01", 
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
        swap_skin = nil,--"es_sword_shield_breton_skin_03",
    },
    Kerillian_elf_shield_heroClean_Saphery01 = {
        kind = "unit",
        new_units = {
            "units/Kerillian_elf_shield/Kerillian_elf_shield_heroClean_mesh",
            "units/Kerillian_elf_shield/Kerillian_elf_shield_heroClean_mesh_3p",
        },
        swap_hand = "left_hand_unit",
        swap_skin = nil,--"we_1h_spears_shield_skin_01",
    },
    Kerillian_elf_shield_heroClean_Caledor01 = {
        kind = "unit",
        new_units = {
            "units/Kerillian_elf_shield/Kerillian_elf_shield_heroClean_mesh_Caledor01",
            "units/Kerillian_elf_shield/Kerillian_elf_shield_heroClean_mesh_Caledor01_3p",
        },
        swap_hand = "left_hand_unit",
        swap_skin = nil,--"we_1h_spears_shield_skin_01",
    },
    Kerillian_elf_shield_heroClean_Avelorn02 = {
        kind = "unit",
        new_units = {
            "units/Kerillian_elf_shield/Kerillian_elf_shield_heroClean_mesh_Avelorn02",
            "units/Kerillian_elf_shield/Kerillian_elf_shield_heroClean_mesh_Avelorn02_3p",
        },
        swap_hand = "left_hand_unit",
        swap_skin = nil,--"we_1h_spears_shield_skin_01",
    },
    Kerillian_elf_shield_basicClean = {
        kind = "unit",
        new_units = {
            "units/Kerillian_elf_shield/Kerillian_elf_shield_heroClean_mesh_Eataine01",
            "units/Kerillian_elf_shield/Kerillian_elf_shield_heroClean_mesh_Eataine01_3p",
        },
        swap_hand = "left_hand_unit",
        swap_skin = nil,--"we_1h_spears_shield_skin_01",
    },
    Kerillian_elf_shield_basic2_Eaglegate01 = {
        kind = "unit",
        new_units = {
            "units/Kerillian_elf_shield/Kerillian_elf_shield_basic2_mesh_Eaglegate01",
            "units/Kerillian_elf_shield/Kerillian_elf_shield_basic2_mesh_Eaglegate01_3p",
        },
        swap_hand = "left_hand_unit",
        swap_skin = nil,--"we_1h_spears_shield_skin_01",
    },
    Kruber_empire_shield_basic1 = {
        kind = "unit",
        new_units = {
            "units/empire_shield/Kruber_Empire_shield01_mesh",
            "units/empire_shield/Kruber_Empire_shield01_mesh_3p",
        },
        swap_hand = "left_hand_unit",
        swap_skin = nil,--"es_1h_sword_shield_skin_03",
    },
    Kruber_empire_shield_basic2 = {
        kind = "unit",
        new_units = {
            "units/empire_shield/Kruber_Empire_shield02_mesh",
            "units/empire_shield/Kruber_Empire_shield02_mesh_3p",
        },
        swap_hand = "left_hand_unit",
        swap_skin = nil,--"es_1h_sword_shield_skin_03",
    },
    Kruber_empire_shield_basic2_Kotbs01 = {
        kind = "unit",
        new_units = {
            "units/empire_shield/Kruber_Empire_shield02_mesh_Kotbs01",
            "units/empire_shield/Kruber_Empire_shield02_mesh_Kotbs01_3p",
        },
        swap_hand = "left_hand_unit",
        swap_skin = nil,--"es_1h_sword_shield_skin_03",
    },
    Kruber_empire_shield_basic2_Middenheim = {
        kind = "unit",
        new_units = {
            "units/empire_shield/Kruber_Empire_shield02_mesh_Middenheim01",
            "units/empire_shield/Kruber_Empire_shield02_mesh_Middenheim01_3p",
        },
        swap_hand = "left_hand_unit",
        swap_skin = nil,--"es_1h_sword_shield_skin_03",
    },
    Kruber_empire_shield_basic3_Middenheim01 = {
        kind = "unit",
        new_units = {
            "units/empire_shield/Kruber_Empire_shield_spear01_mesh",
            "units/empire_shield/Kruber_Empire_shield_spear01_mesh_3p",
        },
        swap_hand = "left_hand_unit",
        swap_skin = nil,--"es_deus_01_skin_03",
    },
}

mod.SKIN_CHANGED = {
    es_sword_shield_breton_skin_01 = {
        changed_texture = false,
        changed_model = false,
        unit = "units/weapons/player/wpn_emp_gk_shield_02/wpn_emp_gk_shield_02",
    },
    es_sword_shield_breton_skin_02 = {
        changed_texture = false,
        changed_model = false,
        unit = "units/weapons/player/wpn_emp_gk_shield_04/wpn_emp_gk_shield_04",
    },
    es_sword_shield_breton_skin_03 = {
        changed_texture = false,
        changed_model = false,
        unit = "units/weapons/player/wpn_emp_gk_shield_05/wpn_emp_gk_shield_05",
    },
    es_sword_shield_breton_skin_03_runed_01 = {
        changed_texture = false,
        changed_model = false,
        unit = "units/weapons/player/wpn_emp_gk_shield_02/wpn_emp_gk_shield_02_runed_01",
    },
    es_sword_shield_breton_skin_03_runed_02 = {
        changed_texture = false,
        changed_model = false,
        unit = "units/weapons/player/wpn_emp_gk_shield_02/wpn_emp_gk_shield_02_runed_01",
    },
    es_sword_shield_breton_skin_04 = {
        changed_texture = false,
        changed_model = false,
        unit = "units/weapons/player/wpn_emp_gk_shield_01/wpn_emp_gk_shield_01",
    },
    es_sword_shield_breton_skin_04_magic_01_magic_01 = {
        changed_texture = false,
        changed_model = false,
        unit = "units/weapons/player/wpn_emp_gk_shield_01/wpn_emp_gk_shield_01_magic_01",
    },
    es_sword_shield_breton_skin_05 = {
        changed_texture = false,
        changed_model = false,
        unit = "units/weapons/player/wpn_emp_gk_shield_03/wpn_emp_gk_shield_03",
    },
    es_deus_01_skin_03 = {
        changed_texture = false,
        changed_model = false,
        unit = "units/weapons/player/wpn_es_deus_shield_03/wpn_es_deus_shield_03",
    },
    es_1h_sword_shield_skin_01 = {
        changed_texture = false,
        changed_model = false,
        unit = "units/weapons/player/wpn_empire_shield_01_t1/wpn_emp_shield_01_t1",
    },
    es_1h_sword_shield_skin_02 = {
        changed_texture = false,
        changed_model = false,
        unit = "units/weapons/player/wpn_empire_shield_02/wpn_emp_shield_02",
    },
    es_1h_sword_shield_skin_02_runed_01 = {
        changed_texture = false,
        changed_model = false,
        unit = "units/weapons/player/wpn_empire_shield_02/wpn_emp_shield_02_runed_01"
    },
    es_1h_sword_shield_skin_03 = {
        changed_texture = false,
        changed_model = false,
        unit = "units/weapons/player/wpn_empire_shield_03/wpn_emp_shield_03",
    },
    es_1h_sword_shield_skin_03_runed_01 = {
        changed_texture = false,
        changed_model = false,
        unit = "units/weapons/player/wpn_empire_shield_03/wpn_emp_shield_03_runed_01",
    },
    es_1h_sword_shield_skin_03_runed_02 = {
        changed_texture = false,
        changed_model = false,
        unit = "units/weapons/player/wpn_empire_shield_03/wpn_emp_shield_03_runed_01",
    },
    es_1h_sword_shield_skin_04 = {
        changed_texture = false,
        changed_model = false,
        unit = "units/weapons/player/wpn_empire_shield_04/wpn_emp_shield_04",
    },
    es_1h_sword_shield_skin_05 = {
        changed_texture = false,
        changed_model = false,
        unit = "units/weapons/player/wpn_empire_shield_05/wpn_emp_shield_05",
    },
    es_1h_mace_shield_skin_01 = {
        changed_texture = false,
        changed_model = false,
        unit = "units/weapons/player/wpn_empire_shield_01_t1/wpn_emp_shield_01_t1"
    },
    es_1h_mace_shield_skin_02 = {
        changed_texture = false,
        changed_model = false,
        unit = "units/weapons/player/wpn_empire_shield_02/wpn_emp_shield_02"
    },
    es_1h_mace_shield_skin_03 = {
        changed_texture = false,
        changed_model = false,
        unit = "units/weapons/player/wpn_empire_shield_03/wpn_emp_shield_03"
    },
    es_1h_mace_shield_skin_04 = {
        changed_texture = false,
        changed_model = false,
        unit = "units/weapons/player/wpn_empire_shield_04/wpn_emp_shield_04"
    },
    es_1h_mace_shield_skin_05 = {
        changed_texture = false,
        changed_model = false,
        unit = "units/weapons/player/wpn_empire_shield_05/wpn_emp_shield_05"
    },
    we_1h_spears_shield_skin_01 = {
        changed_texture = false,
        changed_model = false,
        unit = "units/weapons/player/wpn_we_shield_01/wpn_we_shield_01",
    },
    we_1h_spears_shield_skin_01_runed_01 = {
        changed_texture = false,
        changed_model = false,
        unit = "units/weapons/player/wpn_we_shield_01/wpn_we_shield_01_runed_01",
    },
    we_1h_spears_shield_skin_02 = {
        changed_texture = false,
        changed_model = false,
        unit = "units/weapons/player/wpn_we_shield_02/wpn_we_shield_02",
    },
}
mod.has_old_texture = false

return