local mod = get_mod("Loremasters-Armoury")
mod:dofile("scripts/mods/Loremasters-Armoury/skin_list")
mod:dofile("scripts/mods/Loremasters-Armoury/utils/funcs")
mod:dofile("scripts/mods/Loremasters-Armoury/string_dict")

-- mod:hook_safe(UnitSpawner, 'spawn_local_unit', function (self, unit_name, position, rotation, material)
--     for skin,bools in pairs(mod.SKIN_CHANGED) do
--         if bools.changed_texture then
--             local Armoury_key = mod:get(skin)
--             mod:echo(tostring(skin)..":  "..tostring(bools.changed_texture))
--             local old_unit = WeaponSkins.skins[skin][mod.SKIN_LIST[Armoury_key].swap_hand]
--             --if mod.SKIN_LIST[Armoury_key].units[1] == unit_name or mod.SKIN_LIST[Armoury_key].units[2] == unit_name then
--             if old_unit == unit_name or old_unit.."_3p" == unit_name then
--                 mod.level_queue[Armoury_key] = skin
--                 mod.preview_queue[Armoury_key] = skin
--             end
--         end
--     end
-- end)


--this hook is used to generate the level_world queue; get's the units to change with what custom illusion should be applied to that unit
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
                        -- id = Unit.get_data(unit_1p, "unique_id"),
                    }
                    mod.level_queue[unit_3p] = {
                        Armoury_key = Armoury_key_melee,
                        skin = skin,
                        -- id = Unit.get_data(unit_3p, "unique_id"),
                    }
                    mod.preview_queue[unit_1p] = {
                        Armoury_key = Armoury_key_melee,
                        skin = skin,
                        -- id = Unit.get_data(unit_1p, "unique_id"),
                    }
                    mod.preview_queue[unit_3p] = {
                        Armoury_key = Armoury_key_melee,
                        skin = skin,
                        -- id = Unit.get_data(unit_3p, "unique_id"),
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
                        -- id = Unit.get_data(unit_1p, "unique_id"),
                    }
                    mod.level_queue[unit_3p] = {
                        Armoury_key = Armoury_key_range,
                        skin = skin,
                        -- id = Unit.get_data(unit_3p, "unique_id"),
                    }
                    mod.preview_queue[unit_1p] = {
                        Armoury_key = Armoury_key_range,
                        skin = skin,
                        -- id = Unit.get_data(unit_1p, "unique_id"),
                    }
                    mod.preview_queue[unit_3p] = {
                        Armoury_key = Armoury_key_range,
                        skin = skin,
                        -- id = Unit.get_data(unit_3p, "unique_id"),
                    }
                end
            end

        end
    end


    return func(self, backend_id)
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