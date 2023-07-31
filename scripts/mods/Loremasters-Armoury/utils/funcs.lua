local mod = get_mod("Loremasters-Armoury")
mod:dofile("scripts/mods/Loremasters-Armoury/string_dict")

local function apply_texture_to_all_world_units(world, unit, skin, diff_slot, pack_slot, norm_slot, diff, MAB, norm, Armoury_key, is_fps_unit)
    if Unit.alive(unit) then
        --value is set by hook for units who change skins by material changes
        --PlayerUnitCosmeticExtension._init_mesh_attachment
        local vanilla_skin = Unit.get_data(unit, "vanilla_skin") or skin

        if vanilla_skin == skin then
            local num_meshes = Unit.num_meshes(unit)
            for i = 0, num_meshes - 1, 1 do
                local new_diff = diff
                local new_MAB = MAB
                local new_norm = norm
                --some units like the elf spear and shield have meshes that need to be skipped as they don't use the "main" diffuse map 
                if mod.SKIN_LIST[Armoury_key].skip_meshes["skip"..tostring(i)] and not is_fps_unit then
                    if mod.SKIN_LIST[Armoury_key].textures_other_mesh then 
                        if mod.SKIN_LIST[Armoury_key].textures_other_mesh["skip"..tostring(i)] then
                            if mod.SKIN_LIST[Armoury_key].textures_other_mesh["skip"..tostring(i)][1] then
                                new_diff = mod.SKIN_LIST[Armoury_key].textures_other_mesh["skip"..tostring(i)][1]
                            end
                            if mod.SKIN_LIST[Armoury_key].textures_other_mesh["skip"..tostring(i)][2] then
                                new_MAB = mod.SKIN_LIST[Armoury_key].textures_other_mesh["skip"..tostring(i)][2]
                            end
                            if mod.SKIN_LIST[Armoury_key].textures_other_mesh["skip"..tostring(i)][3] then
                                new_norm = mod.SKIN_LIST[Armoury_key].textures_other_mesh["skip"..tostring(i)][3]
                            end
                        else 
                            goto continue_apply_texture_to_all_world_units
                        end
                    else
                        goto continue_apply_texture_to_all_world_units
                    end
                end
                -- ::apply_new_textures::
                local mesh = Unit.mesh(unit, i)
                local num_mats = Mesh.num_materials(mesh)
                for j = 0, num_mats - 1, 1 do
                    local mat = Mesh.material(mesh, j)
                    if new_diff then
                        Material.set_texture(mat, diff_slot, new_diff)
                    end
                    if new_MAB then 
                        Material.set_texture(mat, pack_slot, new_MAB)
                    end
                    if new_norm then
                        Material.set_texture(mat, norm_slot, new_norm)
                    end
                    if mod.SKIN_LIST[Armoury_key].special_textures then 
                        if not mod.SKIN_LIST[Armoury_key].mat_to_skip["skip"..tostring(j)] then 
                            for _,text_tisch in ipairs(mod.SKIN_LIST[Armoury_key].special_textures) do 
                                Material.set_texture(mat, text_tisch.slot, text_tisch.texture)
                            end
                        end
                    end
                end
                ::continue_apply_texture_to_all_world_units::
            end
        end
    end    
end

function mod.apply_new_skin_from_texture(Armoury_key, world, skin, unit)
    local diff_slot = "texture_map_c0ba2942" 
    local pack_slot = "texture_map_0205ba86"
    local norm_slot = "texture_map_59cd86b9"

    local is_fps_unit = false
    if mod.SKIN_LIST[Armoury_key].swap_hand == 'armor' then 
        diff_slot = "texture_map_64cc5eb8"
        norm_slot = "texture_map_861dbfdc"
        pack_slot = "texture_map_abb81538"
    end

    if mod.SKIN_LIST[Armoury_key].fps_units then 
        local preview_world = nil
        if Managers.world:has_world("character_preview") then
            preview_world = Managers.world:world("character_preview")
        end
        if Managers.world:has_world("LA_armoury_preview") then
            preview_world = Managers.world:world("LA_armoury_preview")
        end
        if preview_world ~= world then
            if Unit.get_data(unit, 'unit_name') == mod.SKIN_LIST[Armoury_key].fps_units[1] then
                diff_slot = "texture_map_64cc5eb8"
                norm_slot = "texture_map_861dbfdc"
                pack_slot = "texture_map_b788717c"
                is_fps_unit = true
            end
        end
        
    end

    if mod.SKIN_LIST[Armoury_key].textures and not is_fps_unit then
        local diff = mod.SKIN_LIST[Armoury_key].textures[1]
        local MAB = mod.SKIN_LIST[Armoury_key].textures[2]
        local norm = mod.SKIN_LIST[Armoury_key].textures[3]

        local hand = mod.SKIN_LIST[Armoury_key].swap_hand
        
        apply_texture_to_all_world_units(world, unit, skin, diff_slot, pack_slot, norm_slot, diff, MAB, norm, Armoury_key, is_fps_unit)
    elseif mod.SKIN_LIST[Armoury_key].textures_fps and is_fps_unit then 
        local diff = mod.SKIN_LIST[Armoury_key].textures_fps[1]
        local MAB = mod.SKIN_LIST[Armoury_key].textures_fps[2]
        local norm = mod.SKIN_LIST[Armoury_key].textures_fps[3]
        
        apply_texture_to_all_world_units(world, unit, skin, diff_slot, pack_slot, norm_slot, diff, MAB, norm, Armoury_key, is_fps_unit)
    end

    if WeaponSkins.skins[skin] and mod.SKIN_LIST[Armoury_key].icons then
        mod.SKIN_CHANGED[skin].icon = ItemMasterList[skin]['inventory_icon']
        WeaponSkins.skins[skin]['inventory_icon'] = mod.SKIN_LIST[Armoury_key].icons[skin] or WeaponSkins.skins[skin]['inventory_icon']
    end

    if ItemMasterList[skin] and mod.SKIN_LIST[Armoury_key].icons then
        local old_icon = tostring(ItemMasterList[skin]['inventory_icon'])
        ItemMasterList[skin]['inventory_icon'] = mod.SKIN_LIST[Armoury_key].icons["default"] or ItemMasterList[skin]['inventory_icon']
        if old_icon ~= ItemMasterList[skin]['inventory_icon'] then
            mod.SKIN_CHANGED[skin].icon = old_icon
        end  
        ItemMasterList[skin]['inventory_icon'] = mod.SKIN_LIST[Armoury_key].icons[skin] or ItemMasterList[skin]['inventory_icon']
    end

end


--this functions ensure that the local network lookup tables get update with repsective package paths,
--to prevent sending clients/host a bad lookup key can causing them to crash
local function swap_units_new(Armoury_key, skin)
    local pattern = "_rightHand"
    local new_name = string.gsub(skin, pattern, "")
    
    local hand = mod.SKIN_LIST[Armoury_key].swap_hand
    if hand == "left_hand_unit" or hand == "right_hand_unit" then
        NetworkLookup.inventory_packages[mod.SKIN_LIST[Armoury_key].new_units[1]] = NetworkLookup.inventory_packages[WeaponSkins.skins[new_name][hand]]
        NetworkLookup.inventory_packages[NetworkLookup.inventory_packages[WeaponSkins.skins[new_name][hand]]] = mod.SKIN_LIST[Armoury_key].new_units[1]

        NetworkLookup.inventory_packages[mod.SKIN_LIST[Armoury_key].new_units[2]] = NetworkLookup.inventory_packages[WeaponSkins.skins[new_name][hand].."_3p"]
        NetworkLookup.inventory_packages[NetworkLookup.inventory_packages[WeaponSkins.skins[new_name][hand].."_3p"]] = mod.SKIN_LIST[Armoury_key].new_units[2]

        
        WeaponSkins.skins[new_name][mod.SKIN_LIST[Armoury_key].swap_hand] = mod.SKIN_LIST[Armoury_key].new_units[1]
        mod.SKIN_CHANGED[new_name].icon = ItemMasterList[new_name]['inventory_icon']
        if mod.SKIN_LIST[Armoury_key].icons then
            WeaponSkins.skins[new_name]['inventory_icon'] = mod.SKIN_LIST[Armoury_key].icons[skin] or WeaponSkins.skins[new_name]['inventory_icon']
        end
    elseif hand == "hat" then
        NetworkLookup.inventory_packages[mod.SKIN_LIST[Armoury_key].new_units[1]] = NetworkLookup.inventory_packages[ItemMasterList[new_name]["unit"]]
        NetworkLookup.inventory_packages[NetworkLookup.inventory_packages[ItemMasterList[new_name]["unit"]]] = mod.SKIN_LIST[Armoury_key].new_units[1]
       
        ItemMasterList[new_name]['unit'] = mod.SKIN_LIST[Armoury_key].new_units[1]
        if mod.SKIN_LIST[Armoury_key].icons then
            ItemMasterList[new_name]['inventory_icon'] = mod.SKIN_LIST[Armoury_key].icons[skin] or ItemMasterList[new_name]['inventory_icon']
        end
    elseif hand == "armor" then
        -- NetworkLookup.inventory_packages[mod.SKIN_LIST[Armoury_key].new_units[1]] = NetworkLookup.inventory_packages[ItemMasterList[skin]["third_person_attachment"]["unit"]]
        -- NetworkLookup.inventory_packages[NetworkLookup.inventory_packages[ItemMasterList[skin]["third_person_attachment"]["unit"]]] = mod.SKIN_LIST[Armoury_key].new_units[1]
       
        -- ItemMasterList[skin]["third_person_attachment"]['unit'] = mod.SKIN_LIST[Armoury_key].new_units[1]\
        if mod.SKIN_LIST[Armoury_key].icons then
            local old_icon = tostring(ItemMasterList[new_name]['inventory_icon'])
            ItemMasterList[new_name]['inventory_icon'] = mod.SKIN_LIST[Armoury_key].icons["default"] or ItemMasterList[new_name]['inventory_icon']
            if old_icon ~= ItemMasterList[new_name]['inventory_icon'] then
                mod.SKIN_CHANGED[new_name].icon = old_icon
            end
        end
        local y = 1
    end

end

local function swap_units_old(Armoury_key, skin)
    local pattern = "_rightHand"
    local new_name = string.gsub(skin, pattern, "")

    if mod.SKIN_CHANGED[skin].changed_model then
        local hand = mod.SKIN_LIST[Armoury_key].swap_hand
        
        if hand == "left_hand_unit" or hand == "right_hand_unit" then

            NetworkLookup.inventory_packages[mod.SKIN_CHANGED[skin].unit] = NetworkLookup.inventory_packages[mod.SKIN_LIST[Armoury_key].new_units[1]]
            NetworkLookup.inventory_packages[NetworkLookup.inventory_packages[mod.SKIN_LIST[Armoury_key].new_units[1]]] = mod.SKIN_CHANGED[skin].unit

            NetworkLookup.inventory_packages[mod.SKIN_CHANGED[skin].unit.."_3p"] = NetworkLookup.inventory_packages[mod.SKIN_LIST[Armoury_key].new_units[2]]
            NetworkLookup.inventory_packages[NetworkLookup.inventory_packages[mod.SKIN_LIST[Armoury_key].new_units[2]]] = mod.SKIN_CHANGED[skin].unit.."_3p"

            WeaponSkins.skins[new_name][mod.SKIN_LIST[Armoury_key].swap_hand] = mod.SKIN_CHANGED[skin].unit
            mod.SKIN_CHANGED[skin].changed_model = false
            WeaponSkins.skins[new_name]['inventory_icon'] = mod.SKIN_CHANGED[skin].icon 
        
        elseif hand == "hat" then
            NetworkLookup.inventory_packages[mod.SKIN_CHANGED[skin].unit] = NetworkLookup.inventory_packages[mod.SKIN_LIST[Armoury_key].new_units[1]]
            NetworkLookup.inventory_packages[NetworkLookup.inventory_packages[mod.SKIN_LIST[Armoury_key].new_units[1]]] = mod.SKIN_CHANGED[skin].unit

            ItemMasterList[new_name]['unit'] = mod.SKIN_LIST[Armoury_key].new_units[1]--needs to be unit if new mesh hat is added
            if mod.SKIN_LIST[Armoury_key].icons then
                ItemMasterList[new_name]['inventory_icon'] = mod.SKIN_CHANGED[skin].icon
            end
            mod.SKIN_CHANGED[new_name].changed_model = false
        elseif hand == "armor" then
            -- NetworkLookup.inventory_packages[mod.SKIN_LIST[Armoury_key].new_units[1]] = NetworkLookup.inventory_packages[ItemMasterList[skin]["third_person_attachment"]["unit"]]
            -- NetworkLookup.inventory_packages[NetworkLookup.inventory_packages[ItemMasterList[skin]["third_person_attachment"]["unit"]]] = mod.SKIN_LIST[Armoury_key].new_units[1]
        
            -- ItemMasterList[skin]["third_person_attachment"]['unit'] = mod.SKIN_LIST[Armoury_key].new_units[1]
            ItemMasterList[new_name]['inventory_icon'] = mod.SKIN_CHANGED[skin].icon
            mod.SKIN_CHANGED[skin].changed_model = false
        end
    end

end

--function to re-equip weapons if the either weapon skin matches the passed in skin
local function re_equip_weapons(skin, unit)
    local player = Managers.player:local_player()
    local pattern = "_rightHand"
    local new_name = string.gsub(skin, pattern, "")
    if player then 
        local player_unit = player.player_unit    
        local inventory_extension = ScriptUnit.extension(player_unit, "inventory_system")
        local career_extension = ScriptUnit.extension(player_unit, "career_system")
        if career_extension then
            local career_name = career_extension:career_name()
            local item_one = BackendUtils.get_loadout_item(career_name, "slot_melee")
            local item_two = BackendUtils.get_loadout_item(career_name, "slot_ranged")
            local item_hat = BackendUtils.get_loadout_item(career_name, "slot_hat")
            local item_skin =  BackendUtils.get_loadout_item(career_name, "slot_skin")

            if item_one.skin == new_name or item_two.skin == new_name then
                BackendUtils.set_loadout_item(item_two.backend_id, career_name, "slot_ranged")
                inventory_extension:create_equipment_in_slot("slot_ranged", item_two.backend_id)
                BackendUtils.set_loadout_item(item_one.backend_id, career_name, "slot_melee")
                inventory_extension:create_equipment_in_slot("slot_melee", item_one.backend_id)
            end

            local attachment_extension = ScriptUnit.extension(player_unit, "attachment_system")
            attachment_extension:create_attachment_in_slot("slot_hat", item_hat.backend_id)

        end
    end
end


--this function checks whether a skin from the vmf menu needs:
--to be given the default unit; depending on the current state of the skin different actions are taken 
--to have it's default unit retextured
--to have it's default skin be given a new unit
function mod.re_apply_illusion(Armoury_key, skin, unit)
    local pattern = "_rightHand"
    local new_name = string.gsub(skin, pattern, "")
    

    if mod.locked_skins[Armoury_key] then
        mod:set(skin, "default")
        goto continue_re_apply_illusion
    end


    if Armoury_key == "default" and (mod.SKIN_CHANGED[skin].changed_texture or mod.SKIN_CHANGED[skin].changed_model) then
        if ItemMasterList[new_name].item_type == "skin"  then
            mod:echo("[Loremaster's Armoury]: You will need to re-equip your character skin for this change to be updated.")
        end
        swap_units_old(mod.current_skin[skin], skin)
        re_equip_weapons(skin, unit)
        mod.SKIN_CHANGED[skin].changed_texture = false
        mod.SKIN_CHANGED[skin].changed_model = false   
    elseif Armoury_key == "default" then
        if mod.SKIN_CHANGED[skin] and WeaponSkins.skins[skin] then
            WeaponSkins.skins[skin]['inventory_icon'] = mod.SKIN_CHANGED[skin].icon 
        end
        if mod.SKIN_CHANGED[skin] and ItemMasterList[new_name] then
            ItemMasterList[new_name]['inventory_icon'] = mod.SKIN_CHANGED[skin].icon
        end
        goto continue_re_apply_illusion
    elseif mod.SKIN_LIST[Armoury_key].kind == "texture" and not mod.SKIN_CHANGED[skin].changed_texture then
        swap_units_old(mod.current_skin[skin], skin)
        if mod.SKIN_LIST[Armoury_key].is_vanilla_unit then
            swap_units_new(Armoury_key, skin)
            mod.SKIN_CHANGED[skin].changed_model = true
        end
        re_equip_weapons(skin, unit)
        mod.SKIN_CHANGED[skin].changed_texture = true
        mod.has_old_texture = true
        if ItemMasterList[new_name].item_type == "skin" then
            mod:echo("[Loremaster's Armoury]: You will need to re-equip your character skin for this change to be updated.")
        end
    elseif mod.SKIN_LIST[Armoury_key].kind == "unit" and not mod.SKIN_CHANGED[skin].changed_model then
        swap_units_new(Armoury_key, skin)
        re_equip_weapons(skin, unit)
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