local mod = get_mod("Loremasters-Armoury")
mod:dofile("scripts/mods/Loremasters-Armoury/string_dict")

local function apply_texture_to_all_world_units(world, unit, diff_slot, pack_slot, norm_slot, diff, MAB, norm, Armoury_key, is_fps_unit)
    if Unit.alive(unit) then
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            --some units like the elf spear and shield have meshes that need to be skipped as they don't use the "main" diffuse map 
            -- mod:echo("is_fps_unit"..":  "..tostring(is_fps_unit))
            if mod.SKIN_LIST[Armoury_key].skip_meshes["skip"..tostring(i)]  and not is_fps_unit then
                goto continue_apply_texture_to_all_world_units
            end
            local mesh = Unit.mesh(unit, i)
            local num_mats = Mesh.num_materials(mesh)
            for j = 0, num_mats - 1, 1 do
                local mat = Mesh.material(mesh, j)
                if diff then
                    Material.set_texture(mat, diff_slot, diff)
                end
                if MAB then 
                    Material.set_texture(mat, pack_slot, MAB)
                end
                if norm then
                    Material.set_texture(mat, norm_slot, norm)
                end
            end
            ::continue_apply_texture_to_all_world_units::
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
        if preview_world ~= world then
            if Unit.get_data(unit, 'unit_name') == mod.SKIN_LIST[Armoury_key].fps_units[1] then
                diff_slot = "texture_map_64cc5eb8"
                norm_slot = "texture_map_861dbfdc"
                pack_slot = "texture_map_b788717c"
                is_fps_unit = true
                -- mod:echo("is_fps_unit"..":  "..tostring(is_fps_unit))
            end
        end
    end

    if mod.SKIN_LIST[Armoury_key].textures and not is_fps_unit then
        local diff = mod.SKIN_LIST[Armoury_key].textures[1]
        local MAB = mod.SKIN_LIST[Armoury_key].textures[2]
        local norm = mod.SKIN_LIST[Armoury_key].textures[3]

        local hand = mod.SKIN_LIST[Armoury_key].swap_hand
        
        apply_texture_to_all_world_units(world, unit, diff_slot, pack_slot, norm_slot, diff, MAB, norm, Armoury_key, is_fps_unit)
    elseif mod.SKIN_LIST[Armoury_key].textures_fps and is_fps_unit then 
        local diff = mod.SKIN_LIST[Armoury_key].textures_fps[1]
        local MAB = mod.SKIN_LIST[Armoury_key].textures_fps[2]
        local norm = mod.SKIN_LIST[Armoury_key].textures_fps[3]
        
        apply_texture_to_all_world_units(world, unit, diff_slot, pack_slot, norm_slot, diff, MAB, norm, Armoury_key, is_fps_unit)
    end
end


--this functions ensure that the local network lookup tables get update with repsective package paths,
--to prevent sending clients/host a bad lookup key can causing them to crash
local function swap_units_new(Armoury_key, skin)
    local hand = mod.SKIN_LIST[Armoury_key].swap_hand
    if hand == "left_hand_unit" or hand == "right_hand_unit" then
        NetworkLookup.inventory_packages[mod.SKIN_LIST[Armoury_key].new_units[1]] = NetworkLookup.inventory_packages[WeaponSkins.skins[skin][hand]]
        NetworkLookup.inventory_packages[NetworkLookup.inventory_packages[WeaponSkins.skins[skin][hand]]] = mod.SKIN_LIST[Armoury_key].new_units[1]

        NetworkLookup.inventory_packages[mod.SKIN_LIST[Armoury_key].new_units[2]] = NetworkLookup.inventory_packages[WeaponSkins.skins[skin][hand].."_3p"]
        NetworkLookup.inventory_packages[NetworkLookup.inventory_packages[WeaponSkins.skins[skin][hand].."_3p"]] = mod.SKIN_LIST[Armoury_key].new_units[2]

        
        WeaponSkins.skins[skin][mod.SKIN_LIST[Armoury_key].swap_hand] = mod.SKIN_LIST[Armoury_key].new_units[1]
    elseif hand == "hat" then
        NetworkLookup.inventory_packages[mod.SKIN_LIST[Armoury_key].new_units[1]] = NetworkLookup.inventory_packages[ItemMasterList[skin]["unit"]]
        NetworkLookup.inventory_packages[NetworkLookup.inventory_packages[ItemMasterList[skin]["unit"]]] = mod.SKIN_LIST[Armoury_key].new_units[1]
       
        ItemMasterList[skin]['unit'] = mod.SKIN_LIST[Armoury_key].new_units[1]
    elseif hand == "armor" then
        -- NetworkLookup.inventory_packages[mod.SKIN_LIST[Armoury_key].new_units[1]] = NetworkLookup.inventory_packages[ItemMasterList[skin]["third_person_attachment"]["unit"]]
        -- NetworkLookup.inventory_packages[NetworkLookup.inventory_packages[ItemMasterList[skin]["third_person_attachment"]["unit"]]] = mod.SKIN_LIST[Armoury_key].new_units[1]
       
        -- ItemMasterList[skin]["third_person_attachment"]['unit'] = mod.SKIN_LIST[Armoury_key].new_units[1]
        local y =1
    end

end

local function swap_units_old(Armoury_key, skin)
    if mod.SKIN_CHANGED[skin].changed_model then
        local hand = mod.SKIN_LIST[Armoury_key].swap_hand
        
        if hand == "left_hand_unit" or hand == "right_hand_unit" then

            NetworkLookup.inventory_packages[mod.SKIN_CHANGED[skin].unit] = NetworkLookup.inventory_packages[mod.SKIN_LIST[Armoury_key].new_units[1]]
            NetworkLookup.inventory_packages[NetworkLookup.inventory_packages[mod.SKIN_LIST[Armoury_key].new_units[1]]] = mod.SKIN_CHANGED[skin].unit

            NetworkLookup.inventory_packages[mod.SKIN_CHANGED[skin].unit.."_3p"] = NetworkLookup.inventory_packages[mod.SKIN_LIST[Armoury_key].new_units[2]]
            NetworkLookup.inventory_packages[NetworkLookup.inventory_packages[mod.SKIN_LIST[Armoury_key].new_units[2]]] = mod.SKIN_CHANGED[skin].unit.."_3p"

            WeaponSkins.skins[skin][mod.SKIN_LIST[Armoury_key].swap_hand] = mod.SKIN_CHANGED[skin].unit
            mod.SKIN_CHANGED[skin].changed_model = false
        end
    elseif hand == "hat" then
        NetworkLookup.inventory_packages[mod.SKIN_CHANGED[skin].unit] = NetworkLookup.inventory_packages[mod.SKIN_LIST[Armoury_key].new_units[1]]
        NetworkLookup.inventory_packages[NetworkLookup.inventory_packages[mod.SKIN_LIST[Armoury_key].new_units[1]]] = mod.SKIN_CHANGED[skin].unit

        ItemMasterList[skin]['unit'] = mod.SKIN_LIST[Armoury_key].new_units[1]--needs to be unit if new mesh hat is added
        mod.SKIN_CHANGED[skin].changed_model = false
    elseif hand == "armor" then
        NetworkLookup.inventory_packages[mod.SKIN_LIST[Armoury_key].new_units[1]] = NetworkLookup.inventory_packages[ItemMasterList[skin]["third_person_attachment"]["unit"]]
        NetworkLookup.inventory_packages[NetworkLookup.inventory_packages[ItemMasterList[skin]["third_person_attachment"]["unit"]]] = mod.SKIN_LIST[Armoury_key].new_units[1]
       
        ItemMasterList[skin]["third_person_attachment"]['unit'] = mod.SKIN_LIST[Armoury_key].new_units[1]
        mod.SKIN_CHANGED[skin].changed_model = false
    end

end

-- local player = Managers.player:local_player()
-- local player_unit = player.player_unit
-- local cosmetic_extension = ScriptUnit.extension(player_unit, "cosmetic_system")
-- local material_changes = {
--     package_name = "units/beings/player/empire_soldier_knight/skins/black_and_gold/chr_empire_soldier_knight_black_and_gold",
--     third_person = {
--         mtr_outfit = "units/beings/player/empire_soldier_knight/skins/black_and_gold/mtr_outfit_black_and_gold"
--     },
--     first_person = {
--         mtr_outfit = "units/beings/player/empire_soldier_knight/skins/black_and_gold/mtr_outfit_black_and_gold_1p"
--     }
-- }
-- mod:echo(material_changes.third_person)
-- cosmetic_extension:change_skin_materials(material_changes)
-- mod:echo(cosmetic_extension)
-- for k,v in pairs(cosmetic_extension) do
--     mod:echo(tostring(k))
-- end

-- local career_extension = ScriptUnit.extension(player_unit, "career_system")
-- local career_name = career_extension:career_name()
-- local item_hat = BackendUtils.get_loadout_item(career_name, "slot_hat")
-- mod:echo(item_hat)
-- local attachment_extension = ScriptUnit.extension(player_unit, "attachment_system")
-- attachment_extension:create_attachment_in_slot("slot_hat", item_hat.backend_id)
-- local player = Managers.player:local_player()
-- CosmeticUtils.update_cosmetic_slot(self._player, "slot_skin", item_data.name)
-- local player = Managers.player
-- for k,v in pairs(player) do
--     mod:echo(tostring(k)..":    "..tostring(v))
    
-- end
-- for k,v in pairs(ItemMasterList) do 
--     local game_localize = Managers.localizer
--     mod:echo(game_localize:_base_lookup("skin_es_knight_brass_keep"))

-- end
--function to re-equip weapons if the either weapon skin matches the passed in skin
local function re_equip_weapons(skin, unit)
    local player = Managers.player:local_player()
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
            -- for k,v in pairs(item_one) do
            --     mod:echo(tostring(k)..":    "..tostring(v))
            -- end
            if item_one.skin == skin or item_two.skin == skin then
                BackendUtils.set_loadout_item(item_two.backend_id, career_name, "slot_ranged")
                inventory_extension:create_equipment_in_slot("slot_ranged", item_two.backend_id)
                BackendUtils.set_loadout_item(item_one.backend_id, career_name, "slot_melee")
                inventory_extension:create_equipment_in_slot("slot_melee", item_one.backend_id)
            end

            local attachment_extension = ScriptUnit.extension(player_unit, "attachment_system")
            attachment_extension:create_attachment_in_slot("slot_hat", item_hat.backend_id)
            -- local unit_name = Unit.get_data(unit, "unit_name")
            -- if string.find(unit_name, mesh) then
            --     local world = Managers.world:world("level_world")
            --     local unit_spawner = Managers.state.unit_spawner
            --     local pos = Unit.local_position(player_unit, 0)
            --     local rot = Unit.local_rotation(player_unit, 0)
            --     unit_spawner:mark_for_deletion(unit)
            --     local new_unit = unit_spawner:spawn_local_unit_with_extensions(unit_name, nil, nil, pos, rot)
            --     AttachmentUtils.link(world, player_unit, new_unit, AttachmentNodeLinking.kruber)
            -- end
            -- attachment_extension:update_resync_loadout()
           
            -- CosmeticUtils.update_cosmetic_slot(player, "slot_skin", item_skin.name)
            -- local cosmetic_table = mod.SKIN_CHANGED[skin].cosmetic_table
            -- if cosmetic_table then 
            --     local cosmetic_extension = ScriptUnit.extension(player_unit, "cosmetic_system")
            --     local attachment_extension = ScriptUnit.extension(player_unit, "attachment_system")

            --     if mod.SKIN_CHANGED[skin].texture then
            --         local material_changes = cosmetic_table.material_changes
            --         if material_changes then 
            --             cosmetic_extension:change_skin_materials(material_changes)
            --         end
            --     else 
            --         attachment_extension:show_attachments(false)
            --         attachment_extension:show_attachments(true)
            --     end
                    
            -- end
            
           
        end
    end
end


--this function checks whether a skin from the vmf menu needs:
--to be given the default unit; depending on the current state of the skin different actions are taken 
--to have it's default unit retextured
--to have it's default skin be given a new unit
function mod.re_apply_illusion(Armoury_key, skin, unit)
    if Armoury_key == "default" and (mod.SKIN_CHANGED[skin].changed_texture or mod.SKIN_CHANGED[skin].changed_model) then
        swap_units_old(mod.current_skin[skin], skin)
        re_equip_weapons(skin, unit)
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
        re_equip_weapons(skin, unit)
        mod.SKIN_CHANGED[skin].changed_texture = true
        mod.has_old_texture = true
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