local mod = get_mod("Loremasters-Armoury")
mod:dofile("scripts/mods/Loremasters-Armoury/utils/hooks")

-- Your mod code goes here.
-- https://vmf-docs.verminti.de

--thesse tables are used as queues that get filled and flushed as skins and their respective units are changed
mod.level_queue = {}
mod.preview_queue = {}
mod.current_skin = {}


--on mod update:
--the level_queue and previe_queue are checked to see if the respective worlds have any units that need to be retextured
--the SKIN_CHANGED table is updated with info from the vmf menu about which skins are currently being used by which weapons
function mod.update()
    local flush_preview = false
    local flush_level = false

    for skin,tisch in pairs(mod.SKIN_CHANGED) do
        if Managers.world:has_world("level_world") then
            local Armoury_key = mod:get(skin)
            mod.re_apply_illusion(Armoury_key, skin, tisch.unit)
        end
    end
    for unit,tisch in pairs(mod.level_queue) do
        if Managers.world:has_world("level_world") then
            local world = Managers.world:world("level_world")
            local Armoury_key = tisch.Armoury_key
            local skin = tisch.skin
            mod.SKIN_LIST[Armoury_key].swap_skin = skin or mod.SKIN_LIST[Armoury_key].swap_skin
            mod.apply_new_skin_from_texture(Armoury_key, world, skin, unit)
            flush_level = true
        end  
    end
    for unit,tisch in pairs(mod.preview_queue) do
        if Managers.world:has_world("character_preview") then
            local world = Managers.world:world("character_preview")
            local Armoury_key = tisch.Armoury_key
            local skin = tisch.skin
            if Armoury_key ~= "default" and mod.SKIN_LIST[Armoury_key] then
                mod.SKIN_LIST[Armoury_key].swap_skin = skin or mod.SKIN_LIST[Armoury_key].swap_skin
                mod.apply_new_skin_from_texture(Armoury_key, world, skin, unit)
            end
            flush_preview = true
        end
    end

    if flush_level then 
        mod.level_queue = {}
    end
    if flush_preview then 
        mod.preview_queue = {}
    end
    
    
end

mod.old_swap_unit = {}
mod.new_swap_unit = "units/empire_sword/Kruber_KOTBS_empire_sword_01_mesh"
mod:command("swap_sword", "", function()
	
    for _,skin in pairs(mod.empire_sword_shield) do
        
        if WeaponSkins.skins[skin]["right_hand_unit"] == mod.new_swap_unit then
            WeaponSkins.skins[skin]["right_hand_unit"] = mod.old_swap_unit[skin]
        else 
            mod.old_swap_unit[skin] = WeaponSkins.skins[skin]["right_hand_unit"]
            WeaponSkins.skins[skin]["right_hand_unit"] = mod.new_swap_unit
        end

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

                if item_one.skin == skin or item_two.skin == skin then
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
    

end)