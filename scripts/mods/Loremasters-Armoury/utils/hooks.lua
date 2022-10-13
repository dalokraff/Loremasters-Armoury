local mod = get_mod("Loremasters-Armoury")
mod:dofile("scripts/mods/Loremasters-Armoury/utils/funcs")
mod:dofile("scripts/mods/Loremasters-Armoury/achievements/crate_locations")
mod:dofile("scripts/mods/Loremasters-Armoury/achievements/book_locations")
mod:dofile("scripts/mods/Loremasters-Armoury/achievements/pickup_marker")

require("scripts/managers/achievements/achievement_templates")
mod:dofile("scripts/mods/Loremasters-Armoury/achievements/achievements")




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


    if data_melee and data_range then
        local list_units = {
            data_melee.right_unit_1p,
            data_melee.right_unit_3p,
            data_range.right_unit_1p,
            data_range.right_unit_3p,
            data_melee.left_unit_1p,
            data_melee.left_unit_3p,
            data_range.left_unit_1p,
            data_range.left_unit_3p,
        }

        for _,unit in pairs(list_units) do
            if Unit.alive(unit) then
                if Unit.has_data(unit, "use_vanilla_glow") then
                    local glow = Unit.get_data(unit, "use_vanilla_glow")
                    GearUtils.apply_material_settings(unit, WeaponMaterialSettingsTemplates[glow])
                end
            end
        end
    end


    return func(self, backend_id)
end)



mod:hook(SimpleInventoryExtension, "_get_no_wield_required_property_and_trait_buffs", function (func, self, backend_id)
    local data_melee = self.recently_acquired_list["slot_melee"]
    local data_range = self.recently_acquired_list["slot_ranged"]
    GearUtils.apply_material_settings(data_melee.right_unit_1p, WeaponMaterialSettingsTemplates.golden_glow)
    mod:echo(data_melee.right_unit_1p)
    -- for k,v in pairs(data_melee) do
    --     mod:echo(k)
    --     mod:echo(v)
    -- end

    return func(self, backend_id)
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
            -- mod:echo(go_id)
            if mod.attached_units[go_id] then 
                -- mod:echo(mod.attached_units[go_id].target)
                
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
            -- message = string.format(new_mesage, ...)
            -- message = new_mesage
            return new_mesage
        end
    end

    return func(message, ...)
end)

mod:hook(PickupSystem, 'rpc_spawn_pickup_with_physics', function (func, self, channel_id, pickup_name_id, position, rotation, spawn_type_id)
    local pickup_name = NetworkLookup.pickup_names[pickup_name_id]
    local level_name = Managers.state.game_mode:level_key()
    
    --for spawning the crate pickup
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
                
                local scrap_unit, scrap_go_id = self:_spawn_pickup(pickup_settings, pickup_name, position, rotation, true, spawn_type)
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

                return 
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
                local scrap_unit, scrap_go_id = self:_spawn_pickup(pickup_settings, pickup_name, position, rotation, true, spawn_type)
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

                return 
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
                local scrap_unit, scrap_go_id = self:_spawn_pickup(pickup_settings, pickup_name, position, rotation, true, spawn_type)
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

                return 
            end
        end
    end

    return func(self, channel_id, pickup_name_id, position, rotation, spawn_type_id)
end)

--checks if citadel expidition has been finished
mod:hook(StatisticsUtil, "_register_completed_journey_difficulty", function (func, statistics_db, player, journey_name, dominant_god, difficulty_name)
    -- mod:echo(journey_name)

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
        -- mod:echo(hud_description)
        -- mod:echo(level_name)
        if (hud_description == "deus_hub_lore_interact_myrmidia") and (level_name == "morris_hub") then
            if mod:get("sub_quest_09") then 
                if (mod:get("sub_quest_01") > 500) and (mod:get("sub_quest_02") > 500) then
                    mod:set("sub_quest_10", true)
                end
            end
        end
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
mod:hook_safe(Unit, "animation_event", function(unit, event)

    if Unit.has_data(unit, "breed") and mod:get("sub_quest_07") then
        local name = Unit.get_data(unit, "breed").name
        if name == "chaos_exalted_sorcerer" then
            local level_name = Managers.state.game_mode:level_key()
            -- mod:echo(level_name)
            if level_name == "ground_zero" then
                if string.find(event, "death") or string.find(event, "ragdoll") then 
                    local position = Vector3(363.476, 50.4658, -13.7107) 
                    local rot = radians_to_quaternion(0, -math.pi/2, 0)
                    local rotation =  Quaternion.multiply(Quaternion.from_elements(0,0,0,1), rot)
                    -- mod:echo(position)
                    -- mod:echo(unit)
                    mod.stored_vectors[level_name] = Vector3Box(position)
                    Managers.state.network.network_transmit:send_rpc_server(
                            "rpc_spawn_pickup_with_physics",
                            NetworkLookup.pickup_names["painting_scrap"],
                            position,
                            rotation,
                            NetworkLookup.pickup_spawn_types['dropped']
                        )
                end
            end
        end
    end
end)

--for checking if the tomes and grims for sub quest 6 are collected
mod:hook(AdventureMechanism, "get_end_of_level_rewards_arguments", function (func, self, game_won, quickplay, statistics_db, stats_id)
    local current_level_key = Managers.level_transition_handler:get_current_level_keys()
    local collection_levels = require("scripts/mods/Loremasters-Armoury/achievements/official_book_collector")

    if mod:get("sub_quest_05") then
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

--setting up tables that contain data for the reward info of chalenges in Okri's Book
mod.LA_quest_rewards = {
    main_quest = {
		item_name = "main_quest_reward",
        reward_type = "item",
        unlocked_reward_icon =  "la_mq01_reward_main_icon_veteran",
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
    },
}

for quest,data in pairs(mod.LA_quest_rewards) do 
    ItemMasterList[quest.."_reward"] = {
        display_name = quest.."_reward_name",
        inventory_icon = data.unlocked_reward_icon or "quest_icon_empty",
        rarity = "plentiful",
        item_type = quest.."_reward_desc",
        can_wield = CanWieldAllItemTemplates
    }
end

ItemMasterList["LA_locked_reward"] = {
    inventory_icon = "la_reward_lock_icon",
    rarity = "plentiful",
    item_type = "LA_locked_reward_desc",
    display_name = "LA_locked_reward_name",
    can_wield = CanWieldAllItemTemplates
}

--hook for showing proper item reward in okri's challenges
mod:hook(HeroViewStateAchievements,"_create_entries", function (func, self, entries, entry_type, entry_subtype)
    local quest_manager = self._quest_manager
	local achievement_manager = self._achievement_manager
    -- mod:echo(entry_type)
    if entry_type == "quest" then
		
		manager = quest_manager
	else
		
		manager = achievement_manager
	end
    
    for i = 1, #entries, 1 do
        local entry_id = entries[i]
        -- mod:echo(entry_id)
        local entry_data = manager:get_data_by_id(entry_id)

        if entry_data.id then
            if mod.LA_quest_rewards[entry_data.id] then 
                entry_data.reward = mod.LA_quest_rewards[entry_data.id]
            end
        end        
    end

    

    return func(self, entries, entry_type, entry_subtype)
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
-- mod:echo(Localize("achv_menu_reward_claimed_title"))



-- mod:hook_safe(HeroViewStateAchievements,"create_ui_elements", function (self, params)
--     local quest_manager = self._quest_manager
-- 	local achievement_manager = self._achievement_manager
--     -- mod:echo(entry_type)
--     if entry_type == "quest" then
		
-- 		manager = quest_manager
-- 	else
		
-- 		manager = achievement_manager
-- 	end

--     for i = 1, #entries, 1 do
--         local entry_id = entries[i]
--         local entry_data = manager:get_data_by_id(entry_id)
--         entry_data.completed = true
--         entry_data.claimed = true
--         -- if entry_data.id then
--         --     if lamod.LA_quest_rewards[entry_data.id] then 
--         --         entry_data.reward = lamod.LA_quest_rewards[entry_data.id]
--         --         entry_data.completed = true
--         --         entry_data.claimed = true
--         --     end
--         -- end        
--     end

-- end)


-- local lamod = get_mod("Loremasters-Armoury")
-- mod:hook(HeroViewStateAchievements,"_create_entries", function (func, self, entries, entry_type, entry_subtype)
--     local quest_manager = self._quest_manager
-- 	local achievement_manager = self._achievement_manager

    
--     local needle = self._search_query
--     local query = self._search_widgets_by_name.filters.content.query
--     needle = SearchUtils.extract_queries(needle, UISettings.achievement_search_definitions, query)
--     -- mod:echo(entry_type)
--     if entry_type == "quest" then
		
-- 		manager = quest_manager
-- 	else
		
-- 		manager = achievement_manager
-- 	end
    
--     for i = 1, #entries, 1 do
--         local entry_id = entries[i]
--         -- mod:echo(entry_id)
--         local entry_data = manager:get_data_by_id(entry_id)
--         -- entry_data.completed = true
--         -- entry_data.claimed = true
--         if entry_data.id then
--             if lamod.LA_quest_rewards[entry_data.id] then 
--                 entry_data.reward = lamod.LA_quest_rewards[entry_data.id]
--                 -- entry_data.completed = true
--                 -- entry_data.claimed = true
--                 -- self._widgets[4].content.texture_id = "paper_back"
--                 -- self._widgets[4].element.passes[1].pass_type = "texture"
--                 -- self._widgets[4].element.passes[1].texture_id = "texture_id"
--                 -- self._widgets[4].element.passes[1].style_id = "texture_id"    

--             end

--             -- local reward = entry_data.reward
--             -- if reward then
--             --     mod:echo(tostring(type(reward)).."      "..tostring(reward))
--             -- end
--             -- if entry_data.completed then
--             --     for k,v in pairs(entry_data.reward) do
--             --         -- mod:echo(tostring(k).."     "..tostring(v))
--             --         -- for i,j in pairs(self._achievement_widgets[1].content) do
--             --         --     mod:echo(tostring(i).."     "..tostring(j))
--             --         -- end
--             --     end
--             --     mod:echo("=====================================================")
--             -- end
--         end
        


--     end
--     self._achievement_widgets[1].content.claimed = true
--     for i,j in pairs(self._achievement_widgets[1].content) do
--         mod:echo(tostring(i).."     "..tostring(j))
--     end
--     -- for i,j in pairs(self._achievement_widgets[1].element.pass_data[13]) do
--     --     mod:echo(tostring(i).."     "..tostring(j))
--     -- end
--     -- for i,j in pairs(self._achievement_widgets[1].element.pass_data[14]) do
--     --     mod:echo(tostring(i).."     "..tostring(j))
--     -- end
--     -- for i,j in pairs(self._achievement_widgets[1].element.pass_data[15]) do
--     --     mod:echo(tostring(i).."     "..tostring(j))
--     -- end
--     -- for i,j in pairs(self._achievement_widgets[1].element.pass_data[16]) do
--     --     mod:echo(tostring(i).."     "..tostring(j))
--     -- end
--     -- for i,j in pairs(self._achievement_widgets[1].element.pass_data[17]) do
--     --     mod:echo(tostring(i).."     "..tostring(j))
--     -- end
--     -- for i,j in pairs(self._achievement_widgets[1].element.pass_data[37]) do
--     --     mod:echo(tostring(i).."     "..tostring(j))
--     -- end
--     -- mod:echo("=====================================================")

--     return func(self, entries, entry_type, entry_subtype)
-- end)


-- local lamod = get_mod("Loremasters-Armoury")
-- mod:hook(HeroViewStateAchievements,"_create_entries", function (func, self, entries, entry_type, entry_subtype)
--     -- for i,j in pairs(self._achievement_widgets[1].element.pass_data) do
--     --     mod:echo(tostring(i).."     "..tostring(j))
--     -- end
--     -- for i,j in pairs(self._achievement_widgets[1].element.pass_data[43].passes) do
--     --     mod:echo(tostring(i).."     "..tostring(j))
--     -- end
--     mod:echo(#self._achievement_widgets[1].element.pass_data[43].passes)
--     for i,j in pairs(self._achievement_widgets[1].element.pass_data[43].passes) do
--         mod:echo("=============      "..tostring(i).."     =================")
--         for k,v in pairs(j.data) do
--             if type(v) =="table" then
--                 if v then
--                     for g,h in pairs(v) do
--                         mod:echo(tostring(g).."     "..tostring(h))
--                     end
--                 end
--             end
--             -- mod:echo(tostring(k).."     "..tostring(v))
--         end
--         mod:echo("=====================================================")
--     end
    
--     mod:echo("=====================================================")
--     mod:echo("=====================================================")
--     mod:echo("=====================================================")
--     mod:echo("=====================================================")

--     return func(self, entries, entry_type, entry_subtype)
-- end)

-- local lamod = get_mod("Loremasters-Armoury")
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


-- desc     Complete 200 deeds
-- [MOD][ExecLua][ECHO] claimed     true
-- [MOD][ExecLua][ECHO] icon     achievement_trophy_deeds_5
-- [MOD][ExecLua][ECHO] id     complete_deeds_5
-- [MOD][ExecLua][ECHO] progress     table: 000000000B599930
-- [MOD][ExecLua][ECHO] completed     true
-- [MOD][ExecLua][ECHO] name     Liber Mortis-Bubonica V
-- [MOD][ExecLua][ECHO] reward     table: 0000000001505E00



-- claimed     false
-- [MOD][ExecLua][ECHO] icon     loremaster_test_icon
-- [MOD][ExecLua][ECHO] id     main_quest
-- [MOD][ExecLua][ECHO] requirements     table: 0000000009E2F500
-- [MOD][ExecLua][ECHO] desc     Complete all relavent Sub Quests.
-- [MOD][ExecLua][ECHO] completed     true
-- [MOD][ExecLua][ECHO] progress     table: 000000000BE153D0
-- [MOD][ExecLua][ECHO] name     Main Quest
-- [MOD][ExecLua][ECHO] reward     table: 00000000065FA9A0


-- local UIRenderer_draw_texture = UIRenderer.draw_texture
-- mod:hook(UIPasses.texture, "draw", function(func, ui_renderer, pass_data, ui_scenegraph, pass_definition, ui_style, ui_content, position, size, input_service, dt)
--     -- mod:echo("texture")
--     -- mod:echo(pass_definition.texture_id)
--     -- local texture_name = ui_content[pass_definition.texture_id or "texture_id"]
--     -- mod:echo(texture_name)
--     -- mod:echo("=====================================================")


--     local texture_name = ui_content[pass_definition.texture_id or "texture_id"]
-- 	local color, masked, saturated, point_sample = nil

-- 	if ui_style then
-- 		local texture_size = ui_style.texture_size

-- 		if texture_size then
-- 			UIUtils.align_box_inplace(ui_style, position, size, texture_size)

-- 			size = texture_size
-- 		end

-- 		color = ui_style.color
-- 		masked = ui_style.masked
-- 		saturated = ui_style.saturated
-- 		point_sample = ui_style.point_sample
-- 	end

--     -- mod:echo(texture_name)
-- 	if pass_definition.retained_mode then
-- 		local retained_id = pass_definition.retained_mode and (pass_data.retained_id or true)
-- 		retained_id = UIRenderer.draw_texture(ui_renderer, "paper_back", position, size, color, masked, saturated, retained_id, point_sample)
-- 		pass_data.retained_id = retained_id or pass_data.retained_id
-- 		pass_data.dirty = false
-- 	else
-- 		UIRenderer.draw_texture(ui_renderer, "paper_back", position, size, color, masked, saturated, nil, point_sample)
-- 	end
--     -- return func(ui_renderer, pass_data, ui_scenegraph, pass_definition, ui_style, ui_content, position, size, input_service, dt)
--     return
-- end)

-- mod:hook(UIRenderer,"draw_texture", function (func, self, material, position, size, color, masked, saturated, retained_id, point_sample)
--     local gui = self.gui

-- 	if retained_id then
-- 		gui = self.gui_retained

-- 		if retained_id == true then
-- 			retained_id = nil
-- 		end
-- 	end

-- 	local scale = RESOLUTION_LOOKUP.scale

-- 	return UIRenderer.script_draw_bitmap(gui, self.render_settings, material, Vector3(position[1] * scale, position[2] * scale, position[3] or 0), Vector3(size[1] * scale, size[2] * scale, size[3] or 0), color, masked, saturated, retained_id, point_sample)

--     -- return func(self, material, position, size, color, masked, saturated, retained_id, point_sample)
-- end)



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
            mod.render_marker(pos_box, 100)
        else 
            mod.attached_units[scrap_id] = nil
        end

    end
    func(self, dt, ...)
end)


    
-- ======================================================================================
-- for helping spawn particles with the GearUtils system
-- ======================================================================================
mod:hook(SimpleInventoryExtension,"get_item_template", function (func, self, slot_data)
    
    -- for k,v in pairs(slot_data) do
    --     mod:echo(tostring(k).."      "..tostring(v))
    -- end
    -- mod:echo("====================================")
    if slot_data then
        if slot_data.skin then
            if mod.SKIN_CHANGED[slot_data.skin] then
                local Armoury_key = mod:get(slot_data.skin)
                -- mod:echo(Armoury_key)
                if Armoury_key then
                    if mod.SKIN_LIST[Armoury_key] then
                        if mod.SKIN_LIST[Armoury_key].particles then
                            -- mod:echo(mod.SKIN_LIST[Armoury_key].particles[1].effect)
                            local item_template = slot_data.item_template or BackendUtils.get_item_template(item_data)

                            item_template.particle_fx = mod.SKIN_LIST[Armoury_key].particles

                            return item_template 
                        end
                    end
                end
            end
        end
    end

    return func(self, slot_data)
end)

--don't want to do an origin hook so just redifining the function with the parameters save for unit_node is no longer local
local function _get_item_particle_link_target(fx, equipment, unit_3p, unit_1p, is_first_person)
	local link_target = nil

	if fx.link_target == "left_weapon" then
		link_target = (is_first_person and equipment.left_hand_wielded_unit) or equipment.left_hand_wielded_unit_3p
	elseif fx.link_target == "right_weapon" then
		link_target = (is_first_person and equipment.right_hand_wielded_unit) or equipment.right_hand_wielded_unit_3p
	elseif fx.link_target == "owner_3p" then
		link_target = unit_3p
	elseif fx.link_target == "owner_1p" then
		link_target = unit_1p
	end

	return link_target
end

local function _get_item_particle_link_node(fx, link_target)
	return (fx.link_node and Unit.node(link_target, fx.link_node)) or 0
end

GearUtils.create_attached_particles = function (world, particle_fx, equipment, unit_3p, unit_1p, is_first_person)
	if not world or not particle_fx or not equipment then
		return nil
	end

	local stop_fx = {}
	local destroy_fx = {}
	local fx_ids = {
		stop_fx = stop_fx,
		destroy_fx = destroy_fx
	}

	for i = 1, #particle_fx, 1 do
		local fx = particle_fx[i]

		if (is_first_person and fx.first_person) or (not is_first_person and fx.third_person) then
			local link_target = _get_item_particle_link_target(fx, equipment, unit_3p, unit_1p, is_first_person)

			if link_target then
				local node_id = _get_item_particle_link_node(fx, link_target)
				local fx_id = ScriptWorld.create_particles_linked(world, fx.effect, link_target, node_id, fx.orphaned_policy)

				if fx.destroy_policy == "stop_spawning" then
					stop_fx[#stop_fx + 1] = fx_id
				else
					destroy_fx[#destroy_fx + 1] = fx_id
				end
			end
		end
	end

	return fx_ids
end

mod:hook(Unit,"node", function (func, unit, node)

    if not Unit.has_node(unit, node) then
        if type(node) == "number" then
            if math.floor(node) < Unit.num_scene_graph_items(unit) then
                return math.floor(node)
            end
        end
    end

    return func(unit, node)
end)

-- ======================================================================================
-- ======================================================================================
-- ======================================================================================


--this is needed to prevent the OutlineSystem from crashing when remvoing the custom LA pickups
mod:hook(OutlineSystem,"outline_unit", function (func, self, unit, flag, channel, do_outline, apply_method)
    if not Unit.alive(unit) then
        return 
    end
    return func(self, unit, flag, channel, do_outline, apply_method)
end)







-- NetworkLookup.husks["units/pickups/LA_reikland_chronicle_mesh"] = 1
-- NetworkLookup.husks["units/pickups/LA_artifact_corrupted_mesh"] = 1
-- NetworkLookup.husks["units/pickups/LA_artifact_mesh"] = 1

mod.LA_new_interactors = {
    "units/pickups/LA_reikland_chronicle_mesh",
    "units/pickups/LA_artifact_corrupted_mesh",
    "units/pickups/LA_artifact_mesh",
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
            Managers.ui:handle_transition("hero_view_force", {
                type = "painting",
                menu_state_name = "keep_decorations",
                use_fade = true,
                interactable_unit = interactable_unit
            })
            
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
	-- mod:echo(interaction_type_id)
    local interactable_unit = self.unit_storage:unit(interactable_go_id)
    
    if interactable_unit then
        if Unit.has_data(interactable_unit, "unit_name") then
            -- mod:echo(Unit.get_data(interactable_unit, "unit_name"))
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


-- local lamod = get_mod("Loremasters-Armoury")
mod:hook(NetworkTransmit, "send_rpc_server", function (func, self, rpc_name, self_2, channel_id, interactor_go_id, interactable_go_id, interaction_type_id, ...)
	-- mod:echo(interaction_type_id)

    -- for k,v in pairs(NetworkLookup.interactions) do 
    --     mod:echo(k)
    -- end
    -- mod:echo(channel_id)

    -- mod:echo(interactor_go_id)
    -- mod:echo(interactable_go_id)
    -- mod:echo(...)
    if rpc_name == "rpc_generic_interaction_request" then
        mod:echo("=========================")
        mod:echo(rpc_name)
        mod:echo(self_2)
        mod:echo(channel_id)
        mod:echo(interactor_go_id)
        mod:echo(interactable_go_id)
        mod:echo(interaction_type_id)
        local interactable_unit = Managers.state.unit_storage:unit(channel_id)
        mod:echo(interactable_unit)

        local unit_name = Unit.get_data(interactable_unit, "unit_name")

        if mod.LA_new_interactors[unit_name] then
            local interactor_unit = Managers.state.unit_storage:unit(interactor_go_id)
            local interactor_extension = ScriptUnit.extension(interactor_unit, "interactor_system")
            local interaction_type = "decoration"--NetworkLookup.interactions[interaction_type_id]
            interactor_extension:interaction_approved(interaction_type, interactable_unit)

            local interactable_extension = ScriptUnit.extension(interactable_unit, "interactable_system")

            mod.approve_request = true
            mod.interactor_goid = interactor_go_id

            InteractionHelper:request_approved(interaction_type, interactor_unit, interactable_unit)

            return 
        end
    end
    return func(self, rpc_name, self_2, channel_id, interactor_go_id, interactable_go_id, interaction_type_id, ...)
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
    mod:echo(interaction_context.interactable_unit)
    if not interaction_context.interactable_unit then
        return func(self, hold_input, interactable_unit, interaction_type, forced)
    end
    mod:echo(interactable_unit)
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
    "test_painting",
    "test_quest_select",
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


--this is needed in the event we want sounds to play for the new trophies added in
-- mod:hook(HeroViewStateKeepDecorations, "_play_sound", function(func, self, event)
    
--     -- mod:echo(mod.parameters)
--     -- for k,v in pairs(mod.parameters) do 
--     --     mod:echo(tostring(k).."     "..tostring(v))
--     -- end

--     if mod.parameters then
--         local state_params = mod.parameters.state_params
--         if state_params then
--             local interactable_unit = state_params.interactable_unit
--             if interactable_unit then
    
	
--                 -- mod:echo(interactable_unit)
--                 local unit_name = Unit.get_data(interactable_unit, "unit_name")
--                 if mod.LA_new_interactors[unit_name] then
--                     event = "Loremaster_letter_open_sound__1_"
--                 elseif letterUnits[unit_name] then
--                     event = "Loremaster_letter_open_sound__1_"
--                 end
--                 -- mod:echo(unit_name)
--                 -- s
--             end
--         end
--     end
--     return func(self, event)
-- end)


mod.og_pass = nil
mod:hook(HeroViewStateKeepDecorations, "draw", function (func, self, input_service, dt)
    local unit = self._interactable_unit    
   
    -- for k,v in pairs(self._widgets[4].element.passes[1]) do 
    --     mod:echo(tostring(k).."     "..tostring(v))
    -- end
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

    -- if unit then
    --     local unit_name = Unit.get_data(unit, "unit_name")
    --     if unit_name then
    --         if letterUnits[unit_name] then
    --             local equipped_decoration = mod.letter_board:get_selected_decoration()
    --             mod.letter_board:change_active_quest(equipped_decoration)
    --         end
    --     end
    -- end

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
                -- self._decoration_system = Managers.state.entity:system("keep_decoration_system")
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
                -- local backend_interface = self._keep_decoration_backend_interface
                -- local unlocked_decorations = (backend_interface and backend_interface:get_unlocked_keep_decorations()) or {}
                local widgets = {}
                local index = 0
                -- self._ordered_table
                for _, key in ipairs(mod.list_order) do
                    if true then
                        local settings = self._main_table[key]
                        -- local settings = mod.painting[key]
                        if settings then
                            -- local unlocked = table.contains(unlocked_decorations, key)
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



