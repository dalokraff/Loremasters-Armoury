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
  self._interactable_unit = mod.interactable_questboard_unit


  self._default_table = mod.painting
  self._main_table = mod.painting
  self._ordered_table = mod.list_order
  self._empty_decoration_name = Unit.get_data(mod.interactable_questboard_unit, "current_quest")

--   self:_initialize_simple_decoration_preview()
  
  self:_create_ui_elements()

  local decoration_settings_key = Unit.get_data(interactable_unit, "decoration_settings_key")

    if decoration_settings_key then
        local keep_decoration_extension = ScriptUnit.extension(interactable_unit, "keep_decoration_system")
        local selected_decoration = keep_decoration_extension:get_selected_decoration()
        self._keep_decoration_extension = keep_decoration_extension
        local view_only = Unit.get_data(interactable_unit, "interaction_data", "view_only") or not self._is_server

        if view_only then
            self:_set_info_by_decoration_key(selected_decoration, false)
        -- else
        --     self._customizable_decoration = true

        --     self:_setup_decorations_list()

        --     local start_index = 1
        --     local widgets = self._list_widgets

        --     for i = 1, #widgets, 1 do
        --     if widgets[i].content.key == selected_decoration then
        --         start_index = i

        --         break
        --         end
        --     end

        -- 	self:_on_list_index_selected(start_index)

        -- 	local start_scroll_percentage = self:_get_scrollbar_percentage_by_index(start_index)

        -- 	self._scrollbar_logic:set_scroll_percentage(start_scroll_percentage)
        end
    else
        self:_initialize_simple_decoration_preview()
    end

  
end

TestWidgets._initialize_simple_decoration_preview = function (self)
	local interactable_unit = self._interactable_unit
	local hud_text_line_1 = Unit.get_data(interactable_unit, "interaction_data", "hud_text_line_1")
	local hud_text_line_2 = Unit.get_data(interactable_unit, "interaction_data", "hud_text_line_2")
	local sound_event = Unit.get_data(interactable_unit, "interaction_data", "sound_event")

	-- if sound_event and sound_event ~= "" then
	-- 	self._sound_event = sound_event
	-- 	self._sound_event_delay = (self._sound_event and DIALOGUE_DELAY) or nil
	-- end

	local title = Localize(hud_text_line_1)
	local description = Localize(hud_text_line_2)

	self:_set_info_texts(title, description)
end

TestWidgets._set_info_texts = function (self, title_text, description_text, artist_text)
	local title_height = self:_set_selected_title(title_text)
	local description_height = self:_set_selected_description(description_text)
	local artist_height = (artist_text and self:_set_selected_artist(artist_text)) or 0
	local ui_scenegraph = self._ui_scenegraph
	local title_scenegraph = ui_scenegraph.title_text
	title_scenegraph.size[2] = title_height
	local artist_scenegraph = ui_scenegraph.artist_text
	artist_scenegraph.size[2] = artist_height
	local window_scenegraph = ui_scenegraph.info_window
	local window_position = window_scenegraph.position
	local window_size = window_scenegraph.size
	local available_description_height = window_size[2] - title_height - artist_height - 110
	local description_scenegraph = ui_scenegraph.description_text
	description_scenegraph.size[2] = available_description_height
end

TestWidgets._set_selected_title = function (self, title_text)
	local widget = self._widgets_by_name.title_text
	widget.content.text = title_text
	local scenegraph_id = widget.scenegraph_id
	local text_style = widget.style.text
	local default_scenegraph = scenegraph_definition[scenegraph_id]
	local default_size = default_scenegraph.size
	local text_height = UIUtils.get_text_height(self._ui_renderer, default_size, text_style, title_text)

	return text_height
end

TestWidgets._set_selected_description = function (self, description_text)
	local widget = self._widgets_by_name.description_text
	widget.content.text = description_text
	local scenegraph_id = widget.scenegraph_id
	local text_style = widget.style.text
	local default_scenegraph = scenegraph_definition[scenegraph_id]
	local default_size = default_scenegraph.size
	local text_height = UIUtils.get_text_height(self._ui_renderer, default_size, text_style, description_text)

	return text_height
end

TestWidgets._set_selected_artist = function (self, artist_text)
	local widget = self._widgets_by_name.artist_text
	widget.content.text = artist_text
	local scenegraph_id = widget.scenegraph_id
	local text_style = widget.style.text
	local default_scenegraph = scenegraph_definition[scenegraph_id]
	local default_size = default_scenegraph.size
	local text_height = UIUtils.get_text_height(self._ui_renderer, default_size, text_style, artist_text)

	return text_height
end

TestWidgets._set_info_by_decoration_key = function (self, key, locked)
	local settings = self._main_table[key]
	local display_name = settings.display_name
	local description = settings.description
	local artist = settings.artist
	local description_text = (locked and Localize("interaction_unavailable")) or Localize(description)
	local artist_text = (artist and not locked and Localize(artist)) or ""
	self._selected_decoration = key

	self:_set_info_texts(Localize(display_name), description_text, artist_text)
	self:_play_sound("Stop_all_keep_decorations_desc_vo")

	-- if not locked then
	-- 	local sound_event = settings.sound_event
	-- 	self._sound_event_delay = (sound_event and DIALOGUE_DELAY) or nil
	-- end
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