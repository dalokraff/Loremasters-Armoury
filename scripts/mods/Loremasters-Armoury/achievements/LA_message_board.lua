local mod = get_mod("Loremasters-Armoury")
mod:dofile("scripts/mods/Loremasters-Armoury/achievements/quest_letters")

local Definitions = require("scripts/mods/Loremasters-Armoury/achievements/LA_message_board_definitions")
local Scenegraph_Definition = Definitions.scenegraph_definition
-- LetterBoard = {}
-- LetterBoard.__index = LetterBoard


LetterBoard = class(LetterBoard)

LetterBoard.init = function (self, interactable_board_unit_name, visible_board_unit_name, board_pos, board_rot, world)

    self.board_path_name = board_unit_path
    self.pos = Vector3Box(board_pos)
    self.rot = QuaternionBox(board_rot)
    self.world = world
    self.active_quest = "main_01"
    

    self.render_menu = false
    self.params = nil
    
    
    local extension_init_data = {}
    local board_unit_interactable = Managers.state.unit_spawner:spawn_network_unit(interactable_board_unit_name, "interaction_unit", extension_init_data, board_pos, board_rot)
    local board_unit_visible = Managers.state.unit_spawner:spawn_local_unit(visible_board_unit_name, board_pos, board_rot)
    Unit.set_data(board_unit_interactable, "current_quest", self.active_quest)

    self.interactable_unit = board_unit_interactable
    self.visible_unit = board_unit_visible
    
    self.active_letters = self:spawn_letters()
    self:add_lantern_light()

end

LetterBoard.destroy = function(self)
    return
end


LetterBoard.spawn_letters = function(self)
    local position = self.pos:unbox()
    local rotation = self.rot:unbox()

    local active_quest = self.active_quest
    local active_letters = {}

    if QuestLetters[active_quest] then
        for quest,letter_unit_name in pairs(QuestLetters[active_quest]) do
            if mod:get(quest) or (string.find(quest, "prologue")) then
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
                Unit.set_data(interactable_letter_unit, "quest", quest)

            end
        end
    end

    return active_letters
end


LetterBoard.active_letters_list = function(self)
    if not self.active_letters then
        return {}
    end

    return self.active_letters
end

LetterBoard.destroy_letters = function(self, active_letters)
    local world = self.world
    for quest, units in pairs(active_letters) do
        


        
      
        World.unlink_unit(world, units["interactable"])
        World.unlink_unit(world, units["visable"])

        local go_id_interactable = Managers.state.unit_storage:go_id(units["interactable"])
        local go_id_visable = Managers.state.unit_storage:go_id(units["visable"])
        Managers.state.unit_spawner:mark_for_deletion(units["interactable"])
        Managers.state.unit_spawner:mark_for_deletion(units["visable"])
        units["interactable"] = nil
        units["visable"] = nil
        active_letters[quest] = nil
        
    end

end

LetterBoard.pin_to_board = function(self, quest, interactable_letter_unit)
    local source_node = string.gsub(quest, "sub_quest", "")
    if string.find(quest, "prologue") then
        source_node = "_03"
    end
    local world = self.world
    local visable_unit = self.visible_unit

    local nodes = {
        {
            target = 0,
            source = "LA_message_board_nail"..source_node,
        },
    }

    AttachmentUtils.link(world, visable_unit, interactable_letter_unit, nodes)
    if string.find(quest, "prologue") then
        Unit.set_local_position(interactable_letter_unit, 0, Vector3(0,-0.2,0))
    end
    
    return
end

LetterBoard.change_active_quest = function(self, new_quest)
    local active_letters = self.active_letters
    if self.active_quest ~= new_quest then
        self:destroy_letters(active_letters)
        self.active_quest = new_quest
        self.active_letters = self:spawn_letters()
    end
end

LetterBoard.add_lantern_light = function(self)
    local position = self.pos:unbox()
    local rotation = self.rot:unbox()

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

LetterBoard.unit = function(self)
    return self.interactable_unit
end

LetterBoard.enter = function(self, params)
    self.render_menu = true
    self.params = params
end

LetterBoard.exit = function(self, params)
    self.render_menu = false
    self.params = params
end

LetterBoard.menu_up = function(self)
    return self.render_menu
end


LetterBoard.input_service = function (self)
	
    if self.params then
        return self.params.parent:input_service()
    end

    return nil
end

LetterBoard.mark_unread_letters = function(self)
    local mark_board = false
    for quest, units in pairs(self.active_letters) do
        if not mod:get(quest.."_letter_read") then
            mark_board = true
        end
    end
    if mark_board then 
        mod.render_marker(self.pos, 100)
    end
    
end




LetterBoard.get_selected_decoration = function(self)
    local unit = self.interactable_unit

    -- if Unit.has_data(unit, "current_quest") then 
    --     local current_quest = Unit.get_data(unit, "current_quest")
    --     return current_quest
    -- end

	return Unit.get_data(unit, "current_quest")
    
end


LetterBoard.reset_selection = function(self)
    local unit = self.interactable_unit
    Unit.set_data(unit, "current_quest", self.current_painting)
    -- if Unit.has_data(unit, "current_quest") then 
    --     local current_quest = Unit.get_data(unit, "current_quest")
    --     return current_quest
    -- end
    
end

LetterBoard.unequip_decoration = function(self, new_painting)
    -- local unit = self.interactable_unit

    -- local current_preview_painting = self._current_preview_painting
	-- local keep_decoration_system = self.keep_decoration_system

	-- keep_decoration_system:on_painting_set(current_preview_painting, self)
	-- self:sync_decoration()

    self:_set_selected_painting(new_painting)
    
end

LetterBoard.decoration_selected = function(self, current_painting)
    local unit = self.interactable_unit
    self.current_painting = current_painting
    -- self:_load_painting(current_painting, nil)
    
end

LetterBoard.confirm_selection = function (self)
	local current_preview_painting = self._current_preview_painting
	-- local keep_decoration_system = self.keep_decoration_system

	-- keep_decoration_system:on_painting_set(current_preview_painting, self)
	-- self:sync_decoration()
    self:_set_selected_painting(new_painting)
    
end

LetterBoard._set_selected_painting = function (self, painting)
	-- local backend_key = self._backend_key
	-- local backend_manager = Managers.backend
	-- local backend_interface = backend_manager:get_interface("keep_decorations")
	-- self._currently_set_painting = painting

	-- backend_interface:set_decoration(backend_key, painting)
	-- backend_manager:commit()
    self._currently_set_painting = painting
    local unit = self.interactable_unit
    Unit.set_data(unit, "current_quest", current_preview_painting)
end


LetterBoard.confirm_selection = function (self)
	local current_preview_painting = self._current_preview_painting
	-- local keep_decoration_system = self.keep_decoration_system

	-- keep_decoration_system:on_painting_set(current_preview_painting, self)
	-- self:sync_decoration()
    local unit = self.interactable_unit
    Unit.set_data(unit, "current_quest", current_preview_painting)
end


LetterBoard.is_decoration_in_use = function(self, decoration)
    local unit = self.interactable_unit
    
    local quest = Unit.get_data(unit, "current_quest")

	if quest == decoration then
        return true
    end

    return false
    
end