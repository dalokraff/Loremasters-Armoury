local mod = get_mod("Loremasters-Armoury")
mod:dofile("scripts/mods/Loremasters-Armoury/buffs/LA_buffs")
mod:dofile("scripts/mods/Loremasters-Armoury/buffs/hooks")
mod:dofile("scripts/mods/Loremasters-Armoury/utils/hooks")
-- mod:dofile("scripts/mods/Loremasters-Armoury/achievements/manager")
mod:dofile("scripts/mods/Loremasters-Armoury/achievements/la_pickup_interaction")
-- mod:dofile("scripts/mods/Loremasters-Armoury/achievements/test")
mod:dofile("scripts/mods/Loremasters-Armoury/utils/outliner")
mod:dofile("scripts/mods/Loremasters-Armoury/achievements/LA_message_board")

mod:dofile("scripts/mods/Loremasters-Armoury/news/hooks")


Managers.package:load("resource_packages/levels/dlcs/morris/slaanesh_common", "global")
Managers.package:load("resource_packages/levels/dlcs/morris/nurgle_common", "global")
Managers.package:load("resource_packages/levels/dlcs/morris/khorne_common", "global")
Managers.package:load("resource_packages/levels/dlcs/morris/tzeentch_common", "global")
Managers.package:load("resource_packages/levels/dlcs/morris/wastes_common", "global")

Managers.package:load("units/weapons/player/wpn_brw_sword_01_t2/wpn_brw_flaming_sword_01_t2", "global")
Managers.package:load("units/weapons/player/wpn_brw_sword_01_t2/wpn_brw_flaming_sword_01_t2_3p", "global")


-- Your mod code goes here.
-- https://vmf-docs.verminti.de


-- mod:hook_safe(StateIngame,'_setup_state_context', function (self, world, is_server, network_event_delegate)
--     Managers.state.achievement = AchievementManager:new(self.world, self.statistics_db)
--     mod:echo('inside out')
-- end)


LA_PICKUPS = {}

--thesse tables are used as queues that get filled and flushed as skins and their respective units are changed
mod.level_queue = {}
mod.preview_queue = {}
mod.armory_preview_queue = {}
mod.current_skin = {}
mod.time = 0
mod.delayed_sounds = {}
mod.show_reward = nil
mod.marker_list = {}

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

    if mod.sword_ritual then
        mod.sword_ritual:update(dt)
    end
    if mod.halescourge_buff then
        mod.halescourge_buff:update(dt)
    end
    if mod.halescourge_boss_debuff then
        mod.halescourge_boss_debuff:update(dt)
    end
    for unit,extension in pairs(LA_PICKUPS) do
        extension:update(dt)
    end

    --dirty way to reapply buffs on player respawn for quest 08
    local current_level_key = Managers.level_transition_handler:get_current_level_keys()
    if current_level_key == "ground_zero" then
        if mod:get("sub_quest_07") then
            if Managers.player then
                local player = Managers.player:local_player()
                if player then
                    local player_unit = player.player_unit
                    if player_unit then
                        local buff_extension = ScriptUnit.extension(player_unit, "buff_system")
                        if buff_extension and mod.halescourge_buff_applied then
                            if not buff_extension:has_buff_type("sub_quest_08_cdr_buff") then
                                buff_extension:add_buff("sub_quest_08_cdr_buff", nil)
                            end
                            if not buff_extension:has_buff_type("sub_quest_08_stamina_buff") then
                                buff_extension:add_buff("sub_quest_08_stamina_buff", nil)
                            end
                            if not buff_extension:has_buff_type("sub_quest_08_heatgen_buff") then
                                buff_extension:add_buff("sub_quest_08_heatgen_buff", nil)
                            end 
                        end
                    end
                end
            end
        end
    end
    

    if mod.scroll_unit then
        local position = Vector3Box(Unit.local_position(mod.scroll_unit, 0))
        mod.render_marker(position, 100)
    end

    local mod_time = mod.time
    if Managers.world:has_world("level_world") then
        local world = Managers.world:world("level_world")
        local wwise_world = Wwise.wwise_world(world)
        for sound_event_name,tisch in pairs(mod.delayed_sounds) do
            if mod_time >= tisch.time then
                local sound_id = WwiseWorld.trigger_event(wwise_world, sound_event_name, tisch.unit)
                mod.delayed_sounds[sound_event_name] = nil
            end
        end
    end
    


    --for displaying item reward after completing main quest, should be sent to it's own funciton or class
    if not mod.reward_popup or mod.show_reward then
        local ingame_ui_context = Managers.ui._ingame_ui_context
        if ingame_ui_context then
            local reward_params = {
                wwise_world = ingame_ui_context.wwise_world,
                ui_renderer = ingame_ui_context.ui_renderer,
                ui_top_renderer = ingame_ui_context.ui_top_renderer,
                input_manager = ingame_ui_context.input_manager
            }
            mod.reward_popup = RewardPopupUI:new(reward_params)

            mod.reward_popup:set_input_manager(ingame_ui_context.input_manager)

            local presentation_data = {}
            local weapon_skin_name = mod.show_reward
            local weapon_skin_data = WeaponSkins.skins[weapon_skin_name]
            if weapon_skin_data then
                local rarity = weapon_skin_data.rarity or "plentiful"
                local display_name = weapon_skin_data.display_name
                local description = weapon_skin_data.description
                local icon = weapon_skin_data.inventory_icon
                local description = {}
                local entry = {}
                description[1] = Localize(display_name)
                description[2] = Localize("achv_menu_reward_claimed_title")
                entry[#entry + 1] = {
                    widget_type = "description",
                    value = description
                }
                entry[#entry + 1] = {
                    widget_type = "weapon_skin",
                    value = {
                        icon = icon,
                        rarity = rarity
                    }
                }
                presentation_data[#presentation_data + 1] = entry

                mod.show_reward = nil

                mod.reward_popup:display_presentation(presentation_data)
            end
        end
    elseif mod.reward_popup then
        mod.reward_popup:update(dt)
    end

    mod.time = mod_time + dt
    
end


mod.on_game_state_changed = function(status, state_name)
    if state_name == "StateIngame" and status == "enter" then
        mod.halescourge_buff_applied = false
        mod.halescourge_buff = nil
        mod.halescourge_boss_debuff = nil
    end
end

mod:command("complete_sub_quest_01", "", function()

    mod.main_quest.sub_quest_01 = true
    mod:set("sub_quest_01", 1500)
end)
mod:command("complete_sub_quest_02", "", function()

    mod.main_quest.sub_quest_02 = true
    mod:set("sub_quest_02", 1500)
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

if mod:get("sub_quest_crate_tracker") == nil then 
    mod:set("sub_quest_crate_tracker", false)
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
    mod:set("sub_quest_crate_tracker", false)
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
    mod:set("sub_quest_01", 1500)
    mod:set("sub_quest_02", 1500)
    mod:set("sub_quest_03", true)
    mod:set("sub_quest_04", true)
    mod:set("sub_quest_05", true)
    mod:set("sub_quest_crate_tracker", true)
    mod:set("sub_quest_06", true)
    mod:set("sub_quest_07", true)
    mod:set("sub_quest_08", true)
    mod:set("sub_quest_09", true)
    mod:set("sub_quest_10", true)
end)


mod:command("complete_sub_quest_03", "", function()
    mod.main_quest["sub_quest_03"] = true
    mod:set("sub_quest_03", true)
end)

mod:command("complete_sub_quest_04", "", function()
    mod.main_quest["sub_quest_04"] = true
    mod:set("sub_quest_04", true)
end)

mod:command("complete_sub_quest_05", "", function()
    mod.main_quest["sub_quest_05"] = true
    mod:set("sub_quest_05", true)
end)

mod:command("complete_sub_quest_06", "", function()
    mod.main_quest["sub_quest_06"] = true
    mod:set("sub_quest_06", true)
end)

mod:command("complete_sub_quest_07", "", function()
    mod.main_quest["sub_quest_07"] = true
    mod:set("sub_quest_07", true)
end)

mod:command("complete_sub_quest_08", "", function()
    mod.main_quest["sub_quest_08"] = true
    mod:set("sub_quest_08", true)
end)

mod:command("complete_sub_quest_09", "", function()
    mod.main_quest["sub_quest_09"] = true
    mod:set("sub_quest_09", true)
end)



-- local player = Managers.player:local_player()
-- local player_unit = player.player_unit
-- local position = Unit.local_position(player_unit, 0)
-- local rotation = Unit.local_rotation(player_unit, 0)
-- local unit_template_name = "interaction_unit"
-- local extension_init_data = {}
-- local box_unit = Managers.state.unit_spawner:spawn_network_unit("units/pickups/LA_artifact_mesh", unit_template_name, 
--     extension_init_data, position, rotation)

-- LA_PICKUPS[box_unit] = LaPickupExtension:new(box_unit)

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
-- local player_unit = player.player_unit
-- mod:echo(Unit.local_position(player_unit, 0))
-- local position = Vector3(-14.0746, -17, 13)
-- local rot1 = Quaternion.from_elements(0, 0, 0.903278, -0.429056)
-- local rot_apply = radians_to_quaternion(0, 0, 0)
-- local rotation = Quaternion.multiply(rot1, rot_apply)
-- local path = "units/props/tzeentch/deus_tzeentch_flag_01"
-- local board_unit_visible = Managers.state.unit_spawner:spawn_local_unit(path, position, rot1)
-- Unit.disable_physics(board_unit_visible)
-- local num_meshes = Unit.num_meshes(board_unit_visible)
-- local mesh = Unit.mesh(board_unit_visible, 3)
-- local num_mats = Mesh.num_materials(mesh)
-- for j = 0, num_mats - 1, 1 do
--     local mater = Mesh.material(mesh, j)
--     local map = "textures/flag"
--     for _,tex_name in pairs(slot_list) do
--         Material.set_texture(mater, tex_name, map)
--     end
-- end

-- local mesh2 = Unit.mesh(board_unit_visible, 2)
-- local mesh3 = Unit.mesh(board_unit_visible, 1)
-- local mesh4 = Unit.mesh(board_unit_visible, 0)
-- Mesh.set_local_position(mesh2, board_unit_visible, Vector3(0,0,-1))
-- Mesh.set_local_position(mesh3, board_unit_visible, Vector3(0,0,-1))
-- Mesh.set_local_position(mesh4, board_unit_visible, Vector3(0,0,-1))
-- Mesh.set_local_position(mesh, board_unit_visible, Vector3(0,0,0))
-- -- local num_mats = Mesh.num_materials(mesh)
-- -- for j = 0, num_mats - 1, 1 do
-- --     -- local mater = Mesh.material(mesh, j)
-- --     local map = "textures/transparent"
-- --     for _,tex_name in pairs(slot_list) do
-- --         Material.set_texture(mater, tex_name, map)
-- --     end
-- -- end


-- Vector3(-14.4497, -16.1263, 14.0184)
-- Vector4(0, 0, 0.903278, -0.429056)