local mod = get_mod("Loremasters-Armoury")
mod:dofile("scripts/mods/Loremasters-Armoury/utils/funcs")

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


-- mod:hook(NetworkTransmit, "send_rpc_server", function (func, self, rpc_name, ...)
--     if rpc_name == "skip_local_interaction" then 
--         return 
--     end
--     return func(self, rpc_name, ...)
-- end)

-- mod:hook(NetworkTransmit, "send_rpc", function (func, self, rpc_name, peer_id, ...)
--     if rpc_name == "skip_local_interaction" then 
--         return 
--     end
--     return func(self, rpc_name, peer_id, ...)
-- end)

-- mod:hook(NetworkTransmit, "send_rpc_party_clients", function (func, self, rpc_name, party, include_spectators, ...)
--     if rpc_name == "skip_local_interaction" then 
--         return 
--     end
--     return func(self, rpc_name, party, include_spectators, ...)
-- end)

-- mod:hook(NetworkTransmit, "send_rpc_party_clients", function (func, self, rpc_name, party, include_spectators, ...)
--     if rpc_name == "skip_local_interaction" then 
--         return 
--     end
--     return func(self, rpc_name, party, include_spectators, ...)
-- end)

-- mod:hook(InteractionHelper, "request", function (func, self, interaction_type, interactor_go_id, interactable_go_id, is_level_unit, is_server)
--     local rpc_name = InteractionHelper.interactions[interaction_type].request_rpc
--     if rpc_name == "skip_local_interaction" then 
--         return 
--     end

--     return func(self, interaction_type, interactor_go_id, interactable_go_id, is_level_unit, is_server)
-- end)

-- mod:hook(InteractionDefinitions.talents_access.client, "stop", function (func, world, interactor_unit, interactable_unit, data, config, t, result)
--     local unit_name = Unit.get_data(interactable_unit, "unit_name")
--     if result == InteractionResult.SUCCESS and not data.is_husk then
--         if mod.cheevo_units[unit_name] then
--             data.start_time = nil
--             local shield_count = mod:get("num_shields_collected")
--             shield_count = shield_count + 1
--             mod:set("num_shields_collected", shield_count)
--             mod:echo('successfull!!!')
--             Managers.state.unit_spawner:mark_for_deletion(interactable_unit)
--             return
--         end
--     end

--     return func(world, interactor_unit, interactable_unit, data, config, t, result)
-- end)

-- mod:hook(InteractionDefinitions.talents_access.client, 'hud_description', function (func, interactable_unit, ...)
--     if Unit.has_data(interactable_unit, "is_LA_object") then
--         -- mod:echo(Unit.get_data(interactable_unit, "interaction_data", "hud_description"))
--         return Unit.get_data(interactable_unit, "interaction_data", "hud_description"), Unit.get_data(interactable_unit, "interaction_data", "hud_text_line_2")
--     end

--     return func(interactable_unit, ...)
-- end)



-- mod:hook(UnitSpawner,'create_unit_extensions', function (func, self, world, unit, ...)

--     local unit_name = Unit.get_data(unit, "unit_name")

--     if mod.cheevo_units[unit_name] then
--         Unit.set_data(unit,"interaction_data","hud_description", "test_item")
--         Unit.set_data(unit,"interaction_data","interaction_length", 0)
--         Unit.set_data(unit,"interaction_data","interaction_type", "talents_access")
--         Unit.set_data(unit,"interaction_data","interactor_animation","interaction_start")
--         Unit.set_data(unit,"interaction_data","interactor_animation_time_variable", "revive_time")
--         Unit.set_data(unit,"interaction_data","only_once", false)
--         Unit.set_data(unit,"interaction_data","hud_text_line_2", "line test")
--         Unit.set_data(unit, "is_LA_object", true)

--         Unit.set_data(unit, "extensions", "UnitSynchronizationExtension")
--         Unit.set_data(unit, "extensions", "GenericUnitInteractableExtension")

--     end

--     return func(self, world, unit, ...)
-- end)

--hook to allow for painting scraps to be used as objectives
mod:hook(InteractionDefinitions.pickup_object.client, 'stop', function (func, world, interactor_unit, interactable_unit, data, config, t, result)
    local pickup_extension = ScriptUnit.extension(interactable_unit, "pickup_system")
	local pickup_settings = pickup_extension:get_pickup_settings()
    mod:echo(pickup_settings.type)

    if pickup_settings.type == "painting_scrap" then
        local shield_count = mod:get("num_shields_collected")
        shield_count = shield_count + 1
        mod:set("num_shields_collected", shield_count)
        mod:echo('successfull!!!')
    end

    return func(world, interactor_unit, interactable_unit, data, config, t, result)
end)


-- mod:hook(InteractionDefinitions.pickup_object.client, 'start', function (func, world, interactor_unit, interactable_unit, data, config, t)
    
--     -- mod:echo(interactable_unit)

--     return func(world, interactor_unit, interactable_unit, data, config, t)
-- end)


--hook for showing proper item reward in okri's challenges
local LA_quest_rewards = {
    sub_quest_01 = {
        weapon_skin_name = "Kruber_empire_shield_hero1_Ostermark01",
        reward_type = "weapon_skin",
    },
    sub_quest_02 = {
        item_name = "Kruber_bret_shield_basic2_Luidhard01",
        reward_type = "item",
    },
    sub_quest_03 = {
        item_name = "explosive_barrel",
        reward_type = "item",
    },
    main_quest = {
		weapon_skin_name = "Kruber_bret_shield_basic2_Luidhard01",
        reward_type = "weapon_skin",
	},
}

WeaponSkins.skins["test_item"] = {
    inventory_icon = "kerillian_elf_shield_basicclean_chrace01_icon",
    description = "test_item_desc",
	rarity = "rare",
	display_name = "test_item_name",
}

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
            if LA_quest_rewards[entry_data.id] then 
                entry_data.reward = LA_quest_rewards[entry_data.id]
            end
        end        
    end

    

    return func(self, entries, entry_type, entry_subtype)
end)