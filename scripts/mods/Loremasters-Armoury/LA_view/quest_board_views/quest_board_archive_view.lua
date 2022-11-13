local mod = get_mod("Loremasters-Armoury")

local definitions = local_require("scripts/mods/Loremasters-Armoury/LA_view/quest_board_views/definitions/quest_board_archive_definitions")
local widget_definitions = definitions.widgets
local entry_widget_definition = definitions.entry_widget_definition
local dummy_entry_widget_definition = definitions.dummy_entry_widget_definition
local scenegraph_definition = definitions.scenegraph_definition
local animation_definitions = definitions.animation_definitions
local generic_input_actions = definitions.generic_input_actions
local input_actions = definitions.input_actions

local DO_RELOAD = false
local LIST_SPACING = 4
local LIST_MAX_WIDTH = 800
local DIALOGUE_DELAY = 1

QuestBoardArchiveView = class(QuestBoardArchiveView)

-- Optional. Executed when instantiating your custom view with `CustomView:new`
function QuestBoardArchiveView:init(ingame_ui_context)
  -- Good idea to create an input service here for use within the view
  self.ingame_ui_context = ingame_ui_context
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
function QuestBoardArchiveView:on_enter(transition_params)
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

  self._menu_input_description = MenuInputDescriptionUI:new(self.ingame_ui_context, self._ui_top_renderer, self:input_service(), 3, 100, generic_input_actions)

  self._animations = {}
  self._ui_animations = {}

  self.quest_board = mod.letter_board

  self._interactable_unit = self.quest_board.interactable_unit


  self._default_table = mod.painting
  self._main_table = mod.painting
  self._ordered_table = mod.list_order
  self._empty_decoration_name = Unit.get_data(interactable_unit, "current_quest")

  self._menu_input_description:set_input_description(nil)

--   self:_initialize_simple_decoration_preview()
  self:_create_ui_elements()


  local decoration_settings_key = Unit.get_data(interactable_unit, "decoration_settings_key") or true

  if decoration_settings_key then
	--   local keep_decoration_extension = ScriptUnit.extension(interactable_unit, "keep_decoration_system")
	  local selected_decoration = self.quest_board.active_quest
	--   self._keep_decoration_extension = keep_decoration_extension
	  local view_only = Unit.get_data(interactable_unit, "interaction_data", "view_only") or not self._is_server

	--   if view_only then
	-- 	  self:_set_info_by_decoration_key(selected_decoration, false)
	--   else
		  self._customizable_decoration = true

		  self:_setup_decorations_list()

		  local start_index = 1
		  local widgets = self._list_widgets

		  for i = 1, #widgets, 1 do
			  if widgets[i].content.key == selected_decoration then
				  start_index = i

				  break
			  end
		  end

		  self:_on_list_index_selected(start_index)

		  local start_scroll_percentage = self:_get_scrollbar_percentage_by_index(start_index)

		  self._scrollbar_logic:set_scroll_percentage(start_scroll_percentage)
	--   end
  else
	  self:_initialize_simple_decoration_preview()
  end


--   self:_initialize_simple_decoration_preview()
  self:play_sound("Loremaster_letter_open_sound__1_")
  
end


QuestBoardArchiveView._set_info_by_decoration_key = function (self, key, locked)
	local settings = self._main_table[key]
	local display_name = settings.display_name
	local description = settings.description
	local artist = settings.artist
	local description_text = (locked and Localize("interaction_unavailable")) or Localize(description)
	local artist_text = (artist and not locked and Localize(artist)) or ""
	self._selected_decoration = key

	self:_set_info_texts(Localize(display_name), description_text, artist_text)
	self:play_sound("Stop_all_keep_decorations_desc_vo")

end

QuestBoardArchiveView._initialize_simple_decoration_preview = function (self)
	local interactable_unit = self._interactable_unit
	local hud_text_line_1 = Unit.get_data(interactable_unit, "interaction_data", "hud_text_line_1")
	local hud_text_line_2 = Unit.get_data(interactable_unit, "interaction_data", "hud_text_line_2")

	local title = Localize(hud_text_line_1)
	local description = Localize(hud_text_line_2)

	self:_set_info_texts(title, description)
end

QuestBoardArchiveView._set_info_texts = function (self, title_text, description_text, artist_text)
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

QuestBoardArchiveView._set_selected_title = function (self, title_text)
	local widget = self._widgets_by_name.title_text
	widget.content.text = title_text
	local scenegraph_id = widget.scenegraph_id
	local text_style = widget.style.text
	local default_scenegraph = scenegraph_definition[scenegraph_id]
	local default_size = default_scenegraph.size
	local text_height = UIUtils.get_text_height(self._ui_renderer, default_size, text_style, title_text)

	return text_height
end

QuestBoardArchiveView._set_selected_description = function (self, description_text)
	local widget = self._widgets_by_name.description_text
	widget.content.text = description_text
	local scenegraph_id = widget.scenegraph_id
	local text_style = widget.style.text
	local default_scenegraph = scenegraph_definition[scenegraph_id]
	local default_size = default_scenegraph.size
	local text_height = UIUtils.get_text_height(self._ui_renderer, default_size, text_style, description_text)

	return text_height
end

QuestBoardArchiveView._set_selected_artist = function (self, artist_text)
	local widget = self._widgets_by_name.artist_text
	widget.content.text = artist_text
	local scenegraph_id = widget.scenegraph_id
	local text_style = widget.style.text
	local default_scenegraph = scenegraph_definition[scenegraph_id]
	local default_size = default_scenegraph.size
	local text_height = UIUtils.get_text_height(self._ui_renderer, default_size, text_style, artist_text)

	return text_height
end

QuestBoardArchiveView._create_ui_elements = function (self)
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

QuestBoardArchiveView._initialize_scrollbar = function (self)
	local list_window_size = scenegraph_definition.list_window.size
	local list_scrollbar_size = scenegraph_definition.list_scrollbar.size
	local draw_length = list_window_size[2]
	local content_length = self._total_list_height
	local scrollbar_length = list_scrollbar_size[2]
	local step_size = 220 + LIST_SPACING * 1.5
	local scroll_step_multiplier = 1
	local scrollbar_logic = self._scrollbar_logic

	scrollbar_logic:set_scrollbar_values(draw_length, content_length, scrollbar_length, step_size, scroll_step_multiplier)
	scrollbar_logic:set_scroll_percentage(0)
end

QuestBoardArchiveView._get_scrollbar_percentage_by_index = function (self, index)
	local scrollbar_logic = self._scrollbar_logic
	local enabled = scrollbar_logic:enabled()

	if enabled then
		local scroll_percentage = scrollbar_logic:get_scroll_percentage()
		local scrolled_length = scrollbar_logic:get_scrolled_length()
		local scroll_length = scrollbar_logic:get_scroll_length()
		local list_window_size = scenegraph_definition.list_window.size
		local draw_length = list_window_size[2]
		local draw_start_height = scrolled_length
		local draw_end_height = draw_start_height + draw_length
		local list_widgets = self._list_widgets

		if list_widgets then
			local widget = list_widgets[index]
			local content = widget.content
			local offset = widget.offset
			local size = content.size
			local height = size[2]
			local start_position_top = math.abs(offset[2])
			local start_position_bottom = start_position_top + height
			local percentage_difference = 0

			if draw_end_height < start_position_bottom then
				local height_missing = start_position_bottom - draw_end_height
				percentage_difference = math.clamp(height_missing / scroll_length, 0, 1)
			elseif start_position_top < draw_start_height then
				local height_missing = draw_start_height - start_position_top
				percentage_difference = -math.clamp(height_missing / scroll_length, 0, 1)
			end

			if percentage_difference then
				local scroll_percentage = math.clamp(scroll_percentage + percentage_difference, 0, 1)

				return scroll_percentage
			end
		end
	end

	return 0
end


QuestBoardArchiveView._update_scroll_position = function (self)
	local scrollbar_logic = self._scrollbar_logic
	local length = scrollbar_logic:get_scrolled_length()

	if length ~= self._scrolled_length then
		self._ui_scenegraph.list_scroll_root.local_position[2] = math.round(length)
		self._scrolled_length = length
	end
end

QuestBoardArchiveView._update_visible_list_entries = function (self)
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

QuestBoardArchiveView.draw = function (self, input_service, dt)
	self:_update_visible_list_entries()

	local ui_renderer = self._ui_renderer
	local ui_top_renderer = self._ui_top_renderer
	local ui_scenegraph = self._ui_scenegraph
	local input_manager = self.input_manager
	local render_settings = self._render_settings
	local gamepad_active = input_manager:is_device_active("gamepad")

	local widgets = self._widgets

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, nil, render_settings)

	-- for i,widget in pairs(widgets) do 
	-- 	UIRenderer.draw_widget(ui_renderer, widget)
	-- end
	-- UIRenderer.draw_widget(ui_renderer, self._widgets[1])

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

function QuestBoardArchiveView:play_sound(event)
	WwiseWorld.trigger_event(self.wwise_world, event)
end

QuestBoardArchiveView._is_button_hover_enter = function (self, widget)
	local content = widget.content
	local hotspot = content.button_hotspot or content.hotspot

	return hotspot.on_hover_enter
end



QuestBoardArchiveView._handle_gamepad_list_selection = function (self, input_service)
	local current_index = self._selected_list_index

	if not current_index then
		return
	end

	local list_widgets = self._list_widgets
	local num_rows = #list_widgets
	local new_index, scroll_index = nil

	if input_service:get("move_up_hold_continuous") then
		new_index = math.max(current_index - 1, 1)
		scroll_index = math.max(new_index - 3, 1)
	elseif input_service:get("move_down_hold_continuous") then
		new_index = math.min(current_index + 1, num_rows)
		scroll_index = math.min(new_index + 3, num_rows)
	end

	if new_index and new_index ~= current_index then
		local scroll_percentage = self:_get_scrollbar_percentage_by_index(scroll_index)

		self:_on_list_index_selected(new_index, scroll_percentage)
		self:play_sound("Play_hud_hover")
	end
end


QuestBoardArchiveView._handle_input = function (self, dt, t)
    -- local esc_pressed = self:input_service():get("toggle_menu")
    -- local widgets = self._widgets
	-- local widgets_by_name = self._widgets_by_name

    -- if self:_is_button_pressed(widgets_by_name["close_button"]) then
	-- 	self:play_sound("Play_hud_select")
	-- 	mod:handle_transition("close_quest_board_letter_view")
	-- 	return
    -- end

	-- if self:_is_button_pressed(widgets_by_name["my_button"]) then
	-- 	self:play_sound("Play_hud_select")
	-- 	mod:handle_transition("close_quest_board_letter_view")
	-- 	return
    -- end

    -- if esc_pressed then

    --     mod:handle_transition("close_quest_board_letter_view")

    --     return
    -- end



	local input_service = self:input_service()
	local mouse_active = Managers.input:is_device_active("mouse")
	local input_pressed = input_service:get("toggle_menu")
	local input_close_pressed = not mouse_active and input_service:get("back")
	local widgets_by_name = self._widgets_by_name

	self._scrollbar_logic:update(dt, t)

	local close_button = widgets_by_name.close_button
	local confirm_button = widgets_by_name.confirm_button

	if self:_is_button_hover_enter(close_button) or self:_is_button_hover_enter(confirm_button) then
		self:play_sound("Play_hud_hover")
	end

	if self._customizable_decoration then
		local interactable_unit = self._interactable_unit

		if self:_is_button_pressed(confirm_button) or input_service:get("confirm") then
			-- local keep_decoration_extension = ScriptUnit.extension(interactable_unit, "keep_decoration_system")

			if self._selected_equipped_decoration then
				-- keep_decoration_extension:unequip_decoration()

				self._selected_equipped_decoration = false

				self:_update_confirm_button()
				self:_update_equipped_widget()
				self._menu_input_description:set_input_description(input_actions.default)
				self:play_sound("Play_hud_select")
			else
				self:_verify_decoration_selection()
				-- keep_decoration_extension:confirm_selection()
				self:play_sound("hud_add_painting")

				self._selected_equipped_decoration = true

				self:_update_confirm_button()
				self:_update_equipped_widget()
				self._menu_input_description:set_input_description(input_actions.remove)
			end
		end

		local is_list_hovered = false

		if not mouse_active then
			is_list_hovered = true

			self:_handle_gamepad_list_selection(input_service)
		else
			is_list_hovered = self:_is_list_hovered()
			local list_widgets = self._list_widgets

			if list_widgets and is_list_hovered then
				for i, widget in ipairs(list_widgets) do
					if self:_is_button_hover_enter(widget) then
						self:play_sound("play_gui_equipment_button_hover")
					end
				end
			end

			local list_index = self:_list_index_pressed()

			if list_index and list_index ~= self._selected_list_index then
				self:_on_list_index_selected(list_index)
				self:play_sound("Play_hud_select")
			end
		end

		self:_animate_list_entries(dt, is_list_hovered)
	end

	if input_pressed or self:_is_button_pressed(close_button) or input_close_pressed then
		self:play_sound("Play_hud_select")
		mod:handle_transition("close_quest_board_letter_view")

		return
	end
end

QuestBoardArchiveView._verify_decoration_selection = function (self)

	local index = self._selected_list_index
	local list_widgets = self._list_widgets

	if not index or index > #list_widgets then
		return
	end

	local selected_widget = list_widgets[index]
	local selected_content = selected_widget.content
	local selected_key = selected_content.key
	local locked = selected_content.locked

	if locked then
		return
	else
		-- keep_decoration_extension:decoration_selected(selected_key)
		self.quest_board:change_active_quest(selected_key)
	end
end

QuestBoardArchiveView._list_index_pressed = function (self)
	local list_widgets = self._list_widgets

	if list_widgets then
		for index, widget in ipairs(list_widgets) do
			local content = widget.content
			local hotspot = content.hotspot or content.button_hotspot

			if hotspot and hotspot.on_release then
				hotspot.on_release = false

				return index
			end
		end
	end
end

QuestBoardArchiveView._is_list_hovered = function (self)
	local widget = self._widgets_by_name.list_mask

	return widget.content.hotspot.is_hover or false
end


QuestBoardArchiveView._has_active_level_vote = function (self)
    local voting_manager = self.voting_manager
    local active_vote_name = voting_manager:vote_in_progress()
    local is_mission_vote = active_vote_name == "game_settings_vote" or active_vote_name == "game_settings_deed_vote"

    return is_mission_vote and not voting_manager:has_voted(Network.peer_id())
end


QuestBoardArchiveView._is_button_pressed = function (self, widget)
    local content = widget.content
    local hotspot = content.button_hotspot or content.hotspot
	if hotspot ~= nil then
		if hotspot.on_release then
			hotspot.on_release = false

			return true
		end
	end

end

QuestBoardArchiveView._update_confirm_button = function (self)
	local selected_equipped_decoration = self._selected_equipped_decoration == true
	local button = self._widgets_by_name.confirm_button

	if selected_equipped_decoration then
		button.content.title_text = Localize("input_description_remove")
	else
		button.content.title_text = Localize("menu_settings_apply")
	end
end

QuestBoardArchiveView._align_list_widgets = function (self)
	local total_height = 0
	local list_widgets = self._list_widgets
	local dummy_widgets = self._dummy_list_widgets
	local num_widgets = #list_widgets + #dummy_widgets

	for index = 1, num_widgets, 1 do
		local widget = nil

		if index <= #list_widgets then
			widget = list_widgets[index]
		else
			widget = dummy_widgets[index - #list_widgets]
		end

		local offset = widget.offset
		local content = widget.content
		local size = content.size
		widget.default_offset = table.clone(offset)
		local height = size[2]
		offset[2] = -total_height
		total_height = total_height + height

		if index ~= num_widgets then
			total_height = total_height + LIST_SPACING
		end
	end

	self._total_list_height = total_height
end

QuestBoardArchiveView._setup_decorations_list = function (self)
	local widgets = {}
	local index = 0

	for _, key in ipairs(self._ordered_table) do
		if not table.contains(self._default_table, key) then
			local settings = self._main_table[key]
			local display_name = Localize(settings.display_name)
			local widget = UIWidget.init(entry_widget_definition)
			index = index + 1
			widgets[index] = widget
			local content = widget.content
			local style = widget.style
			local title = display_name
			local title_style = style.title
			local max_text_width = title_style.size[1] - 10
			content.title = UIRenderer.crop_text_width(self._ui_renderer, title, max_text_width, title_style)
			content.key = key
			content.locked = false
			-- content.new = new
			content.in_use = self.quest_board:is_quest_active(key)
		end
	end

	table.sort(widgets, function (a, b)
		local a_content = a.content
		local b_content = b.content

		if a_content.new ~= b_content.new then
			return a_content.new
		end

		return Localize(a_content.title) < Localize(b_content.title)
	end)

	self._list_widgets = widgets
	self._dummy_list_widgets = {}

	self:_align_list_widgets()

	local content_length = self._total_list_height
	local list_scrollbar_size = scenegraph_definition.list_scrollbar.size
	local scrollbar_length = list_scrollbar_size[2]
	local dummy_list_widgets = {}

	if content_length < scrollbar_length then
		local dummy_count = 0
		local dummy_height = LIST_SPACING

		while scrollbar_length > content_length + dummy_height do
			dummy_count = dummy_count + 1
			local widget = UIWidget.init(dummy_entry_widget_definition)

			table.insert(dummy_list_widgets, widget)

			local content = widget.content
			local size = content.size
			local height = size[2]
			dummy_height = dummy_height + height + LIST_SPACING
		end
	end

	self._dummy_list_widgets = dummy_list_widgets

	self:_align_list_widgets()
	self:_initialize_scrollbar()
	self:_update_equipped_widget()
end


QuestBoardArchiveView._on_list_index_selected = function (self, index, scrollbar_animation_percentage)
	local interactable_unit = self._interactable_unit
	-- local keep_decoration_extension = ScriptUnit.extension(interactable_unit, "keep_decoration_system")
	-- local equipped_decoration = keep_decoration_extension:get_selected_decoration()
	local equipped_decoration = self.quest_board.active_quest
	local list_widgets = self._list_widgets

	if not index or index > #list_widgets then
		return
	end

	local selected_widget = list_widgets[index]
	local selected_content = selected_widget.content
	local selected_key = selected_content.key

	-- if ItemHelper.is_new_keep_decoration_id(selected_key) then
	-- 	ItemHelper.unmark_keep_decoration_as_new(selected_key)

	-- 	selected_content.new = false
	-- end

	-- local locked = selected_content.locked

	self:_set_info_by_decoration_key(selected_key, locked)

	-- if locked then
	-- 	keep_decoration_extension:decoration_selected(self._empty_decoration_name)
	-- else
	-- 	keep_decoration_extension:decoration_selected(selected_key)
	-- end
	self.quest_board:change_active_quest(selected_key)

	self._selected_equipped_decoration = equipped_decoration == selected_key

	self:_update_confirm_button()

	local input_action_key = (self._selected_equipped_decoration and "remove") or "default"

	self._menu_input_description:set_input_description(input_action_key and input_actions[input_action_key])

	if list_widgets then
		for i, widget in ipairs(list_widgets) do
			local content = widget.content
			local hotspot = content.hotspot or content.button_hotspot

			if hotspot then
				local is_selected = i == index
				hotspot.is_selected = is_selected

				if is_selected then
					hotspot.on_hover_enter = true
				end
			end
		end
	end

	self._previous_selected_list_index = self._selected_list_index
	self._selected_list_index = index

	if scrollbar_animation_percentage then
		local scrollbar_widget = self._widgets_by_name.list_scrollbar
		local scroll_bar_info = scrollbar_widget.content.scroll_bar_info
		local func = UIAnimation.function_by_time
		local target = scroll_bar_info
		local target_index = "scroll_value"
		local from = scroll_bar_info.scroll_value
		local to = scrollbar_animation_percentage
		local duration = 0.3
		local easing = math.easeOutCubic
		self._ui_animations.scrollbar = UIAnimation.init(func, target, target_index, from, to, duration, easing)
	else
		self._ui_animations.scrollbar = nil
	end
end


QuestBoardArchiveView._animate_list_entries = function (self, dt, is_list_hovered)
	local widgets = self._list_widgets

	if not widgets then
		return
	end

	for index, widget in ipairs(widgets) do
		self:_animate_list_widget(widget, dt, is_list_hovered)
	end
end

QuestBoardArchiveView._animate_list_widget = function (self, widget, dt, optional_hover)
	local offset = widget.offset
	local content = widget.content
	local style = widget.style
	local hotspot = content.button_hotspot or content.hotspot
	local on_hover_enter = hotspot.on_hover_enter
	local is_hover = hotspot.is_hover

	if optional_hover ~= nil and not optional_hover then
		is_hover = false
		on_hover_enter = false
	end

	local is_selected = hotspot.is_selected
	local input_pressed = not is_selected and hotspot.is_clicked and hotspot.is_clicked == 0
	local input_progress = hotspot.input_progress or 0
	local hover_progress = hotspot.hover_progress or 0
	local pulse_progress = hotspot.pulse_progress or 1
	local offset_progress = hotspot.offset_progress or 1
	local selection_progress = hotspot.selection_progress or 0
	local speed = ((is_hover or is_selected) and 14) or 3
	local pulse_speed = 3
	local input_speed = 20
	local offset_speed = 5

	if input_pressed then
		input_progress = math.min(input_progress + dt * input_speed, 1)
	else
		input_progress = math.max(input_progress - dt * input_speed, 0)
	end

	local input_easing_out_progress = math.easeOutCubic(input_progress)
	local input_easing_in_progress = math.easeInCubic(input_progress)

	if on_hover_enter then
		pulse_progress = 0
	end

	pulse_progress = math.min(pulse_progress + dt * pulse_speed, 1)
	local pulse_easing_out_progress = math.easeOutCubic(pulse_progress)
	local pulse_easing_in_progress = math.easeInCubic(pulse_progress)

	if is_hover then
		hover_progress = math.min(hover_progress + dt * speed, 1)
	else
		hover_progress = math.max(hover_progress - dt * speed, 0)
	end

	local hover_easing_out_progress = math.easeOutCubic(hover_progress)
	local hover_easing_in_progress = math.easeInCubic(hover_progress)

	if is_selected then
		selection_progress = math.min(selection_progress + dt * speed, 1)
		offset_progress = math.min(offset_progress + dt * offset_speed, 1)
	else
		selection_progress = math.max(selection_progress - dt * speed, 0)
		offset_progress = math.max(offset_progress - dt * offset_speed, 0)
	end

	local select_easing_out_progress = math.easeOutCubic(selection_progress)
	local select_easing_in_progress = math.easeInCubic(selection_progress)
	local combined_progress = math.max(hover_progress, selection_progress)
	local combined_out_progress = math.max(select_easing_out_progress, hover_easing_out_progress)
	local combined_in_progress = math.max(hover_easing_in_progress, select_easing_in_progress)
	local hover_alpha = 255 * combined_progress
	style.hover_frame.color[1] = hover_alpha
	local title_text_style = style.title
	local title_text_color = title_text_style.text_color
	local title_default_text_color = title_text_style.default_text_color
	local title_hover_text_color = title_text_style.hover_text_color

	Colors.lerp_color_tables(title_default_text_color, title_hover_text_color, combined_progress, title_text_color)

	local pulse_alpha = 255 - 255 * pulse_progress
	style.pulse_frame.color[1] = pulse_alpha
	offset[1] = 10 * math.ease_in_exp(offset_progress)
	hotspot.offset_progress = offset_progress
	hotspot.pulse_progress = pulse_progress
	hotspot.hover_progress = hover_progress
	hotspot.input_progress = input_progress
	hotspot.selection_progress = selection_progress
end


QuestBoardArchiveView._update_equipped_widget = function (self)
	local interactable_unit = self._interactable_unit
	-- local keep_decoration_extension = ScriptUnit.extension(interactable_unit, "keep_decoration_system")
	-- local equipped_decoration = keep_decoration_extension:get_selected_decoration()
	local equipped_decoration = self.quest_board.active_quest
	local decoration_system = self.quest_board

	for _, list_widget in pairs(self._list_widgets) do
		local key = list_widget.content.key
		list_widget.content.in_use = decoration_system:is_quest_active(key)
		list_widget.content.equipped = equipped_decoration == key
	end
end

QuestBoardArchiveView.post_update = function (self, dt, t)	
	self.ui_animator:update(dt)
	self:_update_animations(dt)
end

QuestBoardArchiveView._update_animations = function (self, dt)
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
	local confirm_button = widgets_by_name.confirm_button

	UIWidgetUtils.animate_default_button(close_button, dt)
	UIWidgetUtils.animate_default_button(confirm_button, dt)
end

-- Required. Executed by `ingame_ui` every tick.
function QuestBoardArchiveView:update(dt, t)	
	self:_handle_gamepad_activity()
	
	self:_update_scroll_position()
	self:draw(self:input_service(), dt)

	if self:_has_active_level_vote() then
        mod:handle_transition("close_quest_board_letter_view")
    else
        self:_handle_input(dt, t)
    end
end


-- Required. Return our custom input service here.
function QuestBoardArchiveView:input_service()
  return self.input_manager:get_service("custom_view_name")
end


QuestBoardArchiveView._handle_gamepad_activity = function (self)
	local mouse_active = Managers.input:is_device_active("mouse")
	local force_update = self._gamepad_active_last_frame == nil

	if not mouse_active then
		if not self._gamepad_active_last_frame or force_update then
			self._gamepad_active_last_frame = true

			if self._customizable_decoration then
				local selected_list_index = self._selected_list_index

				if selected_list_index then
					local scroll_percentage = self:_get_scrollbar_percentage_by_index(selected_list_index)

					self._scrollbar_logic:set_scroll_percentage(scroll_percentage)
				end
			end
		end
	elseif self._gamepad_active_last_frame or force_update then
		self._gamepad_active_last_frame = false
	end
end

function QuestBoardArchiveView:on_exit()
	self.ui_animator = nil
	
	self.input_manager:device_unblock_all_services("keyboard", 1)
	self.input_manager:device_unblock_all_services("mouse", 1)
	self.input_manager:device_unblock_all_services("gamepad", 1)
  
	ShowCursorStack.pop()
end