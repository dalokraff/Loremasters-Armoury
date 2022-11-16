local mod = get_mod("Loremasters-Armoury")

local definitions = local_require("scripts/mods/Loremasters-Armoury/LA_view/armoury_view/definitions/armoury_definitions")
local widget_definitions = definitions.widgets
local scenegraph_definition = definitions.scenegraph_definition
local console_cursor_definition = definitions.console_cursor_definition
local animation_definitions = definitions.animation_definitions
local generic_input_actions = definitions.generic_input_actions
local viewport_definition = definitions.viewport_definition


local DO_RELOAD = false

ArmouryView = class(ArmouryView)

-- Optional. Executed when instantiating your custom view with `CustomView:new`
function ArmouryView:init(ingame_ui_context)
  -- Good idea to create an input service here for use within the view
    local input_manager = ingame_ui_context.input_manager
    input_manager:create_input_service("custom_view_name", "IngameMenuKeymaps", "IngameMenuFilters")
    input_manager:map_device_to_service("custom_view_name", "keyboard")
    input_manager:map_device_to_service("custom_view_name", "mouse")
    input_manager:map_device_to_service("custom_view_name", "gamepad")

    local world = Managers.world:world("level_world")
    self.wwise_world = Managers.world:wwise_world(world)
    
    
    self.input_manager = input_manager
    self.ui_renderer = ingame_ui_context.ui_renderer
    self.ui_top_renderer = ingame_ui_context.ui_top_renderer
    self.voting_manager = ingame_ui_context.voting_manager
end

-- Optional. Executed by `ingame_ui` after transitioning to your custom view.
-- Supplied the transition params that are supplied to the transition function
function ArmouryView:on_enter(transition_params)
  -- Disable other input services
    ShowCursorStack.push()
    local input_manager = self.input_manager
    input_manager:block_device_except_service("custom_view_name", "keyboard", 1)
    input_manager:block_device_except_service("custom_view_name", "mouse", 1)
    input_manager:block_device_except_service("custom_view_name", "gamepad", 1)

    self._on_enter_transition_params = transition_params
    self._render_settings = {
        snap_pixel_positions = true
        }
    self._animations = {}
    self._ui_animations = {}


    self:create_ui_elements(params)

end



ArmouryView.create_ui_elements = function (self, params)
	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self._console_cursor_widget = UIWidget.init(console_cursor_definition)
	local widgets = {}
	local widgets_by_name = {}

	-- if self.viewport_widget then
    --     UIWidget.destroy(self.ui_renderer, self.viewport_widget)
    --     self.viewport_widget = nil
    -- end

    if self.viewport_widget then
        UIWidget.destroy(self.ui_renderer, self.viewport_widget) 
        self.viewport_widget = nil
    end

    
    for name, widget_definition in pairs(widget_definitions) do
		if widget_definition then
			local widget = UIWidget.init(widget_definition)
			widgets[#widgets + 1] = widget
			widgets_by_name[name] = widget
		end
	end

	self._widgets = widgets
	self._widgets_by_name = widgets_by_name
	widgets_by_name.loading_icon.content.visible = false

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(self.ui_scenegraph, animation_definitions)
	local gui_layer = UILayer.default + 30
	local input_service = self:input_service()
	local use_fullscreen_layout = self._gamepad_style_active
	self._menu_input_description = MenuInputDescriptionUI:new(nil, self.ui_top_renderer, input_service, 6, gui_layer, generic_input_actions.default, use_fullscreen_layout)

	self._menu_input_description:set_input_description(nil)

	self._current_input_desc = nil
end



function ArmouryView:play_sound(event)
	WwiseWorld.trigger_event(self.wwise_world, event)
  end

ArmouryView._handle_input = function (self, dt, t)
    local esc_pressed = self:input_service():get("toggle_menu")
    local widgets = self._widgets
	local widgets_by_name = self._widgets_by_name

    if self:_is_button_pressed(widgets_by_name["my_button"]) then
		self:play_sound("Play_hud_select")
		mod:handle_transition("close_quest_board_letter_view")
		return
    end


    if esc_pressed then

        mod:handle_transition("close_quest_board_letter_view")

        return
    end
end

ArmouryView._has_active_level_vote = function (self)
    local voting_manager = self.voting_manager
    local active_vote_name = voting_manager:vote_in_progress()
    local is_mission_vote = active_vote_name == "game_settings_vote" or active_vote_name == "game_settings_deed_vote"

    return is_mission_vote and not voting_manager:has_voted(Network.peer_id())
end


ArmouryView._is_button_pressed = function (self, widget)
    local content = widget.content
    local hotspot = content.button_hotspot or content.hotspot
	if hotspot ~= nil then
		if hotspot.on_release then
			hotspot.on_release = false

			return true
		end
	end

end


ArmouryView.post_update = function (self, dt, t)	
	
end


ArmouryView.draw = function (self, input_service, dt)
	local ui_renderer = self.ui_renderer
	local ui_top_renderer = self.ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local input_manager = self.input_manager
	local render_settings = self._render_settings
	local gamepad_active = input_manager:is_device_active("gamepad")

	local widgets = self._widgets

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, nil, render_settings)

	for i,widget in pairs(widgets) do 
		render_settings.alpha_multiplier = widget.alpha_multiplier or alpha_multiplier
        UIRenderer.draw_widget(ui_renderer, widget)
	end
	-- UIRenderer.draw_widget(ui_renderer, self._widgets[1])

	UIRenderer.end_pass(ui_renderer)

	

    UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, nil, render_settings)
    -- local viewport_data = self._viewport_data
    local viewport_widget = self.viewport_widget
	if viewport_widget then
		render_settings.alpha_multiplier = viewport_widget.alpha_multiplier or alpha_multiplier
        UIRenderer.draw_widget(ui_renderer, viewport_widget)
	end

    UIRenderer.end_pass(ui_renderer)


	if gamepad_active then
		self._menu_input_description:draw(ui_top_renderer, dt)
	end
end

-- Required. Executed by `ingame_ui` every tick.
function ArmouryView:update(dt, t)	
	if not self.viewport_widget then
        -- Managers.package:load("resource_packages/levels/ui_inventory_preview", "global")
        self.viewport_widget = UIWidget.init(definitions.viewport_definition)
        -- self.viewport_widget.style.viewport.camera_position = self.params.background.camera_position
    end
    
    self:draw(self:input_service(), dt)

	if self:_has_active_level_vote() then
        mod:handle_transition("close_quest_board_letter_view")
    else
        self:_handle_input(dt, t)
    end
end


-- Required. Return our custom input service here.
function ArmouryView:input_service()
    return self.input_manager:get_service("custom_view_name")
end

function ArmouryView:on_exit()
	
	self.input_manager:device_unblock_all_services("keyboard", 1)
	self.input_manager:device_unblock_all_services("mouse", 1)
	self.input_manager:device_unblock_all_services("gamepad", 1)
  
    if self.viewport_widget then
        UIWidget.destroy(self.ui_renderer, self.viewport_widget )    
        self.viewport_widget = nil
    end

	ShowCursorStack.pop()
end