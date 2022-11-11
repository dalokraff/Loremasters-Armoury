local mod = get_mod("Loremasters-Armoury")

local definitions = local_require("scripts/mods/Loremasters-Armoury/LA_view/armoury_view/definitions/definitions_widgets")
local widget_definitions = definitions.widgets
local scenegraph_definition = definitions.scenegraph_definition
local animation_definitions = definitions.animation_definitions

TestWidgets = class(TestWidgets)

-- Optional. Executed when instantiating your custom view with `CustomView:new`
function TestWidgets:init(ingame_ui_context)
  -- Good idea to create an input service here for use within the view
  local input_manager = ingame_ui_context.input_manager
  input_manager:create_input_service("custom_view_name", "IngameMenuKeymaps", "IngameMenuFilters")
  input_manager:map_device_to_service("custom_view_name", "keyboard")
  input_manager:map_device_to_service("custom_view_name", "mouse")
  input_manager:map_device_to_service("custom_view_name", "gamepad")

  local world = Managers.world:world("level_world")
  self.wwise_world = Managers.world:wwise_world(world)
  
  
  self.input_manager = input_manager
  self._ui_renderer = ingame_ui_context.ui_renderer
  self._ui_top_renderer = ingame_ui_context.ui_top_renderer
  self.voting_manager = ingame_ui_context.voting_manager
end

-- Optional. Executed by `ingame_ui` after transitioning to your custom view.
-- Supplied the transition params that are supplied to the transition function
function TestWidgets:on_enter(transition_params)
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
  self:_create_ui_elements()
end

TestWidgets._create_ui_elements = function (self)
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	local widgets = {}
	local widgets_by_name = {}

	for name, definition in pairs(widget_definitions) do
		local widget = UIWidget.init(definition)
		local num_widgets = #widgets
		widgets[num_widgets + 1] = widget
		widgets_by_name[name] = widget
	end


	self._widgets = widgets
	self._widgets_by_name = widgets_by_name

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self.ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)
	local scrollbar_widget = self._widgets_by_name.list_scrollbar
	self._scrollbar_logic = ScrollBarLogic:new(scrollbar_widget)
end

TestWidgets.draw = function (self, input_service, dt)
	local ui_renderer = self._ui_renderer
	local ui_top_renderer = self._ui_top_renderer
	local ui_scenegraph = self._ui_scenegraph
	local input_manager = self.input_manager
	local render_settings = self._render_settings
	local gamepad_active = input_manager:is_device_active("gamepad")

	local widgets = self._widgets

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, nil, render_settings)

	for i,widget in pairs(widgets) do 
		UIRenderer.draw_widget(ui_renderer, widget)
	end
	-- UIRenderer.draw_widget(ui_renderer, self._widgets[1])

	UIRenderer.end_pass(ui_renderer)

	render_settings.alpha_multiplier = alpha_multiplier

	if gamepad_active then
		self._menu_input_description:draw(ui_top_renderer, dt)
	end
end

function TestWidgets:play_sound(event)
	WwiseWorld.trigger_event(self.wwise_world, event)
  end

TestWidgets._handle_input = function (self, dt, t)
    local esc_pressed = self:input_service():get("toggle_menu")
    local widgets = self._widgets
	local widgets_by_name = self._widgets_by_name

    if self:_is_button_pressed(widgets_by_name["close_button"]) then
		self:play_sound("Play_hud_select")
		mod:handle_transition("close_quest_board_letter_view")
		return
    end

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

TestWidgets._has_active_level_vote = function (self)
    local voting_manager = self.voting_manager
    local active_vote_name = voting_manager:vote_in_progress()
    local is_mission_vote = active_vote_name == "game_settings_vote" or active_vote_name == "game_settings_deed_vote"

    return is_mission_vote and not voting_manager:has_voted(Network.peer_id())
end


TestWidgets._is_button_pressed = function (self, widget)
    local content = widget.content
    local hotspot = content.button_hotspot or content.hotspot
	if hotspot ~= nil then
		if hotspot.on_release then
			hotspot.on_release = false

			return true
		end
	end

end


TestWidgets.post_update = function (self, dt, t)
	self.ui_animator:update(dt)
	self:_update_animations(dt)
end

TestWidgets._update_animations = function (self, dt)
	for name, animation in pairs(self._ui_animations) do
		UIAnimation.update(animation, dt)

		if UIAnimation.completed(animation) then
			self._ui_animations[name] = nil
		end
	end

	local animations = self._animations
	local ui_animator = self.ui_animator

	for animation_name, animation_id in pairs(animations) do
		if ui_animator:is_animation_completed(animation_id) then
			ui_animator:stop_animation(animation_id)

			animations[animation_name] = nil
		end
	end

	local widgets_by_name = self._widgets_by_name
	local close_button = widgets_by_name.close_button
	-- local close_button = self._widgets[2]
	
	local confirm_button = widgets_by_name.confirm_button

	UIWidgetUtils.animate_default_button(close_button, dt)
	UIWidgetUtils.animate_default_button(confirm_button, dt)
end

-- Required. Executed by `ingame_ui` every tick.
function TestWidgets:update(dt, t)
	self:draw(self:input_service(), dt)

	if self:_has_active_level_vote() then
        mod:handle_transition("close_quest_board_letter_view")
    else
        self:_handle_input(dt, t)
    end
end


-- Required. Return our custom input service here.
function TestWidgets:input_service()
  return self.input_manager:get_service("custom_view_name")
end

function TestWidgets:on_exit()
	self.ui_animator = nil
	
	self.input_manager:device_unblock_all_services("keyboard", 1)
	self.input_manager:device_unblock_all_services("mouse", 1)
	self.input_manager:device_unblock_all_services("gamepad", 1)
  
	ShowCursorStack.pop()
end