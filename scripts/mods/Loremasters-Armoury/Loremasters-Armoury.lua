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
local num_husk = #NetworkLookup.husks
for k,v in pairs(mod.cheevo_units) do 
    NetworkLookup.husks[num_husk +1] = v
    NetworkLookup.husks[v] = num_husk +1
    num_husk = num_husk + 1
    mod.cheevo_units[v] = v
end

mod:command("sword_test_network", "", function()
    -- Managers.package:load("units/weapons/player/pup_wooden_sword_01/pup_wooden_sword_01", "global")
    local player = Managers.player:local_player()
    local player_unit = player.player_unit
    local position = Unit.local_position(player_unit, 0) + Vector3(0, 0, 1)
    local rotation = Unit.local_rotation(player_unit, 0)
    local extension_init_data = {}
    Managers.state.unit_spawner:spawn_network_unit("units/weapons/player/pup_wooden_sword_01/pup_wooden_sword_01", "interaction_unit", extension_init_data, position, rotation)
end)

-- local unit_name = "units/weapons/player/pup_lore_page/pup_lore_page_01"
-- Managers.package:load(unit_name, "global")
-- local player = Managers.player:local_player()
-- local player_unit = player.player_unit
-- local position = Unit.local_position(player_unit, 0) + Vector3(0, 0, 1)
-- local rotation = Unit.local_rotation(player_unit, 0)
-- local extension_init_data = {}
-- local unit = Managers.state.unit_spawner:spawn_network_unit(unit_name, "interaction_unit", extension_init_data, position, rotation)
-- Unit.enable_physics(unit)

-- local unit_name = "units/weapons/player/wpn_potion_buff/wpn_potion_buff_3p"
-- local unit_name ="units/weapons/player/pup_potion_01/pup_potion_strenght_01"
-- local unit_name ="units/shield"
-- Managers.package:load("units/weapons/player/pup_wooden_sword_01/pup_wooden_sword_01", "global")
-- local unit_name = "units/weapons/player/pup_wooden_sword_01/pup_wooden_sword_01"
-- local num_husk = #NetworkLookup.husks
-- NetworkLookup.husks[num_husk +1] = unit_name
-- NetworkLookup.husks[unit_name] = num_husk +1
-- local world = Managers.world:world("level_world")
-- local player = Managers.player:local_player()
-- local player_unit = player.player_unit
-- local position = Unit.local_position(player_unit, 0) + Vector3(0, 0, 1)
-- local rotation = Unit.local_rotation(player_unit, 0)
-- local extension_init_data = {}
-- -- local unit = Managers.state.unit_spawner:spawn_local_unit(unit_name, position, rotation)
-- local unit_template_name = "interaction_unit"


-- local unit = Managers.state.unit_spawner:spawn_network_unit(unit_name, "interaction_unit", extension_init_data, position, rotation)
-- Unit.set_data(unit,"interaction_data","hud_description", "potion")
-- Unit.set_data(unit,"interaction_data","interaction_length", 0)
-- Unit.set_data(unit,"interaction_data","interaction_type", "talents_access")
-- Unit.set_data(unit,"interaction_data","interactor_animation","interaction_start")
-- Unit.set_data(unit,"interaction_data","interactor_animation_time_variable", "revive_time")
-- Unit.set_data(unit,"interaction_data","only_once", false)
-- Unit.set_data(unit,"interaction_data","hud_text_line_2", "line test")
-- mod:echo(Unit.has_data(unit,"interaction_data"))
-- local final_unit_template_name = Managers.state.unit_spawner:create_unit_extensions(world, unit, unit_template_name, extension_init_data)

-- local unit_templates = require("scripts/network/unit_extension_templates")
-- local unit_template = unit_templates[final_unit_template_name]

-- NetworkUnit.add_unit(unit)
-- NetworkUnit.set_is_husk_unit(unit, false)

-- local go_type = unit_template.go_type
-- local go_initializer_function = self.gameobject_initializers[go_type]
-- local go_init_data = go_initializer_function(unit, unit_name, unit_template, self.gameobject_functor_context)
-- local go_id = GameSession.create_game_object(self.game_session, go_type, go_init_data)

-- self.unit_storage:add_unit_info(unit, go_id, go_type, self.own_peer_id)
-- self.entity_manager:sync_unit_extensions(unit, go_id)








-- Unit.enable_physics(unit)

-- mod:hook(GenericUnitInteractorExtension, "init", function (func, self, extension_init_context, unit, extension_init_data)
--     local unit_name = Unit.get_data(unit, "unit_name")
--     if unit_name == "units/shield" then
--         Unit.set_data(unit,"interaction_data","hud_description", "potion")
--         Unit.set_data(unit,"interaction_data","interaction_length", 0)
--         Unit.set_data(unit,"interaction_data","interaction_type", "talents_access")
--         Unit.set_data(unit,"interaction_data","interactor_animation","interaction_start")
--         Unit.set_data(unit,"interaction_data","interactor_animation_time_variable", "revive_time")
--         Unit.set_data(unit,"interaction_data","only_once", false)
--         Unit.set_data(unit,"interaction_data","hud_text_line_2", "line test")
--     end

    
--     return func(self, extension_init_context, unit, extension_init_data)
-- end)

-- mod:hook(EntityManager2,"sync_unit_extensions",function (func, self, unit, go_id)
--     local extensions = self._units[unit]

-- 	if extensions then
-- 		for extension_name, extension in pairs(extensions) do
-- 			if extension.game_object_initialized ~= nil then
-- 				mod:echo(extension_name)
-- 			end
-- 		end
-- 	end
--     return func(self, unit, go_id)

-- end)

-- mod:hook(GenericUnitInteractorExtension, "start_interaction", function (func, self, hold_input, interactable_unit, interaction_type, forced)

--     local interaction_context = self.interaction_context
--     local network_manager = Managers.state.network
--     local interactable_go_id, is_level_unit = network_manager:game_object_or_level_id(interaction_context.interactable_unit)
--     mod:echo(interactable_go_id)
--     mod:echo(is_level_unit)

--     return func(self, hold_input, interactable_unit, interaction_type, forced)
-- end)

-- mod:hook(GenericUnitInteractorExtension, 'can_interact', function (func, self, interactable_unit, interaction_type)
    
--     if Unit.alive(interactable_unit) then
--         if Unit.has_data(interactable_unit, "interaction_data") then
--             mod:echo(Unit.get_data(interactable_unit, "interaction_data", "interaction_type"))
--         end
--     end
    
--     return func(self, interactable_unit, interaction_type)
-- end)

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