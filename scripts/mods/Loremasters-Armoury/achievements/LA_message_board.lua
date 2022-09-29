local mod = get_mod("Loremasters-Armoury")
mod:dofile("scripts/mods/Loremasters-Armoury/achievements/quest_letters")

-- LetterBoard = {}
-- LetterBoard.__index = LetterBoard


LetterBoard = class(LetterBoard)

LetterBoard.init = function (self, interactable_board_unit_name, visible_board_unit_name, board_pos, board_rot, world)

    self.board_path_name = board_unit_path
    self.pos = board_pos
    self.rot = board_rot
    self.world = world
    self.active_quest = "main_01"
    
    
    local extension_init_data = {}
    local board_unit_interactable = Managers.state.unit_spawner:spawn_network_unit(interactable_board_unit_name, "interaction_unit", extension_init_data, board_pos, board_rot)
    local board_unit_visible = Managers.state.unit_spawner:spawn_local_unit(visible_board_unit_name, board_pos, board_rot)

    self.interactable_unit = board_unit_interactable
    self.visible_unit = board_unit_visible
    
    self:spawn_letters()
    self:add_lantern_light()

end

LetterBoard.destroy = function(self)
    return
end


LetterBoard.spawn_letters = function(self)
    local position = self.pos
    local rotation = self.rot

    local active_quest = "main_01"
    local active_letters = {}

    for quest,letter_unit_name in pairs(QuestLetters[active_quest]) do
        if mod:get(quest) then
            local interactable_letter_unit = Managers.state.unit_spawner:spawn_network_unit(letter_unit_name, "interaction_unit", extension_init_data, position, rotation)

            self:pin_to_board(quest, interactable_letter_unit)

            local visable_letter_unit = Managers.state.unit_spawner:spawn_local_unit(letter_unit_name.."_visable", position, rotation)

            local root2root = {
                {
                    target = 0,
                    source = 0,
                },
            }

            AttachmentUtils.link(self.world, interactable_letter_unit, visable_letter_unit, root2root)

            active_letters[quest] = {
                interactable = interactable_letter_unit,
                visable = visable_letter_unit,
            }

        end
    end

    return active_letters
end


LetterBoard.pin_to_board = function(self, quest, interactable_letter_unit)
    local source_node = string.gsub(quest, "sub_quest", "")
    local world = self.world
    local visable_unit = self.visible_unit

    local nodes = {
        {
            target = 0,
            source = "LA_message_board_nail"..source_node,
        },
    }
    
    AttachmentUtils.link(world, visable_unit, interactable_letter_unit, nodes)

    return
end

LetterBoard.add_lantern_light = function(self)
    local position = self.pos
    local rotation = self.rot

    local flame_unit = Managers.state.unit_spawner:spawn_local_unit("units/props/lanterns/lantern_01/prop_lantern_01", position, rotation)

    local stuff = {
        {
            target = 0,
            source = "LA_message_board_lantern",
        },
    }
    AttachmentUtils.link(self.world, self.visible_unit, flame_unit, stuff)
    Unit.set_local_scale(flame_unit, 0, Vector3(0.0001, 0.0001, 0.0001))

    return

end



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