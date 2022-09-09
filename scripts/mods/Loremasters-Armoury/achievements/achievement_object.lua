local mod = get_mod("Loremasters-Armoury")

InteractionHelper = InteractionHelper or {}
InteractionHelper.interactions.achievement_object = {}
-- for _, config_table in pairs(InteractionHelper.interactions) do
-- 	config_table.request_rpc = config_table.request_rpc or "rpc_generic_interaction_request"
-- end
InteractionHelper.interactions.achievement_object.request_rpc = "skip_local_interaction"


-- InteractionDefinitions["achievement_object"] = InteractionDefinitions.achievement_object or table.clone(InteractionDefinitions.smartobject)
-- InteractionDefinitions.achievement_object.config.swap_to_3p = false

-- -- InteractionDefinitions.achievement_object.config.request_rpc = "rpc_generic_interaction_request"

-- InteractionDefinitions.achievement_object.server.stop = function (world, interactor_unit, interactable_unit, data, config, t, result)
--     if result == InteractionResult.SUCCESS then
--         local interactable_system = ScriptUnit.extension(interactable_unit, "interactable_system")
--         interactable_system.num_times_successfully_completed = interactable_system.num_times_successfully_completed + 1

--     end
-- end

-- InteractionDefinitions.achievement_object.client.can_interact = function (interactor_unit, interactable_unit, data, config)

--     return (Unit.alive(interactable_unit) and Unit.alive(interactor_unit))
-- end

-- InteractionDefinitions.achievement_object.server.can_interact = function (interactor_unit, interactable_unit)

--     return (Unit.alive(interactable_unit) and Unit.alive(interactor_unit))
-- end

-- InteractionDefinitions.achievement_object.client.stop = function (world, interactor_unit, interactable_unit, data, config, t, result)
-- 	data.start_time = nil

-- 	if result == InteractionResult.SUCCESS and not data.is_husk then
-- 	    if interactable_unit then
--             mod:echo('successfull!!!')
--         end

-- 	end
-- end

-- InteractionDefinitions.achievement_object.client.hud_description = function (interactable_unit, data, config, fail_reason, interactor_unit)
--     return Unit.get_data(interactable_unit, "interaction_data", "interaction_type"), Unit.get_data(interactable_unit, "interaction_data", "hud_description")
-- end

InteractionDefinitions.achievement_object = {
	config = {
		show_weapons = true,
		hold = true,
		swap_to_3p = false
	},
	client = {
		start = function (world, interactor_unit, interactable_unit, data, config, t)
			data.start_time = t
			local duration = Unit.get_data(interactable_unit, "interaction_data", "interaction_length")
			data.duration = duration
			local interactor_animation_name = Unit.get_data(interactable_unit, "interaction_data", "interactor_animation")
			local interactor_animation_time_variable = Unit.get_data(interactable_unit, "interaction_data", "interactor_animation_time_variable")
			local inventory_extension = ScriptUnit.extension(interactor_unit, "inventory_system")
			local career_extension = ScriptUnit.extension(interactor_unit, "career_system")

			if interactor_animation_name then
				local interactor_animation_time_variable = Unit.animation_find_variable(interactor_unit, interactor_animation_time_variable)

				Unit.animation_set_variable(interactor_unit, interactor_animation_time_variable, duration)
				Unit.animation_event(interactor_unit, interactor_animation_name)
			end

			local interactable_animation_name = Unit.get_data(interactable_unit, "interaction_data", "interactable_animation")
			local interactable_animation_time_variable_name = Unit.get_data(interactable_unit, "interaction_data", "interactable_animation_time_variable")

			if interactable_animation_name then
				local interactable_animation_time_variable = Unit.animation_find_variable(interactable_unit, interactable_animation_time_variable_name)

				Unit.animation_set_variable(interactable_unit, interactable_animation_time_variable, duration)
				Unit.animation_event(interactable_unit, interactable_animation_name)
			end

			CharacterStateHelper.stop_weapon_actions(inventory_extension, "interacting")
			CharacterStateHelper.stop_career_abilities(career_extension, "interacting")
			Unit.set_data(interactable_unit, "interaction_data", "being_used", true)
		end,
		update = function (world, interactor_unit, interactable_unit, data, config, dt, t)
			return
		end,
		stop = function (world, interactor_unit, interactable_unit, data, config, t, result)
				if result == InteractionResult.SUCCESS and not data.is_husk then
					if interactable_unit then
						mod:echo('successfull!!!')
					end

				end
		end,
		get_progress = function (data, config, t)
			if data.duration == 0 then
				return 0
			end

			return (data.start_time == nil and 0) or math.min(1, (t - data.start_time) / data.duration)
		end,
		can_interact = function (interactor_unit, interactable_unit, data, config)
			local custom_interaction_check_name = Unit.get_data(interactable_unit, "interaction_data", "custom_interaction_check_name")

			if custom_interaction_check_name and InteractionCustomChecks[custom_interaction_check_name] and not InteractionCustomChecks[custom_interaction_check_name](interactor_unit, interactable_unit) then
				return false
			end

			local used = Unit.get_data(interactable_unit, "interaction_data", "used")
			local being_used = Unit.get_data(interactable_unit, "interaction_data", "being_used")

			return not used and not being_used
		end,
		hud_description = function (interactable_unit, data, config)
			return Unit.get_data(interactable_unit, "interaction_data", "hud_description"), Unit.get_data(interactable_unit, "interaction_data", "hud_interaction_action")
		end
	}
}