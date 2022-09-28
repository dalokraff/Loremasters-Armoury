local mod = get_mod("Loremasters-Armoury")
--adapted the outline steps from https://github.com/danreeves/UnitExplorer/blob/main/scripts/mods/UnitExplorer/utils/InputHandler.lua
--this implementation won't work with the corresponding hook of OutlineSystem.outline_unit
mod.LA_outline_units = {
    "units/pickups/LA_reikland_chronicle_mesh",
    "units/pickups/LA_artifact_corrupted_mesh",
    "units/pickups/LA_artifact_mesh",
    "units/pickups/Loremaster_shipment_box_mesh_real",
    "units/decorations/LA_message_board_mesh",
    "units/decorations/LA_loremaster_message_large_visable",
    "units/decorations/LA_loremaster_message_medium_visable",
    "units/decorations/LA_loremaster_message_small_visable",

}

for k,v in pairs(mod.LA_outline_units) do 
    mod.LA_outline_units[v] = v
end

mod.current_outlined_unit = nil

function mod.outliner()

    if Managers.world:has_world("level_world") and Managers.state.entity then
        local outline_system = Managers.state.entity:system("outline_system")

        local world = Managers.world:world("level_world")
        local physics_world = World.get_data(world, "physics_world")

        local player = Managers.player:local_player()
        local player_unit = player.player_unit
        -- local player_unit = Managers.player:local_player().player_unit
        
        if player_unit then

            local first_person_extension = ScriptUnit.extension(player_unit, "first_person_system")

            local camera_position = first_person_extension:current_position()
            local camera_rotation = first_person_extension:current_rotation()
            local camera_forward = Quaternion.forward(camera_rotation)
            local distance = 15999
            local hits = physics_world:immediate_raycast(camera_position, camera_forward, distance, "all", "collision_filter", "filter_lookat_object_ray")

            local closest_unit_hit = nil
            local closest_hit = 9999
            
            if hits then
                for _, hit in ipairs(hits) do
                    local hit_distance = hit[2]
                    local actor = hit[4]
                    local unit = Actor.unit(actor)
                    if unit ~= player_unit and hit_distance <= closest_hit then
                        closest_hit = hit_distance
                        closest_unit_hit = unit
                    end
                end
            end

            local flag = "outline_unit"
            local channel = Color(255, 255, 255, 255)
            local apply_method = "unit_and_childs"

            if closest_unit_hit then
                if closest_unit_hit ~= mod.current_outlined_unit and Unit.alive(closest_unit_hit) then
                    if Unit.has_data(closest_unit_hit, "unit_name")  then
                        local unit_name = Unit.get_data(closest_unit_hit, "unit_name")
                        if mod.LA_outline_units[unit_name] then
                            local do_outline = true
                            outline_system:outline_unit(closest_unit_hit, flag, channel, do_outline, apply_method)
                            mod.current_outlined_unit = closest_unit_hit
                        else
                            if mod.current_outlined_unit then
                                local do_outline = false
                                if Unit.alive(closest_unit_hit) then
                                    outline_system:outline_unit(mod.current_outlined_unit, flag, channel, do_outline, apply_method)
                                end
                                mod.current_outlined_unit = nil
                            end
                        end
                    elseif mod.current_outlined_unit then
                        local do_outline = false
                        if Unit.alive(closest_unit_hit) then
                            outline_system:outline_unit(mod.current_outlined_unit, flag, channel, do_outline, apply_method)
                        end
                        mod.current_outlined_unit = nil
                    end
                else
                    local do_outline = true
                    outline_system:outline_unit(closest_unit_hit, flag, channel, do_outline, apply_method)
                    mod.current_outlined_unit = closest_unit_hit
                end
            end
        end
    end



end