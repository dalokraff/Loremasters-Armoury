local mod = get_mod("Loremasters-Armoury")
local atlas = require("materials/Loremasters-Armoury/armoury_atlas")


function mod.render_marker(pos_box)
    local player = Managers.player:local_player()
    local player_unit = player.player_unit
    if player_unit then
        local player_pos = Unit.local_position(player_unit, 0)
        local waypoint_position = Vector3(pos_box[1], pos_box[2], pos_box[3])

        local dist = Vector3.distance(player_pos, waypoint_position)

        if dist <= 25 then
            
            local world = Managers.world:world("level_world")
            local viewport = ScriptWorld.viewport(world, player.viewport_name)
            local camera = ScriptViewport.camera(viewport)
            local scale = UIResolutionScale()
            local waypoint_position2d, depth = Camera.world_to_screen(camera, waypoint_position)

            local top_world = Managers.world:world("top_ingame_view")

            -- local mod_gui = World.create_screen_gui(top_world, "immediate",
            --             "material", "materials/Loremasters-Armoury/LA_waypoint_main_icon"
            --             )
            local mod_gui = World.create_screen_gui(top_world, "immediate",
                        "material", "materials/Loremasters-Armoury/armoury_atlas"
                        )

            local player_pos = ScriptCamera.position(camera)
            local distance = Vector3.distance(player_pos, waypoint_position) / 5
            local waypoint_size = math.max(64 / distance, 24)

            local texture_settings = atlas["la_waypoint_main_icon"]
            local uv00_table = texture_settings.uv00
            local uv11_table = texture_settings.uv11
            local uv00 = Vector2(uv00_table[1], uv00_table[2])
            local uv11 = Vector2(uv11_table[1], uv11_table[2])
            -- Gui.bitmap(mod_gui, "LA_waypoint_main_icon", Vector2(waypoint_position2d[1], waypoint_position2d[2]), Vector2(waypoint_size, waypoint_size))
            Gui.bitmap_uv(mod_gui, "armoury_atlas", uv00, uv11, Vector2(waypoint_position2d[1], waypoint_position2d[2]), Vector2(waypoint_size, waypoint_size))
        end
    end
end