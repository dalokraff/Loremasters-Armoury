local mod = get_mod("Loremasters-Armoury")

local num_husk = #NetworkLookup.husks
local num_interacts = #NetworkLookup.interactions


NetworkLookup.interactions["sword_enchantment"] = num_interacts+1
NetworkLookup.interactions[num_interacts + 1] = "sword_enchantment"

-- local scroll_path = "units/pickups/Loremaster_magicscroll_interactor_mesh"
-- NetworkLookup.husks[num_husk +1] = scroll_path
-- NetworkLookup.husks[scroll_path] = num_husk +1

InteractionHelper = InteractionHelper or {}
InteractionHelper.interactions.sword_enchantment = {}
for _, config_table in pairs(InteractionHelper.interactions) do
	config_table.request_rpc = config_table.request_rpc or "rpc_generic_interaction_request"
end


InteractionDefinitions["sword_enchantment"] = InteractionDefinitions.sword_enchantment or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.sword_enchantment.config.swap_to_3p = false

InteractionDefinitions.sword_enchantment.config.request_rpc = "rpc_generic_interaction_request"

InteractionDefinitions.sword_enchantment.server.stop = function (world, interactor_unit, interactable_unit, data, config, t, result)
    if result == InteractionResult.SUCCESS then
        local interactable_system = ScriptUnit.extension(interactable_unit, "interactable_system")
        interactable_system.num_times_successfully_completed = interactable_system.num_times_successfully_completed + 1

    end
end

InteractionDefinitions.sword_enchantment.client.can_interact = function (interactor_unit, interactable_unit, data, config)
    if mod:get("sub_quest_10") then
        return false
    end

    if not mod:get("sub_quest_09") then
        return false
    end

    if mod:get("sub_quest_01") < 1500 then
        return false
    end

    if mod:get("sub_quest_02") < 1500 then
        return false
    end

    local position = Vector3Box(Unit.local_position(interactable_unit, 0))
    mod.render_marker(position, 100)

    return (Unit.alive(interactable_unit) and Unit.alive(interactor_unit))
end

InteractionDefinitions.sword_enchantment.server.can_interact = function (interactor_unit, interactable_unit)

    if mod:get("sub_quest_10") then
        return false
    end

    if not mod:get("sub_quest_09") then
        return false
    end

    if mod:get("sub_quest_01") < 1500 then
        return false
    end

    if mod:get("sub_quest_02") < 1500 then
        return false
    end

    local position = Vector3Box(Unit.local_position(interactable_unit, 0))
    mod.render_marker(position, 100)

    return (Unit.alive(interactable_unit) and Unit.alive(interactor_unit))
end

InteractionDefinitions.sword_enchantment.client.stop = function (world, interactor_unit, interactable_unit, data, config, t, result)
	data.start_time = nil

	if result == InteractionResult.SUCCESS and not data.is_husk then
	    if interactable_unit then
            mod:set("sub_quest_10", true)
            mod.sword_ritual = SwordEnchantment:new(world)
            mod.scroll_unit = nil
        end

	end
end

InteractionDefinitions.sword_enchantment.client.hud_description = function (interactable_unit, data, config, fail_reason, interactor_unit)
    return Unit.get_data(interactable_unit, "interaction_data", "interaction_type"), Unit.get_data(interactable_unit, "interaction_data", "hud_description")
end