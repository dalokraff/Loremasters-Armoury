local mod = get_mod("Loremasters-Armoury")

local level_quest_table = require("scripts/mods/Loremasters-Armoury/achievements/pickup_maps")

local num_interacts = #NetworkLookup.interactions


NetworkLookup.interactions["archive_search"] = num_interacts+1
NetworkLookup.interactions[num_interacts + 1] = "archive_search"

InteractionHelper = InteractionHelper or {}
InteractionHelper.interactions.archive_search = {}
for _, config_table in pairs(InteractionHelper.interactions) do
	config_table.request_rpc = config_table.request_rpc or "rpc_generic_interaction_request"
end


InteractionDefinitions["archive_search"] = InteractionDefinitions.archive_search or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.archive_search.config.swap_to_3p = false

InteractionDefinitions.archive_search.config.request_rpc = "rpc_generic_interaction_request"

InteractionDefinitions.archive_search.server.stop = function (world, interactor_unit, interactable_unit, data, config, t, result)
    if result == InteractionResult.SUCCESS then
        local interactable_system = ScriptUnit.extension(interactable_unit, "interactable_system")
        interactable_system.num_times_successfully_completed = interactable_system.num_times_successfully_completed + 1

    end
end

InteractionDefinitions.archive_search.client.can_interact = function (interactor_unit, interactable_unit, data, config)
    return (Unit.alive(interactable_unit) and Unit.alive(interactor_unit))
end

InteractionDefinitions.archive_search.server.can_interact = function (interactor_unit, interactable_unit)

    return (Unit.alive(interactable_unit) and Unit.alive(interactor_unit))
end

InteractionDefinitions.archive_search.client.stop = function (world, interactor_unit, interactable_unit, data, config, t, result)
	data.start_time = nil

	if result == InteractionResult.SUCCESS and not data.is_husk then
	    if interactable_unit then
            mod.interactable_unit = interactable_unit
			mod:handle_transition("open_quest_board_archive_view")
        end

	end
end


InteractionDefinitions.archive_search.replacement_rpc = function(interactable_unit)
    if interactable_unit then
        mod.interactable_unit = interactable_unit
        mod:handle_transition("open_quest_board_archive_view")
        return true  
    end
end

InteractionDefinitions.archive_search.client.hud_description = function (interactable_unit, data, config, fail_reason, interactor_unit)
    return Unit.get_data(interactable_unit, "interaction_data", "hud_interaction_action"), Unit.get_data(interactable_unit, "interaction_data", "hud_description")
end