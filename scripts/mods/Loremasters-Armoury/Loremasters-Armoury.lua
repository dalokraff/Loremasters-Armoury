local mod = get_mod("Loremasters-Armoury")
mod:dofile("scripts/mods/Loremasters-Armoury/utils/hooks")
-- mod:dofile("scripts/mods/Loremasters-Armoury/achievements/manager")
mod:dofile("scripts/mods/Loremasters-Armoury/achievements/achievement_object")
-- mod:dofile("scripts/mods/Loremasters-Armoury/achievements/test")
mod:dofile("scripts/mods/Loremasters-Armoury/utils/outliner")
mod:dofile("scripts/mods/Loremasters-Armoury/achievements/LA_message_board")


Managers.package:load("resource_packages/levels/dlcs/morris/slaanesh_common", "global")
Managers.package:load("resource_packages/levels/dlcs/morris/nurgle_common", "global")
Managers.package:load("resource_packages/levels/dlcs/morris/khorne_common", "global")
Managers.package:load("resource_packages/levels/dlcs/morris/tzeentch_common", "global")
Managers.package:load("resource_packages/levels/dlcs/morris/wastes_common", "global")

-- Your mod code goes here.
-- https://vmf-docs.verminti.de


mod:hook_safe(StateIngame,'_setup_state_context', function (self, world, is_server, network_event_delegate)
    Managers.state.achievement = AchievementManager:new(self.world, self.statistics_db)
    mod:echo('inside out')
end)

--thesse tables are used as queues that get filled and flushed as skins and their respective units are changed
mod.level_queue = {}
mod.preview_queue = {}
mod.armory_preview_queue = {}
mod.current_skin = {}


--on mod update:
--the level_queue and previe_queue are checked to see if the respective worlds have any units that need to be retextured
--the SKIN_CHANGED table is updated with info from the vmf menu about which skins are currently being used by which weapons
function mod.update(dt)
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
        if Managers.world:has_world("armory_preview") then
            local world = Managers.world:world("armory_preview")
            local Armoury_key = tisch.Armoury_key
            local skin = tisch.skin
            if Armoury_key ~= "default" and mod.SKIN_LIST[Armoury_key] then
                mod.SKIN_LIST[Armoury_key].swap_skin = skin or mod.SKIN_LIST[Armoury_key].swap_skin
                mod.apply_new_skin_from_texture(Armoury_key, world, skin, unit)
            end
            flush_armory_preview = true
        end
    end

    if flush_level then 
        mod.level_queue = {}
    end
    if flush_preview then 
        mod.preview_queue = {}
    end
    if flush_armory_preview then 
        mod.armory_preview_queue = {}
    end
    
    mod.outliner()

    if mod.letter_board then
        if Unit.alive(mod.letter_board:unit()) then
            local equipped_decoration = Unit.get_data(mod.letter_board:unit(), "current_quest")
            mod.letter_board:change_active_quest(equipped_decoration)
            mod.letter_board:mark_unread_letters()
        end
    end

end


mod:command("spawn_empire_sword", "", function()
    -- Managers.package:load("units/weapons/player/wpn_brw_sword_01_t2/wpn_brw_sword_01_t2_3p", "global")
    -- Managers.package:load("units/weapons/player/wpn_emp_sword_02_t2/wpn_emp_sword_02_t2_3p", "global")
    local player = Managers.player:local_player()
    local player_unit = player.player_unit
    local position = Unit.local_position(player_unit, 0) + Vector3(0,0,1)

    local rotation = Unit.local_rotation(player_unit, 0)
    local box_unit = Managers.state.unit_spawner:spawn_local_unit("units/empire_sword/Kruber_KOTBS_empire_sword_01_mesh_3p", position, rotation)
    -- local box_unit = Managers.state.unit_spawner:spawn_local_unit("units/weapons/player/wpn_brw_sword_01_t2/wpn_brw_sword_01_t2_3p", position+Vector3(0.5,0,0), rotation)
    -- local box_unit = Managers.state.unit_spawner:spawn_local_unit("units/weapons/player/wpn_emp_sword_02_t2/wpn_emp_sword_02_t2_3p", position+Vector3(1,0,0), rotation)
end)


mod.complete = 0

mod:command("increase_count", "", function()

    mod.complete = mod.complete + 1

end)

mod:command("achievement_reset", "", function()

    for k,v in pairs(mod.achievement_list) do 
        mod:set(k, false)
    end

end)

mod:command("complete_sub_quest_01", "", function()

    mod.main_quest.sub_quest_01 = true

end)
mod:command("complete_sub_quest_02", "", function()

    mod.main_quest.sub_quest_02 = true

end)
mod:command("complete_sub_quest_03", "", function()

    mod.main_quest.sub_quest_03 = true

end)

if not mod:get("num_shields_collected") then 
    mod:set("num_shields_collected", 0)
end


if mod:get("sub_quest_prologue") == nil then 
    mod:set("sub_quest_prologue", false)
end

if not mod:get("sub_quest_01") then 
    mod:set("sub_quest_01", 0)
end

if not mod:get("sub_quest_02") then 
    mod:set("sub_quest_02", 0)
end

if mod:get("sub_quest_03") == nil then 
    mod:set("sub_quest_03", false)
end

if mod:get("sub_quest_04") == nil then 
    mod:set("sub_quest_04", false)
end

if mod:get("sub_quest_05") == nil then 
    mod:set("sub_quest_05", false)
end

if mod:get("sub_quest_06") == nil then 
    mod:set("sub_quest_06", false)
end

if mod:get("sub_quest_07") == nil then 
    mod:set("sub_quest_07", false)
end

if mod:get("sub_quest_08") == nil then 
    mod:set("sub_quest_08", false)
end

if mod:get("sub_quest_09") == nil then 
    mod:set("sub_quest_09", false)
end

if mod:get("sub_quest_10") == nil then 
    mod:set("sub_quest_10", false)
end

mod:command("reset_sub_quests", "", function()
    for quest,_ in pairs(mod.main_quest) do
        mod.main_quest[quest] = false
        mod:set(quest.."_letter_read", false)
    end
    mod:set("sub_quest_prologue", false)
    mod:set("sub_quest_01", 0)
    mod:set("sub_quest_02", 0)
    mod:set("sub_quest_03", false)
    mod:set("sub_quest_04", false)
    mod:set("sub_quest_05", false)
    mod:set("sub_quest_06", false)
    mod:set("sub_quest_07", false)
    mod:set("sub_quest_08", false)
    mod:set("sub_quest_09", false)
    mod:set("sub_quest_10", false)
end)

mod:command("complete_sub_quests", "", function()

    for quest,_ in pairs(mod.main_quest) do
        mod.main_quest[quest] = true
    end
    mod:set("sub_quest_01", 500)
    mod:set("sub_quest_02", 500)
    mod:set("sub_quest_03", true)
    mod:set("sub_quest_04", true)
    mod:set("sub_quest_05", true)
    mod:set("sub_quest_06", true)
    mod:set("sub_quest_07", true)
    mod:set("sub_quest_08", true)
    mod:set("sub_quest_09", true)
    mod:set("sub_quest_10", true)
end)

mod:command("complete_sub_quest_06", "", function()
    mod.main_quest["sub_quest_06"] = true
    mod:set("sub_quest_06", true)
end)

mod:command("complete_sub_quest_08", "", function()
    mod.main_quest["sub_quest_08"] = true
    mod:set("sub_quest_08", true)
end)



-- local num_husk = #NetworkLookup.husks
-- -- local num_interacts = #NetworkLookup.interactions
-- NetworkLookup.husks[num_husk +1] = "units/shield"
-- NetworkLookup.husks["units/shield"] = num_husk +1
-- NetworkLookup.interactions["achievement_object"] = num_interacts+1
-- NetworkLookup.interactions[num_interacts + 1] = "achievement_object"

mod:command("object_test_network", "", function()
    
    local player = Managers.player:local_player()
    local player_unit = player.player_unit
    local position = Unit.local_position(player_unit, 0) + Vector3(0, 0, 1)
    local rotation = Unit.local_rotation(player_unit, 0)
    local extension_init_data = {}
    Managers.state.unit_spawner:spawn_network_unit("units/shield", "interaction_unit", extension_init_data, position, rotation)
end)

mod:command("object_test_local", "", function()
    
    local player = Managers.player:local_player()
    local player_unit = player.player_unit
    local position = Unit.local_position(player_unit, 0) + Vector3(0, 0, 1)
    local rotation = Unit.local_rotation(player_unit, 0)
    local extension_init_data = {}
    local unit,final_unit_template_name = Managers.state.unit_spawner:spawn_local_unit_with_extensions("units/shield", "interaction_unit", extension_init_data, position, rotation)
    -- local unit_template = Managers.state.unit_spawner.unit_template_lut[final_unit_template_name]
    -- NetworkUnit.add_unit(unit)
    -- NetworkUnit.set_is_husk_unit(unit, false)
    -- local go_type = unit_template.go_type
	-- local go_initializer_function = Managers.state.unit_spawner.gameobject_initializers[go_type]
	-- local go_init_data = go_initializer_function(unit, unit_name, unit_template, Managers.state.unit_spawner.gameobject_functor_context)
	-- local go_id = GameSession.create_game_object(Managers.state.unit_spawner.game_session, go_type, go_init_data)

	-- Managers.state.unit_storage:add_unit_info(unit, go_id, go_type, Managers.state.unit_spawner.own_peer_id)
	-- Managers.state.entity:sync_unit_extensions(unit, go_id)
end)



Managers.package:load("units/weapons/player/pup_wooden_sword_01/pup_wooden_sword_01", "global")
-- mod.cheevo_unit = "units/weapons/player/pup_wooden_sword_01/pup_wooden_sword_01"
mod.cheevo_units = {
    "units/shield",
    "units/weapons/player/pup_bottle_01/pup_bottle_01",
    "units/weapons/player/pup_scrolls/pup_scroll_t1",
    "units/weapons/player/pup_wooden_sword_01/pup_wooden_sword_01",
    "units/weapons/player/pup_potion/pup_potion_t1",
    "units/weapons/player/pup_oil_jug_01/pup_oil_jug_01",
    "units/weapons/player/pup_lore_page/pup_lore_page_01",
    "units/weapons/player/pup_potion/pup_potion_buff",
    "units/weapons/player/pup_sacks/pup_sacks_01",
	"units/weapons/player/pup_sacks/pup_sacks_01_test",
	"units/weapons/player/pup_sacks/pup_sacks_02",
	"units/weapons/player/pup_sacks/pup_sacks_03",
	"units/weapons/player/pup_sacks/pup_sacks_04",
	"units/weapons/player/pup_sacks/pup_sacks_05",
}
-- local num_husk = #NetworkLookup.husks
for k,v in pairs(mod.cheevo_units) do 
    -- NetworkLookup.husks[num_husk +1] = v
    -- NetworkLookup.husks[v] = num_husk +1
    -- num_husk = num_husk + 1
    mod.cheevo_units[v] = v
end

mod:command("sword_test_network", "", function()
    -- Managers.package:load("units/weapons/player/pup_wooden_sword_01/pup_wooden_sword_01", "global")
    local player = Managers.player:local_player()
    local player_unit = player.player_unit
    local position = Unit.local_position(player_unit, 0) + Vector3(0, 0, 1)
    local rotation = Unit.local_rotation(player_unit, 0)
    local extension_init_data = {}
    Managers.state.unit_spawner:spawn_network_unit("units/shield", "interaction_unit", extension_init_data, position, rotation)
end)


mod:command("sword_test_local", "", function()
    -- Managers.package:load("units/weapons/player/pup_wooden_sword_01/pup_wooden_sword_01", "global")
    local player = Managers.player:local_player()
    local player_unit = player.player_unit
    local position = Unit.local_position(player_unit, 0) + Vector3(0, 0, 1)
    local rotation = Unit.local_rotation(player_unit, 0)
    local extension_init_data = {}
    Managers.state.unit_spawner:spawn_local_unit_with_extensions("units/shield", "interaction_unit", extension_init_data, position, rotation)
end)

mod:command("spawn_crate", "", function()
    -- Managers.package:load("units/weapons/player/pup_wooden_sword_01/pup_wooden_sword_01", "global")
    local player = Managers.player:local_player()
    local player_unit = player.player_unit
    local position = Unit.local_position(player_unit, 0)
    local rotation = Unit.local_rotation(player_unit, 0)
    local box_unit = Managers.state.unit_spawner:spawn_local_unit("units/pickups/Loremaster_shipment_box_mesh_real", position, rotation)
end)


mod:command("spawn_gemstone", "", function()
    -- Managers.package:load("units/weapons/player/pup_wooden_sword_01/pup_wooden_sword_01", "global")
    local player = Managers.player:local_player()
    local player_unit = player.player_unit
    local position = Unit.local_position(player_unit, 0) + Vector3(0, 0, 1.5)
    local rotation = Unit.local_rotation(player_unit, 0)
    local box_unit = Managers.state.unit_spawner:spawn_local_unit("units/pickups/LA_artifact_gemstone_mesh", position, rotation)
end)

mod:command("spawn_chest_with_gemstone", "", function()
    -- Managers.package:load("units/weapons/player/pup_wooden_sword_01/pup_wooden_sword_01", "global")
    local player = Managers.player:local_player()
    local player_unit = player.player_unit
    local position = Unit.local_position(player_unit, 0) + Vector3(0, 0, 1)
    local rotation = Unit.local_rotation(player_unit, 0)
    local box_unit = Managers.state.unit_spawner:spawn_local_unit("units/pickups/LA_artifact_mesh", position, rotation)
end)

mod:command("spawn_book", "", function()
    -- Managers.package:load("units/weapons/player/pup_wooden_sword_01/pup_wooden_sword_01", "global")
    local player = Managers.player:local_player()
    local player_unit = player.player_unit
    local position = Unit.local_position(player_unit, 0) + Vector3(0, 0, 1)
    local rotation = Unit.local_rotation(player_unit, 0)
    local box_unit = Managers.state.unit_spawner:spawn_local_unit("units/pickups/LA_reikland_chronicle_mesh", position, rotation)
end)

-- local player = Managers.player:local_player()
-- local player_unit = player.player_unit
-- local position = Unit.local_position(player_unit, 0) 
-- local rotation = Unit.local_rotation(player_unit, 0)
-- mod:echo(position)
-- mod:echo(rotation)
-- local extension_init_data = {}
-- Managers.state.unit_spawner:spawn_local_unit("units/pickups/LA_MQ01_sub7_chronicle_mesh", position, rotation)
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

-- local player = Managers.player:local_player()
--     local player_unit = player.player_unit
--     local position = Vector3(70.4, -10.4, -0.85)
--     local rot = radians_to_quaternion(0, -3*math.pi/4, 0)
--     local rotation =  Quaternion.multiply(Quaternion.from_elements(0,0,0,1), rot)
--     mod:echo(position)
--     local box_unit = Managers.state.unit_spawner:spawn_local_unit("units/pickups/LA_reikland_chronicle_mesh", position, rotation)

-- local rotation = Quaternion.multiply(Quaternion.from_elements(0, 0, 0, 1), radians_to_quaternion(0, 0, math.pi*1/2))
-- local rotation = Quaternion.multiply(rotation, radians_to_quaternion(math.pi, 0, 0))
-- mod:echo(rotation)
-- Managers.state.network.network_transmit:send_rpc_server(
--                         "rpc_spawn_pickup_with_physics",
--                         NetworkLookup.pickup_names["painting_scrap"],
--                         Vector3(70.4, -10.4, -0.76),
--                         rotation,
--                         NetworkLookup.pickup_spawn_types['dropped']
--                     )

-- mod.attached_units = {}
-- mod:hook(PickupSystem, 'rpc_spawn_pickup_with_physics', function (func, self, channel_id, pickup_name_id, position, rotation, spawn_type_id)
--     local pickup_name = NetworkLookup.pickup_names[pickup_name_id]
--     local level_name = Managers.state.game_mode:level_key()
--     if pickup_name == "painting_scrap" then
--         local pickup_name = NetworkLookup.pickup_names[pickup_name_id]

--         local pickup_settings = AllPickups[pickup_name]
--         local spawn_type = NetworkLookup.pickup_spawn_types[spawn_type_id]
        
--         local scrap_unit, scrap_go_id = self:_spawn_pickup(pickup_settings, pickup_name, position, rotation, true, spawn_type)
--         mod:echo(scrap_go_id)
--         mod:echo(scrap_unit)
--         local box_unit = Managers.state.unit_spawner:spawn_local_unit("units/pickups/LA_MQ01_sub7_chronicle_mesh", position, rotation)
--         local world = Managers.world:world("level_world")
--         local attach_nodes = {
--             {
--                 target = 0,
--                 source = "root_point",
--             },
--         }
--         AttachmentUtils.link(world, scrap_unit, box_unit, attach_nodes)
--         Unit.set_data(box_unit, "unit_marker", scrap_go_id)
--         Unit.set_data(scrap_unit, "is_LA_box", true)
--         -- Unit.set_data(scrap_unit, "level", level_name)
--         Unit.set_unit_visibility(scrap_unit, false)
--         mod.attached_units[scrap_go_id] = {
--             source = scrap_unit, 
--             target = box_unit,
--         }
--         mod:echo(mod.attached_units[scrap_go_id].target)

--         Unit.set_data(scrap_unit, "interaction_data", "hud_description", "LA_crate")

--         return 
--     end

--     return func(self, channel_id, pickup_name_id, position, rotation, spawn_type_id)
-- end)

-- mod:hook(InteractionDefinitions.pickup_object.client, 'stop', function (func, world, interactor_unit, interactable_unit, data, config, t, result)
    
--     if interactable_unit then 
--         local go_id = Managers.state.unit_storage:go_id(interactable_unit)
--         if go_id then
--             mod:echo(go_id)
--             if mod.attached_units[go_id] then 
--                 mod:echo(mod.attached_units[go_id].target)
--                 Managers.state.unit_spawner:mark_for_deletion(mod.attached_units[go_id].target)

--                 local pickup_extension = ScriptUnit.extension(interactable_unit, "pickup_system")
--                 local pickup_settings = pickup_extension:get_pickup_settings()
--                 pickup_settings.pickup_sound_event = "Loremaster_shipment_pickup_sound"
--                 -- LA_crate_pickup
--             end
--         end
--     end
--     return func(world, interactor_unit, interactable_unit, data, config, t, result)
-- end)

-- local position = Vector3(-6.56431, 3.91166, 5.16261)
-- local rotation = Quaternion.from_elements(0, 0, 0.924188, 0.15)
-- local rotation = Quaternion.from_elements(0, 0, 0.924188, 0.381939)
-- local box_unit = Managers.state.unit_spawner:spawn_local_unit("units/pickups/Loremaster_shipment_storage_mesh", position, rotation)


local function radians_to_quaternion(theta, ro, phi)
    local c1 =  math.cos(theta/2)
    local c2 = math.cos(ro/2)
    local c3 = math.cos(phi/2)
    local s1 = math.sin(theta/2)
    local s2 = math.sin(ro/2)
    local s3 = math.sin(phi/2)
    local x = (s1*s2*c3) + (c1*c2*s3)
    local y = (s1*c2*c3) + (c1*s2*s3)
    local z = (c1*s2*c3) - (s1*c2*s3)
    local w = (c1*c2*c3) - (s1*s2*s3)
    local rot = Quaternion.from_elements(x, y, z, w)
    return rot
end


-- local position = Vector3(-6, 4.7, 6.3)
-- local rot = radians_to_quaternion(7*math.pi/18, 10*math.pi/9, -3*math.pi/4)
-- local rotation =  Quaternion.multiply(Quaternion.from_elements(0,0,0,1), rot)
-- local artifact_unit = Managers.state.unit_spawner:spawn_local_unit("units/pickups/LA_reikland_chronicle_mesh", position, rotation)

-- local position = Vector3(-5.9, 4.98, 6.15258)
-- local rot = radians_to_quaternion(7*math.pi/18, 10*math.pi/9, -3*math.pi/4)
-- local rotation =  radians_to_quaternion(0, math.pi, 0)
-- local artifact_unit = Managers.state.unit_spawner:spawn_local_unit("units/pickups/LA_artifact_corrupted_mesh", position, rotation)


-- local num_husk = #NetworkLookup.husks
-- NetworkLookup.husks[num_husk +1] = "units/pickups/LA_reikland_chronicle_mesh"
-- NetworkLookup.husks["units/pickups/LA_reikland_chronicle_mesh"] = num_husk +1
-- NetworkLookup.husks[num_husk +2] = "units/pickups/LA_artifact_corrupted_mesh"
-- NetworkLookup.husks["units/pickups/LA_artifact_corrupted_mesh"] = num_husk +2
-- NetworkLookup.husks[num_husk +3] = "units/pickups/LA_artifact_mesh"
-- NetworkLookup.husks["units/pickups/LA_artifact_mesh"] = num_husk +3




-- mod:hook_safe(GenericUnitInteractableExtension,"set_is_being_interacted_with",function (self, interactor_unit, interaction_result)
--     local unit_name = Unit.get_data(interactable_unit, "unit_name")
--     if unit_name == "units/pickups/LA_reikland_chronicle_mesh" then
--         if mod.unit_is_being_interacted_with then
--             mod.unit_is_being_interacted_with = false 
--             interactor_unit = nil
--         end
--     end
-- end)

-- mod.already_got = {}
-- mod:hook(Unit, "get_data", function(func, self, param, ...)

--     if param == "unit_template" and not mod.already_got[self] then
--         mod.already_got[self] = true
--         mod:echo("==================================")
--         mod:echo(Unit.get_data(self, "unit_template"))
--         mod:echo("==================================")
--     end

--     return func(self, param, ...)
-- end)

-- mod:hook(UnitSpawner, "spawn_local_unit_with_extensions", function(func, self, unit_name, unit_template_name, ...)

--     mod:echo(tostring(unit_name).."     "..tostring(unit_template_name))

--     return func(self, unit_name, unit_template_name, ...)
-- end)

mod.on_game_state_changed = function(status, state_name)
    if state_name == "StateIngame" then
        
        -- local level_name = Managers.state.game_mode:level_key() or "no level"
        local level_name = Managers.level_transition_handler:get_current_level_keys()
        mod:chat_broadcast(level_name)
        -- mod:chat_broadcast(current_level)
        -- mod:echo(level_name)
        if mod.list_of_LA_levels[level_name] then 
            if not mod.list_of_LA_levels[level_name].collected then
                if (level_name == "military" and mod:get("sub_quest_prologue_letter_read")) or (level_name == "catacombs" and mod:get("sub_quest_prologue_letter_read")) or (level_name == "ussingen" and mod:get("sub_quest_prologue_letter_read")) then
                    Managers.state.network.network_transmit:send_rpc_server(
                        "rpc_spawn_pickup_with_physics",
                        NetworkLookup.pickup_names["painting_scrap"],
                        mod.list_of_LA_levels[level_name].position:unbox(),
                        Quaternion.from_elements(0,0,0,0),
                        NetworkLookup.pickup_spawn_types['dropped']
                    )
                end
            end
        end

        if mod.list_of_LA_levels_books[level_name] then
            if not mod.list_of_LA_levels_books[level_name].collected then
                if (level_name == "dlc_bastion")  and mod:get("sub_quest_06_letter_read") then
                    Managers.state.network.network_transmit:send_rpc_server(
                        "rpc_spawn_pickup_with_physics",
                        NetworkLookup.pickup_names["painting_scrap"],
                        mod.list_of_LA_levels_books[level_name].position:unbox(),
                        mod.list_of_LA_levels_books[level_name].rotation:unbox(),
                        NetworkLookup.pickup_spawn_types['dropped']
                    )
                end
            end
        end

        if level_name == "inn_level" then
            
            -- mod.spawn_message_board()

            local board_pos = Vector3(24.17, -5.96, 27.2681)
            local board_rot = Quaternion.from_elements(0,0,0.376287, -0.926503)
            local world = Managers.world:world("level_world")
            local interactable_board_unit_name = "units/decorations/LA_message_board_mesh"
            local visible_board_unit_name = "units/decorations/LA_message_board_back_board"
            local letter_board = LetterBoard:new(interactable_board_unit_name, visible_board_unit_name, board_pos, board_rot, world)
            mod.letter_board = letter_board



            if mod:get("sub_quest_05") then
                local position = Vector3(-6.56431, 3.91166, 5.16261)
                local rotation = Quaternion.from_elements(0, 0, 0.924188, 0.15)
                local box_unit = Managers.state.unit_spawner:spawn_local_unit("units/decorations/Loremaster_shipment_storage_mesh", position, rotation)
            end
            if mod:get("sub_quest_07") then
                local position = Vector3(-6, 4.7, 6.3)
                local rot = radians_to_quaternion(7*math.pi/18, 10*math.pi/9, -3*math.pi/4)
                local rotation =  Quaternion.multiply(Quaternion.from_elements(0,0,0,1), rot)
                -- local artifact_unit = Managers.state.unit_spawner:spawn_local_unit("units/pickups/LA_reikland_chronicle_mesh", position, rotation)
                local extension_init_data = {}
                Managers.state.unit_spawner:spawn_network_unit("units/pickups/LA_reikland_chronicle_mesh", "interaction_unit", extension_init_data, position, rotation)
            end
            if mod:get("sub_quest_08") and not mod:get("sub_quest_09") then
                local position = Vector3(-5.9, 4.96421, 6.15258)
                local rot = radians_to_quaternion(0, math.pi, 0)
                local rotation =  Quaternion.multiply(Quaternion.from_elements(0,0,0,1), rot)
                -- local artifact_unit = Managers.state.unit_spawner:spawn_local_unit("units/pickups/LA_artifact_corrupted_mesh", position, rotation)
                local extension_init_data = {}
                Managers.state.unit_spawner:spawn_network_unit("units/pickups/LA_artifact_corrupted_mesh", "interaction_unit", extension_init_data, position, rotation)
            end
            if mod:get("sub_quest_09") then
                local position = Vector3(-5.9, 4.96421, 6.15258)
                local rot = radians_to_quaternion(0, math.pi, 0)
                local rotation =  Quaternion.multiply(Quaternion.from_elements(0,0,0,1), rot)
                -- local artifact_unit = Managers.state.unit_spawner:spawn_local_unit("units/pickups/LA_artifact_mesh", position, rotation)
                local extension_init_data = {}
                Managers.state.unit_spawner:spawn_network_unit("units/pickups/LA_artifact_mesh", "interaction_unit", extension_init_data, position, rotation)
            end
        end

        if string.find(level_name, "arena_citadel") and mod:get("sub_quest_08") then
            local position = Vector3(0.6, 34.85, 13.56)
            local rotation = Quaternion.from_elements(0,0,0,0)
            local gem_unit = Managers.state.unit_spawner:spawn_local_unit("units/pickups/LA_artifact_gemstone_mesh", position, rotation)
        end

    end
end
-- mod:hook_safe(InteractionDefinitions.pickup_object.client, "stop", function(world, interactor_unit, interactable_unit, data, config, t, result)
--     if interactable_unit then 
--         local go_id = Managers.state.unit_storage:go_id(interactable_unit)
--         if go_id then
--             mod:echo(go_id)
--             if mod.attached_units[go_id] then 
--                 mod:echo(mod.attached_units[go_id].target)
--                 Managers.state.unit_spawner:mark_for_deletion(mod.attached_units[go_id].target)
--             end
--         end
--     end
-- end)

-- local tisch = {}

-- local key_vec = Vector3(0,1,2)
-- tisch[key_vec] = 10
-- mod:echo(key_vec)
-- mod:echo(tisch[key_vec])


-- local player = Managers.player:local_player()
-- local player_unit = player.player_unit
-- local position = Unit.local_position(player_unit, 0) + Vector3(0,0,1)
-- local rotation = Unit.local_rotation(player_unit, 0)

-- local world = Managers.world:world("level_world")
-- local interactable_board_unit_name = "units/decorations/LA_message_board_mesh"
-- local visible_board_unit_name = "units/decorations/LA_message_board_back_board"
-- local board = Managers.state.unit_spawner:spawn_local_unit("units/decorations/letters/LA_quest_message_stage01_visable", position, rotation)

--             local active_quest = "main_01"
--             local active_letters = {}
        
--             for quest,letter_unit_name in pairs(QuestLetters[active_quest]) do
--                 if true then
--                     local interactable_letter_unit = Managers.state.unit_spawner:spawn_network_unit(letter_unit_name, "interaction_unit", extension_init_data, position, rotation)

        
--                     local source_node = string.gsub(quest, "sub_quest", "")
--                     local visable_unit = board 

--                     local nodes = {
--                         {
--                             target = 0,
--                             source = "LA_message_board_nail"..source_node,
--                         },
--                     }
                    
--                     AttachmentUtils.link(world, visable_unit, interactable_letter_unit, nodes)


--                     local visable_letter_unit = Managers.state.unit_spawner:spawn_local_unit(letter_unit_name.."_visable", position, rotation)
        
--                     local root2root = {
--                         {
--                             target = 0,
--                             source = 0,
--                         },
--                     }
        
--                     AttachmentUtils.link(world, interactable_letter_unit, visable_letter_unit, root2root)
        
--                     active_letters[quest] = {
--                         interactable = interactable_letter_unit,
--                         visable = visable_letter_unit,
--                     }


--                     -- Unit.set_local_position(visable_letter_unit, 0, Vector3(0,0,1))
        
--                 end
--             end

-- local visable_letter_unit = Managers.state.unit_spawner:spawn_local_unit("units/decorations/letters/LA_quest_message_stage01".."_visable", position, rotation)
-- mod:echo(position)
-- mod:echo(rotation)

-- [MOD][ExecLua][ECHO] Vector3(172.06, 255.759, -13.775)
-- [MOD][ExecLua][ECHO] Vector4(0, 0, -0.484305, -0.874899)

-- Managers.state.game_mode:start_specific_level("arena_citadel_slaanesh_path1")
-- local level_name = Managers.state.game_mode:level_key()
-- mod:echo(level_name)
-- -- military

-- local player = Managers.player:local_player()
-- local player_unit = player.player_unit
-- -- local position = Unit.local_position(player_unit, 0) + Vector3(0,0,1)
-- -- local position = Vector3(27.0182, -9.92629, 27.1653)
-- local rotation = Quaternion.from_elements(0,0,0,0)
-- local extension_init_data = {}
-- Managers.state.unit_spawner:spawn_network_unit("units/pickups/LA_artifact_corrupted_mesh", "interaction_unit", extension_init_data, position, rotation)
-- mod:echo(position)
-- local box_unit = Managers.state.unit_spawner:spawn_local_unit("units/pickups/LA_MQ01_sub7_chronicle_mesh", position, rotation)
-- local extension_init_data = {}
-- Managers.state.unit_spawner:spawn_network_unit("units/pickups/LA_reikland_chronicle_mesh", "interaction_unit", extension_init_data, position, rotation)

-- -- mod:echo(string.find("arena_citadel_slaanesh_path1", "arena_citadel2"))


-- local top_world = Managers.world:world("top_ingame_view")
-- local mod_gui = World.create_screen_gui(top_world, "immediate",
-- "material", "materials/Loremasters-Armoury/LA_waypoint_main_icon"
-- )

-- Gui.bitmap(mod_gui, "LA_waypoint_main_icon", Vector2(600, 600), Vector2(100, 100))

-- mod:hook(MatchmakingManager, "update", function(func, self, dt, ...)
    
--     local top_world = Managers.world:world("top_ingame_view")
--     local mod_gui = World.create_screen_gui(top_world, "immediate",
--     "material", "materials/Loremasters-Armoury/LA_waypoint_main_icon"
--     )

--     Gui.bitmap(mod_gui, "LA_waypoint_main_icon", Vector2(600, 600), Vector2(100, 100))

-- 	func(self, dt, ...)
-- end)


-- local player = Managers.player:local_player()
-- local player_unit = player.player_unit
-- -- local position = Unit.local_position(player_unit, 0) + Vector3(0,0,1)
-- local position = Vector3(24.17, -5.96, 27.2681)
-- local rotation = Quaternion.from_elements(0,0,0.376287, -0.926503)
-- -- local rotation = Unit.local_rotation(player_unit, 0)
-- mod:echo(position)
-- mod:echo(rotation)
-- local box_unit = Managers.state.unit_spawner:spawn_local_unit("units/decorations/LA_message_board_mesh", position, rotation)


-- Vector3(24.7861, -6.24515, 27.2681)
-- Vector4(0, 0, 0.376287, -0.926503)




-- local player = Managers.player:local_player()
-- local player_unit = player.player_unit
-- local position = Unit.local_position(player_unit, 0) + Vector3(0,0,1)

-- local rotation = Unit.local_rotation(player_unit, 0)
-- local box_unit = Managers.state.unit_spawner:spawn_local_unit("units/props/khorne/deus_khorne_torch_01", position, rotation)


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
