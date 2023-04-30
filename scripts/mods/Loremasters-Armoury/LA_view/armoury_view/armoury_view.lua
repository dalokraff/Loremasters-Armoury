local mod = get_mod("Loremasters-Armoury")
-- for k,v in pairs(mod.SKIN_CHANGED) do
-- 	mod:echo(k)
-- end
-- mod:echo(mod.current_skin["es_1h_sword_shield_skin_03_runed_01_rightHand"])

local VANILLA_TO_MODDED_TABLE = local_require("scripts/mods/Loremasters-Armoury/LA_view/armoury_view/definitions/vanilla_to_modded_table")
local ARMOURY_TABLE = local_require("scripts/mods/Loremasters-Armoury/LA_view/armoury_view/armoury_db")
local definitions = local_require("scripts/mods/Loremasters-Armoury/LA_view/armoury_view/definitions/armoury_definitions")
local widget_definitions = definitions.widgets
local scenegraph_definition = definitions.scenegraph_definition
local console_cursor_definition = definitions.console_cursor_definition
local animation_definitions = definitions.animation_definitions
local generic_input_actions = definitions.generic_input_actions
local viewport_definition = definitions.viewport_definition
local ItemMasterList = ItemMasterList
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
	self.SKIN_CHANGED = mod.SKIN_CHANGED
	self.armoury_db = table.clone(ARMOURY_TABLE, true)

	self:init_armoury_db()
end

function ArmouryView:init_armoury_db()
	--populates UI table that tracks which skin is equipped.
	local armoury_db = self.armoury_db
	
	for weapon_type, weapon_data in pairs(armoury_db) do
		for item_name, hand_data in pairs(weapon_data) do
			hand_data.right = mod:get(item_name.."_rightHand") or "default"
			hand_data.left = mod:get(item_name) or "default"
			
		end
	end
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
		"hat_item_select",
        -- "original_skins_list_entry",
    }

	self.original_skin_list_page_offset = 0

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
				--selects hero
                self.selected_hero = name
                self:unselect_buttons(widgets_by_name, "hero_select")
                self:toggle_button(button_widget)
				self.original_skin_list_page_offset = 0
				-- self:clear_original_skin_list_skin_entry_widgets()
                self:update_original_skin_list()
				self:clear_equipped_skin_widgets()
            elseif string.find(name, "item_select") then
				--selects which weapon/item type (ranged, melee, char skin)
                self.selected_item = name
                self:unselect_buttons(widgets_by_name, "item_select")
                self:toggle_button(button_widget)
				self.original_skin_list_page_offset = 0
				-- self:clear_original_skin_list_skin_entry_widgets()
                self:update_original_skin_list()
				self:clear_equipped_skin_widgets()
            elseif string.find(name, "_original_skin") then
				--selects which of the base game items to modify
                -- self.selected_item = name
                self:unselect_buttons(widgets_by_name, "_original_skin")
                self:toggle_button(button_widget)
                -- self:update_original_skin_list()
				self:spawn_item_in_viewport(name)
				self:update_original_skin_list_skin_entries(name)
				self:clear_equipped_skin_widgets()
			elseif string.find(name, "_original_entry_skin") then
				--selects which of the base game skins to modify
                -- self.selected_item = name
                self:unselect_buttons(widgets_by_name, "_original_entry_skin")
                self:toggle_button(button_widget)
                self:update_LA_skin_list(name, "weapon") --update LA skins
				self:spawn_item_in_viewport(name)
				self.original_skin_chosen = name
				self:create_equipped_skins_display()
			elseif string.find(name, "_original_entry_outfit_skin") then
				self:unselect_buttons(widgets_by_name, "_original_entry_outfit_skin")
                self:toggle_button(button_widget)
                self:update_LA_skin_list(name, "outfits") --update LA skins
				self:spawn_item_in_viewport(name)
				self.original_skin_chosen = name
				self:create_equipped_skins_display()
			elseif string.find(name, "_LA_skins_entry_skin") then
                --selects which LA skin to equip
				-- self.selected_item = name
                self:unselect_buttons(widgets_by_name, "_LA_skins_entry_skin")
                self:toggle_button(button_widget)
                self:set_armoury_key(name) --update LA skins
				-- self:spawn_item_in_viewport(name)
				self:create_equipped_skins_display()
			elseif string.find(name, "_original_equipped_skin") then
                --for reseting the skin to default
				-- self.selected_item = name
                self:unselect_buttons(widgets_by_name, "_original_equipped_skin")
                self:toggle_button(button_widget)
				self:reset_hand_to_default(name)
				self:create_equipped_skins_display()
			elseif string.find(name, "original_skins_equiped_skin_page_button") then
				self:unselect_buttons(widgets_by_name, "original_skins_equiped_skin_page_button")
				self:toggle_button(button_widget)
				self.original_skin_list_page_offset = self.original_skin_list_page_offset + 22
				self:update_original_skin_list()
				self:clear_equipped_skin_widgets()
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
    local armoury_db = self.armoury_db
	local original_skin = self.original_skin_chosen
	local LA_skin = widget_name

	-- mod:echo(original_skin) --item type and skin name
	-- mod:echo(LA_skin) --hand data and amoruykey

	local right_count = 0
	local left_count = 0
	local outfits_count = 0
	local skin_name = string.gsub(original_skin, "_original_entry_skin", "")
	skin_name = string.gsub(skin_name, "_original_entry_outfit_skin", "")
	local weapon_type = string.gsub(skin_name, "_skin.+", "")
	weapon_type = string.gsub(weapon_type, "_original_entry_outfit_skin", "")
	local mod_setting_id = string.rep(skin_name, 1)
	-- if string.find(skin_name, "shield") then
	-- 	mod_setting_id = skin_name.."_rightHand"
	-- end

	local Armoury_key_hand = string.gsub(LA_skin, "_LA_skins_entry_skin", "")
	local Armoury_key, left_count  = string.gsub(Armoury_key_hand, "_off_hand", "")
	Armoury_key, right_count = string.gsub(Armoury_key, "_main_hand", "")
	Armoury_key, outfits_count = string.gsub(Armoury_key, "_outfits", "")

	local hand = ""
	if right_count > left_count then
		hand = "right"
		if string.find(skin_name, "shield") or string.find(skin_name, "dual") or string.find(skin_name, "_and") then
			mod_setting_id = skin_name.."_rightHand"
		end
	elseif right_count < left_count or outfits_count>0 then
		hand = "left"
	end
	mod:set(mod_setting_id, Armoury_key)
	armoury_db[weapon_type][skin_name][hand] = Armoury_key
	
end

ArmouryView.spawn_item_in_viewport = function (self, widget_name)
    self:remove_units_from_viewport()
	local unit_spawner = self._unit_spawner

	local item_key = string.gsub(widget_name, "_original_skin", "")
	item_key = string.gsub(item_key, "_original_entry_skin", "")
	item_key = string.gsub(item_key, "_original_entry_outfit_skin", "")
	local item_data = ItemMasterList[item_key]
	local item_unit_name_right = item_data.right_hand_unit
	local item_unit_name_left = item_data.left_hand_unit
	local item_unit_name = item_data.unit
	local item_type = item_data.item_type
	
	if item_type == "skin" then
		local cosmetic_data = Cosmetics[item_data.name]
		local unit_name = cosmetic_data.third_person_attachment.unit
		local package_lookup_id = NetworkLookup.inventory_packages[unit_name]
		local new_mtrs = nil
		if package_lookup_id then
			Managers.package:load(unit_name, "global")
		end
		if cosmetic_data.material_changes then
			local mtr_package_name = cosmetic_data.material_changes.package_name
			Managers.package:load(mtr_package_name, "global")
			new_mtrs = table.clone(cosmetic_data.material_changes.third_person)
		end
		local skin_unit = unit_spawner:spawn_local_unit(unit_name, Vector3(0,0,1), radians_to_quaternion(0,math.pi/2,0))
		if new_mtrs then
			for mtr_slot, mtr in pairs(new_mtrs) do
				Unit.set_material(skin_unit, mtr_slot, mtr)
			end
		end
		self.viewport_skin = skin_unit
		POSITION_LOOKUP[skin_unit] = nil
	end

	if item_unit_name_right then 
		Managers.package:load(item_unit_name_right, "global")
		local right_unit = unit_spawner:spawn_local_unit(item_unit_name_right, Vector3(-0.25,0,2), radians_to_quaternion(0,0,-math.pi/6))
		self.viewport_right_hand = right_unit
		POSITION_LOOKUP[right_unit] = nil
	end
	if item_unit_name_left then 
		Managers.package:load(item_unit_name_left, "global")
		local left_unit = unit_spawner:spawn_local_unit(item_unit_name_left, Vector3(0,0,2), radians_to_quaternion(0,0,math.pi/6))
		self.viewport_left_hand = left_unit
		POSITION_LOOKUP[left_unit] = nil
	end
	if item_unit_name then 
		Managers.package:load(item_unit_name, "global")
		local hat_unit = unit_spawner:spawn_local_unit(item_unit_name, Vector3(0,0,2), radians_to_quaternion(0,math.pi/2,0))
		self.viewport_hat = hat_unit
		POSITION_LOOKUP[hat_unit] = nil
	end

end

ArmouryView.remove_units_from_viewport = function (self, widget_name)
	local unit_spawner = self._unit_spawner
	local world = unit_spawner.world
	local viewport_right_hand = self.viewport_right_hand
	local viewport_left_hand = self.viewport_left_hand
	local viewport_hat = self.viewport_hat
	local viewport_skin = self.viewport_skin

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
	if viewport_hat then 
		World.destroy_unit(world, viewport_hat)
		-- unit_spawner:mark_for_deletion(viewport_hat)
		self.viewport_hat = nil
	end
	if viewport_skin then 
		World.destroy_unit(world, viewport_skin)
		-- unit_spawner:mark_for_deletion(viewport_hat)
		self.viewport_skin = nil
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


ArmouryView.reset_hand_to_default = function (self, widget_name)
	local armoury_db = self.armoury_db

	local right_count = 0
	local left_count = 0
	local outfits_count = 0
	local skin_name = string.gsub(widget_name, "_original_equipped_skin", "")
	skin_name, right_count = string.gsub(skin_name, "_main_hand", "")
	skin_name, left_count = string.gsub(skin_name, "_off_hand", "")
	skin_name, outfits_count = string.gsub(skin_name, "_outfits", "")
	local weapon_type = string.gsub(skin_name, "_skin.+", "")
	local mod_setting_id = string.rep(skin_name, 1)
	-- if string.find(skin_name, "shield") then
	-- 	mod_setting_id = skin_name.."_rightHand"
	-- end

	local hand = ""
	if right_count > left_count then
		hand = "right"
		if string.find(skin_name, "shield") or string.find(skin_name, "dual") or string.find(skin_name, "_and") then
			mod_setting_id = skin_name.."_rightHand"
		end
	elseif right_count < left_count or outfits_count > 0 then
		hand = "left"
	end

	armoury_db[weapon_type][skin_name][hand] = "default"
	mod:set(mod_setting_id, "default")

end

ArmouryView.clear_equipped_skin_widgets = function (self)
	local equipped_skin_widgets = self.equipped_skin_widgets or {}
	local widgets = self._widgets
    local buttons = self.buttons
	local widgets_by_name = self._widgets_by_name
    for widget_number, data in pairs(equipped_skin_widgets) do
        widgets[widget_number] = nil
		widgets_by_name[data.widget_name] = nil
        buttons[data.button_number] = nil
    end
	self.equipped_skin_widgets = {}
end

ArmouryView.create_equipped_skins_display = function (self)
    local original_skin_chosen = self.original_skin_chosen
	-- local chosen_skin_name = string.gsub(original_skin_chosen, "_original_skin", "")
	local chosen_skin_name = string.gsub(original_skin_chosen, "_original_entry_skin", "")
	chosen_skin_name = string.gsub(chosen_skin_name, "_original_equipped_skin", "")
	chosen_skin_name = string.gsub(chosen_skin_name, "_original_entry_outfit_skin", "")
	chosen_skin_name = string.gsub(chosen_skin_name, "_off_hand", "")
	chosen_skin_name = string.gsub(chosen_skin_name, "_main_hand", "")
	chosen_skin_name = string.gsub(chosen_skin_name, "_name", "")
	local Armoury_skin_data_off_hand = self.SKIN_CHANGED[chosen_skin_name]
	local Armoury_skin_data_main_hand = self.SKIN_CHANGED[chosen_skin_name.."_rightHand"]
	local item_master_list = ItemMasterList
	local item_data = item_master_list[chosen_skin_name]

	local icon = item_data.inventory_icon or "tabs_inventory_icon_hats_normal"
	local display_name = item_data.display_name

	self:clear_equipped_skin_widgets()
	self:update_equipped_skin_display(Armoury_skin_data_off_hand, item_data, chosen_skin_name, display_name, "off_hand")
	self:update_equipped_skin_display(Armoury_skin_data_main_hand, item_data, chosen_skin_name, display_name, "main_hand")
	self:update_equipped_skin_display(Armoury_skin_data_off_hand, item_data, chosen_skin_name, display_name, "outfits")
	self:create_equipped_skin_title(display_name)
end

ArmouryView.create_equipped_skin_title = function (self, display_name)
	local widgets = self._widgets
	local widgets_by_name = self._widgets_by_name
	local equipped_skin_widgets = self.equipped_skin_widgets or {}

	local title_style = {
		dynamic_height = false,
		upper_case = true,
		localize = false,
		word_wrap = true,
		font_size = 18,
		vertical_alignment = "top",
		horizontal_alignment = "left",
		use_shadow = true,
		dynamic_font_size = false,
		font_type = "hell_shark_header",
		text_color = {255,247,170,6},
		offset = {
			0,
			0,
			32
		}
	}

	local text = "Equiped Skin for:\n"..Localize(display_name.."_LA_menu_widget")
	local title_widget_def = UIWidgets.create_simple_text(text, "original_equipped_skins_title_text", nil, nil, title_style)
	local title_widget = UIWidget.init(title_widget_def)
	local widget_number = math.random(10,10^9)
	local title_widget_name = display_name.."_equiped_title_widget"
	widgets[widget_number] = title_widget
	widgets_by_name[title_widget_name] = title_widget
	equipped_skin_widgets[widget_number] = {
		widget_name = title_widget_name,
		button_number = math.random(10,10^9),
	}
	self:_start_transition_animation("on_enter", title_widget, title_widget_name)
	self.equipped_skin_widgets = equipped_skin_widgets
end

--this function needs to be revisted and simplified to better handle the retrieval of icons based off of handedness.
ArmouryView.update_equipped_skin_display = function (self, Armoury_skin_data, item_data, chosen_skin_name, display_name, hand)
	local widgets = self._widgets
	local widgets_by_name = self._widgets_by_name
    local buttons = self.buttons
	
	local equipped_skin_widgets = self.equipped_skin_widgets or {}

	local check_left_hand = (not item_data.right_hand_unit) and hand == "off_hand"
	local check_right_hand = (not item_data.left_hand_unit) and hand == "main_hand"
	local check_outfit = (not item_data.unit) and  (not (item_data.item_type == "skin")) and hand == "outfits" 
	if check_left_hand or check_right_hand or check_outfit then
		return
	end

	local vanilla_to_modded_table_handed = VANILLA_TO_MODDED_TABLE[hand]

	local icon = item_data.inventory_icon or "tabs_inventory_icon_hats_normal"
	local display_name = item_data.display_name
	if Armoury_skin_data then
		local skin_changed = Armoury_skin_data.changed_texture or Armoury_skin_data.changed_model
		if skin_changed then
			local Armoury_key = mod:get(chosen_skin_name)
			local Armoury_key_right = mod:get(chosen_skin_name.."_rightHand")
			local Amoury_data = self.SKIN_LIST[Armoury_key]
			local Armoury_data_right = self.SKIN_LIST[Armoury_key_right]
			-- if Amoury_data or Armoury_data_right then
				local secondary_icon = self:look_for_other_hands_icons(chosen_skin_name, vanilla_to_modded_table_handed, Armoury_key)
				if hand == 'main_hand' and Armoury_data_right then 
					icon = Armoury_data_right.icons[chosen_skin_name] or Armoury_data_right.icons["default"] or secondary_icon or "la_notification_icon"
				elseif hand == 'off_hand' and Amoury_data then
					icon = Amoury_data.icons[chosen_skin_name] or secondary_icon or "la_notification_icon"
				elseif hand == 'outfits' and Amoury_data then
					icon = "la_notification_icon"
				end
			-- end
			

		end

	end

	local offset = 0
	if hand == "off_hand" then
		offset = 150
	end
	-- self:create_equipped_skin_title(display_name)

	local scenegraph_definition_size = scenegraph_definition.original_skins_equiped_skin.size
	local new_widget_def = UIWidgets.create_icon_button("original_skins_equiped_skin",scenegraph_definition_size , nil, nil, icon)

	new_widget_def.offset = {
		0 + offset,
		100,
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
	new_widget_def.content["tooltip_text"] = display_name

	new_widget_def.style["tooltip_text"] = {
		dynamic_height = false,
		upper_case = false,
		localize = true,
		word_wrap = false,
		font_size = 16,
		max_width = 200,
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

	local widget = UIWidget.init(new_widget_def)
	local widget_number = math.random(10,10^9)
	local button_number = math.random(10,10^9)
	local new_widget_name = chosen_skin_name.."_"..hand.."_original_equipped_skin"
	widgets[widget_number] = widget
	widgets_by_name[new_widget_name] = widget
	equipped_skin_widgets[widget_number] = {
		widget_name = new_widget_name,
		button_number = button_number,
	}
	buttons[button_number] = new_widget_name
	self:_start_transition_animation("on_enter", widget, new_widget_name)

end

ArmouryView.update_original_skin_list_skin_entries = function (self, widget_name)
    local widgets = self._widgets
	local widgets_by_name = self._widgets_by_name
    local buttons = self.buttons
	self:clear_original_skin_list_skin_entry_widgets()

	local cur_button_num = #buttons
    local original_skin_list_skin_entry_widgets = self.original_skin_list_skin_entry_widgets or {}

	local list_of_base_skins = self.list_of_base_skins
	local item_master_list = ItemMasterList

	local default_item_name = string.gsub(widget_name, "_original_skin", "")
	local default_skin_key = string.gsub(default_item_name, "_skin.+", "")

	local selected_hero = string.gsub(self.selected_hero, "_hero_select", "")
    local selected_item = string.gsub(self.selected_item, "_item_select", "")
	local item_list = self.items_by_hero[selected_hero][selected_item]
	local i = 0
	local j =  0 --2*math.ceil(#item_list/5)
	local divider_offset = widgets_by_name["original_skins_list_divider"].offset[2] - 30
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
		new_widget_def.content["tooltip_text"] = item_data.display_name.."_LA_menu_widget"

		new_widget_def.style["tooltip_text"] = {
			dynamic_height = false,
			upper_case = false,
			localize = true,
			word_wrap = false,
			font_size = 16,
			max_width = 200,
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

ArmouryView.update_LA_skin_list = function (self, widget_name, skin_type)
    
	
	self:clear_LA_skin_widgets()

	if skin_type == "weapon" then
		self:update_LA_skin_hand(widget_name, "main_hand")
		self:update_LA_skin_hand(widget_name, "off_hand")
	elseif skin_type == "outfits" then
		self:update_LA_skin_hand(widget_name, "outfits")
	end

end

ArmouryView.look_for_other_hands_icons = function (self, default_skin_key, vanilla_to_modded_table_handed, Armoury_key)
	local skin_list = self.SKIN_LIST

	local new_skin_key = string.gsub(default_skin_key, "_shield", "")
	if new_skin_key == "es_sword_breton" then
		new_skin_key = "es_bastard_sword"
	end

	local list_of_possible_skins = vanilla_to_modded_table_handed[new_skin_key]
	if list_of_possible_skins then
		local armoury_data = skin_list[Armoury_key]
		local icon = "la_notification_icon" 
		if armoury_data then
			if armoury_data.icons then
				icon = armoury_data.icons["default"] or icon
			end
		end
		return icon
	end

	return nil
end

ArmouryView.update_LA_skin_hand = function (self, widget_name, hand)
    local widgets = self._widgets
	local widgets_by_name = self._widgets_by_name
    local buttons = self.buttons

	local cur_button_num = #buttons
    local LA_skins_list_entry_widgets = self.LA_skins_list_entry_widgets or {}

	local vanilla_to_modded_table_handed = VANILLA_TO_MODDED_TABLE[hand]
	local skin_list = self.SKIN_LIST

	local default_item_name = string.gsub(widget_name, "_original_entry_skin", "")
	local default_skin_key = string.gsub(widget_name, "_original_entry_skin", "")
	default_skin_key = string.gsub(widget_name, "_original_entry_outfit_skin", "")
	default_skin_key = string.gsub(default_skin_key, "_skin.+", "")
	

	local list_of_possible_skins = vanilla_to_modded_table_handed[default_skin_key]

	local selected_hero = string.gsub(self.selected_hero, "_hero_select", "")
    local selected_item = string.gsub(self.selected_item, "_item_select", "")
	local item_list = self.items_by_hero[selected_hero][selected_item]
	local i = 0
	local j =  0 

	local down_shift = 0
	if hand == "off_hand" then
		down_shift = -300
	end

	local title_style = {
		dynamic_height = false,
		upper_case = true,
		localize = true,
		word_wrap = true,
		font_size = 18,
		vertical_alignment = "top",
		horizontal_alignment = "left",
		use_shadow = true,
		dynamic_font_size = false,
		font_type = "hell_shark_header",
		text_color = {255,247,170,6},
		offset = {
			-100,
			0+down_shift,
			32
		}
	}
	local hand_title_widget_def = UIWidgets.create_simple_text(hand, "LA_skins_"..hand.."_text", nil, nil, title_style)
	local hand_title_widget = UIWidget.init(hand_title_widget_def)
	local widget_number = math.random(10,10^9)
	local hand_title_widget_name = hand.."_title_widget"
	widgets[widget_number] = hand_title_widget
	widgets_by_name[hand_title_widget_name] = hand_title_widget
	LA_skins_list_entry_widgets[widget_number] = {
		widget_name = hand_title_widget_name,
		button_number = math.random(10,10^9),
	}
	self:_start_transition_animation("on_enter", hand_title_widget, hand_title_widget_name)


	if list_of_possible_skins[default_item_name] then
		list_of_possible_skins = list_of_possible_skins[default_item_name]
	end
	for Armoury_key,armoury_name in pairs(list_of_possible_skins) do
		if type(armoury_name) == "string" then
			local armoury_data = skin_list[Armoury_key]
			
			local scenegraph_definition_size = scenegraph_definition["LA_skins_list_entry_"..hand].size
			local secondary_icon = self:look_for_other_hands_icons(default_skin_key, vanilla_to_modded_table_handed, Armoury_key)
			local icon = secondary_icon or "la_notification_icon"
			if armoury_data.icons then
				icon = armoury_data.icons[default_item_name] or icon
			end
			
			
			local new_widget_def = UIWidgets.create_icon_button("LA_skins_list_entry_"..hand, scenegraph_definition_size , nil, nil, icon)

			if i > 5 then
				i = 0
				j = j + 1
			end
			new_widget_def.offset = {
				i*-60,
				j*-60 + down_shift - 40,
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
			local new_widget_name = Armoury_key.."_LA_skins_entry_skin_"..hand
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
	-- local items_per_page = mod.items_per_page_original_skin_entry
	local items_per_page = 23
	local num_pages = math.ceil((#item_list)/(items_per_page+1))
	local displayed_items = 0
	local page_offset = self.original_skin_list_page_offset

	--checks if you cycle past last page and resets to page 1
	if math.ceil(page_offset/items_per_page +1) > num_pages then
		self.original_skin_list_page_offset = 0
		page_offset = 0
	end

    for index,item_name in ipairs(item_list) do
        if index-page_offset > items_per_page  or (index < page_offset) then
			goto pageOver
		end

		if i > 5 then
			i = 0
			j = j + 1
		end

		local scenegraph_definition_size = scenegraph_definition.original_skins_list_entry.size
        local icon = ItemMasterList[item_name].inventory_icon or "tabs_inventory_icon_hats_normal"
        local new_widget_def = UIWidgets.create_icon_button("original_skins_list_entry", scenegraph_definition_size , nil, nil, icon)
        
		
		new_widget_def.offset = {
            i*60,
            j*-60,
            32
        }
        new_widget_def.style.texture_icon.texture_size = scenegraph_definition_size
        i = i + 1
		displayed_items = displayed_items + 1

		local widget_suffix = "_original_skin"
		if string.find(item_name, "_hat") or string.find(item_name, "skin_[%a][%a]_") then
			widget_suffix = "_original_entry_outfit_skin"
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
			new_widget_def.content["tooltip_text"] = ItemMasterList[item_name].display_name

			new_widget_def.style["tooltip_text"] = {
				dynamic_height = false,
				upper_case = false,
				localize = true,
				word_wrap = true,
				font_size = 16,
				max_width = 150,
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
		end

		local widget = UIWidget.init(new_widget_def)
        local widget_number =math.random(10,10^9)
        local button_number = math.random(10,10^9)

        local new_widget_name = item_name..widget_suffix
		widgets[widget_number] = widget
		widgets_by_name[new_widget_name] = widget
        original_skin_list_widgets[widget_number] = {
            widget_name = new_widget_name,
            button_number = button_number,
        }
        buttons[button_number] = new_widget_name
		self:_start_transition_animation("on_enter", widget, new_widget_name, button_number-cur_button_num)
		::pageOver::
    end

	

	local skin_divider_def = UIWidgets.create_simple_texture("la_ui_separatorleft", "original_skins_list_divider")
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

	local page_button_size = scenegraph_definition.original_skins_equiped_skin_page_button.size
	local page_button_def = UIWidgets.create_icon_button("original_skins_equiped_skin_page_button", page_button_size , nil, nil, "tabs_icon_all_selected")
	
	local page_button_widget = UIWidget.init(page_button_def)
	local page_button_widget_number = math.random(10,10^9)
	local page_button_number = math.random(10,10^9)
	widgets[page_button_widget_number] = page_button_widget
	widgets_by_name["original_skins_equiped_skin_page_button"] = page_button_widget
	original_skin_list_widgets[page_button_widget_number] = {
		widget_name = "original_skins_equiped_skin_page_button",
		button_number = page_button_number,
	}
	buttons[page_button_number] = "original_skins_equiped_skin_page_button"


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

	self.time = t
	self.dt = dt
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
	self.viewport_hat = nil
	self.viewport_skin = nil
	self.original_skin_list_page_offset = nil

	ShowCursorStack.pop()
end


-- need to simplify database structure
-- + have a pregenned table of all valid options for each vanilla weapon 
-- + weapon -> hand -> skin

-- then a second table to keep track of which weapons are currently equipped
-- + weapon -> hand -> skin
-- this will lead to redundant data in the user config but should be worth it for simplicity

--tooltip wideget definitions need to be seperated into their own funcitons