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
mod.LA_armoury_preview ={}
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

    
    for unit,tisch in pairs(mod.LA_armoury_preview) do
        if Managers.world:has_world("LA_armoury_preview") then
            local world = Managers.world:world("LA_armoury_preview")
            local Armoury_key = tisch.Armoury_key
            local skin = tisch.skin
            if Armoury_key ~= "default" and mod.SKIN_LIST[Armoury_key] then
                mod.SKIN_LIST[Armoury_key].swap_skin = skin or mod.SKIN_LIST[Armoury_key].swap_skin
                mod.apply_new_skin_from_texture(Armoury_key, world, skin, unit)
            end
        end
        flush_LA_armoury_preview = true
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
    if flush_LA_armoury_preview then 
        mod.LA_armoury_preview = {}
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



mod:dofile("scripts/mods/Loremasters-Armoury/LA_view/armoury_view/armoury_view")
local armoury_view_data = {
    view_name = "armoury_view",
    view_settings = {
      init_view_function = function(ingame_ui_context)
        return ArmouryView:new(ingame_ui_context)
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
      open_armoury_view = function(ingame_ui)
        ingame_ui.current_view = "armoury_view"
      end,
      close_armoury_view = function(ingame_ui)
        ingame_ui.current_view = nil
      end
    }
  }
mod:register_view(armoury_view_data)

-- mod:dofile("scripts/mods/Loremasters-Armoury/LA_view/armoury_view/test_widget")
-- local test_view_data = {
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
--       test_open_quest_board_letter_view = function(ingame_ui)
--         ingame_ui.current_view = "quest_board_letter_view"
--       end,
--       test_close_quest_board_letter_view = function(ingame_ui)
--         ingame_ui.current_view = nil
--       end
--     }
--   }
-- mod:register_view(test_view_data)

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


--sort all items into better categories 

mod.items_by_hero = {
    es = {
        melee = {},
        ranged = {},
        skin = {},
        hat = {},
    },
    dr = {
        melee = {},
        ranged = {},
        skin = {},
        hat = {},
    },
    we = {
        melee = {},
        ranged = {},
        skin = {},
        hat = {},
    },
    wh = {
        melee = {},
        ranged = {},
        skin = {},
        hat = {},
    },
    bw = {
        melee = {},
        ranged = {},
        skin = {},
        hat = {},
    },
}

mod.list_of_base_skins = {}
local list_of_base_skins = mod.list_of_base_skins

for weapon,skin_list in pairs(WeaponSkins.skin_combinations) do
    local base_skin = skin_list.common[1] or skin_list.rare[1] or skin_list.plentiful[1]
    if base_skin then
        local item_data = ItemMasterList[base_skin]
        local matching_item_key = item_data.matching_item_key
        local slot_type = ItemMasterList[matching_item_key].slot_type
        local can_wield_tisch = item_data.can_wield or {}
        for _,career in pairs(can_wield_tisch) do
            local char = string.sub(career, 1, 1)..string.sub(career, 2, 2)   
            if slot_type then 
                local item_key = slot_type
            --    mod:echo(slot_type)
                -- if slot_type == "hat" or slot_type == "skin" then
                --     item_key = "skin"
                -- end
                    
                    -- mod.items_by_hero[char][item_key][#mod.items_by_hero[char][item_key] + 1] = item_name
                if mod.items_by_hero[char] then
                    if mod.items_by_hero[char][item_key] then
                        if not mod.items_by_hero[char][item_key][base_skin] then
                            -- mod:echo(base_skin.."_"..char)
                            local num_items = #mod.items_by_hero[char][item_key] + 1
                            mod.items_by_hero[char][item_key][num_items] = base_skin
                            mod.items_by_hero[char][item_key][base_skin] = base_skin 
                            
                            local default_skin_key = string.gsub(base_skin, "_skin.+", "")
                            list_of_base_skins[default_skin_key] = {}
                        end
                    end
                end
            end
        end
    end
end


for skin_name,skin_tisch in pairs(WeaponSkins.skins) do 

    local skin_name = skin_name
    if skin_name then
        local default_skin_key = string.gsub(skin_name, "_skin.+", "")

        if list_of_base_skins[default_skin_key] then
            list_of_base_skins[default_skin_key][#list_of_base_skins[default_skin_key] + 1] = skin_name
        end
    end

end


for item_name,item_data in pairs(ItemMasterList) do
    local slot_type = item_data.slot_type
    local can_wield_tisch = item_data.can_wield or {}
    for _,career in pairs(can_wield_tisch) do
        local char = string.sub(career, 1, 1)..string.sub(career, 2, 2)--gets first 2 letters of entry in can_wield table to determint carreers 
        if slot_type == "skin" or slot_type == "hat" then 
                local item_key = slot_type
            --    mod:echo(slot_type)
                -- if slot_type == "hat" or slot_type == "skin" then
                --     item_key = "skin"
                -- end
                    
                    -- mod.items_by_hero[char][item_key][#mod.items_by_hero[char][item_key] + 1] = item_name
            if mod.items_by_hero[char] then
                if mod.items_by_hero[char][item_key] then
                    if not mod.items_by_hero[char][item_key][item_name] then
                        -- mod:echo(item_name.."_"..char)
                        local num_items = #mod.items_by_hero[char][item_key] + 1
                        mod.items_by_hero[char][item_key][num_items] = item_name 
                        mod.items_by_hero[char][item_key][item_name] = item_name 
                            
                        local default_skin_key = string.gsub(item_name, "_skin.+", "")
                        list_of_base_skins[default_skin_key] = {}
                    end
                end
            end
        end
    end
end


-- local mod = get_mod("Loremasters-Armoury")
local items_by_hero = mod.items_by_hero
mod.items_per_page_original_skin_entry = 18
for char,char_item_data in pairs(items_by_hero) do
    for slot_type, item_list in pairs(char_item_data) do
        local num_items = 0
        for item_name, _ in pairs(item_list) do
            num_items = num_items + 1
        end
        item_list["pages"] = math.ceil(num_items/mod.items_per_page_original_skin_entry)
        item_list["num_items"] = num_items
    end
end
-- require 'pl.pretty'.dump(mod.items_by_hero)


-- local mod = get_mod("Loremasters-Armoury")
-- local items_by_hero = mod.items_by_hero
-- for char,char_item_data in pairs(items_by_hero) do
--     for slot_type, item_list in pairs(char_item_data) do
--         local num_items = 0
--         for item_name, _ in ipairs(item_list) do
--             num_items = num_items + 1
--         end
--        mod:echo(slot_type)
--     end
-- end


-- for k,v in pairs(list_of_base_skins["wh_1h_axe"]) do
--     mod:echo(v)
-- end

-- local str = string.gsub("es_1h_mace_shield_skin_01", "_skin.+", "")
-- mod:echo(str)

-- local mod = get_mod("Loremasters-Armoury")
-- for k,v in pairs(mod.list_of_base_skins) do
--     print(k.." = {},")
-- end

-- for skin_name,skin_tisch in pairs(WeaponSkins.skins) do 

--     local skin_name = skin_name
--     if skin_name then
--         local default_skin_key = string.gsub(skin_name, "_skin.+", "")
--         mod:echo(default_skin_key)

--         if mod.list_of_base_skins[default_skin_key] then
--             mod.list_of_base_skins[default_skin_key][#mod.list_of_base_skins[default_skin_key] + 1] = skin_name
--         end
--     end

-- end

-- for i,skin_tisch in pairs(WeaponSkins.skins) do 
--     mod:echo(i)
-- --    for k,v in pairs(skin_tisch) do 
-- --         mod:echo(k)
-- --    end
--     -- mod:echo(skin_tisch)

-- end


-- for item_name, item_data in pairs(ItemMasterList) do
--     if item_name
--     local can_wield_tisch = item_data.can_wield or {}
--     for _,career in pairs(can_wield_tisch) do
--         local char = string.sub(career, 1, 1)..string.sub(career, 2, 2)
--         if item_data then
--             local slot_type = item_data.slot_type
--             if slot_type then 
--                 local item_key = slot_type

--                 if slot_type == "hat" or slot_type == "skin" then
--                     item_key = "skin"
--                 end
                
--                 -- mod.items_by_hero[char][item_key][#mod.items_by_hero[char][item_key] + 1] = item_name
--                 if mod.items_by_hero[char] then
--                     if mod.items_by_hero[char][item_key] then
--                         table.insert(mod.items_by_hero[char][item_key], item_name)
--                     end
--                 end
--             end
--         end
--     end
-- end


mod:dofile("scripts/mods/Loremasters-Armoury/cosmetic_testing_tools/retexture_mesh")

mod:command("gk_body_mesh", "", function(diffuse, normal, combined)
    local player = Managers.player:local_player()
    local player_unit = player.player_unit
    local position = Unit.local_position(player_unit, 0)
    local rotation = Unit.local_rotation(player_unit, 0)
    local altered_mesh = RetextureMesh:new("units/beings/player/empire_soldier_breton/third_person_base/chr_third_person_mesh", Managers.state.unit_spawner, position, rotation)
    altered_mesh:set_texture("texture_map_64cc5eb8", diffuse)
    altered_mesh:set_texture("texture_map_861dbfdc", normal)
    altered_mesh:set_texture("texture_map_b788717c", combined)
end)

mod:command("url_gk_body_mesh", "Parameters: url_to_diffuse url_to_normal url_to_combined", function(diffuse, normal, combined)
    local player = Managers.player:local_player()
    local player_unit = player.player_unit
    local position = Unit.local_position(player_unit, 0)
    local rotation = Unit.local_rotation(player_unit, 0)
    local altered_mesh = RetextureMesh:new("units/beings/player/empire_soldier_breton/third_person_base/chr_third_person_mesh", Managers.state.unit_spawner, position, rotation)
    altered_mesh:set_texture_from_url("texture_map_64cc5eb8", tostring(diffuse), nil, diffuse)
    altered_mesh:set_texture_from_url("texture_map_861dbfdc", tostring(normal), nil, normal)
    altered_mesh:set_texture_from_url("texture_map_b788717c", tostring(combined), nil, combined)
end)

Managers.package:load("units/beings/player/empire_soldier_breton/headpiece/es_gk_hat_03", "global")
mod:command("gk_hat_mesh", "", function(diffuse, normal, combined)
    local player = Managers.player:local_player()
    local player_unit = player.player_unit
    local position = Unit.local_position(player_unit, 0) +Vector3(0,0,1)
    local rotation = Unit.local_rotation(player_unit, 0)
    local altered_mesh = RetextureMesh:new("units/beings/player/empire_soldier_breton/headpiece/es_gk_hat_03", Managers.state.unit_spawner, position, rotation)
    altered_mesh:set_texture("texture_map_c0ba2942", diffuse)
    altered_mesh:set_texture("texture_map_59cd86b9", normal)
    altered_mesh:set_texture("texture_map_0205ba86", combined)
end)

mod:command("url_gk_hat_mesh", "Parameters: url_to_diffuse url_to_normal url_to_combined", function(diffuse, normal, combined)
    local player = Managers.player:local_player()
    local player_unit = player.player_unit
    local position = Unit.local_position(player_unit, 0) +Vector3(0,0,1)
    local rotation = Unit.local_rotation(player_unit, 0)
    local altered_mesh = RetextureMesh:new("units/beings/player/empire_soldier_breton/headpiece/es_gk_hat_03", Managers.state.unit_spawner, position, rotation)
    altered_mesh:set_texture_from_url("texture_map_c0ba2942", tostring(diffuse), nil, diffuse)
    altered_mesh:set_texture_from_url("texture_map_59cd86b9", tostring(normal), nil, normal)
    altered_mesh:set_texture_from_url("texture_map_0205ba86", tostring(combined), nil, combined)
end)


mod:command("url_body", "Parameters: url_to_diffuse url_to_normal url_to_combined", function(diffuse, normal, combined)
    local player = Managers.player:local_player()
    local player_unit = player.player_unit
    local cosmetic_extension = ScriptUnit.has_extension(player_unit, "cosmetic_system")
    local tp_mesh = cosmetic_extension._tp_unit_mesh
    local altered_mesh = RetextureMesh:new(tp_mesh, Managers.state.unit_spawner)
    altered_mesh:set_texture_from_url("texture_map_64cc5eb8", tostring(diffuse), nil, diffuse)
    altered_mesh:set_texture_from_url("texture_map_861dbfdc", tostring(normal), nil, normal)
    altered_mesh:set_texture_from_url("texture_map_b788717c", tostring(combined), nil, combined)
end)

mod:command("url_hat", "Parameters: url_to_diffuse url_to_normal url_to_combined", function(diffuse, normal, combined)
    local player = Managers.player:local_player()
    local player_unit = player.player_unit
    local cosmetic_extension = ScriptUnit.has_extension(player_unit, "cosmetic_system")
    local attachment_extension = cosmetic_extension["_attachment_extension"]
    local hat_data = attachment_extension:get_slot_data("slot_hat")
    local hat_unit = hat_data.unit
    local altered_mesh = RetextureMesh:new(hat_unit, Managers.state.unit_spawner)
    altered_mesh:set_texture_from_url("texture_map_c0ba2942", tostring(diffuse), nil, diffuse)
    altered_mesh:set_texture_from_url("texture_map_59cd86b9", tostring(normal), nil, normal)
    altered_mesh:set_texture_from_url("texture_map_0205ba86", tostring(combined), nil, combined)
end)

mod:command("url_left_hand", "Parameters: url_to_diffuse url_to_normal url_to_combined", function(diffuse, normal, combined)
    local player = Managers.player:local_player()
    local player_unit = player.player_unit
    local inventory_extension = ScriptUnit.has_extension(player_unit, "inventory_system")
    local equipment = inventory_extension["_equipment"]
    local left_hand_unit = equipment.left_hand_wielded_unit
    local altered_mesh = RetextureMesh:new(left_hand_unit, Managers.state.unit_spawner)
    altered_mesh:set_texture_from_url("texture_map_c0ba2942", tostring(diffuse), nil, diffuse)
    altered_mesh:set_texture_from_url("texture_map_59cd86b9", tostring(normal), nil, normal)
    altered_mesh:set_texture_from_url("texture_map_0205ba86", tostring(combined), nil, combined)
end)

mod:command("url_right_hand", "Parameters: url_to_diffuse url_to_normal url_to_combined", function(diffuse, normal, combined)
    local player = Managers.player:local_player()
    local player_unit = player.player_unit
    local inventory_extension = ScriptUnit.has_extension(player_unit, "inventory_system")
    local equipment = inventory_extension["_equipment"]
    local right_hand_unit = equipment.right_hand_wielded_unit
    local altered_mesh = RetextureMesh:new(right_hand_unit, Managers.state.unit_spawner)
    altered_mesh:set_texture_from_url("texture_map_c0ba2942", tostring(diffuse), nil, diffuse)
    altered_mesh:set_texture_from_url("texture_map_59cd86b9", tostring(normal), nil, normal)
    altered_mesh:set_texture_from_url("texture_map_0205ba86", tostring(combined), nil, combined)
end)

mod:command("url_fps", "Parameters: url_to_diffuse url_to_normal url_to_combined", function(diffuse, normal, combined)
    local player = Managers.player:local_player()
    local player_unit = player.player_unit
    local first_person_extension = ScriptUnit.has_extension(player_unit, "first_person_system")
    local first_person_unit = first_person_extension:get_first_person_mesh_unit()
    local altered_mesh = RetextureMesh:new(first_person_unit, Managers.state.unit_spawner)
    altered_mesh:set_texture_from_url("texture_map_64cc5eb8", tostring(diffuse), nil, diffuse)
    altered_mesh:set_texture_from_url("texture_map_861dbfdc", tostring(normal), nil, normal)
    altered_mesh:set_texture_from_url("texture_map_b788717c", tostring(combined), nil, combined)
end)
