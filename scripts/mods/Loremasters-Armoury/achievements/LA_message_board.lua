local mod = get_mod("Loremasters-Armoury")

mod.current_quest_view = "main_01"

function mod.spawn_message_board()
    -- local player = Managers.player:local_player()
    -- local player_unit = player.player_unit
    -- local position = Unit.local_position(player_unit, 0) + Vector3(0,0,1)
    -- local rotation = Unit.local_rotation(player_unit, 0)
    local position = Vector3(24.17, -5.96, 27.2681)
    local rotation = Quaternion.from_elements(0,0,0.376287, -0.926503)
    local world = Managers.world:world("level_world")
    local extension_init_data = {}
    local small_unit = Managers.state.unit_spawner:spawn_network_unit("units/decorations/LA_loremaster_message_small", "interaction_unit", extension_init_data, position, rotation)
    local medium_unit = Managers.state.unit_spawner:spawn_network_unit("units/decorations/LA_loremaster_message_medium", "interaction_unit", extension_init_data, position, rotation)
    local large_unit = Managers.state.unit_spawner:spawn_network_unit("units/decorations/LA_loremaster_message_large", "interaction_unit", extension_init_data, position, rotation)
            
        
    local board_unit = Managers.state.unit_spawner:spawn_network_unit("units/decorations/LA_message_board_mesh", "interaction_unit", extension_init_data, position, rotation)
    local board_unit = Managers.state.unit_spawner:spawn_local_unit("units/decorations/LA_message_board_back_board", position, rotation)
    local small_unit_visable = Managers.state.unit_spawner:spawn_local_unit("units/decorations/LA_loremaster_message_small_visable", position, rotation)
    local medium_unit_visable = Managers.state.unit_spawner:spawn_local_unit("units/decorations/LA_loremaster_message_medium_visable", position, rotation)
    local large_unit_visable = Managers.state.unit_spawner:spawn_local_unit("units/decorations/LA_loremaster_message_large_visable", position, rotation)
    local small_node = {
        {
            target = 0,
            source = "LA_message_board_nail_01",
        },
    }
    local medium_node = {
        {
            target = 0,
            source = "LA_message_board_nail_02",
        },
     }
    local large_node = {
        {
            target = 0,
            source = "LA_message_board_nail_03",
        },
    }
    local root2root = {
        {
            target = 0,
            source = 0,
        },
    }
    AttachmentUtils.link(world, board_unit, small_unit, small_node)
    AttachmentUtils.link(world, board_unit, medium_unit, medium_node)
    AttachmentUtils.link(world, board_unit, large_unit, large_node)
    AttachmentUtils.link(world, small_unit, small_unit_visable, root2root)
    AttachmentUtils.link(world, medium_unit, medium_unit_visable, root2root)
    AttachmentUtils.link(world, large_unit, large_unit_visable, root2root)

    

    -- local flame_unit = Managers.state.unit_spawner:spawn_local_unit("units/props/khorne/deus_khorne_torch_01", position, rotation)
    
    local flame_unit = Managers.state.unit_spawner:spawn_local_unit("units/props/lanterns/lantern_01/prop_lantern_01", position, rotation)
    -- local flame_unit = Managers.state.unit_spawner:spawn_local_unit("units/props/lanterns/lantern_02/prop_lantern_02", position, rotation)

    local stuff = {
        {
            target = 0,
            source = "LA_message_board_lantern",
        },
    }
    AttachmentUtils.link(world, board_unit, flame_unit, stuff)
    Unit.set_local_scale(flame_unit, 0, Vector3(0.0001, 0.0001, 0.0001))

end