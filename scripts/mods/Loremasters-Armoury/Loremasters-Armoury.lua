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

mod:command("reset_sub_quests", "", function()

    mod.main_quest.sub_quest_01 = false
    mod.main_quest.sub_quest_02 = false
    mod.main_quest.sub_quest_03 = false
    mod:set("num_shields_collected", 0)
end)




local num_husk = #NetworkLookup.husks
-- local num_interacts = #NetworkLookup.interactions
NetworkLookup.husks[num_husk +1] = "units/shield"
NetworkLookup.husks["units/shield"] = num_husk +1
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
    local unit_template = Managers.state.unit_spawner.unit_template_lut[final_unit_template_name]
    NetworkUnit.add_unit(unit)
    NetworkUnit.set_is_husk_unit(unit, false)
    local go_type = unit_template.go_type
	local go_initializer_function = Managers.state.unit_spawner.gameobject_initializers[go_type]
	local go_init_data = go_initializer_function(unit, unit_name, unit_template, Managers.state.unit_spawner.gameobject_functor_context)
	local go_id = GameSession.create_game_object(Managers.state.unit_spawner.game_session, go_type, go_init_data)

	Managers.state.unit_storage:add_unit_info(unit, go_id, go_type, Managers.state.unit_spawner.own_peer_id)
	Managers.state.entity:sync_unit_extensions(unit, go_id)
end)

-- spawn_local_unit_with_extensions
-- spawn_network_unit


-- local num_husk = #NetworkLookup.husks
-- local num_interacts = #NetworkLookup.interactions
-- NetworkLookup.husks[num_husk +1] = "units/shield"
-- NetworkLookup.husks["units/shield"] = num_husk +1
-- NetworkLookup.interactions["achievement_object"] = num_interacts+1
-- NetworkLookup.interactions[num_interacts + 1] = "achievement_object"

-- local player = Managers.player:local_player()
-- local player_unit = player.player_unit
-- local position = Unit.local_position(player_unit, 0) + Vector3(0, 0, 1)
-- local rotation = Unit.local_rotation(player_unit, 0)
-- local extension_init_data = {}
-- Managers.state.unit_spawner:spawn_local_unit_with_extensions("units/shield", "interaction_unit", extension_init_data, position, rotation)


-- for k,v in pairs(InteractionDefinitions) do 
--     mod:echo(k)
    
-- end