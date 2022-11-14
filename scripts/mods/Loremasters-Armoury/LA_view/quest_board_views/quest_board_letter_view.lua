local mod = get_mod("Loremasters-Armoury")

local definitions = local_require("scripts/mods/Loremasters-Armoury/LA_view/quest_board_views/definitions/quest_board_letter_definitions")
local widget_definitions = definitions.widgets
local scenegraph_definition = definitions.scenegraph_definition
local animation_definitions = definitions.animation_definitions
local create_trait_option = definitions.create_trait_option
local create_reward_option = definitions.create_reward_option


local DO_RELOAD = true

QuestBoardLetterView = class(QuestBoardLetterView)

-- Optional. Executed when instantiating your custom view with `CustomView:new`
function QuestBoardLetterView:init(ingame_ui_context)
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
  self._animations = {}
  self._ui_animations = {}
  self.quest_board = mod.letter_board
  self._interactable_unit = mod.interactable_unit

  self._default_table = mod.painting
  self._main_table = mod.painting
  self._ordered_table = {
	"place",
	"holder",
	"hello",
	"world",
  }
  self._empty_decoration_name = Unit.get_data(interactable_unit, "current_quest")

--   self:_initialize_simple_decoration_preview()
  self:_create_ui_elements()


  self:_initialize_simple_decoration_preview()
  self:play_sound("Loremaster_letter_open_sound__1_")
  
end

QuestBoardLetterView._initialize_simple_decoration_preview = function (self)
	local interactable_unit = self._interactable_unit
	local hud_text_line_1 = Unit.get_data(interactable_unit, "interaction_data", "hud_text_line_1")
	local hud_text_line_2 = Unit.get_data(interactable_unit, "interaction_data", "hud_text_line_2")

	local title = Localize(hud_text_line_1)
	local description = Localize(hud_text_line_2)

	self:_set_info_texts(title, description)
end

QuestBoardLetterView._set_info_texts = function (self, title_text, description_text, artist_text)
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

QuestBoardLetterView._set_selected_title = function (self, title_text)
	local widget = self._widgets_by_name.title_text
	widget.content.text = title_text
	local scenegraph_id = widget.scenegraph_id
	local text_style = widget.style.text
	local default_scenegraph = scenegraph_definition[scenegraph_id]
	local default_size = default_scenegraph.size
	local text_height = UIUtils.get_text_height(self._ui_renderer, default_size, text_style, title_text)

	return text_height
end

QuestBoardLetterView._set_selected_description = function (self, description_text)
	local widget = self._widgets_by_name.description_text
	widget.content.text = description_text
	local scenegraph_id = widget.scenegraph_id
	local text_style = widget.style.text
	local default_scenegraph = scenegraph_definition[scenegraph_id]
	local default_size = default_scenegraph.size
	local text_height = UIUtils.get_text_height(self._ui_renderer, default_size, text_style, description_text)

	return text_height
end

QuestBoardLetterView._set_selected_artist = function (self, artist_text)
	local widget = self._widgets_by_name.artist_text
	widget.content.text = artist_text
	local scenegraph_id = widget.scenegraph_id
	local text_style = widget.style.text
	local default_scenegraph = scenegraph_definition[scenegraph_id]
	local default_size = default_scenegraph.size
	local text_height = UIUtils.get_text_height(self._ui_renderer, default_size, text_style, artist_text)

	return text_height
end


QuestBoardLetterView._create_reward_display = function (self, title_text, description_text, icon)
	local ui_top_renderer = self._ui_top_renderer
	local scenegraph_id = "reward_display"
	local definition = create_reward_option(scenegraph_id, title_text, description_text, icon)
	local widget = UIWidget.init(definition)
	local content = widget.content
	local style = widget.style
	local text_style = style.text
	local description_text_style = style.description_text
	local description_text_size = description_text_style.size
	local text_height = math.floor(UIUtils.get_text_height(ui_top_renderer, description_text_size, description_text_style, description_text))
	local additional_height = math.floor(text_height)

	return widget, additional_height
end

QuestBoardLetterView.setup_reward_display = function (self, title_text, description_text, icon)
	local widgets = self._widgets
	local unit_name = Unit.get_data(self._interactable_unit, "unit_name")
	local quest_board = self.quest_board
	local active_quest = quest_board.active_quest
	local main_quest = QuestLetters[active_quest]
	local sub_quest_data = main_quest[unit_name]
	local sub_quest_name = sub_quest_data.sub_quest_name
	local reward_data = ItemMasterList[sub_quest_name.."_reward"]
	local name = reward_data.display_name or ""
	local trait_advanced_description = reward_data.information_text or ""
	local trait_icon = reward_data.inventory_icon
	local title_text = Localize(name)
	-- local description_text = reward_data.description or ""
	local description_text = Localize(reward_data.description or reward_data.item_type or "")
	local widget, additional_height = self:_create_reward_display(title_text, description_text, trait_icon)
	widgets[#widgets + 1] = widget

	
end


QuestBoardLetterView._create_trait_option_entry = function (self, title_text, description_text, icon)
	local ui_top_renderer = self._ui_top_renderer
	local scenegraph_id = "trait_options"
	local definition = create_trait_option(scenegraph_id, title_text, description_text, icon)
	local widget = UIWidget.init(definition)
	local content = widget.content
	local style = widget.style
	local text_style = style.text
	local description_text_style = style.description_text
	local description_text_size = description_text_style.size
	local text_height = math.floor(UIUtils.get_text_height(ui_top_renderer, description_text_size, description_text_style, description_text))
	local additional_height = math.floor(text_height)

	return widget, additional_height
end

QuestBoardLetterView._setup_modifier_list = function (self)
	local widgets = self._widgets
	local edge_spacing = 45
	local spacing = 30
	local y_offset = edge_spacing
	for _, name in pairs(self._ordered_table) do
		local approved = false

		local trait_name = name
		local trait_advanced_description = name.."_description_adv"
		local trait_icon = "la_mq01_reward_sub9_icon"
		local title_text = Localize(trait_name)
		local description_text = name.."_desc"
		local widget, additional_height = self:_create_trait_option_entry(title_text, description_text, trait_icon)
		widgets[#widgets + 1] = widget
		widget.offset[2] = -y_offset
		y_offset = y_offset + spacing + additional_height
		
	end
	
end

QuestBoardLetterView._create_ui_elements = function (self)
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

	self:_setup_modifier_list()

	self:setup_reward_display()

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self.ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)
end

QuestBoardLetterView.draw = function (self, input_service, dt)
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

function QuestBoardLetterView:play_sound(event)
	WwiseWorld.trigger_event(self.wwise_world, event)
  end

QuestBoardLetterView._handle_input = function (self, dt, t)
    local esc_pressed = self:input_service():get("toggle_menu")
    local widgets = self._widgets
	local widgets_by_name = self._widgets_by_name

    if self:_is_button_pressed(widgets_by_name["close_button"]) then
		self:play_sound("Play_hud_select")
		mod:handle_transition("close_quest_board_letter_view")
		return
    end

	-- if self:_is_button_pressed(widgets_by_name["my_button"]) then
	-- 	self:play_sound("Play_hud_select")
	-- 	mod:handle_transition("close_quest_board_letter_view")
	-- 	return
    -- end

    if esc_pressed then

        mod:handle_transition("close_quest_board_letter_view")

        return
    end
end

QuestBoardLetterView._has_active_level_vote = function (self)
    local voting_manager = self.voting_manager
    local active_vote_name = voting_manager:vote_in_progress()
    local is_mission_vote = active_vote_name == "game_settings_vote" or active_vote_name == "game_settings_deed_vote"

    return is_mission_vote and not voting_manager:has_voted(Network.peer_id())
end


QuestBoardLetterView._is_button_pressed = function (self, widget)
    local content = widget.content
    local hotspot = content.button_hotspot or content.hotspot
	if hotspot ~= nil then
		if hotspot.on_release then
			hotspot.on_release = false

			return true
		end
	end

end


QuestBoardLetterView.post_update = function (self, dt, t)	
	self.ui_animator:update(dt)
	self:_update_animations(dt)
end

QuestBoardLetterView._update_animations = function (self, dt)
	local widgets_by_name = self._widgets_by_name
	local close_button = widgets_by_name.close_button

	UIWidgetUtils.animate_default_button(close_button, dt)
end

-- Required. Executed by `ingame_ui` every tick.
function QuestBoardLetterView:update(dt, t)	
	self:draw(self:input_service(), dt)

	if self:_has_active_level_vote() then
        mod:handle_transition("close_quest_board_letter_view")
    else
        self:_handle_input(dt, t)
    end
end


-- Required. Return our custom input service here.
function QuestBoardLetterView:input_service()
  return self.input_manager:get_service("custom_view_name")
end

function QuestBoardLetterView:on_exit()
	self.ui_animator = nil
	
	self.input_manager:device_unblock_all_services("keyboard", 1)
	self.input_manager:device_unblock_all_services("mouse", 1)
	self.input_manager:device_unblock_all_services("gamepad", 1)
  
	ShowCursorStack.pop()
end