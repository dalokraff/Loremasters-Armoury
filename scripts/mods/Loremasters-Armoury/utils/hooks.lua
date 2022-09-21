local mod = get_mod("Loremasters-Armoury")
mod:dofile("scripts/mods/Loremasters-Armoury/utils/funcs")
mod:dofile("scripts/mods/Loremasters-Armoury/achievements/crate_locations")
mod:dofile("scripts/mods/Loremasters-Armoury/achievements/book_locations")

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
local level_quest_table = require("scripts/mods/Loremasters-Armoury/achievements/pickup_maps")
mod:hook(InteractionDefinitions.pickup_object.client, 'stop', function (func, world, interactor_unit, interactable_unit, data, config, t, result)
    
    if interactable_unit then 
        local go_id = Managers.state.unit_storage:go_id(interactable_unit)
        if go_id then
            mod:echo(go_id)
            if mod.attached_units[go_id] then 
                mod:echo(mod.attached_units[go_id].target)
                Managers.state.unit_spawner:mark_for_deletion(mod.attached_units[go_id].target)

                local level_name = Managers.state.game_mode:level_key()
                local quest = level_quest_table[level_name]
                if quest then
                    mod:set(quest.."_temp", true)
                end
                local pickup_extension = ScriptUnit.extension(interactable_unit, "pickup_system")
                local pickup_settings = pickup_extension:get_pickup_settings()
                pickup_settings.pickup_sound_event = "Loremaster_shipment_pickup_sound"
                -- LA_crate_pickup
            end
        end
    end
    return func(world, interactor_unit, interactable_unit, data, config, t, result)
end)

mod:hook(PickupSystem, 'rpc_spawn_pickup_with_physics', function (func, self, channel_id, pickup_name_id, position, rotation, spawn_type_id)
    local pickup_name = NetworkLookup.pickup_names[pickup_name_id]
    local level_name = Managers.state.game_mode:level_key()
    if mod.list_of_LA_levels[level_name] then
        local LA_position = mod.list_of_LA_levels[level_name].position
        mod:echo(LA_position:unbox())
        mod:echo(position)
        if Vector3.equal(position, LA_position:unbox()) then
            mod:echo(pickup_name)
            if pickup_name == "painting_scrap" then
                local pickup_name = NetworkLookup.pickup_names[pickup_name_id]

                local pickup_settings = AllPickups[pickup_name]
                local spawn_type = NetworkLookup.pickup_spawn_types[spawn_type_id]
                
                local scrap_unit, scrap_go_id = self:_spawn_pickup(pickup_settings, pickup_name, position, rotation, true, spawn_type)
                mod:echo(scrap_go_id)
                mod:echo(scrap_unit)
                local box_unit = Managers.state.unit_spawner:spawn_local_unit("units/pickups/Loremaster_shipment_box_mesh_real", position, rotation)
                local world = Managers.world:world("level_world")
                local attach_nodes = {
                    {
                        target = 0,
                        source = "root_point",
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
                mod:echo(mod.attached_units[scrap_go_id].target)

                Unit.set_data(scrap_unit, "interaction_data", "hud_description", "LA_crate")

                return 
            end
        end
    end

    if mod.list_of_LA_levels_books[level_name] then
        local LA_position = mod.list_of_LA_levels_books[level_name].position
        mod:echo(LA_position:unbox())
        mod:echo(position)
        if Vector3.equal(position, LA_position:unbox()) then
            mod:echo(pickup_name)
            if pickup_name == "painting_scrap" then
                local pickup_name = NetworkLookup.pickup_names[pickup_name_id]

                local pickup_settings = AllPickups[pickup_name]
                local spawn_type = NetworkLookup.pickup_spawn_types[spawn_type_id]
                local scrap_unit, scrap_go_id = self:_spawn_pickup(pickup_settings, pickup_name, position, rotation, true, spawn_type)
                mod:echo(scrap_go_id)
                mod:echo(scrap_unit)
                local box_unit = Managers.state.unit_spawner:spawn_local_unit("units/pickups/LA_MQ01_sub7_chronicle_mesh", position, rotation)
                local world = Managers.world:world("level_world")
                local attach_nodes = {
                    {
                        target = "LA_MQ01_sub7_chronicle",
                        source = "root_point",
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
                mod:echo(mod.attached_units[scrap_go_id].target)

                Unit.set_data(scrap_unit, "interaction_data", "hud_description", "LA_crate")

                return 
            end
        end
    end

    return func(self, channel_id, pickup_name_id, position, rotation, spawn_type_id)
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

local skin_killQuest = require("scripts/mods/Loremasters-Armoury/achievements/kill_quests")
mod:hook(StatisticsUtil, "register_kill", function(func, victim_unit, damage_data, statistics_db, is_server)
	
	local victim_health_extension = ScriptUnit.has_extension(victim_unit, "health_system")
	local victim_damage_data = victim_health_extension.last_damage_data

    if victim_damage_data then
        local player_manager = Managers.player
        local attacker_unique_id = victim_damage_data.attacker_unique_id
        if attacker_unique_id then
            local attacker_player = player_manager:player_from_unique_id(attacker_unique_id)
            local career_extension = ScriptUnit.extension(attacker_player.player_unit, "career_system")
            local career_name = career_extension:career_name()
            local item_one = BackendUtils.get_loadout_item(career_name, "slot_melee")
            local item_two = BackendUtils.get_loadout_item(career_name, "slot_ranged")

            local tisch = {
                item_one, 
                item_two, 
            }

            local damage_source = damage_data[DamageDataIndex.DAMAGE_SOURCE_NAME]
            local master_list_item = rawget(ItemMasterList, damage_source)


            for _,item in pairs(tisch) do 
                if mod.current_skin[item.skin] then
                    local quest_data = skin_killQuest[mod.current_skin[item.skin]]
                    if quest_data then
                        if master_list_item then
                            if master_list_item.name == item.ItemId then 
                                mod:echo(mod.current_skin[item.skin])
                                local breed_killed = Unit.get_data(victim_unit, "breed")
                                local breed_killed_name = breed_killed.name
			                    local killed_race_name = breed_killed.race
                                for quest,enemy_types in pairs(quest_data) do
                                    
                                    mod:echo(breed_killed_name)
                                    mod:echo(killed_race_name)
                                    for _,enemy in pairs(enemy_types) do 
                                        mod:echo(quest.."       "..enemy)
                                        if (enemy == breed_killed_name) or (enemy == killed_race_name) then
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
            end
        end

    end

	return func(victim_unit, damage_data, statistics_db, is_server)
end)



--setting up tables that contain data for the reward info of chalenges in Okri's Book
mod.LA_quest_rewards = {
    main_quest = {
		item_name = "main_quest_reward",
        reward_type = "item",
	},
    sub_quest_01 = {
        item_name = "sub_quest_01_reward",
        reward_type = "item",
    },
    sub_quest_02 = {
        item_name = "sub_quest_02_reward",
        reward_type = "item",
    },
    sub_quest_03 = {
        item_name = "sub_quest_03_reward",
        reward_type = "item",
    },
    sub_quest_04 = {
        item_name = "sub_quest_04_reward",
        reward_type = "item",
    },
    sub_quest_05 = {
        item_name = "sub_quest_05_reward",
        reward_type = "item",
    },
    sub_quest_06 = {
        item_name = "LA_locked_reward",
        reward_type = "item",
    },
    sub_quest_07 = {
        item_name = "LA_locked_reward",
        reward_type = "item",
    },
    sub_quest_08 = {
        item_name = "LA_locked_reward",
        reward_type = "item",
    },
    sub_quest_09 = {
        item_name = "LA_locked_reward",
        reward_type = "item",
    },
    sub_quest_10 = {
        item_name = "LA_locked_reward",
        reward_type = "item",
    },
}

for quest,data in pairs(mod.LA_quest_rewards) do 
    ItemMasterList[quest.."_reward"] = {
        -- temporary_template = "explosive_barrel",
        -- slot_type = "healthkit",
        -- is_local = true,
        display_name = quest.."_reward_name",
        inventory_icon = "quest_icon_empty",
        -- left_hand_unit = "units/weapons/player/wpn_explosive_barrel/wpn_explosive_barrel_01",
        rarity = "plentiful",
        -- gamepad_hud_icon = "consumables_icon_defence",
        -- hud_icon = "consumables_icon_defence",
        item_type = quest.."_reward_desc",
        -- item_type = "item_description",
        can_wield = CanWieldAllItemTemplates
    }
end

ItemMasterList["LA_locked_reward"] = {
    inventory_icon = "achievement_trophy_helmgart_lord_1",
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