local mod = get_mod("Loremasters-Armoury")

local definitions = local_require("scripts/ui/views/hero_view/states/definitions/hero_view_state_keep_decorations_definitions")
local definitions = local_require("scripts/mods/Loremasters-Armoury/LA_view/quest_board_views/definitions/quest_board_letter_definitions")
local widget_definitions = definitions.widgets_definitions
local scenegraph_definition = definitions.scenegraph_definition
local generic_input_actions = definitions.generic_input_actions
local animation_definitions = definitions.animation_definitions
local entry_widget_definition = definitions.entry_widget_definition
local dummy_entry_widget_definition = definitions.dummy_entry_widget_definition
local input_actions = definitions.input_actions

QuestBoardLetterView = class(QuestBoardLetterView)

-- Optional. Executed when instantiating your custom view with `CustomView:new`
function QuestBoardLetterView:init(ingame_ui_context)
  -- Good idea to create an input service here for use within the view
  local input_manager = ingame_ui_context.input_manager
  input_manager:create_input_service("custom_view_name", "IngameMenuKeymaps", "IngameMenuFilters")
  input_manager:map_device_to_service("custom_view_name", "keyboard")
  input_manager:map_device_to_service("custom_view_name", "mouse")
  input_manager:map_device_to_service("custom_view_name", "gamepad")
  
  
  self.input_manager = input_manager
  self._ui_renderer = ingame_ui_context.ui_renderer
  self._ui_top_renderer = ingame_ui_context.ui_top_renderer
end

-- Optional. Executed by `ingame_ui` after transitioning to your custom view.
-- Supplied the transition params that are supplied to the transition function
function QuestBoardLetterView:on_enter(transition_params)
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
  self:_create_ui_elements(transition_params)
end

QuestBoardLetterView._create_ui_elements = function (self, params)
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	local widgets = {}
	local widgets_by_name = {}

	for name, widget_definition in pairs(widget_definitions) do
		if widget_definition then
			local widget = UIWidget.init(widget_definition)
			widgets[#widgets + 1] = widget
			widgets_by_name[name] = widget
		end
	end

	self._widgets = widgets
	self._widgets_by_name = widgets_by_name

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self.ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)
	local scrollbar_widget = self._widgets_by_name.list_scrollbar
	self._scrollbar_logic = ScrollBarLogic:new(scrollbar_widget)
end

QuestBoardLetterView._update_scroll_position = function (self)
	local scrollbar_logic = self._scrollbar_logic
	local length = scrollbar_logic:get_scrolled_length()

	if length ~= self._scrolled_length then
		self._ui_scenegraph.list_scroll_root.local_position[2] = math.round(length)
		self._scrolled_length = length
	end
end

QuestBoardLetterView._update_visible_list_entries = function (self)
	local scrollbar_logic = self._scrollbar_logic
	local enabled = scrollbar_logic:enabled()

	if not enabled then
		return
	end

	local scroll_percentage = scrollbar_logic:get_scroll_percentage()
	local scrolled_length = scrollbar_logic:get_scrolled_length()
	local scroll_length = scrollbar_logic:get_scroll_length()
	local list_window_size = scenegraph_definition.list_window.size
	local draw_padding = LIST_SPACING * 2
	local draw_length = list_window_size[2] + draw_padding
	local widgets = self._list_widgets
	local num_widgets = #widgets

	for index, widget in ipairs(widgets) do
		local offset = widget.offset
		local content = widget.content
		local size = content.size
		local widget_position = math.abs(offset[2]) + size[2]
		local is_outside = false

		if widget_position < scrolled_length - draw_padding then
			is_outside = true
		elseif draw_length < math.abs(offset[2]) - scrolled_length then
			is_outside = true
		end

		content.visible = not is_outside
	end
end

QuestBoardLetterView.draw = function (self, input_service, dt)
	self:_update_visible_list_entries()

	local ui_renderer = self._ui_renderer
	local ui_top_renderer = self._ui_top_renderer
	local ui_scenegraph = self._ui_scenegraph
	local input_manager = self.input_manager
	local render_settings = self._render_settings
	local gamepad_active = input_manager:is_device_active("gamepad")

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, nil, render_settings)

	local snap_pixel_positions = render_settings.snap_pixel_positions
	local alpha_multiplier = render_settings.alpha_multiplier or 1
	local list_widgets = self._list_widgets

	if list_widgets then
		for _, widget in ipairs(list_widgets) do
			UIRenderer.draw_widget(ui_renderer, widget)
		end
	end

	local dummy_list_widgets = self._dummy_list_widgets

	if dummy_list_widgets then
		for _, widget in ipairs(dummy_list_widgets) do
			UIRenderer.draw_widget(ui_renderer, widget)
		end
	end

	for _, widget in ipairs(self._widgets) do
		if widget.snap_pixel_positions ~= nil then
			render_settings.snap_pixel_positions = widget.snap_pixel_positions
		end

		render_settings.alpha_multiplier = widget.alpha_multiplier or alpha_multiplier

		UIRenderer.draw_widget(ui_renderer, widget)

		render_settings.snap_pixel_positions = snap_pixel_positions
	end

	UIRenderer.end_pass(ui_renderer)

	render_settings.alpha_multiplier = alpha_multiplier

	if gamepad_active then
		self._menu_input_description:draw(ui_top_renderer, dt)
	end
end


-- Required. Executed by `ingame_ui` every tick.
function QuestBoardLetterView:update(dt, t)
	if DO_RELOAD then
		DO_RELOAD = false

		self:_create_ui_elements()
	end
	self:_update_scroll_position()
	self:draw(self:input_service(), dt)
end

-- Required. Return our custom input service here.
function QuestBoardLetterView:input_service()
  return self.input_manager:get_service("custom_view_name")
end

function QuestBoardLetterView:on_exit()
	self.input_manager:device_unblock_all_services("keyboard", 1)
	self.input_manager:device_unblock_all_services("mouse", 1)
	self.input_manager:device_unblock_all_services("gamepad", 1)
  
	ShowCursorStack.pop()
  end