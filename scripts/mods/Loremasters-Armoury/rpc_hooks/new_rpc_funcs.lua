local mod = get_mod("Loremasters-Armoury")

local rpc_table = {
    rpc_generic_interaction_request = function(self_2, channel_id, interactor_go_id, interactable_go_id, interaction_type_id)
        -- mod:echo("=========================")
        -- mod:echo(rpc_name)
        -- mod:echo(self_2)
        -- mod:echo(channel_id)
        -- mod:echo(interactor_go_id)
        -- mod:echo(interactable_go_id)
        -- mod:echo(interaction_type_id)
        -- mod:echo(channel_id)
        -- mod:echo(interactor_go_id)
        -- mod:echo(interactable_go_id)
        -- mod:echo(is_level_unit)
        -- mod:echo(interaction_type_id)
        local interactable_unit = Managers.state.unit_storage:unit(channel_id)
        -- mod:echo(tostring(interactable_unit).."     "..tostring(Unit.get_data(interactable_unit, "unit_name")))

        local unit_name = Unit.get_data(interactable_unit, "unit_name")

        if mod.LA_new_interactors[unit_name] then
            local interactor_unit = Managers.state.unit_storage:unit(self_2)
            -- mod:echo(tostring(interactor_unit).."     "..tostring(Unit.get_data(interactor_unit, "unit_name")))
            local interactor_extension = ScriptUnit.extension(interactor_unit, "interactor_system")
            local interaction_type = NetworkLookup.interactions[interactable_go_id]
            -- interactor_extension:interaction_approved(interaction_type, interactable_unit)

            local interactable_extension = ScriptUnit.extension(interactable_unit, "interactable_system")
            -- interactable_extension:set_is_being_interacted_with(interactor_unit)

            interactor_extension:interaction_denied()

            if interaction_type == "sword_enchantment" then
                if interactable_unit then
                    local world = Managers.world:world("level_world")
                    mod:set("sub_quest_10", true)
                    mod.sword_ritual = SwordEnchantment:new(world)
                    return true
                end
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
                    
                    return true
                end
            end
            return true
        end

        return false
    end,

    rpc_spawn_pickup_with_physics = function(pickup_name_id, position, rotation, spawn_type_id)


        -- mod:echo(pickup_name_id)
        -- mod:echo(position)
        -- mod:echo(rotation)
        -- mod:echo(spawn_type_id)


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



-- local player = Managers.player:local_player()
-- local player_unit = player.player_unit
-- local position = Unit.local_position(player_unit, 0)
-- mod:echo(position)
-- Vector3(4.05782, -9.37817, -2.09167)

-- Vector3(5.4675, -9.22365, -2.13532)

-- local function radians_to_quaternion(theta, ro, phi)
--     local c1 =  math.cos(theta/2)
--     local c2 = math.cos(ro/2)
--     local c3 = math.cos(phi/2)
--     local s1 = math.sin(theta/2)
--     local s2 = math.sin(ro/2)
--     local s3 = math.sin(phi/2)
--     local x = (s1*s2*c3) + (c1*c2*s3)
--     local y = (s1*c2*c3) + (c1*s2*s3)
--     local z = (c1*s2*c3) - (s1*c2*s3)
--     local w = (c1*c2*c3) - (s1*s2*s3)
--     local rot = Quaternion.from_elements(x, y, z, w)
--     return rot
-- end

-- local position = Vector3(5.2, -9, -2.15)
-- local rotation = Quaternion.from_elements(0,0,0,0)
-- local box_unit = Managers.state.unit_spawner:spawn_local_unit("units/pickups/LA_artifact_gemstone_mesh", position, rotation)

-- local position = Vector3(4.32, -9.075, -1.8)
-- local rotation = radians_to_quaternion(math.pi*11/10, -math.pi*3/12, math.pi*1/12)
-- local box_unit = Managers.state.unit_spawner:spawn_local_unit("units/empire_sword/Kruber_KOTBS_empire_sword_01_mesh_3p", position, rotation)


-- local player = Managers.player:local_player()
-- local player_unit = player.player_unit
-- local position = Unit.local_position(player_unit, 0)
-- mod:echo(position)
-- local rotation = radians_to_quaternion(0, 0, 0)
-- local box_unit = Managers.state.unit_spawner:spawn_local_unit("units/pickups/Loremaster_shipment_box_mesh_real", position, rotation)







-- local function radians_to_quaternion(theta, ro, phi)
--     local c1 =  math.cos(theta/2)
--     local c2 = math.cos(ro/2)
--     local c3 = math.cos(phi/2)
--     local s1 = math.sin(theta/2)
--     local s2 = math.sin(ro/2)
--     local s3 = math.sin(phi/2)
--     local x = (s1*s2*c3) + (c1*c2*s3)
--     local y = (s1*c2*c3) + (c1*s2*s3)
--     local z = (c1*s2*c3) - (s1*c2*s3)
--     local w = (c1*c2*c3) - (s1*s2*s3)
--     local rot = Quaternion.from_elements(x, y, z, w)
--     return rot
-- end


-- local position = Vector3(1.8, 9.76, 7)
-- local rotation = radians_to_quaternion(math.pi,0,0)
-- Managers.state.unit_spawner:spawn_local_unit("units/empire_sword/Kruber_KOTBS_empire_sword_01_mesh_3p", position, rotation)

-- local position = Vector3(0.8, 7.7, 5.17543)
-- local rotation = radians_to_quaternion(0,math.pi/8,0)
-- local box_unit = Managers.state.unit_spawner:spawn_local_unit("units/decorations/Loremaster_shipment_storage_mesh", position, rotation)

-- local diff = Vector3(0.8, 7.7, 5.17543) - Vector3(-6.56431, 3.91166, 5.16261)

-- -- Vector3(-6, 4.61, 6.28)
-- mod:echo(Vector3(-6, 4.61, 6.28)+diff)

-- local rotation = radians_to_quaternion(math.pi/2,-math.pi/12,math.pi/2)
-- local box_unit = Managers.state.unit_spawner:spawn_local_unit("units/pickups/LA_reikland_chronicle_mesh", Vector3(1, 6.835, 6.29282), rotation)

-- -- Vector3(-5.9, 4.96421, 6.15258)
-- mod:echo(Vector3(-5.9, 4.96421, 6.15258)+diff)
-- local rotation = radians_to_quaternion(0,math.pi/8,0)
-- local box_unit = Managers.state.unit_spawner:spawn_local_unit("units/pickups/LA_artifact_mesh", Vector3(1.3, 6.5, 6.1654), rotation)





-- local player = Managers.player:local_player()
-- local player_unit = player.player_unit
-- local position = Vector3(-7.1, 0.125946, -3.75)
-- local rotation = Quaternion.from_elements(0, 0, 0.99738, 0.07234)
-- local rot = radians_to_quaternion(0, math.pi/42, 0)
-- local rotation1 =  Quaternion.multiply(rotation, rot)
-- mod:echo(position)
-- mod:echo(rotation1)
-- local world = Managers.world:world("level_world")
-- local interactable_board_unit_name = "units/decorations/LA_message_board_mesh"
-- local visible_board_unit_name = "units/decorations/LA_message_board_back_board"
-- local letter_board = LetterBoard:new(interactable_board_unit_name, visible_board_unit_name, position, rotation1, world)





-- local player = Managers.player:local_player()
-- local player_unit = player.player_unit
-- local position = Unit.local_position(player_unit, 0) + Vector3(0,0,1)
-- local rotation = Quaternion.from_elements(0, 0, 0, 0)
-- local box_unit = Managers.state.unit_spawner:spawn_local_unit("units/props/candles/prop_candle_02", position, rotation)
-- Unit.set_local_scale(box_unit, 1, Vector3(0.0001, 0.0001, 0.0001))

-- "units/props/lanterns/lantern_01/prop_lantern_01"

-- Managers.package:load("resource_packages/levels/honduras/fort_common", "global")
-- local function is_available(type, name)
-- 	printf("%s.%s : available? => %s", name, type, Application.can_get(type, name))
-- end
-- is_available("unit", "units/props/lanterns/lantern_02/prop_lantern_02")
-- resource_packages/props/lanterns
