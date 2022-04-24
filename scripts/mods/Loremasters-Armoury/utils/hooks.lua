local mod = get_mod("Loremasters-Armoury")
mod:dofile("scripts/mods/Loremasters-Armoury/utils/funcs")

--this hook is used to populate the level_world queue; get's the units to change with what custom illusion should be applied to that unit
mod:hook(SimpleInventoryExtension, "_get_no_wield_required_property_and_trait_buffs", function (func, self, backend_id)
    local data_melee = self.recently_acquired_list["slot_melee"]
    local data_range = self.recently_acquired_list["slot_ranged"]
    local hat = self.recently_acquired_list["slot_hat"]
    for k,v in pairs(self.recently_acquired_list) do 
        mod:echo(k)
    end

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

--hook to populate level queue with hat units
mod:hook_safe(PlayerUnitAttachmentExtension,"show_attachments", function(self, show)
    if self._show_attachments then
        local slots = self._attachments.slots
        local slot_hat = slots["slot_hat"]

        local unit = slot_hat.unit
        local hat_name = slot_hat.name
        local Armoury_key = mod:get(hat_name)
        for skin,bools in pairs(mod.SKIN_CHANGED) do
            if bools.changed_texture then
                if hat_name == skin then
                    mod.level_queue[unit] = {
                        Armoury_key = Armoury_key,
                        skin = skin,
                    }
                end
            end
        end
    end
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
end)
-- mod:hook_safe(CosmeticUtils,"update_cosmetic_slot", function(player, slot, item_name, skin_name)
--     if slot == "slot_hat" then 
--         mod:echo(slot)
--         mod:echo(item_name)
--         mod:echo(skin_name)
--         local num = player:get_data("slot_hat")
--         mod:echo(NetworkLookup.item_names[num])
--     end
--     -- local num = player:get_data("slot_hat")
--     -- local unit = Managers.state.unit_storage:unit(num)
--     -- mod:echo(unit)
--     -- mod:echo(num)
-- end)
-- local player = Managers.player:local_player()
-- local player_unit = player.player_unit    
-- local inventory_extension = ScriptUnit.extension(player_unit, "inventory_system")
-- local career_extension = ScriptUnit.extension(player_unit, "career_system")
-- local career_name = career_extension:career_name()
-- local item = BackendUtils.get_loadout_item(career_name, "slot_".."hat")
-- for k ,v in pairs(item.data) do 
--     mod:echo(tostring(k)..":    "..tostring(v))
-- end
-- mod:echo(item)
-- mod:hook_safe(HeroPreviewer, "_spawn_item_unit",  function (self, unit, item_slot_type, item_template, unit_attachment_node_linking, scene_graph_links, material_settings) 
--     mod:echo(item_slot_type)
--     if item_slot_type == "hat" then
--         mod:echo(unit)
--         for k,v in pairs(item_template.slots) do 
--             mod:echo(tostring(k)..":    "..tostring(v))
--         end
--     end
--     for slot_order,units in pairs(self._equipment_units) do
--         -- local slot = slot_dict[slot_order]
--         mod:echo(slot_order)
--     end
-- end)

-- mod:hook(SimpleInventoryExtension, "_get_no_wield_required_property_and_trait_buffs", function (func, self, backend_id)
--     local data_melee = self.recently_acquired_list["slot_melee"]
--     local data_range = self.recently_acquired_list["slot_ranged"]
--     local data_hat = self.recently_acquired_list["slot_hat"]
--     mod:echo(data_hat)
-- end)

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
    
	return func(self, text_id)
end)