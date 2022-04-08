local mod = get_mod("Loremasters-Armoury")
mod:dofile("scripts/mods/Loremasters-Armoury/skin_list")
mod:dofile("scripts/mods/Loremasters-Armoury/utils/funcs")
mod:dofile("scripts/mods/Loremasters-Armoury/string_dict")

mod:hook_safe(UnitSpawner, 'spawn_local_unit', function (self, unit_name, position, rotation, material)
    for skin,bools in pairs(mod.SKIN_CHANGED) do
        if bools.changed_texture then
            local Armoury_key = mod:get(skin)
            local old_unit = WeaponSkins.skins[skin][mod.SKIN_LIST[Armoury_key].swap_hand]
            --if mod.SKIN_LIST[Armoury_key].units[1] == unit_name or mod.SKIN_LIST[Armoury_key].units[2] == unit_name then
            if old_unit == unit_name or old_unit.."_3p" == unit_name then
                mod.level_queue[Armoury_key] = skin
                mod.preview_queue[Armoury_key] = skin
            end
        end
    end
end)

--this table is used to tell the package manager that the custom units are loaded already
-- local hat_path = "units/Kerillian_elf_shield/Kerillian_elf_shield_heroClean_mesh"
-- local Eataine01 = "units/Kerillian_elf_shield/Kerillian_elf_shield_heroClean_mesh_Eataine01"
-- local Avelorn01 = "units/Kerillian_elf_shield/Kerillian_elf_shield_heroClean_mesh_Avelorn01"
-- local Griffongate01 = "units/Kerillian_elf_shield/Kerillian_elf_shield_basic2_mesh_Griffongate01"
-- local Empire_shield01 = "units/empire_shield/Kruber_Empire_shield01_mesh"
-- local Empire_shield02 = "units/empire_shield/Kruber_Empire_shield02_mesh"
-- local Empire_shield03 = "units/empire_shield/Kruber_Empire_shield_spear01_mesh"
-- local Empire_shield03_Kotbs01 = "units/empire_shield/Kruber_Empire_shield02_mesh_Kotbs01"
-- local Empire_shield03_Middenheim01 = "units/empire_shield/Kruber_Empire_shield02_mesh_Middenheim01"

local new_pacakges = {
    hat_path = "units/Kerillian_elf_shield/Kerillian_elf_shield_heroClean_mesh",
    Eataine01 = "units/Kerillian_elf_shield/Kerillian_elf_shield_heroClean_mesh_Eataine01",
    Avelorn01 = "units/Kerillian_elf_shield/Kerillian_elf_shield_heroClean_mesh_Avelorn01",
    Caledor01 = "units/Kerillian_elf_shield/Kerillian_elf_shield_heroClean_mesh_Caledor01",
    Avelorn02 = "units/Kerillian_elf_shield/Kerillian_elf_shield_heroClean_mesh_Avelorn02",
    Griffongate01 = "units/Kerillian_elf_shield/Kerillian_elf_shield_basic2_mesh_Griffongate01",
    Eaglegate01 = "units/Kerillian_elf_shield/Kerillian_elf_shield_basic2_mesh_Eaglegate01",
    Empire_shield01 = "units/empire_shield/Kruber_Empire_shield01_mesh",
    Empire_shield02 = "units/empire_shield/Kruber_Empire_shield02_mesh",
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