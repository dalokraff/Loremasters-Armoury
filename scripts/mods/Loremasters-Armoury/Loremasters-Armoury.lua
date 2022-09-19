local mod = get_mod("Loremasters-Armoury")
mod:dofile("scripts/mods/Loremasters-Armoury/utils/hooks")
mod:dofile("scripts/mods/Loremasters-Armoury/achievements/manager")
mod:dofile("scripts/mods/Loremasters-Armoury/achievements/achievement_object")

-- Your mod code goes here.
-- https://vmf-docs.verminti.de


mod:hook_safe(StateIngame,'_setup_state_context', function (self, world, is_server, network_event_delegate)
    Managers.state.achievement = AchievementManager:new(self.world, self.statistics_db)
    mod:echo('inside out')
end)

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

if not mod:get("sub_quest_one_kills") then 
    mod:set("sub_quest_one_kills", 0)
end

if not mod:get("sub_quest_two_kills") then 
    mod:set("sub_quest_two_kills", 0)
end

if mod:get("sub_quest_three_found") == nil then 
    mod:set("sub_quest_three_found", false)
end

if mod:get("sub_quest_four_found") == nil then 
    mod:set("sub_quest_four_found", false)
end

if mod:get("sub_quest_five_found") == nil then 
    mod:set("sub_quest_five_found", false)
end

if mod:get("sub_quest_06_completed") == nil then 
    mod:set("sub_quest_06_completed", false)
end

if mod:get("sub_quest_07_interacted") == nil then 
    mod:set("sub_quest_07_interacted", false)
end

if mod:get("sub_quest_08_kill_n_collect") == nil then 
    mod:set("sub_quest_08_kill_n_collect", false)
end

if mod:get("sub_quest_09_pillgrimage") == nil then 
    mod:set("sub_quest_09_pillgrimage", false)
end

if mod:get("sub_quest_10_pray") == nil then 
    mod:set("sub_quest_10_pray", false)
end

mod:command("reset_sub_quests", "", function()
    for quest,_ in pairs(mod.main_quest) do
        mod.main_quest[quest] = false
    end
    mod:set("sub_quest_one_kills", 0)
    mod:set("sub_quest_two_kills", 0)
    mod:set("sub_quest_three_found", false)
    mod:set("sub_quest_four_found", false)
    mod:set("sub_quest_five_found", false)
    mod:set("sub_quest_06_completed", false)
    mod:set("sub_quest_07_interacted", false)
    mod:set("sub_quest_08_kill_n_collect", false)
    mod:set("sub_quest_09_pillgrimage", false)
    mod:set("sub_quest_10_pray", false)
end)

mod:command("complete_sub_quests", "", function()

    for quest,_ in pairs(mod.main_quest) do
        mod.main_quest[quest] = true
    end
    mod:set("sub_quest_one_kills", 500)
    mod:set("sub_quest_two_kills", 500)
    mod:set("sub_quest_three_found", true)
    mod:set("sub_quest_four_found", true)
    mod:set("sub_quest_five_found", true)
    mod:set("sub_quest_06_completed", true)
    mod:set("sub_quest_07_interacted", true)
    mod:set("sub_quest_08_kill_n_collect", true)
    mod:set("sub_quest_09_pillgrimage", true)
    mod:set("sub_quest_10_pray", true)
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

-- local player = Managers.player:local_player()
-- local player_unit = player.player_unit
-- local position = Unit.local_position(player_unit, 0) + Vector3(0, 0, 1)
-- local rotation = Unit.local_rotation(player_unit, 0)
-- local extension_init_data = {}
-- Managers.state.unit_spawner:spawn_local_unit("units/pickups/Loremaster_shipment_box_mesh_real", position, rotation)

-- local position = Vector3(-6.56431, 3.91166, 5.16261)
-- local rotation = Quaternion.from_elements(0, 0, 0.924188, 0.15)
-- local rotation = Quaternion.from_elements(0, 0, 0.924188, 0.381939)
-- local box_unit = Managers.state.unit_spawner:spawn_local_unit("units/pickups/Loremaster_shipment_storage_mesh", position, rotation)

mod.on_game_state_changed = function(status, state_name)
    if status == "enter" and state_name == "StateIngame" then
        mod:chat_broadcast("Attention everyone, we are now entering the Rat Zone.")
        local level_name = Managers.state.game_mode:level_key()
        -- mod:echo(level_name)
        if mod.list_of_LA_levels[level_name] then 
            Managers.state.network.network_transmit:send_rpc_server(
                "rpc_spawn_pickup_with_physics",
                NetworkLookup.pickup_names["painting_scrap"],
                mod.list_of_LA_levels[level_name].position:unbox(),
                Quaternion.from_elements(0,0,0,0),
                NetworkLookup.pickup_spawn_types['dropped']
            )
        end

        if level_name == "inn_level" then
            local position = Vector3(-6.56431, 3.91166, 5.16261)
            local rotation = Quaternion.from_elements(0, 0, 0.924188, 0.15)
            local box_unit = Managers.state.unit_spawner:spawn_local_unit("units/pickups/Loremaster_shipment_storage_mesh", position, rotation)
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
-- local position = Unit.local_position(player_unit, 0)
-- local rotation = Unit.local_rotation(player_unit, 0)
-- mod:echo(position)
-- mod:echo(rotation)

-- [MOD][ExecLua][ECHO] Vector3(172.06, 255.759, -13.775)
-- [MOD][ExecLua][ECHO] Vector4(0, 0, -0.484305, -0.874899)

-- local level_name = Managers.state.game_mode:level_key()
-- mod:echo(level_name)
-- military