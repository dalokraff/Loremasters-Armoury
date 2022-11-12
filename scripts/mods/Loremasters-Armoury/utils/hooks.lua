local mod = get_mod("Loremasters-Armoury")
mod:dofile("scripts/mods/Loremasters-Armoury/utils/funcs")
mod:dofile("scripts/mods/Loremasters-Armoury/achievements/crate_locations")
mod:dofile("scripts/mods/Loremasters-Armoury/achievements/book_locations")
mod:dofile("scripts/mods/Loremasters-Armoury/achievements/pickup_marker")

require("scripts/managers/achievements/achievement_templates")
mod:dofile("scripts/mods/Loremasters-Armoury/achievements/achievements")

mod:dofile("scripts/mods/Loremasters-Armoury/rpc_hooks/hooks")

mod:dofile("scripts/mods/Loremasters-Armoury/unit_sounds/hooks")
local unit_sound_map = require("scripts/mods/Loremasters-Armoury/unit_sounds/unit_sound_map")

mod:dofile("scripts/mods/Loremasters-Armoury/achievements/sword_enchantment")
mod:dofile("scripts/mods/Loremasters-Armoury/buffs/halescourge_buff")

mod:dofile("scripts/mods/Loremasters-Armoury/achievements/sword_enchantment_interaction")




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

--this hook is used to populate the level_world queue; get's the units to change with what custom illusion should be applied to that unit
mod:hook(SimpleInventoryExtension, "_get_no_wield_required_property_and_trait_buffs", function (func, self, backend_id)
    local data_melee = self.recently_acquired_list["slot_melee"]
    local data_range = self.recently_acquired_list["slot_ranged"]

    for skin,bools in pairs(mod.SKIN_CHANGED) do
        if bools.changed_texture then
            local Armoury_key_melee = mod:get(skin)
            local Armoury_key_range = mod:get(skin)

            if data_melee then
                if skin == data_melee.skin then
                    local hand_key = mod.SKIN_LIST[Armoury_key_melee].swap_hand
                    local p1 = hand_key:gsub("_hand",""):gsub("unit", "unit_1p")
                    local p3 = hand_key:gsub("_hand",""):gsub("unit", "unit_3p")
                    local unit_1p = data_melee[p1]
                    local unit_3p = data_melee[p3]
                    
                    
                    mod.level_queue[unit_1p] = {
                        Armoury_key = Armoury_key_melee,
                        skin = skin,
                    }
                    mod.level_queue[unit_3p] = {
                        Armoury_key = Armoury_key_melee,
                        skin = skin,
                    }
                end
            end

            if data_range then
                if skin == data_range.skin then
                    local hand_key = mod.SKIN_LIST[Armoury_key_range].swap_hand
                    local p1 = hand_key:gsub("_hand",""):gsub("unit", "unit_1p")
                    local p3 = hand_key:gsub("_hand",""):gsub("unit", "unit_3p")
                    local unit_1p = data_range[p1]
                    local unit_3p = data_range[p3]
                    
                    
                    mod.level_queue[unit_1p] = {
                        Armoury_key = Armoury_key_range,
                        skin = skin,
                    }
                    mod.level_queue[unit_3p] = {
                        Armoury_key = Armoury_key_range,
                        skin = skin,
                    }
                end
            end

        end
    end

    return func(self, backend_id)
end)


--applies the vanilla material setting to custom units if specified in the unit
mod:hook_safe(World, "link_unit", function(self, child, child_node_index, parent, parent_node_index )
    if type(child) == "userdata" then
        if Unit.has_data(child, "use_vanilla_glow") then
            local glow = Unit.get_data(child, "use_vanilla_glow")
            GearUtils.apply_material_settings(child, WeaponMaterialSettingsTemplates[glow])
        end
    end
    if type(parent) == "userdata" then 
        if Unit.has_data(parent, "use_vanilla_glow") then
            local glow = Unit.get_data(child, "use_vanilla_glow")
            GearUtils.apply_material_settings(parent, WeaponMaterialSettingsTemplates[glow])
        end
    end
end)


mod:hook(AttachmentUtils, 'link', function (func, world, source, target, node_linking)
    local unit_name = nil
    if Unit.has_data(target, 'unit_name') then
        unit_name = Unit.get_data(target, 'unit_name')
    end
    for skin,tisch in pairs(mod.SKIN_CHANGED) do
        local Armoury_key = mod:get(skin)
        if tisch.changed_texture then
            if mod.SKIN_LIST[Armoury_key].new_units then
                if unit_name == mod.SKIN_LIST[Armoury_key].new_units[1] then
                    
                    mod.SKIN_CHANGED[skin].changed_texture = true
                    mod.level_queue[target] = {
                        Armoury_key = Armoury_key,
                        skin = skin,
                    }
                end
            end
            if mod.SKIN_LIST[Armoury_key].fps_units then
                if unit_name == mod.SKIN_LIST[Armoury_key].fps_units[1] then
                    mod.level_queue[target] = {
                        Armoury_key = Armoury_key,
                        skin = skin,
                    }
                end
            end
        end
    end
 
    return func(world, source, target, node_linking)
end)

--this hook is used to populate the character_preview queue; gets the unit loaded in the preview if it's of the correct skin. correct hand and in the correct slot
local slot_dict = {
    "melee",
    "ranged",
}
slot_dict[6] = "hat", --hat is 6th in the HeroPreviewer's self._item_info_by_slot table, even though the other options are nil
mod:hook_safe(HeroPreviewer, "_spawn_item_unit",  function (self, unit, item_slot_type, item_template, unit_attachment_node_linking, scene_graph_links, material_settings) 
    local player = Managers.player:local_player()
    if player then
        local player_unit = player.player_unit    
        local inventory_extension = ScriptUnit.extension(player_unit, "inventory_system")
        local career_extension = ScriptUnit.extension(player_unit, "career_system")
        if career_extension then
            if career_extension.career_name then
                local career_name = career_extension:career_name()
                for slot_order,units in pairs(self._equipment_units) do
                    local slot = slot_dict[slot_order]
                    
                    if slot then
                        if self._item_info_by_slot[slot] then 
                            local item = BackendUtils.get_loadout_item(career_name, "slot_"..slot)
                            if item_slot_type == "melee" or  item_slot_type == "ranged" then
                                if item.skin then 
                                    local skin = item.skin
                                    local Armoury_key = mod:get(skin)
                                    local skin_list = mod.SKIN_LIST[Armoury_key]
                                    if skin_list then
                                        local hand = skin_list.swap_hand
                                        local hand_key = hand:gsub("_hand_unit", "")
                                        local unit = units[hand_key]

                                        if unit then
                                            mod.preview_queue[unit] = {
                                                Armoury_key = Armoury_key,
                                                skin = skin,
                                            }
                                            mod.armory_preview_queue[unit] = {
                                                Armoury_key = Armoury_key,
                                                skin = skin,
                                            }
                                        end
                                    end
                                end
                            elseif item_slot_type == "hat" then
                                if item.key then
                                    local skin = item.key
                                    local Armoury_key = mod:get(skin)
                                    if unit then
                                        mod.preview_queue[unit] = {
                                            Armoury_key = Armoury_key,
                                            skin = skin,
                                        }
                                        mod.armory_preview_queue[unit] = {
                                            Armoury_key = Armoury_key,
                                            skin = skin,
                                        }
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    


end)


mod:hook_safe(HeroPreviewer, "post_update",  function (self, dt) 
    local unit = self.mesh_unit
    if self._hero_loading_package_data then
        local skin_data = self._hero_loading_package_data.skin_data
        local skin_name = skin_data.name
        local Armoury_key = mod:get(skin_name)
        if mod.SKIN_CHANGED[skin_name] then
            if mod.SKIN_CHANGED[skin_name].changed_texture and unit then
                mod.preview_queue[unit] = {
                    Armoury_key = Armoury_key,
                    skin = skin_name,
                }
                mod.armory_preview_queue[unit] = {
                    Armoury_key = Armoury_key,
                    skin = skin,
                }
            end
        end
    end
end)

--the name of pacakges to count as loaded are taken from the string_dict file
local pacakge_tisch = {}
for k,v in pairs(mod.SKIN_LIST) do
    if v.kind == "unit" then
        local package = v.new_units[1]
        pacakge_tisch[package] = package
        pacakge_tisch[package.."_3p"] = package.."_3p"
    end
    
end

mod:hook(PackageManager, "load",
         function(func, self, package_name, reference_name, callback,
                  asynchronous, prioritize)
    if package_name ~= pacakge_tisch[package_name] and package_name ~= pacakge_tisch[package_name.."_3p"] then
        func(self, package_name, reference_name, callback, asynchronous,
             prioritize)
    end
	
end)

mod:hook(PackageManager, "unload",
         function(func, self, package_name, reference_name)
    if package_name ~= pacakge_tisch[package_name] and package_name ~= pacakge_tisch[package_name.."_3p"] then
        func(self, package_name, reference_name)
    end
	
end)

mod:hook(PackageManager, "has_loaded",
         function(func, self, package, reference_name)
    if package == pacakge_tisch[package] or package == pacakge_tisch[package.."_3p"] then
        return true
    end
	
    return func(self, package, reference_name)
end)

--replaces item skin name and descritpion
mod:hook(LocalizationManager, "_base_lookup", function (func, self, text_id)
    local word = mod.dict[text_id]
    local skin = mod.helper_dict[text_id]
    local Armoury_key = mod:get(skin)

    if word then    
        if mod.SKIN_CHANGED[skin].changed_texture or mod.SKIN_CHANGED[skin].changed_model then
            return word[Armoury_key]
        end
    end

    if not string.find(mod:localize(text_id), "<") then
        return mod:localize(text_id)
    end
    
	return func(self, text_id)
end)


mod:hook(BackendInterfaceLootPlayfab,'get_achievement_rewards', function (func, self, achievement_id)

    local achievement_rewards = self._backend_mirror:get_achievement_rewards()
	local rewards = achievement_rewards[achievement_id] and achievement_rewards[achievement_id][1]

    if rewards then
        if mod.achievement_rewards[achievement_id] then
            return mod.achievement_rewards[achievement_id]
        end
    end

    return func(self, achievement_id)
end)

--hooks to allow for painting scraps to be used as objectives
mod.attached_units = {}
mod.replace_chat_message = nil
local level_quest_table = require("scripts/mods/Loremasters-Armoury/achievements/pickup_maps")
mod:hook(InteractionDefinitions.pickup_object.client, 'stop', function (func, world, interactor_unit, interactable_unit, data, config, t, result)
    
    if interactable_unit then 
        local go_id = Managers.state.unit_storage:go_id(interactable_unit)
        if go_id then
            if mod.attached_units[go_id] then
                
                local player = Managers.player:local_player()
                local player_unit = player.player_unit


                if player_unit == interactor_unit then 
                    Managers.state.unit_spawner:mark_for_deletion(mod.attached_units[go_id].target)
                end

                local level_name = Managers.state.game_mode:level_key()
                local quest = level_quest_table[level_name]
                if quest then
                    mod:set(quest.."_temp", true)
                end
                local pickup_extension = ScriptUnit.extension(interactable_unit, "pickup_system")
                local pickup_settings = pickup_extension:get_pickup_settings()

                if Unit.has_data(interactable_unit, "pickup_sound") then
                    pickup_settings.pickup_sound_event = Unit.get_data(interactable_unit, "pickup_sound")
                end
                if Unit.has_data(interactable_unit, "pickup_message") then
                    mod.replace_chat_message = Unit.get_data(interactable_unit, "pickup_message")
                end
            end
        end
    end
    return func(world, interactor_unit, interactable_unit, data, config, t, result)
end)

--hooking ChatManager to intercept art pickup message proved too difficult so hooked string.format instead
mod:hook(string, "format", function(func, message, ...)
    if mod.replace_chat_message then
        if message == Localize("system_chat_player_picked_up_painting_chat") then
            local new_mesage = mod:localize(mod.replace_chat_message)
            mod.replace_chat_message = nil
            return new_mesage
        end
    end

    return func(message, ...)
end)


--checks if citadel expidition has been finished
mod:hook(StatisticsUtil, "_register_completed_journey_difficulty", function (func, statistics_db, player, journey_name, dominant_god, difficulty_name)
    if string.find(journey_name, "citadel") and mod:get("sub_quest_08") then
        mod:set("sub_quest_09", true)
    end

    return func(statistics_db, player, journey_name, dominant_god, difficulty_name)
end)

--checks if you've prayed as myrmidia's shrine
mod:hook(InteractionDefinitions.decoration.client, "stop", function (func, world, interactor_unit, interactable_unit, data, config, t, result)
	
	if result == InteractionResult.SUCCESS and not data.is_husk and rawget(_G, "HeroViewStateKeepDecorations") then
		local hud_description = Unit.get_data(interactable_unit, "interaction_data", "hud_description")
        local level_name = Managers.state.game_mode:level_key()
        if Unit.has_data(interactable_unit, "quest") then
            local quest = Unit.get_data(interactable_unit, "quest")
            mod:set(quest.."_letter_read", true)
        end
	end
    return func(world, interactor_unit, interactable_unit, data, config, t, result)
end)

mod:hook_safe(LevelEndView, "start", function(self)
    for level,quest in pairs(level_quest_table) do 
        if mod:get(quest.."_temp") then
            if self.game_won then
                mod:set(quest, true)
                if mod.list_of_LA_levels[level] then
                    mod.list_of_LA_levels[level].compelted = true
                end
                if mod.list_of_LA_levels_books[level] then
                    mod.list_of_LA_levels_books[level].compelted = true
                end
            end
        end
    end
end)

mod:hook_safe(LevelTransitionHandler,"load_current_level", function (self)
    for level,quest in pairs(level_quest_table) do 
        mod:set(quest.."_temp", false)
    end
end)


--hook used to track an register kills made with specific skins for okri's challenges/achievments
--need to add a check for if the attacking player is the local player
local skin_killQuest = require("scripts/mods/Loremasters-Armoury/achievements/kill_quests")
mod:hook(StatisticsUtil, "register_kill", function(func, victim_unit, damage_data, statistics_db, is_server)
	
	local victim_health_extension = ScriptUnit.has_extension(victim_unit, "health_system")
	local victim_damage_data = victim_health_extension.last_damage_data

    if victim_damage_data then
        local player_manager = Managers.player
        local attacker_unique_id = victim_damage_data.attacker_unique_id
        if attacker_unique_id then
            local attacker_player = player_manager:player_from_unique_id(attacker_unique_id)
            local player = Managers.player:local_player()
            local player_unit = player.player_unit 
            if player_unit == attacker_player.player_unit then

                local career_extension = ScriptUnit.extension(attacker_player.player_unit, "career_system")
                if career_extension then
                    if career_extension.career_name then
                        local career_name = career_extension:career_name()
                        local item_one = BackendUtils.get_loadout_item(career_name, "slot_melee")
                        local item_two = BackendUtils.get_loadout_item(career_name, "slot_ranged")

                        local tisch = {
                            item_one, 
                            item_two, 
                        }

                        local damage_source = damage_data[DamageDataIndex.DAMAGE_SOURCE_NAME]
                        local master_list_item = rawget(ItemMasterList, damage_source)

                        for quest, reqs in pairs(skin_killQuest) do
                            local breed_killed = Unit.get_data(victim_unit, "breed")
                            local breed_killed_name = breed_killed.name
                            local killed_race_name = breed_killed.race

                            if reqs.kind == killed_race_name then
                                local current_kills = mod:get(quest)
                                current_kills = current_kills + 1
                                mod:set(quest, current_kills)
                            end

                        end
                    end

                end
            end
        end

    end

	return func(victim_unit, damage_data, statistics_db, is_server)
end)

--used to register when bodvarr dies, so his collectable can be spawned
mod.stored_vectors = {}
mod:hook_safe(Unit, "animation_event", function(unit, event, ...)
    if Unit.has_data(unit, "breed") and mod:get("sub_quest_07") and not mod:get("sub_quest_08") then
        local name = Unit.get_data(unit, "breed").name
        if name == "chaos_exalted_sorcerer" then
            local level_name = Managers.state.game_mode:level_key()
            if level_name == "ground_zero" then
                if string.find(event, "death") or string.find(event, "ragdoll") then 
                    local position = Vector3(363.476, 50.4658, -13.7107) 
                    local rot = radians_to_quaternion(0, -math.pi/2, 0)
                    local rotation =  Quaternion.multiply(Quaternion.from_elements(0,0,0,1), rot)
                    local unit_template_name = "interaction_unit"
                    local extension_init_data = {}
                    local artifact_unit = Managers.state.unit_spawner:spawn_network_unit("units/pickups/LA_artifact_corrupted_mesh", unit_template_name, 
                        extension_init_data, position, rotation)

                    LA_PICKUPS[artifact_unit] = LaPickupExtension:new(artifact_unit)
                end
                if string.find(event, "intro_lord") and not mod.halescourge_boss_debuff then 
                    mod.halescourge_boss_debuff = HalescourgeDebuff:new(unit)
                end
            end
        end
    end


    local inventory_extension = ScriptUnit.extension(unit, "inventory_system")
    if inventory_extension then
        local slot_data = inventory_extension:get_wielded_slot_data()
        if slot_data then
            local left_hand =  slot_data.left_hand_unit_name
            local right_hand = slot_data.right_hand_unit_name


            if right_hand then
                local sound_table = unit_sound_map[right_hand]
                if sound_table then
                    local sound_event = sound_table[event]
                    if sound_event then
                        if not sound_event.delay then
                            local world = Managers.world:world("level_world")
                            local wwise_world = Wwise.wwise_world(world)
                            local sound_id = WwiseWorld.trigger_event(wwise_world, sound_event.name, slot_data.right_unit_1p)
                        else 
                            local time = mod.time + sound_event.delay 
                            mod.delayed_sounds[sound_event.name] = {
                                time = time, 
                                unit = slot_data.right_unit_1p
                            }
                        end
                    end
                end
            end

            if left_hand then
                local sound_table = unit_sound_map[left_hand]
                if sound_table then
                    local sound_event = sound_table[event]
                    if sound_event then
                        if not sound_event.delay then
                            local world = Managers.world:world("level_world")
                            local wwise_world = Wwise.wwise_world(world)
                            local sound_id = WwiseWorld.trigger_event(wwise_world, sound_event.name, slot_data.left_unit_1p)
                        else 
                            local time = mod.time + sound_event.delay 
                            mod.delayed_sounds[sound_event.name] = {
                                time = time, 
                                unit = slot_data.left_unit_1p
                            }
                        end
                    end
                end
            end
        end
    end

end)

--for checking if the tomes and grims for sub quest 6 are collected
mod:hook(AdventureMechanism, "get_end_of_level_rewards_arguments", function (func, self, game_won, quickplay, statistics_db, stats_id)
    local current_level_key = Managers.level_transition_handler:get_current_level_keys()
    local collection_levels = require("scripts/mods/Loremasters-Armoury/achievements/official_book_collector")

    if mod:get("sub_quest_crate_tracker") then
        for level, tisch in pairs(collection_levels) do 
            if level == current_level_key then 
                local mission_system = Managers.state.entity:system("mission_system")
                local tome = mission_system:get_level_end_mission_data("tome_bonus_mission")
                local grimoire = mission_system:get_level_end_mission_data("grimoire_hidden_mission")

                if tome and grimoire then
                    if (tome.current_amount == tisch.tomes) and (grimoire.current_amount == tisch.grims) then
                    mod:set(tisch.quest, true)
                    end
                end
            end
        end
    end

    return func(self, game_won, quickplay, statistics_db, stats_id)
end)


--taken from the Casual Mode mod by Squatting Bear, these are used to run so the previously hooked function is ran and can check for tomes/grims
--https://github.com/Squatting-Bear/vermintide-mods/blob/development/casual_mode/scripts/mods/casual_mode/casual_mode.lua#L794
-- Pretend we are trusted so that the experience reward screen will be shown.
mod:hook_safe(StateInGameRunning, "on_enter", function(self, params)
	self._booted_eac_untrusted = false
end)

-- This hook is just to stop weaves crashing at the end screen.
mod:hook(StateInGameRunning, "_submit_weave_scores", function (self)
end)

-- Pretend we are trusted so that the end-mission rewards will be computed.
mod:hook(LevelEndViewBase, "init", function(orig_func, self, context)
	local real_eac_untrusted = script_data["eac-untrusted"]
	script_data["eac-untrusted"] = false
	orig_func(self, context)
	script_data["eac-untrusted"] = real_eac_untrusted
end)

-- Prevent the backend from being accessed, since we're not actually trusted.
mod:hook(BackendInterfaceLootPlayfab, "generate_end_of_level_loot", function(orig_func, self, ...)
	local fake_id = "loot!"
	self._loot_requests[fake_id] = {}
	return fake_id
end)

--setting up tables that contain data for the reward info of chalenges in Okri's Book
mod.LA_quest_rewards = {
    main_quest = {
		item_name = "main_quest_reward",
        reward_type = "item",
        unlocked_reward_icon =  "la_mq01_reward_main_icon_veteran",
        description = "la_mq01_reward_description",
        information_text = "info_text_la_mq01_reward",
        item_type = "weapon_skin",
        rarity = "unique",
	},
    sub_quest_prologue = {
		item_name = "sub_quest_prologue_reward",
        reward_type = "item",
        unlocked_reward_icon = "la_mq01_reward_prelude_icon",
	},
    sub_quest_01 = {
        item_name = "LA_locked_reward",
        reward_type = "item",
        unlocked_reward_icon = "la_mq01_reward_sub1_icon",
    },
    sub_quest_02 = {
        item_name = "LA_locked_reward",
        reward_type = "item",
        unlocked_reward_icon = "la_mq01_reward_sub1_icon",
    },
    sub_quest_03 = {
        item_name = "LA_locked_reward",
        reward_type = "item",
        unlocked_reward_icon = "la_mq01_reward_sub3_icon",
    },
    sub_quest_04 = {
        item_name = "LA_locked_reward",
        reward_type = "item",
        unlocked_reward_icon = "la_mq01_reward_sub3_icon",
    },
    sub_quest_05 = {
        item_name = "LA_locked_reward",
        reward_type = "item",
        unlocked_reward_icon = "la_mq01_reward_sub3_icon",
    },
    sub_quest_crate_tracker = {
        item_name = "LA_locked_reward",
        reward_type = "item",
        unlocked_reward_icon = "la_mq01_reward_sub1_icon",
    },
    sub_quest_06 = {
        item_name = "LA_locked_reward",
        reward_type = "item",
        unlocked_reward_icon = "la_mq01_reward_sub1_icon",
    },
    sub_quest_07 = {
        item_name = "LA_locked_reward",
        reward_type = "item",
        unlocked_reward_icon = "la_mq01_reward_sub7_icon",
    },
    sub_quest_08 = {
        item_name = "LA_locked_reward",
        reward_type = "item",
        unlocked_reward_icon = "la_mq01_reward_sub8_icon",
    },
    sub_quest_09 = {
        item_name = "LA_locked_reward",
        reward_type = "item",
        unlocked_reward_icon = "la_mq01_reward_sub9_icon",
    },
    sub_quest_10 = {
        item_name = "LA_locked_reward",
        reward_type = "item",
        unlocked_reward_icon = "la_mq01_reward_sub10_icon",
        rarity = "unique",
    },
}

for quest,data in pairs(mod.LA_quest_rewards) do 
    ItemMasterList[quest.."_reward"] = {
        display_name = quest.."_reward_name",
        inventory_icon = data.unlocked_reward_icon or "quest_icon_empty",
        rarity = data.rarity or "plentiful",
        item_type = data.item_type or quest.."_reward_desc",
        can_wield = CanWieldAllItemTemplates,
	    description = data.description,
        information_text = data.information_text,
        slot_type = data.slot_type,
        template = data.template,
        skin = data.skin or 'es_1h_sword_skin_02',
        matching_item_key = data.matching_item_key, 

    }
end

ItemMasterList["LA_locked_reward"] = {
    inventory_icon = "la_reward_lock_icon",
    rarity = "plentiful",
    item_type = "LA_locked_reward_desc",
    display_name = "LA_locked_reward_name",
    can_wield = CanWieldAllItemTemplates,
}

--this is needed to stop a crash from the reward item causign a crash in the okri's challenges UI
WeaponSkins.skins["main_quest_reward"] = {
    template = "one_handed_swords_template_1",
    right_hand_unit = "units/empire_sword/Kruber_KOTBS_empire_sword_01_mesh",
    display_name = "main_quest_reward_name",
    inventory_icon = "la_mq01_reward_main_icon_veteran",
    display_unit = "units/weapons/weapon_display/display_1h_swords",
    hud_icon = "la_mq01_reward_main_icon_veteran",
    rarity = "plentiful",
    description = "la_mq01_reward_description",
}
WeaponSkins.skins["main_quest_reward_02"] = {
    template = "one_handed_swords_template_1",
    right_hand_unit = "units/empire_sword/Kruber_KOTBS_empire_sword_01_mesh",
    display_name = "main_quest_reward_name",
    inventory_icon = "la_kotbs_greatsword_glow_reward_icon",
    display_unit = "units/weapons/weapon_display/display_1h_swords",
    hud_icon = "la_kotbs_greatsword_glow_reward_icon",
    rarity = "plentiful",
    description = "la_mq01_reward_description",
}
WeaponSkins.skins["main_quest_reward_03"] = {
    template = "one_handed_swords_template_1",
    right_hand_unit = "units/empire_sword/Kruber_KOTBS_empire_sword_01_mesh",
    display_name = "main_quest_reward_name",
    inventory_icon = "la_kotbs_wizardsword_glow_reward_icon",
    display_unit = "units/weapons/weapon_display/display_1h_swords",
    hud_icon = "la_kotbs_wizardsword_glow_reward_icon",
    rarity = "plentiful",
    description = "la_mq01_reward_description",
}
WeaponSkins.skins["main_quest_reward_04"] = {
    template = "one_handed_swords_template_1",
    right_hand_unit = "units/empire_sword/Kruber_KOTBS_empire_sword_01_mesh",
    display_name = "main_quest_reward_name",
    inventory_icon = "la_kotbs_firesword_glow_reward_icon",
    display_unit = "units/weapons/weapon_display/display_1h_swords",
    hud_icon = "la_kotbs_firesword_glow_reward_icon",
    rarity = "plentiful",
    description = "la_mq01_reward_description",
}


WeaponSkins.skins["quest_reward"] = {
    template = "one_handed_swords_template_1",
    right_hand_unit = "units/empire_sword/Kruber_KOTBS_empire_sword_01_mesh",
    display_name = "main_quesub_quest_reward_namest_reward_name",
    inventory_icon = "LA_Kotbs_sword_reward_icon",
    display_unit = "units/weapons/weapon_display/display_1h_swords",
    hud_icon = "LA_Kotbs_sword_reward_icon",
    rarity = "plentiful",
    description = "la_mq01_reward_description",
}
WeaponSkins.skins["quest_reward_02"] = {
    template = "one_handed_swords_template_1",
    right_hand_unit = "units/empire_sword/Kruber_KOTBS_empire_sword_01_mesh",
    display_name = "sub_quest_reward_name",
    inventory_icon = "la_kotbs_greatsword_reward_icon",
    display_unit = "units/weapons/weapon_display/display_1h_swords",
    hud_icon = "la_kotbs_greatsword_reward_icon",
    rarity = "plentiful",
    description = "la_mq01_reward_description",
}
WeaponSkins.skins["quest_reward_03"] = {
    template = "one_handed_swords_template_1",
    right_hand_unit = "units/empire_sword/Kruber_KOTBS_empire_sword_01_mesh",
    display_name = "sub_quest_reward_name",
    inventory_icon = "la_kotbs_wizardsword_reward_icon",
    display_unit = "units/weapons/weapon_display/display_1h_swords",
    hud_icon = "la_kotbs_wizardsword_reward_icon",
    rarity = "plentiful",
    description = "la_mq01_reward_description",
}
WeaponSkins.skins["quest_reward_04"] = {
    template = "one_handed_swords_template_1",
    right_hand_unit = "units/empire_sword/Kruber_KOTBS_empire_sword_01_mesh",
    display_name = "sub_quest_reward_name",
    inventory_icon = "la_kotbs_firesword_reward_icon",
    display_unit = "units/weapons/weapon_display/display_1h_swords",
    hud_icon = "la_kotbs_firesword_reward_icon",
    rarity = "plentiful",
    description = "la_mq01_reward_description",
}

--hook for showing proper item reward in okri's challenges
mod:hook(HeroViewStateAchievements,"_create_entries", function (func, self, entries, entry_type, entry_subtype)
    local quest_manager = self._quest_manager
	local achievement_manager = self._achievement_manager
    if entry_type == "quest" then
		
		manager = quest_manager
	else
		
		manager = achievement_manager
	end
    
    for i = 1, #entries, 1 do
        local entry_id = entries[i]
        local entry_data = manager:get_data_by_id(entry_id)

        if entry_data.id then
            if mod.LA_quest_rewards[entry_data.id] then 
                entry_data.reward = mod.LA_quest_rewards[entry_data.id]
            end
        end        
    end

    

    return func(self, entries, entry_type, entry_subtype)
end)

mod.spawned_in_units = {}

mod:hook(GameMechanismManager, "handle_level_load", function (func, self, done_again_during_loading)
    local current_level_key = Managers.level_transition_handler:get_current_level_key()
    --for reset the indicator that LA units have been spawned on the level
    mod.spawned_in_units[current_level_key] = nil
    return func(self, done_again_during_loading)
end)

mod:hook(UnitSpawner, "spawn_network_unit", function (func, self, unit_name, unit_template_name, extension_init_data, position, rotation, material)
    local level_name = Managers.level_transition_handler:get_current_level_keys()

    if level_name == "ground_zero" and not mod.halescourge_buff_applied and not mod.halescourge_buff then
        if mod:get("sub_quest_07") and not mod:get("sub_quest_08") then
            mod.halescourge_buff = HalescourgeBuff:new(self.world)
        end
    end

    if not mod.spawned_in_units[level_name] then
        mod.spawned_in_units[level_name] = true

        if mod.list_of_LA_levels[level_name] then 
            if not mod.list_of_LA_levels[level_name].collected then
                if (level_name == "military" and mod:get("sub_quest_prologue_letter_read")) or (level_name == "catacombs" and mod:get("sub_quest_prologue_letter_read")) or (level_name == "ussingen" and mod:get("sub_quest_prologue_letter_read")) then
                    if not mod:get("sub_quest_crate_tracker") then
                        local unit_template_name = "interaction_unit"
                        local extension_init_data = {}
                        local box_unit = Managers.state.unit_spawner:spawn_network_unit("units/pickups/Loremaster_shipment_box_mesh_real", unit_template_name, 
                            extension_init_data, mod.list_of_LA_levels[level_name].position:unbox(), Quaternion.from_elements(0,0,0,0))
                        LA_PICKUPS[box_unit] = LaPickupExtension:new(box_unit)
                    end
                end
            end
        end

        if mod.list_of_LA_levels_books[level_name] then
            if not mod.list_of_LA_levels_books[level_name].collected then
                if (level_name == "dlc_bastion")  and mod:get("sub_quest_06_letter_read") and not mod:get("sub_quest_07") then
                    local unit_template_name = "interaction_unit"
                    local extension_init_data = {}
                    local book_unit = Managers.state.unit_spawner:spawn_network_unit("units/pickups/LA_reikland_chronicle_mesh", unit_template_name, 
                        extension_init_data, mod.list_of_LA_levels_books[level_name].position:unbox(), mod.list_of_LA_levels_books[level_name].rotation:unbox())

                    LA_PICKUPS[book_unit] = LaPickupExtension:new(book_unit)
                end
            end
        end

        if level_name == "morris_hub" then
            
            local board_pos = Vector3(0, 0, 300)
            local board_rot = Quaternion.from_elements(0,0,0.376287, -0.926503)
            local world = Managers.world:world("level_world")
            local interactable_board_unit_name = "units/decorations/LA_message_board_mesh"
            local visible_board_unit_name = "units/decorations/LA_message_board_back_board"
            local letter_board = LetterBoard:new(interactable_board_unit_name, visible_board_unit_name, board_pos, board_rot, world)
            mod.letter_board = letter_board
            
            if mod:get("sub_quest_09_letter_read") then
                local position = Vector3(5.2, -9, -2.15)
                local rotation = Quaternion.from_elements(0,0,0,0)
                local box_unit = Managers.state.unit_spawner:spawn_local_unit("units/pickups/LA_artifact_gemstone_mesh", position, rotation)

                if not mod:get("sub_quest_10") then
                    local position = Vector3(4.32, -9.075, -1.8)
                    local rotation = radians_to_quaternion(math.pi*11/10, -math.pi*3/12, math.pi*1/12)
                    local sword_unit = Managers.state.unit_spawner:spawn_local_unit("units/empire_sword/Kruber_KOTBS_empire_sword_01_mesh_3p", position, rotation)
                    
                    local position = Vector3(4.8, -9.15, -2.0437)
                    local rotation = radians_to_quaternion(0, math.pi/16, 0)
                    local scroll_path = "units/pickups/Loremaster_magicscroll_interactor_mesh"
                    local unit_template_name = "interaction_unit"
                    local extension_init_data = {}
                    local scroll_unit, go_id = Managers.state.unit_spawner:spawn_network_unit(scroll_path, unit_template_name, extension_init_data, position, rotation)
                    Unit.set_local_scale(scroll_unit, 0, Vector3(0.75, 0.75, 0.75))

                    mod.scroll_unit = scroll_unit
                    mod.marker_list[scroll_unit] = Vector3Box(position)
                    mod.sword_unit = sword_unit

                end                            
            end

            if mod:get("sub_quest_10") then
                local position = Vector3(4.32, -9.075, -1.8)
                local rotation = radians_to_quaternion(math.pi*11/10, -math.pi*3/12, math.pi*1/12)
                local sword_unit = Managers.state.unit_spawner:spawn_local_unit("units/empire_sword/Kruber_KOTBS_empire_sword_01_mesh_gold_3p", position, rotation)
                if Unit.has_data(sword_unit, "use_vanilla_glow") then
                    local glow = Unit.get_data(sword_unit, "use_vanilla_glow")
                    GearUtils.apply_material_settings(sword_unit, WeaponMaterialSettingsTemplates[glow])
                end

                local position = Vector3(4.8, -9.15, -2.0437)
                local rotation = radians_to_quaternion(0, math.pi/16, 0)
                local scroll_unit = Managers.state.unit_spawner:spawn_local_unit("units/pickups/Loremaster_magicscroll_used_mesh", position, rotation)
                Unit.set_local_scale(scroll_unit, 0, Vector3(0.75, 0.75, 0.75))
            end

        end
        
        if string.find(level_name, "inn_level") then
            
            local board_pos = Vector3(24.17, -5.96, 27.2681)
            local board_rot = Quaternion.from_elements(0,0,0.376287, -0.926503)
            local world = Managers.world:world("level_world")
            local interactable_board_unit_name = "units/decorations/LA_message_board_mesh"
            local visible_board_unit_name = "units/decorations/LA_message_board_back_board"
            local letter_board = LetterBoard:new(interactable_board_unit_name, visible_board_unit_name, board_pos, board_rot, world)
            mod.letter_board = letter_board



            if mod:get("sub_quest_crate_tracker") then
                local position = Vector3(0.8, 7.7, 5.17543)
                local rotation = radians_to_quaternion(0,math.pi/8,0)
                local box_unit = Managers.state.unit_spawner:spawn_local_unit("units/decorations/Loremaster_shipment_storage_mesh", position, rotation)

                
                if not mod:get("sub_quest_10") then
                    local position = Vector3(1.8, 9.76, 7)
                    local rotation = radians_to_quaternion(math.pi,0,0)
                    local sword_unit = Managers.state.unit_spawner:spawn_local_unit("units/empire_sword/Kruber_KOTBS_empire_sword_01_mesh_3p", position, rotation)
                    
                    local position = Vector3(0.96, 6.55, 6.18)
                    local rotation = radians_to_quaternion(0,math.pi/4,0)
                    local extension_init_data = {}
                    local scroll_unit = Managers.state.unit_spawner:spawn_network_unit("units/decorations/Loremaster_magicscroll_rolled_mesh", "interaction_unit", extension_init_data, position, rotation)
                    Unit.set_local_scale(scroll_unit, 0, Vector3(0.75, 0.75, 0.75))
                end
            end
            if mod:get("sub_quest_07") then
                local position = Vector3(1, 6.835, 6.29282)
                local rotation = radians_to_quaternion(math.pi/2,-math.pi/12,math.pi/2)
                local extension_init_data = {}
                Managers.state.unit_spawner:spawn_network_unit("units/decorations/LA_reikland_chronicle_mesh", "interaction_unit", extension_init_data, position, rotation)
            end
            if mod:get("sub_quest_08") and not mod:get("sub_quest_09") then
                local position = Vector3(1.32, 6.5, 6.15)
                local rotation = radians_to_quaternion(0,math.pi/8,0)
                local extension_init_data = {}
                Managers.state.unit_spawner:spawn_network_unit("units/decorations/LA_artifact_corrupted_mesh", "interaction_unit", extension_init_data, position, rotation)
            end
            if mod:get("sub_quest_09") then
                local position = Vector3(1.32, 6.5, 6.15)
                local rotation = radians_to_quaternion(0,math.pi/8,0)
                local extension_init_data = {}
                Managers.state.unit_spawner:spawn_network_unit("units/decorations/LA_artifact_mesh", "interaction_unit", extension_init_data, position, rotation)
            end
            if mod:get("sub_quest_10") then
                local position = Vector3(1.8, 9.76, 7)
                local rotation = radians_to_quaternion(math.pi,0,0)
                local sword_unit = Managers.state.unit_spawner:spawn_local_unit("units/empire_sword/Kruber_KOTBS_empire_sword_01_mesh_gold_3p", position, rotation)
                if Unit.has_data(sword_unit, "use_vanilla_glow") then
                    local glow = Unit.get_data(sword_unit, "use_vanilla_glow")
                    GearUtils.apply_material_settings(sword_unit, WeaponMaterialSettingsTemplates[glow])
                end
            end
        end

        if string.find(level_name, "arena_citadel") and mod:get("sub_quest_08") and not mod:get("sub_quest_09") then
            local position = Vector3(0.6, 34.85, 13.56)
            local rotation = Quaternion.from_elements(0,0,0,0)
            local gem_unit = Managers.state.unit_spawner:spawn_local_unit("units/pickups/LA_artifact_gemstone_mesh", position, rotation)
        end


    end
    return func(self, unit_name, unit_template_name, extension_init_data, position, rotation, material)
end)

-- =========================================================================================
-- =========================================================================================
-- =========================================================================================
-- =========================================================================================
-- =========================================================================================
-- =========================================================================================
-- =========================================================================================
-- =========================================================================================
-- =========================================================================================

mod:hook(HeroViewStateAchievements,"draw", function (func, self, input_service, dt)
    
    if self._achievement_widgets then
        for _,widget in pairs(self._achievement_widgets) do
            for quest, status in pairs(mod.main_quest) do 
                if widget.content.title == mod:localize(quest) then
                    if status then
                        widget.content.claimed = true
                    end
                end
            end
            if widget.content.title == mod:localize("main_quest") then
                if mod.main_quest_completed then
                    widget.content.claimed = true
                end
            end
        end
    end
    -- self._achievement_widgets[1].content.progress_text
    return func(self, input_service, dt)
end)


-- =========================================================================================
-- =========================================================================================
-- =========================================================================================
-- =========================================================================================
-- =========================================================================================
-- =========================================================================================
-- =========================================================================================
-- =========================================================================================
-- =========================================================================================



mod:hook(AchievementManager,"outline", function (func, self)
    if not self.initialized then
		return nil, "AchievementManager not initialized"
	end
    local outline = require("scripts/mods/Loremasters-Armoury/achievements/outline")
	return outline
end)

mod:hook(AchievementManager,"get_entries_from_category", function (func, self, in_category_id)
	local outline = require("scripts/mods/Loremasters-Armoury/achievements/outline")
    return self:_search_sub_categories(outline.categories, in_category_id)
end)


mod:hook(AchievementManager,"setup_achievement_data", function (func, self)
	if not self._enabled then
		return
	end

	if not self.initialized then
		return nil, "AchievementManager not initialized"
	end

	local function setup_achievement_data_from_categories(achievement_manager, categories)
		for i, category in ipairs(categories) do
			if category.categories then
				setup_achievement_data_from_categories(achievement_manager, category.categories)
			end

			if category.entries then
				achievement_manager:setup_achievement_data_from_list(category.entries)
			end
		end
	end
    local outline = require("scripts/mods/Loremasters-Armoury/achievements/outline")
	setup_achievement_data_from_categories(self, outline.categories)
end)


--this hook is for generating the marker when close to a LA quest pickup
--genral idea inspired by the waypoints in https://github.com/badwin-vt/waypoints
mod:hook(MatchmakingManager, "update", function(func, self, dt, ...)
    
    for scrap_id, units in pairs(mod.attached_units) do 
        if Unit.alive(units.target) then
            local position = Unit.world_position(units.target, 0)
            local pos_box = Vector3Box(position)
            mod.render_marker(pos_box, 2)
        else 
            mod.attached_units[scrap_id] = nil
        end
    end

    func(self, dt, ...)
end)



--this is needed to prevent the OutlineSystem from crashing when remvoing the custom LA pickups
mod:hook(OutlineSystem,"outline_unit", function (func, self, unit, flag, channel, do_outline, apply_method)
    if not Unit.alive(unit) then
        return 
    end
    return func(self, unit, flag, channel, do_outline, apply_method)
end)


mod.LA_new_interactors = {
    "units/pickups/LA_reikland_chronicle_mesh",
    "units/decorations/LA_reikland_chronicle_mesh",
    "units/pickups/LA_artifact_corrupted_mesh",
    "units/decorations/LA_artifact_corrupted_mesh",
    "units/pickups/LA_artifact_mesh",
    "units/decorations/LA_artifact_mesh",
    "units/decorations/LA_message_board_mesh",
    "units/decorations/LA_loremaster_message_large",
    "units/decorations/LA_loremaster_message_medium",
    "units/decorations/LA_loremaster_message_small",
    "units/decorations/letters/LA_quest_message_stage01",
    "units/decorations/letters/LA_quest_message_stage02",
    "units/decorations/letters/LA_quest_message_stage03",
    "units/decorations/letters/LA_quest_message_stage04",
    "units/decorations/letters/LA_quest_message_stage05",
    "units/decorations/letters/LA_quest_message_stage06",
    "units/decorations/letters/LA_quest_message_stage07",
    "units/decorations/letters/LA_quest_message_stage08",
    "units/decorations/letters/LA_quest_message_stage09",
    "units/decorations/letters/LA_quest_message_stage10",
    "units/decorations/Loremaster_magicscroll_rolled_mesh",
    "units/pickups/Loremaster_magicscroll_interactor_mesh",
    "units/pickups/Loremaster_shipment_box_mesh_real",
}


--overloading the "1" key as I don't want the netlookup tables to be different across users 
for k,v in pairs(mod.LA_new_interactors) do 
    NetworkLookup.husks[v] = 1
    mod.LA_new_interactors[v] = v
end




mod:hook(InteractionDefinitions.pictureframe.client, "can_interact", function (func, interactor_unit, interactable_unit, data, config)
	
    if Unit.has_data(interactable_unit, "unit_name") then
        local unit_name = Unit.get_data(interactable_unit, "unit_name")
        if mod.LA_new_interactors[unit_name] then
            return true
        end
    end
    return func(interactor_unit, interactable_unit, data, config)
end)

mod:hook(InteractionDefinitions.pictureframe.client, "stop", function (func, world, interactor_unit, interactable_unit, data, config, t, result)
	
    if Unit.has_data(interactable_unit, "unit_name") then
        local unit_name = Unit.get_data(interactable_unit, "unit_name")
        if mod.LA_new_interactors[unit_name] then
            -- Managers.ui:handle_transition("hero_view_force", {
            --     type = "painting",
            --     menu_state_name = "keep_decorations",
            --     use_fade = true,
            --     interactable_unit = interactable_unit
            -- })
            -- mod:handle_transition("open_quest_board_letter_view")
            mod:handle_transition("open_quest_board_letter_view")
            mod.interactable_unit = interactable_unit
            return
        end
    end
    return func(world, interactor_unit, interactable_unit, data, config, t, result)
end)

mod:hook_safe(LevelEndView, "start", function(self)
    for level,quest in pairs(level_quest_table) do 
        if mod:get(quest.."_temp") then
            if self.game_won then
                mod:set(quest, true)
                if mod.list_of_LA_levels[level] then
                    mod.list_of_LA_levels[level].compelted = true
                end
                if mod.list_of_LA_levels_books[level] then
                    mod.list_of_LA_levels_books[level].compelted = true
                end
            end
        end
    end
end)

mod:hook_safe(LevelTransitionHandler,"load_current_level", function (self)
    for level,quest in pairs(level_quest_table) do 
        mod:set(quest.."_temp", false)
    end
end)





mod.approve_request = false
mod.interactor_goid = nil

mod:hook(InteractableSystem, "rpc_generic_interaction_request", function (func, self, channel_id, interactor_go_id, interactable_go_id, is_level_unit, interaction_type_id)
    local interactable_unit = self.unit_storage:unit(interactable_go_id)
    
    if interactable_unit then
        if Unit.has_data(interactable_unit, "unit_name") then
            local unit_name = Unit.get_data(interactable_unit, "unit_name")

            if mod.LA_new_interactors[unit_name] then
                local interactor_unit = self.unit_storage:unit(interactor_go_id)
                local interactor_extension = ScriptUnit.extension(interactor_unit, "interactor_system")
                local interaction_type = NetworkLookup.interactions[interaction_type_id]
                interactor_extension:interaction_approved(interaction_type, interactable_unit)

                local interactable_extension = ScriptUnit.extension(interactable_unit, "interactable_system")

                mod.approve_request = true
                mod.interactor_goid = interactor_go_id

                return 
            end
        end
    end
    return func(self, channel_id, interactor_go_id, interactable_go_id, is_level_unit, interaction_type_id)
end)

mod:hook(GenericUnitInteractableExtension,"set_is_being_interacted_with",function (func, self, interactor_unit, interaction_result)
    
    

    if mod.approve_request then 
        mod.approve_request = false
        interactor_unit = Managers.state.unit_storage:unit(mod.interactor_goid)
        mod.interactor_goid = nil
        
    end

    if mod.unit_is_being_interacted_with then
        
        if not self.interactor_unit then
            self.interactor_unit = Managers.state.unit_storage:unit(mod.interactor_goid)
        else
            interactor_unit = nil
        end
        mod.unit_is_being_interacted_with = false 
    end
    mod.unit_is_being_interacted_with = true

    return func(self, interactor_unit, interaction_result)
end)

mod:hook(GenericUnitInteractorExtension,"start_interaction", function (func, self, hold_input, interactable_unit, interaction_type, forced)

    local interaction_context = self.interaction_context
    local network_manager = Managers.state.network
    if not interaction_context.interactable_unit then
        return func(self, hold_input, interactable_unit, interaction_type, forced)
    end
    local interactable_go_id, is_level_unit = network_manager:game_object_or_level_id(interaction_context.interactable_unit)
    local unit = self.unit

    if interactable_go_id == nil then
        if interactable_unit then 

            local interaction_data = interaction_context.data
            local interactor_data = interaction_data.interactor_data
            local interaction_template = InteractionDefinitions[interaction_type]
            local client_functions = interaction_template.client

            table.clear(interactor_data)

            if client_functions.set_interactor_data then
                client_functions.set_interactor_data(unit, interactable_unit, interactor_data)
            end

            self.state = "waiting_for_confirmation"
            return
        end
    end

    return func(self, hold_input, interactable_unit, interaction_type, forced)
end)


--used to replace the trophy UI sound for LA trophies and letters



--swaps the background in the UI when intereacting with the listed units

-- ================================================================================================================================
-- ================================================================================================================================
-- ================================================================================================================================
-- ================================================================================================================================
-- ================================================================================================================================
-- ================================================================================================================================
-- ================================================================================================================================
-- ================================================================================================================================
-- ================================================================================================================================
-- ================================================================================================================================
-- ================================================================================================================================


mod:hook(ScriptUnit, "extension", function (func, unit, system)
    if system == "keep_decoration_system" then
        if mod.letter_board then
            if mod.letter_board:unit() == unit then
                return mod.letter_board
            end
        end
    end
    return func(unit, system)
end)

mod.list_order = {
    -- "test_painting",
    -- "test_quest_select",
    "main_01",
}

mod.painting = {
    test_painting = {
        -- sound_event = "painting_warriors_of_chaos_page_17_description",
        sound_event = "Loremaster_letter_open_sound__1_",
        rarity = "common",
        display_name = "test_quest",
        icon = "icon_painting_2",
        frame = "painted",
        description = "test_quest_desc",
        artist = "signature",
        orientation = "vertical",
        frames = {
            gold = true,
            paint = true,
            wood = true
        }
    },
    test_quest_select = {
        -- sound_event = "painting_warriors_of_chaos_page_46_description",
        sound_event = "Loremaster_letter_open_sound__1_",
        rarity = "common",
        display_name = "test_quest_select",
        icon = "icon_painting_2",
        frame = "wood",
        description = "test_quest_select_desc",
        artist = "test_quest_select_signature",
        orientation = "vertical",
        frames = {
            gold = true,
            paint = true,
            wood = true
        }
    },
    main_01 = {
        sound_event = "Loremaster_letter_open_sound__1_",
        rarity = "common",
        display_name = "main_01",
        icon = "icon_painting_2",
        frame = "wood",
        description = "main_01_desc",
        artist = "main_01_signature",
        orientation = "vertical",
        frames = {
            gold = true,
            paint = true,
            wood = true
        }
    },
}


local letterUnits = {
    "units/decorations/LA_message_board_mesh",
    "units/decorations/LA_loremaster_message_large",
    "units/decorations/LA_loremaster_message_medium",
    "units/decorations/LA_loremaster_message_small",
    "units/decorations/letters/LA_quest_message_stage01",
    "units/decorations/letters/LA_quest_message_stage02",
    "units/decorations/letters/LA_quest_message_stage03",
    "units/decorations/letters/LA_quest_message_stage04",
    "units/decorations/letters/LA_quest_message_stage05",
    "units/decorations/letters/LA_quest_message_stage06",
    "units/decorations/letters/LA_quest_message_stage07",
    "units/decorations/letters/LA_quest_message_stage08",
    "units/decorations/letters/LA_quest_message_stage09",
    "units/decorations/letters/LA_quest_message_stage10",
}
for k,v in pairs(letterUnits) do 
    letterUnits[v] = v
end

mod.og_pass = nil
mod:hook(HeroViewStateKeepDecorations, "draw", function (func, self, input_service, dt)
    local unit = self._interactable_unit    

    if Unit.has_data(unit, "unit_name") then
        local unit_name = Unit.get_data(unit, "unit_name")
        mod.og_pass = table.clone(self._widgets[4].element, false)
        if letterUnits[unit_name] then
            self._widgets[4].content.texture_id = "paper_back"
            self._widgets[4].element.passes[1].pass_type = "texture"
            self._widgets[4].element.passes[1].texture_id = "texture_id"
            self._widgets[4].element.passes[1].style_id = "texture_id"
        else
            self._widgets[4].element.passes = table.clone(mod.og_pass, false)
        end
    else 
        if not mod.og_pass and self._widgets[4].element then
            mod.og_pass = table.clone(self._widgets[4].element, false)
        end
        self._widgets[4].element.passes = table.clone(mod.og_pass, false)
    end 
    return func(self, input_service, dt)
end)

mod.parameters = nil
mod:hook(HeroViewStateKeepDecorations, "_create_ui_elements", function(func, self, params)
    
    mod.parameters = params
    

    return func(self, params)
end)


mod:hook(HeroViewStateKeepDecorations, "on_enter", function (func, self, params)
    local state_params = params.state_params
    local unit = state_params.interactable_unit
    
    if unit then
        local unit_name = Unit.get_data(unit, "unit_name")
        if unit_name then
            if letterUnits[unit_name] then
                
                print("[HeroViewState] Enter Substate HeroViewStateKeepDecorations")

                self.parent = params.parent
                local ingame_ui_context = params.ingame_ui_context
                self.ingame_ui_context = ingame_ui_context
                self._ui_renderer = ingame_ui_context.ui_renderer
                self._ui_top_renderer = ingame_ui_context.ui_top_renderer
                self._input_manager = ingame_ui_context.input_manager
                self._voting_manager = ingame_ui_context.voting_manager
                self._render_settings = {
                    snap_pixel_positions = true
                }
                self._wwise_world = params.wwise_world
                self._is_server = ingame_ui_context.is_server
                local input_service = self:input_service()
                self._menu_input_description = MenuInputDescriptionUI:new(ingame_ui_context, self._ui_top_renderer, input_service, 3, 100, generic_input_actions)

                self._menu_input_description:set_input_description(nil)

                self._animations = {}
                self._ui_animations = {}
                self._decoration_system = mod.letter_board
                self._keep_decoration_backend_interface = Managers.backend:get_interface("keep_decorations")

                self:_create_ui_elements(params)

                if params.initial_state then
                    params.initial_state = nil

                    self:_start_transition_animation("on_enter", "on_enter")
                end

                self:_play_sound("Loremaster_letter_open_sound__1_")

                local state_params = params.state_params
                local interactable_unit = state_params.interactable_unit
                self._interactable_unit = interactable_unit
                self._type = state_params.type

                if self._type == "painting" then
                    self._default_table = mod.painting
                    self._main_table = mod.painting
                    self._ordered_table = mod.list_order
                    self._empty_decoration_name = Unit.get_data(interactable_unit, "current_quest")
                elseif self._type == "trophy" then
                    self._default_table = DefaultTrophies
                    self._main_table = Trophies
                    self._ordered_table = TrophyOrder
                    self._empty_decoration_name = "hub_trophy_empty"
                end


                self._default_decorations = {}

                table.append(self._default_decorations, DefaultPaintings)
                table.append(self._default_decorations, DefaultTrophies)

                local camera_interaction_name = Unit.get_data(interactable_unit, "interaction_data", "camera_interaction_name")
                local hide_character = Unit.get_data(interactable_unit, "interaction_data", "hide_character")
                self._hide_character = hide_character
                local player = Managers.player:local_player()

                if player then
                    UISettings.map.camera_time_enter = Unit.get_data(interactable_unit, "interaction_data", "camera_transition_time_in") or 0.5
                    UISettings.map.camera_time_exit = Unit.get_data(interactable_unit, "interaction_data", "camera_transition_time_out") or 0.5
                    local params = {
                        camera_interaction_name = camera_interaction_name
                    }

                    CharacterStateHelper.change_camera_state(player, "camera_state_interaction", params)

                    local player_unit = player.player_unit

                    if Unit.alive(player_unit) then
                        local first_person_extension = ScriptUnit.extension(player_unit, "first_person_system")

                        first_person_extension:abort_toggle_visibility_timer()
                        first_person_extension:abort_first_person_units_visibility_timer()

                        if hide_character then
                            if not first_person_extension:first_person_mode_active() then
                                first_person_extension:set_first_person_mode(true)
                            end

                            if first_person_extension:first_person_units_visible() then
                                first_person_extension:toggle_first_person_units_visibility("third_person_mode")
                            end
                        elseif first_person_extension:first_person_mode_active() then
                            first_person_extension:set_first_person_mode(false)
                        end
                    end
                end

                local decoration_settings_key = Unit.get_data(interactable_unit, "decoration_settings_key")

                if decoration_settings_key then
                    local keep_decoration_extension = ScriptUnit.extension(interactable_unit, "keep_decoration_system")
                    local selected_decoration = keep_decoration_extension:get_selected_decoration()
                    self._keep_decoration_extension = keep_decoration_extension
                    local view_only = Unit.get_data(interactable_unit, "interaction_data", "view_only") or not self._is_server

                    if view_only then
                        self:_set_info_by_decoration_key(selected_decoration, false)
                    else
                        self._customizable_decoration = true

                        self:_setup_decorations_list()

                        local start_index = 1
                        local widgets = self._list_widgets

                        for i = 1, #widgets, 1 do
                            if widgets[i].content.key == selected_decoration then
                                start_index = i

                                break
                            end
                        end

                        self:_on_list_index_selected(start_index)

                        local start_scroll_percentage = self:_get_scrollbar_percentage_by_index(start_index)

                        self._scrollbar_logic:set_scroll_percentage(start_scroll_percentage)
                    end
                else
                    self:_initialize_simple_decoration_preview()
                end

                if not self._customizable_decoration then
                    self:_disable_list_widgets()
                end






                return

            end
        end
    end

    return func(self, params)
end)



local LIST_SPACING = 4
local definitions = local_require("scripts/ui/views/hero_view/states/definitions/hero_view_state_keep_decorations_definitions")
local widget_definitions = definitions.widgets_definitions
local scenegraph_definition = definitions.scenegraph_definition
local generic_input_actions = definitions.generic_input_actions
local animation_definitions = definitions.animation_definitions
local entry_widget_definition = definitions.entry_widget_definition
local dummy_entry_widget_definition = definitions.dummy_entry_widget_definition
local input_actions = definitions.input_actions
mod:hook(HeroViewStateKeepDecorations, "_setup_decorations_list", function (func, self)
    local unit = self._interactable_unit    
    if unit then
        local unit_name = Unit.get_data(unit, "unit_name")
        if unit_name then
            if letterUnits[unit_name] then
                local widgets = {}
                local index = 0
                for _, key in ipairs(mod.list_order) do
                    if true then
                        local settings = self._main_table[key]
                        if settings then
                            local unlocked = true
                            local display_name = Localize(settings.display_name)
                            local new = ItemHelper.is_new_keep_decoration_id(key)
                            if unlocked then
                                local widget = UIWidget.init(entry_widget_definition)
                                index = index + 1
                                widgets[index] = widget
                                local content = widget.content
                                local style = widget.style
                                local title = display_name
                                local title_style = style.title
                                local max_text_width = title_style.size[1] - 10
                                content.title = UIRenderer.crop_text_width(self._ui_renderer, title, max_text_width, title_style)
                                content.key = key
                                content.locked = false
                                content.new = new
                                content.in_use = self._decoration_system:is_decoration_in_use(key)
                                -- content.in_use = false
                            end
                        end
                    end
                end
                table.sort(widgets, function (a, b)
                    local a_content = a.content
                    local b_content = b.content

                    if a_content.new ~= b_content.new then
                        return a_content.new
                    end

                    return Localize(a_content.title) < Localize(b_content.title)
                end)
                self._list_widgets = widgets
                self._dummy_list_widgets = {}
                self:_align_list_widgets()
                local content_length = self._total_list_height
                local list_scrollbar_size = scenegraph_definition.list_scrollbar.size
                local scrollbar_length = list_scrollbar_size[2]
                local dummy_list_widgets = {}
                if content_length < scrollbar_length then
                    local dummy_count = 0
                    local dummy_height = LIST_SPACING

                    while scrollbar_length > content_length + dummy_height do
                        dummy_count = dummy_count + 1
                        local widget = UIWidget.init(dummy_entry_widget_definition)

                        table.insert(dummy_list_widgets, widget)

                        local content = widget.content
                        local size = content.size
                        local height = size[2]
                        dummy_height = dummy_height + height + LIST_SPACING
                    end
                end
                self._dummy_list_widgets = dummy_list_widgets
                self:_align_list_widgets()
                self:_initialize_scrollbar()
                self:_update_equipped_widget()

                return
            end
        end
    end 
    return func(self)
end)



-- ================================================================================================================================
-- ================================================================================================================================
-- ================================================================================================================================
-- ================================================================================================================================
-- ================================================================================================================================
-- ================================================================================================================================
-- ================================================================================================================================
-- ================================================================================================================================
-- ================================================================================================================================
-- ================================================================================================================================
-- ================================================================================================================================


--temp fix for clients errors when using mod
mod:hook(GameSession, "create_game_object", function( func, self, type, fields)
    if (not self ) then
        math.randomseed(1)
        return math.random(400, 500)
    end
    return func(self, type, fields)
end)



mod:hook(LocalizationManager, "_base_lookup", function (func, self, text_id)
    if not string.find(mod:localize(text_id), "<") then
        return mod:localize(text_id)
    end

	return func(self, text_id)
end)

