local mod = get_mod("Loremasters-Armoury")
mod:dofile("scripts/mods/Loremasters-Armoury/skin_list")
mod:dofile("scripts/mods/Loremasters-Armoury/utils/funcs")
mod:dofile("scripts/mods/Loremasters-Armoury/string_dict")

--this hook is used to populate the level_world queue; get's the units to change with what custom illusion should be applied to that unit
mod:hook(SimpleInventoryExtension, "_get_no_wield_required_property_and_trait_buffs", function (func, self, backend_id)
    local data_melee = self.recently_acquired_list["slot_melee"]
    local data_range = self.recently_acquired_list["slot_ranged"]

    for skin,bools in pairs(mod.SKIN_CHANGED) do
        if bools.changed_texture then
            local Armoury_key_melee = mod:get(skin)
            local Armoury_key_range = mod:get(skin)
            
            if data_melee then
                if skin == data_melee.skin then
                    local hand_key = mod.SKIN_LIST[Armoury_key_melee].swap_hand
                    local p1 = hand_key:gsub("_hand",""):gsub("unit", "unit_1p")
                    local p3 = hand_key:gsub("_hand",""):gsub("unit", "unit_3p")
                    local unit_1p = data_melee[p1]
                    local unit_3p = data_melee[p3]
                    
                    
                    mod.level_queue[unit_1p] = {
                        Armoury_key = Armoury_key_melee,
                        skin = skin,
                    }
                    mod.level_queue[unit_3p] = {
                        Armoury_key = Armoury_key_melee,
                        skin = skin,
                    }
                end
            end

            if data_range then
                if skin == data_range.skin then
                    local hand_key = mod.SKIN_LIST[Armoury_key_range].swap_hand
                    local p1 = hand_key:gsub("_hand",""):gsub("unit", "unit_1p")
                    local p3 = hand_key:gsub("_hand",""):gsub("unit", "unit_3p")
                    local unit_1p = data_range[p1]
                    local unit_3p = data_range[p3]
                    
                    
                    mod.level_queue[unit_1p] = {
                        Armoury_key = Armoury_key_range,
                        skin = skin,
                    }
                    mod.level_queue[unit_3p] = {
                        Armoury_key = Armoury_key_range,
                        skin = skin,
                    }
                end
            end

        end
    end


    return func(self, backend_id)
end)


--this hook is used to populate the character_preview queue; gets the unit loaded in the preview if it's of the correct skin. correct hand and in the correct slot
local slot_dict = {
    "melee",
    "ranged",
}
mod:hook_safe(HeroPreviewer, "_spawn_item_unit",  function (self, unit, item_slot_type, item_template, unit_attachment_node_linking, scene_graph_links, material_settings) 
    local player = Managers.player:local_player()
    if player then
        local player_unit = player.player_unit    
        local inventory_extension = ScriptUnit.extension(player_unit, "inventory_system")
        local career_extension = ScriptUnit.extension(player_unit, "career_system")
        if career_extension then
            local career_name = career_extension:career_name()
            for slot_order,units in pairs(self._equipment_units) do
                local slot = slot_dict[slot_order]
                
                if slot then
                    if self._item_info_by_slot[slot] then 
                        local item = BackendUtils.get_loadout_item(career_name, "slot_"..slot)
                        if item then
                            local skin = item.skin
                            local Armoury_key = mod:get(skin)
                            local hand = mod.SKIN_LIST[Armoury_key].swap_hand
                            local hand_key = hand:gsub("_hand_unit", "")
                            local unit = units[hand_key]

                            if unit then
                                mod.preview_queue[unit] = {
                                    Armoury_key = Armoury_key,
                                    skin = skin,
                                }
                            end
                        end
                    end
                end
            end

            
        end
    end
end)

--this table is used to tell the package manager that the custom units are loaded already
local new_pacakges = {
    hat_path = "units/Kerillian_elf_shield/Kerillian_elf_shield_heroClean_mesh",
    Eataine01 = "units/Kerillian_elf_shield/Kerillian_elf_shield_heroClean_mesh_Eataine01",
    Avelorn01 = "units/Kerillian_elf_shield/Kerillian_elf_shield_heroClean_mesh_Avelorn01",
    Caledor01 = "units/Kerillian_elf_shield/Kerillian_elf_shield_heroClean_mesh_Caledor01",
    Avelorn02 = "units/Kerillian_elf_shield/Kerillian_elf_shield_heroClean_mesh_Avelorn02",
    Griffongate01 = "units/Kerillian_elf_shield/Kerillian_elf_shield_basic2_mesh_Griffongate01",
    Eaglegate01 = "units/Kerillian_elf_shield/Kerillian_elf_shield_basicClean_mesh_Eaglegate01",
    Empire_shield01 = "units/empire_shield/Kruber_Empire_shield01_mesh",
    Empire_shield02 = "units/empire_shield/Kruber_Empire_shield02_mesh",
    Empire_shield02_Ostermark01 = "units/empire_shield/Kruber_Empire_shield01_mesh_Ostermark01",
    Empire_shield03 = "units/empire_shield/Kruber_Empire_shield_spear01_mesh",
    Empire_shield03_Kotbs01 = "units/empire_shield/Kruber_Empire_shield02_mesh_Kotbs01",
    Empire_shield03_Middenheim01 = "units/empire_shield/Kruber_Empire_shield02_mesh_Middenheim01",
}

local pacakge_tisch = {}
for k,v in pairs(new_pacakges) do
    pacakge_tisch[v] = v
    pacakge_tisch[v.."_3p"] = v.."_3p"
end

mod:hook(PackageManager, "load",
         function(func, self, package_name, reference_name, callback,
                  asynchronous, prioritize)
    if package_name ~= pacakge_tisch[package_name] and package_name ~= pacakge_tisch[package_name.."_3p"] then
        func(self, package_name, reference_name, callback, asynchronous,
             prioritize)
    end
	
end)

mod:hook(PackageManager, "unload",
         function(func, self, package_name, reference_name)
    if package_name ~= pacakge_tisch[package_name] and package_name ~= pacakge_tisch[package_name.."_3p"] then
        func(self, package_name, reference_name)
    end
	
end)

mod:hook(PackageManager, "has_loaded",
         function(func, self, package, reference_name)
    if package == pacakge_tisch[package] or package == pacakge_tisch[package.."_3p"] then
        return true
    end
	
    return func(self, package, reference_name)
end)

--replaces item skin name and descritpion
mod:hook(LocalizationManager, "_base_lookup", function (func, self, text_id)
    local word = mod.dict[text_id]
    local skin = mod.helper_dict[text_id]
    local Armoury_key = mod:get(skin)

    if word then    
        if mod.SKIN_CHANGED[skin].changed_texture or mod.SKIN_CHANGED[skin].changed_model then
            return word[Armoury_key]
        end
    end
    
	return func(self, text_id)
end)