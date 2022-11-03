local mod = get_mod("Loremasters-Armoury")
local level_quest_table = require("scripts/mods/Loremasters-Armoury/achievements/pickup_maps")
local rpc_table = {
    rpc_generic_interaction_request = function(self_2, channel_id, interactor_go_id, interactable_go_id, interaction_type_id)
        local interactable_unit = Managers.state.unit_storage:unit(channel_id)
        if interactable_unit then
            local unit_name = Unit.get_data(interactable_unit, "unit_name")

            if mod.LA_new_interactors[unit_name] then
                local interactor_unit = Managers.state.unit_storage:unit(self_2)
                local interactor_extension = ScriptUnit.extension(interactor_unit, "interactor_system")
                local interaction_type = NetworkLookup.interactions[interactable_go_id]
                local interactable_extension = ScriptUnit.extension(interactable_unit, "interactable_system")

                interactor_extension:interaction_denied()

                if interaction_type == "sword_enchantment" then
                    if interactable_unit then
                        local world = Managers.world:world("level_world")
                        mod:set("sub_quest_10", true)
                        mod.sword_ritual = SwordEnchantment:new(world)
                        mod.scroll_unit = nil
                        return true
                    end
                end
                
                if interaction_type == "la_pickup" then   
                    
                    local sound = Unit.get_data(interactable_unit, "interaction_data", "pickup_sound")
                    if sound then
                        local world = Managers.world:world("level_world")
                        local wwise_world = Wwise.wwise_world(world)
                        WwiseWorld.trigger_event(wwise_world, sound)  
                    end
                    local la_pickup_ext = LA_PICKUPS[interactable_unit]
                    if la_pickup_ext then
                        la_pickup_ext:destroy()
                    end

                    local level_name = Managers.state.game_mode:level_key()
                    local quest = level_quest_table[level_name]
                    if quest then
                        mod:set(quest.."_temp", true)
                    end
                    
                    return true
                end

                if Unit.has_data(interactable_unit, "unit_name") then
                    local unit_name = Unit.get_data(interactable_unit, "unit_name")
                    if mod.LA_new_interactors[unit_name] then
                        Managers.ui:handle_transition("hero_view_force", {
                            type = "painting",
                            menu_state_name = "keep_decorations",
                            use_fade = true,
                            interactable_unit = interactable_unit
                        })
                        if Unit.has_data(interactable_unit, "quest") then
                            local quest = Unit.get_data(interactable_unit, "quest")
                            mod:set(quest.."_letter_read", true)
                        end
                        return true
                    end
                end

                return true
            end
        end       

        return false
    end,

    rpc_spawn_pickup_with_physics = function(pickup_name_id, position, rotation, spawn_type_id)

        local pickup_name = NetworkLookup.pickup_names[pickup_name_id]
        local level_name = Managers.state.game_mode:level_key()
        local entity_manager = Managers.state.entity

        if mod.list_of_LA_levels[level_name] then
            local LA_position = mod.list_of_LA_levels[level_name].position
            
            if Vector3.equal(position, LA_position:unbox()) then
               
                if pickup_name == "painting_scrap" then
                    local pickup_name = NetworkLookup.pickup_names[pickup_name_id]
    
                    local pickup_settings = AllPickups[pickup_name]
                    local spawn_type = NetworkLookup.pickup_spawn_types[spawn_type_id]
                    
                    local scrap_unit, scrap_go_id = entity_manager:system("pickup_system"):_spawn_pickup(pickup_settings, pickup_name, position, rotation, true, spawn_type)
                    
                    local box_unit = Managers.state.unit_spawner:spawn_local_unit("units/pickups/Loremaster_shipment_box_mesh_real", position, rotation)
                    local world = Managers.world:world("level_world")
                    local attach_nodes = {
                        {
                            target = 0,
                            source = 0,
                        },
                    }
                    AttachmentUtils.link(world, scrap_unit, box_unit, attach_nodes)
                    Unit.set_data(box_unit, "unit_marker", scrap_go_id)
                    Unit.set_data(scrap_unit, "is_LA_box", true)
                    Unit.set_unit_visibility(scrap_unit, false)
                    mod.attached_units[scrap_go_id] = {
                        source = scrap_unit, 
                        target = box_unit,
                    }
                    
    
                    Unit.set_data(scrap_unit, "interaction_data", "hud_description", "LA_crate")
                    Unit.set_data(scrap_unit, "pickup_message", "LA_crate_pickup")
                    Unit.set_data(scrap_unit, "pickup_sound", "Loremaster_shipment_pickup_sound")
    
                    return true
                end
            end
        end
        
        --for spawning the book pickup
        if mod.list_of_LA_levels_books[level_name] then
            local LA_position = mod.list_of_LA_levels_books[level_name].position
            
            if Vector3.equal(position, LA_position:unbox()) then
                
                if pickup_name == "painting_scrap" then
                    local pickup_name = NetworkLookup.pickup_names[pickup_name_id]
    
                    local pickup_settings = AllPickups[pickup_name]
                    local spawn_type = NetworkLookup.pickup_spawn_types[spawn_type_id]
                    local scrap_unit, scrap_go_id = entity_manager:system("pickup_system"):_spawn_pickup(pickup_settings, pickup_name, position, rotation, true, spawn_type)
                    
                    local box_unit = Managers.state.unit_spawner:spawn_local_unit("units/pickups/LA_reikland_chronicle_mesh", position, rotation)
                    local world = Managers.world:world("level_world")
                    local attach_nodes = {
                        {
                            target = 0,
                            source = 0,
                        },
                    }
                    AttachmentUtils.link(world, scrap_unit, box_unit, attach_nodes)
                    Unit.set_data(box_unit, "unit_marker", scrap_go_id)
                    Unit.set_data(scrap_unit, "is_LA_box", true)
                    Unit.set_unit_visibility(scrap_unit, false)
                    mod.attached_units[scrap_go_id] = {
                        source = scrap_unit, 
                        target = box_unit,
                    }
                    
                    Unit.set_data(scrap_unit, "interaction_data", "hud_description", "reikbuch")
                    Unit.set_data(scrap_unit, "pickup_message", "LA_reikbuch_pickup")
                    Unit.set_data(scrap_unit, "pickup_sound", "Loremaster_book_pickup_sound__1_")
    
                    return true
                end
            end
        end
    
        --for spawning the gem pickup
        if mod.stored_vectors[level_name] then
            if Vector3.equal(position, mod.stored_vectors[level_name]:unbox()) then
                if pickup_name == "painting_scrap" then
                    local pickup_name = NetworkLookup.pickup_names[pickup_name_id]
    
                    local pickup_settings = AllPickups[pickup_name]
                    local spawn_type = NetworkLookup.pickup_spawn_types[spawn_type_id]
                    local scrap_unit, scrap_go_id = entity_manager:system("pickup_system"):_spawn_pickup(pickup_settings, pickup_name, position, rotation, true, spawn_type)

                    local box_unit = Managers.state.unit_spawner:spawn_local_unit("units/pickups/LA_artifact_corrupted_mesh", position, rotation)
                    local world = Managers.world:world("level_world")
                    local attach_nodes = {
                        {
                            target = 0,
                            source = 0,
                        },
                    }
                    AttachmentUtils.link(world, scrap_unit, box_unit, attach_nodes)
                    Unit.set_data(box_unit, "unit_marker", scrap_go_id)
                    Unit.set_data(scrap_unit, "is_LA_box", true)
                    Unit.set_unit_visibility(scrap_unit, false)
                    mod.attached_units[scrap_go_id] = {
                        source = scrap_unit, 
                        target = box_unit,
                    }
    
                    Unit.set_data(scrap_unit, "interaction_data", "hud_description", "magic_gem_nurgle")
                    Unit.set_data(scrap_unit, "pickup_message", "LA_magic_gem_pickup")
                    Unit.set_data(scrap_unit, "pickup_sound", "Loremaster_Corrupted_Artifact_pickup_sound")
    
                    return true
                end
            end
        end

        return false
    end, 
}

return rpc_table