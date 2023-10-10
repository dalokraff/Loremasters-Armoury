local mod = get_mod("Loremasters-Armoury")
local atlas = require("materials/Loremasters-Armoury/armoury_atlas")


local quat_forward = Quaternion.forward
local quat_right = Quaternion.right
local vec3_norm = Vector3.normalize
local vec3_flat = Vector3.flat
local vec3_dot = Vector3.dot
local vec3_dist = Vector3.distance

local unit_local_pos = Unit.local_position

local gui_bitmap = Gui.bitmap
local gui_update_bitmap = Gui.update_bitmap

local world_create_screen_gui = World.create_screen_gui

local math_abs = math.abs
local math_log = math.log
local math_ex = math.exp


-- https://github.com/Aussiemon/Vermintide-2-Source-Code/blob/9f98479071fe839dedf487ce8567e7d9492704c9/scripts/ui/hud_ui/floating_icon_ui.lua
-- Line 224
local get_floating_icon_position = function (screen_pos_x, screen_pos_y, forward_dot, right_dot)
	local root_size = Vector2(RESOLUTION_LOOKUP.res_w, RESOLUTION_LOOKUP.res_h)
	local scale = RESOLUTION_LOOKUP.scale
	local scaled_root_size_x = root_size[1] * scale
	local scaled_root_size_y = root_size[2] * scale
	local scaled_root_size_x_half = scaled_root_size_x * 0.5
	local scaled_root_size_y_half = scaled_root_size_y * 0.5
	local screen_width = RESOLUTION_LOOKUP.res_w
	local screen_height = RESOLUTION_LOOKUP.res_h
	local center_pos_x = screen_width / 2
	local center_pos_y = screen_height / 2
	local x_diff = screen_pos_x - center_pos_x
	local y_diff = center_pos_y - screen_pos_y
	local is_x_clamped = false
	local is_y_clamped = false

	if math_abs(x_diff) > scaled_root_size_x_half * 0.9 then
		is_x_clamped = true
	end

	if math_abs(y_diff) > scaled_root_size_y_half * 0.9 then
		is_y_clamped = true
	end

	local clamped_x_pos = screen_pos_x
	local clamped_y_pos = screen_pos_y
	local is_behind = (forward_dot < 0 and true) or false
	local is_clamped = ((is_x_clamped or is_y_clamped) and true) or false

	if is_clamped or is_behind then
		local distance_from_center = {
            width = 128,
            height = 128
        }
		clamped_x_pos = scaled_root_size_x_half + right_dot * distance_from_center.width * scale
		clamped_y_pos = scaled_root_size_y_half + forward_dot * distance_from_center.height * scale
	else
		local screen_pos_diff_x = screen_width - scaled_root_size_x
		local screen_pos_diff_y = screen_height - scaled_root_size_y
		clamped_x_pos = clamped_x_pos - screen_pos_diff_x / 2
		clamped_y_pos = clamped_y_pos - screen_pos_diff_y / 2
	end

	local inverse_scale = RESOLUTION_LOOKUP.inv_scale
	clamped_x_pos = clamped_x_pos * inverse_scale
	clamped_y_pos = clamped_y_pos * inverse_scale

	return clamped_x_pos, clamped_y_pos, is_clamped, is_behind
end


--gaussing function that handles size of waypoint based on distance from it
local gaussian_size_decrease = function(current_distance, min_size, max_size, max_distance)

    local lambda = -(100^2)/math_log(min_size/max_size)

    local gaussian_size = max_size*math_ex(-(current_distance-max_distance)^2/lambda)

    return gaussian_size
end


--renders the LA waypoint marker at the given 3D position
--takes Vector3box as param
--returns nothing
function mod.render_marker(pos_box, distance_view)
    local player = Managers.player:local_player()
    local player_unit = player.player_unit
    if player_unit and not Managers.ui._ingame_ui.current_view then
        local player_pos = unit_local_pos(player_unit, 0)
        local waypoint_position = Vector3(pos_box[1], pos_box[2], pos_box[3])

        local dist = vec3_dist(player_pos, waypoint_position)

        if (dist <= distance_view) and (dist > 1) then

            local world = Managers.world:world("level_world")
            local viewport = ScriptWorld.viewport(world, player.viewport_name)
            local camera = ScriptViewport.camera(viewport)
            local waypoint_position2d, depth = Camera.world_to_screen(camera, waypoint_position)

            local top_world = Managers.world:world("top_ingame_view")

            local mod_gui = nil
            if not mod.mod_gui then
                mod_gui = world_create_screen_gui(top_world, "immediate",
                        "material", "materials/Loremasters-Armoury/LA_waypoint_main_icon"
                        )
                mod.mod_gui = mod_gui
                mod.gui = nil
            else
                mod_gui = mod.mod_gui
            end

            local distance = vec3_dist(player_pos, waypoint_position)

            --gaussing function that handles size of waypoint based on distance from it
            local min_size = 55*0.8
            local max_size = 150*0.8
            local max_distance = distance_view
            local waypoint_size = gaussian_size_decrease(distance, min_size, max_size, max_distance)



            local waypoint_size_behind = 32

			local screen_width = RESOLUTION_LOOKUP.res_w
			local screen_height = RESOLUTION_LOOKUP.res_h
			local center_pos_x = screen_width / 2
			local center_pos_y = (screen_height / 2)

			local first_person_extension = ScriptUnit.extension(player.player_unit, "first_person_system")
			local player_rotation = first_person_extension:current_rotation()

			local player_direction_forward = quat_forward(player_rotation)
			player_direction_forward = vec3_norm(vec3_flat(player_direction_forward))

			local player_direction_right = quat_right(player_rotation)
			player_direction_right = vec3_norm(vec3_flat(player_direction_right))

			local offset = waypoint_position - player_pos

			local direction = vec3_norm(vec3_flat(offset))

			local player_forward_dot = vec3_dot(player_direction_forward, direction)
			local player_right_dot = vec3_dot(player_direction_right, direction)

			local is_behind = (player_forward_dot < 0 and true) or false

			local x, y, is_clamped, is_behind = get_floating_icon_position(waypoint_position2d[1], waypoint_position2d[2], player_forward_dot, player_right_dot)





            if is_clamped or is_behind then
                if not waypoint_on_me then
                    local alpha = 100
                    local arrow_size = Vector2(waypoint_size_behind,waypoint_size_behind)
                    local icon_size = Vector2(waypoint_size_behind,waypoint_size_behind)

                    local icon_loc_x = 0
                    local icon_loc_y = 0

                    icon_loc_x = x
                    icon_loc_y = y

                    local mid_x = screen_width/2
                    local mid_y = screen_height/2

                    local side_check = mid_x - x

                    local up_check = mid_y - y

                    if up_check < -30 then
                        if not mod.gui then
                            mod.gui = gui_bitmap(mod_gui, "LA_waypoint_main_icon", Vector2(screen_width/2, screen_height - screen_height/8), Vector2(waypoint_size, waypoint_size), Color(alpha, 255, 255, 255))
                        else
                            gui_update_bitmap(mod_gui, mod.gui, "LA_waypoint_main_icon", Vector2(screen_width/2, screen_height - screen_height/8), Vector2(waypoint_size, waypoint_size), Color(alpha, 255, 255, 255))
                        end
                    elseif side_check > 0 then
                        if not mod.gui then
                            mod.gui = gui_bitmap(mod_gui, "LA_waypoint_main_icon", Vector2(screen_width/20, screen_height/2), Vector2(waypoint_size, waypoint_size), Color(alpha, 255, 255, 255))
                        else
                            gui_update_bitmap(mod_gui, mod.gui, "LA_waypoint_main_icon", Vector2(screen_width/20, screen_height/2), Vector2(waypoint_size, waypoint_size), Color(alpha, 255, 255, 255))
                        end
                    else
                        if not mod.gui then
                            mod.gui = gui_bitmap(mod_gui, "LA_waypoint_main_icon", Vector2(screen_width - screen_width/20, screen_height/2), Vector2(waypoint_size, waypoint_size), Color(alpha, 255, 255, 255))
                        else
                            gui_update_bitmap(mod_gui, mod.gui, "LA_waypoint_main_icon", Vector2(screen_width - screen_width/20, screen_height/2), Vector2(waypoint_size, waypoint_size), Color(alpha, 255, 255, 255))
                        end
                    end


                end
            else
                local alpha = 255
                if not mod.gui then
                    mod.gui = gui_bitmap(mod_gui, "LA_waypoint_main_icon", Vector2(waypoint_position2d[1], waypoint_position2d[2]), Vector2(waypoint_size, waypoint_size), Color(alpha, 255, 255, 255))
                else
                    gui_update_bitmap(mod_gui, mod.gui, "LA_waypoint_main_icon", Vector2(waypoint_position2d[1], waypoint_position2d[2]), Vector2(waypoint_size, waypoint_size), Color(alpha, 255, 255, 255))
                end
            end
        end
    end
end