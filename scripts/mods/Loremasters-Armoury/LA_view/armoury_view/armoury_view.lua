local mod = get_mod("Loremasters-Armoury")

local vanilla_to_modded_table = local_require("scripts/mods/Loremasters-Armoury/LA_view/armoury_view/definitions/vanilla_to_modded_table")
local definitions = local_require("scripts/mods/Loremasters-Armoury/LA_view/armoury_view/definitions/armoury_definitions")
local widget_definitions = definitions.widgets
local scenegraph_definition = definitions.scenegraph_definition
local console_cursor_definition = definitions.console_cursor_definition
local animation_definitions = definitions.animation_definitions
local generic_input_actions = definitions.generic_input_actions
local viewport_definition = definitions.viewport_definition
math.randomseed(os.time())

local DO_RELOAD = false


local function radians_to_quaternion(theta, ro, phi)
    local c1 =  math.cos(theta/2)
    local c2 = math.cos(ro/2)
    local c3 = math.cos(phi/2)
    local s1 = math.sin(theta/2)
    local s2 = math.sin(ro/2)
    local s3 = math.sin(phi/2)
    local x = (s1*s2*c3) + (c1*c2*s3)
    local y = (s1*c2*c3) + (c1*s2*s3)
    local z = (c1*s2*c3) - (s1*c2*s3)
    local w = (c1*c2*c3) - (s1*s2*s3)
    local rot = Quaternion.from_elements(x, y, z, w)
    return rot
end

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

    self.items_by_hero = mod.items_by_hero

	self.list_of_base_skins = mod.list_of_base_skins

	self.SKIN_LIST =  mod.SKIN_LIST

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

	self.selected_hero = "es_hero_select"
    self.selected_item = "melee_item_select"
    self.buttons = {
        "es_hero_select",
        "dr_hero_select",
        "we_hero_select",
        "wh_hero_select",
        "bw_hero_select",
        "melee_item_select",
        "ranged_item_select",
        "skin_item_select",
        -- "original_skins_list_entry",
    }

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
			widgets[math.random(10,10^9)] = widget
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

    for _,name in pairs(self.buttons) do
        local button_widget = widgets_by_name[name]
        if self:_is_button_pressed(button_widget) then
            self:play_sound("Play_hud_select")
            
            if string.find(name, "hero_select") then
                self.selected_hero = name
                self:unselect_buttons(widgets_by_name, "hero_select")
                self:toggle_button(button_widget)
				-- self:clear_original_skin_list_skin_entry_widgets()
                self:update_original_skin_list()
            elseif string.find(name, "item_select") then
                self.selected_item = name
                self:unselect_buttons(widgets_by_name, "item_select")
                self:toggle_button(button_widget)
				-- self:clear_original_skin_list_skin_entry_widgets()
                self:update_original_skin_list()
            elseif string.find(name, "_original_skin") then
                -- self.selected_item = name
                self:unselect_buttons(widgets_by_name, "_original_skin")
                self:toggle_button(button_widget)
                -- self:update_original_skin_list()
				self:spawn_item_in_viewport(name)
				self:update_original_skin_list_skin_entries(name)
			elseif string.find(name, "_original_entry_skin") then
                -- self.selected_item = name
                self:unselect_buttons(widgets_by_name, "_original_entry_skin")
                self:toggle_button(button_widget)
                self:update_LA_skin_list(name) --update LA skins
				self:spawn_item_in_viewport(name)
				self.original_skin_chosen = name
			elseif string.find(name, "_LA_skins_entry_skin") then
                -- self.selected_item = name
                self:unselect_buttons(widgets_by_name, "_LA_skins_entry_skin")
                self:toggle_button(button_widget)
                self:set_armoury_key(name) --update LA skins
				-- self:spawn_item_in_viewport(name)
            end
            return
        end
    end

    if esc_pressed then

        mod:handle_transition("close_quest_board_letter_view")

        return
    end
end

ArmouryView.set_armoury_key = function (self, widget_name)
    
	local original_skin = self.original_skin_chosen
	local LA_skin = widget_name

	local mod_setting_id = string.gsub(original_skin, "_original_entry_skin", "")
	local Armoury_key = string.gsub(LA_skin, "_LA_skins_entry_skin", "")

	mod:echo(mod_setting_id)
	mod:echo(Armoury_key)
	mod:set(mod_setting_id, Armoury_key)

end

ArmouryView.spawn_item_in_viewport = function (self, widget_name)
    self:remove_units_from_viewport()
	local unit_spawner = self._unit_spawner

	local item_key = string.gsub(widget_name, "_original_skin", "")
	item_key = string.gsub(item_key, "_original_entry_skin", "")
	local item_data = ItemMasterList[item_key]
	local item_unit_name_right = item_data.right_hand_unit
	local item_unit_name_left = item_data.left_hand_unit

	Managers.package:load(item_unit_name_right, "global")
	Managers.package:load(item_unit_name_left, "global")

	if item_unit_name_right then 
		local right_unit = unit_spawner:spawn_local_unit(item_unit_name_right, Vector3(-0.25,0,2), radians_to_quaternion(0,0,-math.pi/6))
		self.viewport_right_hand = right_unit
		POSITION_LOOKUP[right_unit] = nil
	end
	if item_unit_name_left then 
		local left_unit = unit_spawner:spawn_local_unit(item_unit_name_left, Vector3(0,0,2), radians_to_quaternion(0,0,math.pi/6))
		self.viewport_left_hand = left_unit
		POSITION_LOOKUP[left_unit] = nil
	end

end

ArmouryView.remove_units_from_viewport = function (self, widget_name)
	local unit_spawner = self._unit_spawner
	local world = unit_spawner.world
	local viewport_right_hand = self.viewport_right_hand
	local viewport_left_hand = self.viewport_left_hand

	if viewport_right_hand then
		World.destroy_unit(world, viewport_right_hand)
		-- unit_spawner:mark_for_deletion(viewport_right_hand)
		self.viewport_right_hand = nil
	end
	if viewport_left_hand then 
		World.destroy_unit(world, viewport_left_hand)
		-- unit_spawner:mark_for_deletion(viewport_left_hand)
		self.viewport_left_hand = nil
	end
	-- unit_spawner:remove_units_marked_for_deletion()
end

ArmouryView.unselect_buttons = function (self, widgets_by_name, category)
    for _,name in pairs(self.buttons) do
        local button_widget = widgets_by_name[name]
        if string.find(name, category) then
            button_widget.content.button_hotspot.is_selected = false
        end
    end
end

ArmouryView.toggle_button = function (self, button_widget)
    button_widget.content.button_hotspot.is_selected = not button_widget.content.button_hotspot.is_selected
end

ArmouryView.update_original_skin_list_skin_entries = function (self, widget_name)
    local widgets = self._widgets
	local widgets_by_name = self._widgets_by_name
    local buttons = self.buttons
	self:clear_original_skin_list_skin_entry_widgets()

	local cur_button_num = #buttons
    local original_skin_list_skin_entry_widgets = {}

	local list_of_base_skins = self.list_of_base_skins
	local item_master_list = ItemMasterList

	local default_item_name = string.gsub(widget_name, "_original_skin", "")
	local default_skin_key = string.gsub(default_item_name, "_skin.+", "")

	local selected_hero = string.gsub(self.selected_hero, "_hero_select", "")
    local selected_item = string.gsub(self.selected_item, "_item_select", "")
	local item_list = self.items_by_hero[selected_hero][selected_item]
	local i = 0
	local j =  0 --2*math.ceil(#item_list/5)
	local divider_offset = widgets_by_name["original_skins_list_divider"].offset[2] - 10
	for _,item_name in pairs(list_of_base_skins[default_skin_key]) do
		local item_data = item_master_list[item_name]
		
		local scenegraph_definition_size = scenegraph_definition.original_skins_list_skin_entry.size
		local icon = item_data.inventory_icon or "tabs_inventory_icon_hats_normal"
		local new_widget_def = UIWidgets.create_icon_button("original_skins_list_skin_entry",scenegraph_definition_size , nil, nil, icon)

		if i > 5 then
			i = 0
			j = j + 1
		end
		new_widget_def.offset = {
            i*60,
            j*-60 + divider_offset,
            32
        }
		new_widget_def.style.texture_icon.texture_size = scenegraph_definition_size

		local num_passes = #new_widget_def.element.passes
		new_widget_def.element.passes[num_passes+1] = {
			pass_type = "hotspot",
			content_id = "tooltip_hotspot",
			content_check_function = function (ui_content)
				return not ui_content.disabled
			end
		}
		new_widget_def.element.passes[num_passes+2] = {
			style_id = "tooltip_text",
			pass_type = "tooltip_text",
			text_id = "tooltip_text",
			content_check_function = function (ui_content)
				return ui_content.tooltip_hotspot.is_hover
			end
		}

		new_widget_def.content["tooltip_hotspot"] = {}
		new_widget_def.content["tooltip_text"] = item_data.display_name

		new_widget_def.style["tooltip_text"] = {
			dynamic_height = false,
			upper_case = false,
			localize = true,
			word_wrap = false,
			font_size = 16,
			max_width = 500,
			vertical_alignment = "top",
			horizontal_alignment = "left",
			use_shadow = true,
			dynamic_font_size = false,
			font_type = "hell_shark",
			text_color = {255,247,170,6},
			offset = {
				0,
				0,
				2
			}
		}

        i = i + 1

		local widget = UIWidget.init(new_widget_def)
        local widget_number = math.random(10,10^9)
        local button_number = math.random(10,10^9)
        local new_widget_name = item_name.."_original_entry_skin"
		widgets[widget_number] = widget
		widgets_by_name[new_widget_name] = widget
        original_skin_list_skin_entry_widgets[widget_number] = {
            widget_name = new_widget_name,
            button_number = button_number,
        }
        buttons[button_number] = new_widget_name
		self:_start_transition_animation("on_enter", widget, new_widget_name)
		
	end
    
	self.original_skin_list_skin_entry_widgets = original_skin_list_skin_entry_widgets
end

ArmouryView.clear_original_skin_list_skin_entry_widgets = function (self)
    self:clear_LA_skin_widgets()
	local original_skin_list_skin_entry_widgets = self.original_skin_list_skin_entry_widgets or {}
	local widgets = self._widgets
    local buttons = self.buttons
	local widgets_by_name = self._widgets_by_name
    for widget_number, data in pairs(original_skin_list_skin_entry_widgets) do
        widgets[widget_number] = nil
		widgets_by_name[data.widget_name] = nil
        buttons[data.button_number] = nil
    end
	original_skin_list_skin_entry_widgets = {}
end

ArmouryView.update_LA_skin_list = function (self, widget_name)
    local widgets = self._widgets
	local widgets_by_name = self._widgets_by_name
    local buttons = self.buttons

	self:clear_LA_skin_widgets()

	local cur_button_num = #buttons
    local LA_skins_list_entry_widgets = {}

	local vanilla_to_modded_table = vanilla_to_modded_table
	local skin_list = self.SKIN_LIST

	local default_item_name = string.gsub(widget_name, "_original_entry_skin", "")
	local default_skin_key = string.gsub(widget_name, "_skin.+", "")

	local list_of_possible_skins = vanilla_to_modded_table[default_skin_key]

	local selected_hero = string.gsub(self.selected_hero, "_hero_select", "")
    local selected_item = string.gsub(self.selected_item, "_item_select", "")
	local item_list = self.items_by_hero[selected_hero][selected_item]
	local i = 0
	local j =  0 

	if list_of_possible_skins[default_item_name] then
		list_of_possible_skins = list_of_possible_skins[default_item_name]
	end
	for Armoury_key,armoury_name in pairs(list_of_possible_skins) do
		if type(armoury_name) == "string" then
			local armoury_data = skin_list[Armoury_key]
			
			local scenegraph_definition_size = scenegraph_definition.LA_skins_list_entry.size
			local icon = armoury_data.icons[default_item_name] or "la_notification_icon"
			
			local new_widget_def = UIWidgets.create_icon_button("LA_skins_list_entry",scenegraph_definition_size , nil, nil, icon)

			if i > 5 then
				i = 0
				j = j + 1
			end
			new_widget_def.offset = {
				i*-60,
				j*-60,
				-1
			}
			new_widget_def.style.texture_icon.texture_size = scenegraph_definition_size

			local num_passes = #new_widget_def.element.passes
			new_widget_def.element.passes[num_passes+1] = {
				pass_type = "hotspot",
				content_id = "tooltip_hotspot",
				content_check_function = function (ui_content)
					return not ui_content.disabled
				end
			}
			new_widget_def.element.passes[num_passes+2] = {
				style_id = "tooltip_text",
				pass_type = "tooltip_text",
				text_id = "tooltip_text",
				content_check_function = function (ui_content)
					return ui_content.tooltip_hotspot.is_hover
				end
			}

			new_widget_def.content["tooltip_hotspot"] = {}
			new_widget_def.content["tooltip_text"] = armoury_name or "missing_name"

			new_widget_def.style["tooltip_text"] = {
				dynamic_height = false,
				upper_case = false,
				localize = false,
				word_wrap = true,
				font_size = 16,
				max_width = 500,
				vertical_alignment = "top",
				horizontal_alignment = "left",
				use_shadow = true,
				dynamic_font_size = false,
				font_type = "hell_shark",
				text_color = {255,247,170,6},
				offset = {
					0,
					0,
					2
				}
			}

			i = i + 1

			local widget = UIWidget.init(new_widget_def)
			local widget_number = math.random(10,10^9)
			local button_number = math.random(10,10^9)
			local new_widget_name = Armoury_key.."_LA_skins_entry_skin"
			widgets[widget_number] = widget
			widgets_by_name[new_widget_name] = widget
			LA_skins_list_entry_widgets[widget_number] = {
				widget_name = new_widget_name,
				button_number = button_number,
			}
			buttons[button_number] = new_widget_name
			self:_start_transition_animation("on_enter", widget, new_widget_name)
		end		
	end
    
	self.LA_skins_list_entry_widgets = LA_skins_list_entry_widgets
end

ArmouryView.clear_LA_skin_widgets = function (self)
    local LA_skins_list_entry_widgets = self.LA_skins_list_entry_widgets or {}
	local widgets = self._widgets
    local buttons = self.buttons
	local widgets_by_name = self._widgets_by_name
    for widget_number, data in pairs(LA_skins_list_entry_widgets) do
        widgets[widget_number] = nil
		widgets_by_name[data.widget_name] = nil
        buttons[data.button_number] = nil
    end
	LA_skins_list_entry_widgets = {}
end

ArmouryView.update_original_skin_list = function (self)
    local widgets = self._widgets
	local widgets_by_name = self._widgets_by_name
    local buttons = self.buttons
    local original_skin_list_widgets = {}
    self:clear_original_skin_list_widgets()

	local cur_button_num = #buttons

    local selected_hero = string.gsub(self.selected_hero, "_hero_select", "")
    local selected_item = string.gsub(self.selected_item, "_item_select", "")
    local item_list = self.items_by_hero[selected_hero][selected_item]

    local i = 0
	local j = 0
    for _,item_name in pairs(item_list) do
        local scenegraph_definition_size = scenegraph_definition.original_skins_list_entry.size
        local icon = ItemMasterList[item_name].inventory_icon or "tabs_inventory_icon_hats_normal"
        local new_widget_def = UIWidgets.create_icon_button("original_skins_list_entry", scenegraph_definition_size , nil, nil, icon)
        
		if i > 5 then
			i = 0
			j = j + 1
		end
		new_widget_def.offset = {
            i*60,
            j*-60,
            32
        }
        new_widget_def.style.texture_icon.texture_size = scenegraph_definition_size
        i = i + 1

        local widget = UIWidget.init(new_widget_def)
        local widget_number =math.random(10,10^9)
        local button_number = math.random(10,10^9)
        local new_widget_name = item_name.."_original_skin"
		widgets[widget_number] = widget
		widgets_by_name[new_widget_name] = widget
        original_skin_list_widgets[widget_number] = {
            widget_name = new_widget_name,
            button_number = button_number,
        }
        buttons[button_number] = new_widget_name
		self:_start_transition_animation("on_enter", widget, new_widget_name, button_number-cur_button_num)
    end

	local skin_divider_def = UIWidgets.create_simple_texture("small_divider", "original_skins_list_divider")
	skin_divider_def.offset[2] = (j+1)*-60 - 15
	local skin_divider_widget = UIWidget.init(skin_divider_def)

	local widget_number = math.random(10,10^9)
	widgets[widget_number] = skin_divider_widget
	widgets_by_name["original_skins_list_divider"] = skin_divider_widget
	original_skin_list_widgets[widget_number] = {
		widget_name = "original_skins_list_divider",
		button_number = math.random(10,10^9),
	}
	
	self:_start_transition_animation("on_enter", skin_divider_widget, "original_skins_list_divider")


    self._original_skin_list_widgets = original_skin_list_widgets
	
end

function ArmouryView:_start_transition_animation(animation_name, widget, scenegraph_id, delay_num)

	local params = {
	  render_settings = self._render_settings,
	}

	if delay_num then
		params.delay_num = delay_num
	end
  
	-- local widgets = {
	--   list_widget = self.list,
	--   list_items = self.list_items,
	--   list_detail_widget = self.list_detail_widgets[2]
	-- }
  
	local anim_id = self.ui_animator:start_animation(animation_name, widget, scenegraph_definition, params)
	self._ui_animations[animation_name] = anim_id
  
  end

ArmouryView.clear_original_skin_list_widgets = function (self)
    self:clear_original_skin_list_skin_entry_widgets()
	local original_skin_list_widgets = self._original_skin_list_widgets or {}
    local widgets = self._widgets
    local buttons = self.buttons
	local widgets_by_name = self._widgets_by_name
    for widget_number, data in pairs(original_skin_list_widgets) do
        widgets[widget_number] = nil
		widgets_by_name[data.widget_name] = nil
        buttons[data.button_number] = nil
    end
	original_skin_list_widgets = {}
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
	self.ui_animator:update(dt)
	self:_update_animations(dt)
end

ArmouryView._update_animations = function (self, dt)
	local widgets_by_name = self._widgets_by_name
	
    for _,name in pairs(self.buttons) do
        local button = widgets_by_name[name]
	    UIWidgetUtils.animate_icon_button(button, dt)
    end

	local animations = self._ui_animations
	local ui_animator = self.ui_animator

	for anim_name, anim_id in pairs(animations) do
		if ui_animator:is_animation_completed(anim_id) then

		if anim_name == "on_exit" then
			self.on_exit_completed = true
		end

		animations[anim_name] = nil
		end
	end
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
        self.viewport_widget = UIWidget.init(viewport_definition)
		local world = Managers.world:world(viewport_definition.style.viewport.world_name)
		local unit_spawner = UnitSpawner:new(world, StateIngame.entity_manager, StateIngame.is_server)
		self._unit_spawner = unit_spawner
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

    

    local widgets_by_name = self._widgets_by_name
    self:unselect_buttons(widgets_by_name, "_original_skin")
    self:unselect_buttons(widgets_by_name, "item_select")
    self:unselect_buttons(widgets_by_name, "hero_select")

	self._original_skin_list_widgets = nil
	self.original_skin_list_skin_entry_widgets = nil
	self.LA_skins_list_entry_widgets = nil
	self.buttons = nil
	self._widgets_by_name = nil
	self._widgets = nil

	self._unit_spawner = nil
	self.viewport_right_hand = nil
	self.viewport_left_hand = nil

	ShowCursorStack.pop()
end