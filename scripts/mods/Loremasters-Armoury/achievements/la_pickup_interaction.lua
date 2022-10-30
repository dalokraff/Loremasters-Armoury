local mod = get_mod("Loremasters-Armoury")
mod:dofile("scripts/mods/Loremasters-Armoury/achievements/la_pickup_extension")

local level_quest_table = require("scripts/mods/Loremasters-Armoury/achievements/pickup_maps")

local num_husk = #NetworkLookup.husks
local num_interacts = #NetworkLookup.interactions


NetworkLookup.interactions["la_pickup"] = num_interacts+1
NetworkLookup.interactions[num_interacts + 1] = "la_pickup"

-- local box_path = "units/pickups/Loremaster_shipment_box_mesh_real"
-- NetworkLookup.husks[num_husk +1] = box_path
-- NetworkLookup.husks[box_path] = num_husk +1

InteractionHelper = InteractionHelper or {}
InteractionHelper.interactions.la_pickup = {}
for _, config_table in pairs(InteractionHelper.interactions) do
	config_table.request_rpc = config_table.request_rpc or "rpc_generic_interaction_request"
end


InteractionDefinitions["la_pickup"] = InteractionDefinitions.la_pickup or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.la_pickup.config.swap_to_3p = false

InteractionDefinitions.la_pickup.config.request_rpc = "rpc_generic_interaction_request"

InteractionDefinitions.la_pickup.server.stop = function (world, interactor_unit, interactable_unit, data, config, t, result)
    if result == InteractionResult.SUCCESS then
        local interactable_system = ScriptUnit.extension(interactable_unit, "interactable_system")
        interactable_system.num_times_successfully_completed = interactable_system.num_times_successfully_completed + 1

    end
end

InteractionDefinitions.la_pickup.client.can_interact = function (interactor_unit, interactable_unit, data, config)
    return (Unit.alive(interactable_unit) and Unit.alive(interactor_unit))
end

InteractionDefinitions.la_pickup.server.can_interact = function (interactor_unit, interactable_unit)

    return (Unit.alive(interactable_unit) and Unit.alive(interactor_unit))
end

InteractionDefinitions.la_pickup.client.stop = function (world, interactor_unit, interactable_unit, data, config, t, result)
	data.start_time = nil

	if result == InteractionResult.SUCCESS and not data.is_husk then
	    if interactable_unit then

			-- Managers.state.unit_spawner:mark_for_deletion(interactable_unit)
            local la_pickup_ext = LA_PICKUPS[interactable_unit]
            if la_pickup_ext then
                la_pickup_ext:destroy()
            end

			local level_name = Managers.state.game_mode:level_key()
            local quest = level_quest_table[level_name]
            if quest then
                mod:set(quest.."_temp", true)
            end
			local wwise_world = Wwise.wwise_world(world)
			WwiseWorld.trigger_event(wwise_world, "Loremaster_shipment_pickup_sound")  
			
        end

	end
end


InteractionDefinitions.la_pickup.replacement_rpc = function(interactable_unit)

	Managers.state.unit_spawner:mark_for_deletion(interactable_unit)
	local level_name = Managers.state.game_mode:level_key()
    local quest = level_quest_table[level_name]
    if quest then
        mod:set(quest.."_temp", true)
    end

end

InteractionDefinitions.la_pickup.client.hud_description = function (interactable_unit, data, config, fail_reason, interactor_unit)
    return Unit.get_data(interactable_unit, "interaction_data", "la_interaction_type"), Unit.get_data(interactable_unit, "interaction_data", "hud_description")
end