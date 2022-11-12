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

mod:dofile("scripts/mods/Loremasters-Armoury/interactions/letter_interaction")
mod:dofile("scripts/mods/Loremasters-Armoury/interactions/archive_interaction")


Managers.package:load("resource_packages/levels/dlcs/morris/slaanesh_common", "global")
Managers.package:load("resource_packages/levels/dlcs/morris/nurgle_common", "global")
Managers.package:load("resource_packages/levels/dlcs/morris/khorne_common", "global")
Managers.package:load("resource_packages/levels/dlcs/morris/tzeentch_common", "global")
Managers.package:load("resource_packages/levels/dlcs/morris/wastes_common", "global")

Managers.package:load("units/weapons/player/wpn_brw_sword_01_t2/wpn_brw_flaming_sword_01_t2", "global")
Managers.package:load("units/weapons/player/wpn_brw_sword_01_t2/wpn_brw_flaming_sword_01_t2_3p", "global")


-- Your mod code goes here.
-- https://vmf-docs.verminti.de

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
    if state_name == "StateIngame" and status == "loading" then
        for unit,extension in pairs(LA_PICKUPS) do
            LA_PICKUPS[unit] = nil
        end
    end
end

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



-- Managers.ui:handle_transition("hero_view_force", {
--     menu_state_name = "keep_decorations",
--     use_fade = true,
--     interactable_unit = interactable_unit
-- })


mod:dofile("scripts/mods/Loremasters-Armoury/LA_view/quest_board_views/quest_board_letter_view")
local letter_view_data = {
    view_name = "quest_board_letter_view",
    view_settings = {
      init_view_function = function(ingame_ui_context)
        return QuestBoardLetterView:new(ingame_ui_context)
      end,
      active = {        -- Only enable in keep
        inn = true,
        ingame = false
      },
      blocked_transitions = {
        inn = {},
        ingame = {}
      }
    },
    view_transitions = {
      open_quest_board_letter_view = function(ingame_ui)
        ingame_ui.current_view = "quest_board_letter_view"
      end,
      close_quest_board_letter_view = function(ingame_ui)
        ingame_ui.current_view = nil
      end
    }
  }
mod:register_view(letter_view_data)




mod:dofile("scripts/mods/Loremasters-Armoury/LA_view/quest_board_views/quest_board_archive_view")
local archive_view_data = {
    view_name = "quest_board_archive_view",
    view_settings = {
      init_view_function = function(ingame_ui_context)
        return QuestBoardArchiveView:new(ingame_ui_context)
      end,
      active = {        -- Only enable in keep
        inn = true,
        ingame = false
      },
      blocked_transitions = {
        inn = {},
        ingame = {}
      }
    },
    view_transitions = {
      open_quest_board_archive_view = function(ingame_ui)
        ingame_ui.current_view = "quest_board_archive_view"
      end,
      close_quest_board_archive_view = function(ingame_ui)
        ingame_ui.current_view = nil
      end
    }
  }
mod:register_view(archive_view_data)

-- mod:dofile("scripts/mods/Loremasters-Armoury/LA_view/armoury_view/test_widget")
-- local view_data = {
--     view_name = "quest_board_letter_view",
--     view_settings = {
--       init_view_function = function(ingame_ui_context)
--         return TestWidgets:new(ingame_ui_context)
--       end,
--       active = {        -- Only enable in keep
--         inn = true,
--         ingame = false
--       },
--       blocked_transitions = {
--         inn = {},
--         ingame = {}
--       }
--     },
--     view_transitions = {
--       open_quest_board_letter_view = function(ingame_ui)
--         ingame_ui.current_view = "quest_board_letter_view"
--       end,
--       close_quest_board_letter_view = function(ingame_ui)
--         ingame_ui.current_view = nil
--       end
--     }
--   }
-- mod:register_view(view_data)

-- local lamod = get_mod("Loremasters-Armoury")
-- lamod:handle_transition("close_quest_board_letter_view", true, true)

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



mod:command("complete_sub_quest_01", "", function()

    mod.main_quest.sub_quest_01 = true
    mod:set("sub_quest_01", 1500)
end)

mod:command("complete_sub_quest_02", "", function()

    mod.main_quest.sub_quest_02 = true
    mod:set("sub_quest_02", 1500)
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
