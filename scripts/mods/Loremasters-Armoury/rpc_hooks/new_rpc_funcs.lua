local mod = get_mod("Loremasters-Armoury")

local rpc_table = {
    rpc_generic_interaction_request = function(self_2, channel_id, interactor_go_id, interactable_go_id, interaction_type_id)
        mod:echo("=========================")
        -- mod:echo(rpc_name)
        mod:echo(self_2)
        mod:echo(channel_id)
        mod:echo(interactor_go_id)
        mod:echo(interactable_go_id)
        mod:echo(interaction_type_id)
        -- mod:echo(channel_id)
        -- mod:echo(interactor_go_id)
        -- mod:echo(interactable_go_id)
        -- mod:echo(is_level_unit)
        -- mod:echo(interaction_type_id)
        local interactable_unit = Managers.state.unit_storage:unit(channel_id)
        mod:echo(tostring(interactable_unit).."     "..tostring(Unit.get_data(interactable_unit, "unit_name")))
        

        local unit_name = Unit.get_data(interactable_unit, "unit_name")

        if mod.LA_new_interactors[unit_name] then
            local interactor_unit = Managers.state.unit_storage:unit(self_2)
            mod:echo(tostring(interactor_unit).."     "..tostring(Unit.get_data(interactor_unit, "unit_name")))
            local interactor_extension = ScriptUnit.extension(interactor_unit, "interactor_system")
            local interaction_type = NetworkLookup.interactions[interactable_go_id]
            -- interactor_extension:interaction_approved(interaction_type, interactable_unit)

            local interactable_extension = ScriptUnit.extension(interactable_unit, "interactable_system")
            -- interactable_extension:set_is_being_interacted_with(interactor_unit)

            interactor_extension:interaction_denied()
            if Unit.has_data(interactable_unit, "unit_name") then
                local unit_name = Unit.get_data(interactable_unit, "unit_name")
                if mod.LA_new_interactors[unit_name] then
                    Managers.ui:handle_transition("hero_view_force", {
                        type = "painting",
                        menu_state_name = "keep_decorations",
                        use_fade = true,
                        interactable_unit = interactable_unit
                    })
                    
                    return true
                end
            end
            return true
        end

        return false
    end,

    rpc_spawn_pickup_with_physics = function(pickup_name_id, position, rotation, spawn_type_id)


        mod:echo(pickup_name_id)
        mod:echo(position)
        mod:echo(rotation)
        mod:echo(spawn_type_id)


        local pickup_name = NetworkLookup.pickup_names[pickup_name_id]
        local level_name = Managers.state.game_mode:level_key()
        local entity_manager = Managers.state.entity

        if mod.list_of_LA_levels[level_name] then
            local LA_position = mod.list_of_LA_levels[level_name].position
            -- mod:echo(LA_position:unbox())
            -- mod:echo(position)
            if Vector3.equal(position, LA_position:unbox()) then
                -- mod:echo(pickup_name)
                if pickup_name == "painting_scrap" then
                    local pickup_name = NetworkLookup.pickup_names[pickup_name_id]
    
                    local pickup_settings = AllPickups[pickup_name]
                    local spawn_type = NetworkLookup.pickup_spawn_types[spawn_type_id]
                    
                    local scrap_unit, scrap_go_id = entity_manager:system("pickup_system"):_spawn_pickup(pickup_settings, pickup_name, position, rotation, true, spawn_type)
                    -- mod:echo(scrap_go_id)
                    -- mod:echo(scrap_unit)
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
                    -- mod:echo(mod.attached_units[scrap_go_id].target)
    
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
            -- mod:echo(LA_position:unbox())
            -- mod:echo(position)
            if Vector3.equal(position, LA_position:unbox()) then
                -- mod:echo(pickup_name)
                if pickup_name == "painting_scrap" then
                    local pickup_name = NetworkLookup.pickup_names[pickup_name_id]
    
                    local pickup_settings = AllPickups[pickup_name]
                    local spawn_type = NetworkLookup.pickup_spawn_types[spawn_type_id]
                    local scrap_unit, scrap_go_id = entity_manager:system("pickup_system"):_spawn_pickup(pickup_settings, pickup_name, position, rotation, true, spawn_type)
                    -- mod:echo(scrap_go_id)
                    -- mod:echo(scrap_unit)
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
                    -- Unit.set_data(scrap_unit, "level", level_name)
                    Unit.set_unit_visibility(scrap_unit, false)
                    mod.attached_units[scrap_go_id] = {
                        source = scrap_unit, 
                        target = box_unit,
                    }
                    -- mod:echo(mod.attached_units[scrap_go_id].target)
                    Unit.set_data(scrap_unit, "interaction_data", "hud_description", "reikbuch")
                    Unit.set_data(scrap_unit, "pickup_message", "LA_reikbuch_pickup")
                    Unit.set_data(scrap_unit, "pickup_sound", "Loremaster_book_pickup_sound__1_")
    
                    return true
                end
            end
        end
    
        --for spawning the gem pickup
        -- mod:echo(Vector3Box(position))
        -- mod:echo(mod.stored_vectors[Vector3Box(position)])
        if mod.stored_vectors[level_name] then
            if Vector3.equal(position, mod.stored_vectors[level_name]:unbox()) then
                -- mod:echo(pickup_name)
                if pickup_name == "painting_scrap" then
                    local pickup_name = NetworkLookup.pickup_names[pickup_name_id]
    
                    local pickup_settings = AllPickups[pickup_name]
                    local spawn_type = NetworkLookup.pickup_spawn_types[spawn_type_id]
                    local scrap_unit, scrap_go_id = entity_manager:system("pickup_system"):_spawn_pickup(pickup_settings, pickup_name, position, rotation, true, spawn_type)
                    -- mod:echo(scrap_go_id)
                    -- mod:echo(scrap_unit)
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
                    -- Unit.set_data(scrap_unit, "level", level_name)
                    Unit.set_unit_visibility(scrap_unit, false)
                    mod.attached_units[scrap_go_id] = {
                        source = scrap_unit, 
                        target = box_unit,
                    }
                    -- mod:echo(mod.attached_units[scrap_go_id].target)
    
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