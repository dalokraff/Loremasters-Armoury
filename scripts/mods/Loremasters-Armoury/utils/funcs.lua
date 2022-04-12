local mod = get_mod("Loremasters-Armoury")

mod:dofile("scripts/mods/Loremasters-Armoury/skin_list")

local function apply_texture_to_all_world_units(world, unit, diff_slot, pack_slot, norm_slot, diff, MAB, norm, Armoury_key)
    if Unit.alive(unit) then
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            if mod.SKIN_LIST[Armoury_key].skip_meshes["skip"..tostring(i)] then
                goto continue_apply_texture_to_all_world_units
            end
            local mesh = Unit.mesh(unit, i)
            local num_mats = Mesh.num_materials(mesh)
            for j = 0, num_mats - 1, 1 do
                local mat = Mesh.material(mesh, j)
                Material.set_texture(mat, diff_slot, diff)
                -- Material.set_texture(mat, pack_slot, MAB)
                -- Material.set_texture(mat, norm_slot, norm)
            end
            ::continue_apply_texture_to_all_world_units::
        end
    end    
end

function mod.apply_new_skin_from_texture(Armoury_key, world, skin, unit)
    local diff_slot = "texture_map_c0ba2942" 
    local pack_slot = "texture_map_0205ba86"
    local norm_slot = "texture_map_59cd86b9"

    local diff = mod.SKIN_LIST[Armoury_key].textures[1]
    local MAB = mod.SKIN_LIST[Armoury_key].textures[2]
    local norm = mod.SKIN_LIST[Armoury_key].textures[3]

    local hand = mod.SKIN_LIST[Armoury_key].swap_hand
    -- local skin = mod.SKIN_LIST[Armoury_key].swap_skin

    -- local package_1p = WeaponSkins.skins[skin][hand]
    -- local package_3p = WeaponSkins.skins[skin][hand].."_3p"
    
    apply_texture_to_all_world_units(world, unit, diff_slot, pack_slot, norm_slot, diff, MAB, norm, Armoury_key)

    -- apply_texture_to_all_world_units(world, package_1p, diff_slot, pack_slot, norm_slot, diff, MAB, norm, Armoury_key)
    -- apply_texture_to_all_world_units(world, package_3p, diff_slot, pack_slot, norm_slot, diff, MAB, norm, Armoury_key)    
end


local function swap_units_new(Armoury_key, skin)
    local hand = mod.SKIN_LIST[Armoury_key].swap_hand
    
    NetworkLookup.inventory_packages[mod.SKIN_LIST[Armoury_key].new_units[1]] = NetworkLookup.inventory_packages[WeaponSkins.skins[skin][hand]]
    NetworkLookup.inventory_packages[NetworkLookup.inventory_packages[WeaponSkins.skins[skin][hand]]] = mod.SKIN_LIST[Armoury_key].new_units[1]

    NetworkLookup.inventory_packages[mod.SKIN_LIST[Armoury_key].new_units[2]] = NetworkLookup.inventory_packages[WeaponSkins.skins[skin][hand].."_3p"]
    NetworkLookup.inventory_packages[NetworkLookup.inventory_packages[WeaponSkins.skins[skin][hand].."_3p"]] = mod.SKIN_LIST[Armoury_key].new_units[2]

    
    WeaponSkins.skins[skin][mod.SKIN_LIST[Armoury_key].swap_hand] = mod.SKIN_LIST[Armoury_key].new_units[1]

end

local function swap_units_old(Armoury_key, skin)
    if mod.SKIN_CHANGED[skin].changed_model then
        local hand = mod.SKIN_LIST[Armoury_key].swap_hand
        
        NetworkLookup.inventory_packages[mod.SKIN_CHANGED[skin].unit] = NetworkLookup.inventory_packages[mod.SKIN_LIST[Armoury_key].new_units[1]]
        NetworkLookup.inventory_packages[NetworkLookup.inventory_packages[mod.SKIN_LIST[Armoury_key].new_units[1]]] = mod.SKIN_CHANGED[skin].unit

        NetworkLookup.inventory_packages[mod.SKIN_CHANGED[skin].unit.."_3p"] = NetworkLookup.inventory_packages[mod.SKIN_LIST[Armoury_key].new_units[2]]
        NetworkLookup.inventory_packages[NetworkLookup.inventory_packages[mod.SKIN_LIST[Armoury_key].new_units[2]]] = mod.SKIN_CHANGED[skin].unit.."_3p"

        WeaponSkins.skins[skin][mod.SKIN_LIST[Armoury_key].swap_hand] = mod.SKIN_CHANGED[skin].unit
        mod.SKIN_CHANGED[skin].changed_model = false
    end

end

local function re_equip_weapons(skin)
    local player = Managers.player:local_player()
    if player then 
        local player_unit = player.player_unit    
        local inventory_extension = ScriptUnit.extension(player_unit, "inventory_system")
        local career_extension = ScriptUnit.extension(player_unit, "career_system")
        if career_extension then
            local career_name = career_extension:career_name()
            local item_one = BackendUtils.get_loadout_item(career_name, "slot_melee")
            local item_two = BackendUtils.get_loadout_item(career_name, "slot_ranged")

            if item_one.skin == skin or item_two.skin == skin then
                BackendUtils.set_loadout_item(item_two.backend_id, career_name, "slot_ranged")
                inventory_extension:create_equipment_in_slot("slot_ranged", item_two.backend_id)
                BackendUtils.set_loadout_item(item_one.backend_id, career_name, "slot_melee")
                inventory_extension:create_equipment_in_slot("slot_melee", item_one.backend_id)
            end
    
        end
    end
end

function mod.re_apply_illusion(Armoury_key, skin)
    if Armoury_key == "default" and (mod.SKIN_CHANGED[skin].changed_texture or mod.SKIN_CHANGED[skin].changed_model) then
        swap_units_old(mod.current_skin[skin], skin)
        re_equip_weapons(skin)
        mod.SKIN_CHANGED[skin].changed_texture = false
        mod.SKIN_CHANGED[skin].changed_model = false
    elseif Armoury_key == "default" then
        goto continue_re_apply_illusion
    elseif mod.SKIN_LIST[Armoury_key].kind == "texture" and not mod.SKIN_CHANGED[skin].changed_texture then
        swap_units_old(mod.current_skin[skin], skin)
        if mod.SKIN_LIST[Armoury_key].is_vanilla_unit then
            swap_units_new(Armoury_key, skin)
            mod.SKIN_CHANGED[skin].changed_model = true
        end
        re_equip_weapons(skin)
        mod.SKIN_CHANGED[skin].changed_texture = true
        mod.has_old_texture = true
    elseif mod.SKIN_LIST[Armoury_key].kind == "unit" and not mod.SKIN_CHANGED[skin].changed_model then
        swap_units_new(Armoury_key, skin)
        re_equip_weapons(skin)
        mod.SKIN_CHANGED[skin].changed_model = true
    end
    if mod.current_skin[skin] ~= Armoury_key then
        mod.SKIN_CHANGED[skin].changed_texture = false
        mod.SKIN_CHANGED[skin].changed_model = false
    end

    mod.current_skin[skin] = Armoury_key
    mod.current_skin[Armoury_key] = skin
    ::continue_re_apply_illusion::
    
end