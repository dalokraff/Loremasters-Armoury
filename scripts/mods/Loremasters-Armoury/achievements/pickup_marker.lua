local mod = get_mod("Loremasters-Armoury")
local atlas = require("materials/Loremasters-Armoury/armoury_atlas")




-- https://github.com/Aussiemon/Vermintide-2-Source-Code/blob/9f98479071fe839dedf487ce8567e7d9492704c9/scripts/ui/hud_ui/floating_icon_ui.lua
-- Line 224
local get_floating_icon_position = function (screen_pos_x, screen_pos_y, forward_dot, right_dot)
	-- local root_size = UISceneGraph.get_size_scaled(mod.ui_scenegraph, "screen")
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

	if math.abs(x_diff) > scaled_root_size_x_half * 0.9 then
		is_x_clamped = true
	end

	if math.abs(y_diff) > scaled_root_size_y_half * 0.9 then
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

    local lambda = -(100^2)/math.log(min_size/max_size)

    local gaussian_size = max_size*math.exp(-(current_distance-max_distance)^2/lambda)

    -- 150*math.exp(-(distance-100)^2/(1*10^4))

    return gaussian_size
end


--renders the LA waypoint marker at the given 3D position
--takes Vector3box as param
--returns nothing
function mod.render_marker(pos_box, distance_view)
    local player = Managers.player:local_player()
    local player_unit = player.player_unit
    if player_unit and not Managers.ui._ingame_ui.current_view then
        local player_pos = Unit.local_position(player_unit, 0)
        local waypoint_position = Vector3(pos_box[1], pos_box[2], pos_box[3])

        local dist = Vector3.distance(player_pos, waypoint_position)

        if (dist <= distance_view) and (dist > 1) then
            
            local world = Managers.world:world("level_world")
            local viewport = ScriptWorld.viewport(world, player.viewport_name)
            local camera = ScriptViewport.camera(viewport)
            -- local scale = UIResolutionScale()
            local waypoint_position2d, depth = Camera.world_to_screen(camera, waypoint_position)

            local top_world = Managers.world:world("top_ingame_view")

            local mod_gui = World.create_screen_gui(top_world, "immediate",
                        "material", "materials/Loremasters-Armoury/LA_waypoint_main_icon"
                        )
            -- local mod_gui = World.create_screen_gui(top_world, "immediate",
            --             "material", "materials/Loremasters-Armoury/armoury_atlas"
            --             )

            -- local player_pos = ScriptCamera.position(camera)
            local distance = Vector3.distance(player_pos, waypoint_position)

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

			local player_direction_forward = Quaternion.forward(player_rotation)
			player_direction_forward = Vector3.normalize(Vector3.flat(player_direction_forward))

			local player_direction_right = Quaternion.right(player_rotation)
			player_direction_right = Vector3.normalize(Vector3.flat(player_direction_right))

			local offset = waypoint_position - player_pos

			local direction = Vector3.normalize(Vector3.flat(offset))

			local player_forward_dot = Vector3.dot(player_direction_forward, direction)
			local player_right_dot = Vector3.dot(player_direction_right, direction)

			local is_behind = (player_forward_dot < 0 and true) or false

			local x, y, is_clamped, is_behind = get_floating_icon_position(waypoint_position2d[1], waypoint_position2d[2], player_forward_dot, player_right_dot)



            -- local texture_settings = atlas["la_waypoint_main_icon"]
            -- local uv00_table = texture_settings.uv00
            -- local uv11_table = texture_settings.uv11
            -- local uv00 = Vector2(uv00_table[1], uv00_table[2])
            -- local uv11 = Vector2(uv11_table[1], uv11_table[2])

            -- local alpha = math.max(0, 255 - (255 * distance / 5))
            local alpha = 100

            if is_clamped or is_behind then
                if not waypoint_on_me then
                    local arrow_size = Vector2(waypoint_size_behind,waypoint_size_behind)
                    local icon_size = Vector2(waypoint_size_behind,waypoint_size_behind)

                    local icon_loc_x = 0
                    local icon_loc_y = 0

                    -- local alpha = math.max(0, 255 - (255 * distance / 5))

                    icon_loc_x = x
                    icon_loc_y = y

                    local mid_x = screen_width/2
                    local mid_y = screen_height/2

                    local side_check = mid_x - x

                    local up_check = mid_y - y

                    if up_check < -30 then
                        Gui.bitmap(mod_gui, "LA_waypoint_main_icon", Vector2(screen_width/2, screen_height - screen_height/8), Vector2(waypoint_size, waypoint_size))
                    elseif side_check > 0 then
                        Gui.bitmap(mod_gui, "LA_waypoint_main_icon", Vector2(screen_width/20, screen_height/2), Vector2(waypoint_size, waypoint_size))
                    else
                        Gui.bitmap(mod_gui, "LA_waypoint_main_icon", Vector2(screen_width - screen_width/20, screen_height/2), Vector2(waypoint_size, waypoint_size))
                    end

                    -- Gui.bitmap_uv(mod_gui, "armoury_atlas", uv00, uv11, Vector2(icon_loc_x, icon_loc_y), Vector2(waypoint_size_behind, waypoint_size_behind), Color(alpha, 255, 255, 255))
                    -- Gui.bitmap(mod_gui, "LA_waypoint_main_icon", Vector2(waypoint_position2d[1], waypoint_position2d[2]), Vector2(waypoint_size, waypoint_size), Color(alpha, 255, 255, 255))
                    -- Gui.bitmap(mod_gui, "LA_waypoint_main_icon", Vector2(screen_width/20, screen_height/2), Vector2(100, 100), Color(alpha, 255, 255, 255))
                end
            else
                -- Gui.bitmap_uv(mod_gui, "armoury_atlas", uv00, uv11, Vector2(waypoint_position2d[1], waypoint_position2d[2]), Vector2(waypoint_size, waypoint_size))
                Gui.bitmap(mod_gui, "LA_waypoint_main_icon", Vector2(waypoint_position2d[1], waypoint_position2d[2]), Vector2(waypoint_size, waypoint_size))
            end


            -- Gui.bitmap(mod_gui, "LA_waypoint_main_icon", Vector2(waypoint_position2d[1], waypoint_position2d[2]), Vector2(waypoint_size, waypoint_size))
            -- Gui.bitmap_uv(mod_gui, "armoury_atlas", uv00, uv11, Vector2(waypoint_position2d[1], waypoint_position2d[2]), Vector2(waypoint_size, waypoint_size))
        end
    end
end