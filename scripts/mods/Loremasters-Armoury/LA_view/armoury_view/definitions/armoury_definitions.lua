local mod = get_mod("Loremasters-Armoury")
local generate_scenegraph_definition = local_require("scripts/mods/Loremasters-Armoury/LA_view/armoury_view/definitions/scenegraph_definition")
local generate_animation_definition = local_require("scripts/mods/Loremasters-Armoury/LA_view/armoury_view/definitions/animation_definitions")
local generate_widgets_definitions = local_require("scripts/mods/Loremasters-Armoury/LA_view/armoury_view/definitions/widgets_definitions")

local window_default_settings = UISettings.game_start_windows
local small_window_background = window_default_settings.background
local small_window_frame = window_default_settings.frame
local small_window_size = window_default_settings.size
local small_window_spacing = window_default_settings.spacing
local large_window_frame = window_default_settings.large_window_frame
local large_window_frame_width = UIFrameSettings[large_window_frame].texture_sizes.vertical[1]
local inner_window_size = {
	small_window_size[1] * 3 + small_window_spacing * 2 + large_window_frame_width * 2,
	small_window_size[2] + 80
}
local window_size = {
	inner_window_size[1] + 50,
	inner_window_size[2]
}
local window_frame_name = "menu_frame_11"
local window_frame = UIFrameSettings[window_frame_name]
local window_frame_width = window_frame.texture_sizes.vertical[1]

local list_window_size = {
	-- 400*0.9,
	-- 700*0.9
	400,
    600
}
local list_scrollbar_size = {
	16,
	list_window_size[2] - 20
}
local entry_height = (IS_PC and 35) or 50
local entry_font_size = (IS_PC and 22) or 28
local list_entry_size = {
	50,
	50
}

local original_skins_frame_size = {
    400,
    900
}
local LA_UI_frame_size = {
    585*0.9,
    779*0.9
}
local LA_preview_background_size = {
	524,
	784
}
local la_ui_headerlarge_size = {
	503*0.9,
	87*0.9
}
local la_ui_headersmall_size = {
	245*1.2,
	28*1.2
}
local la_ui_separator = {
	509*0.9,
	34*0.9
}
local la_ui_gear_icon = {
	462*0.85,
	63*0.85
}
local gear_icon_seperation_factor = 0.85/0.90

UIFrameSettings["la_ui_border_test"] = {
	texture = "la_ui_border_test",
	texture_size = {
		400 - 40,
		300
	},
	texture_sizes = {
		corner = {
			22,
			22
		},
		vertical = {
			22,
			1
		},
		horizontal = {
			1,
			22
		}
	}
}


UIFrameSettings["la_ui_framecorners"] = {
	texture = "la_ui_framecorners",
	texture_size = {
		400,
		400
	},
	texture_sizes = {
		corner = {
			120/270 * 400,
			120/270 * 400
		},
		vertical = {
			22/270 * 400,
			1
		},
		horizontal = {
			1,
			22/270 * 400
		}
	}
}

local scenegraph_definition = generate_scenegraph_definition(
	inner_window_size,
	window_size,
	window_frame,
	list_window_size,
	list_scrollbar_size,
	entry_height,
	entry_font_size,
	list_entry_size,
	original_skins_frame_size,
	LA_UI_frame_size,
	LA_preview_background_size,
	la_ui_headerlarge_size,
	la_ui_headersmall_size,
	la_ui_separator,
	la_ui_gear_icon,
	gear_icon_seperation_factor
)

local viewport_definition = {
    scenegraph_id = "LA_preview",
    element = UIElements.Viewport,
    style = {
            viewport = {
                layer = 900,
                scenegraph_id = "LA_preview",
                viewport_name = "LA_armoury_preview_viewport",
                shading_environment = "environment/ui_end_screen",
                level_name = "levels/end_screen/world",
                viewport_type = "default_forward",
                clear_screen_on_create = true,
                enable_sub_gui = false,
                fov = 70,
                world_name = "LA_armoury_preview",
                world_flags = {
                    Application.DISABLE_SOUND,
                    Application.DISABLE_ESRAM,
                    Application.ENABLE_VOLUMETRICS
                },
                camera_position = { -2, 0, 2 },
                camera_lookat = { 0, 0, 2 },
            }
        },
    content = {
        button_hotspot = {
            allow_multi_hover = true
        }
    }
}


local window_title_text_style = {
	dynamic_height = false,
	upper_case = true,
	localize = true,
	word_wrap = true,
	font_size = 28,
	vertical_alignment = "top",
	horizontal_alignment = "center",
	use_shadow = true,
	dynamic_font_size = false,
	font_type = "hell_shark_header",
	-- text_color = Colors.get_color_table_with_alpha("font_title", 255),
    text_color = {255,247,170,6},
	offset = {
		0,
		0,
		2
	}
}

local original_skins_title_text_style = {
	dynamic_height = false,
	upper_case = true,
	localize = true,
	word_wrap = true,
	font_size = 28,
	vertical_alignment = "top",
	horizontal_alignment = "center",
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

local LA_skins_title_text_style = {
	dynamic_height = false,
	upper_case = true,
	localize = true,
	word_wrap = true,
	font_size = 28,
	vertical_alignment = "top",
	horizontal_alignment = "center",
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


local widgets_definitions = generate_widgets_definitions(
    scenegraph_definition,
	window_title_text_style,
    original_skins_title_text_style,
    LA_skins_title_text_style
)

local animation_definitions = generate_animation_definition()

local generic_input_actions = {
	default = {
		{
			input_action = "confirm",
			priority = 2,
			description_text = "input_description_select"
		},
		{
			input_action = "back",
			priority = 3,
			description_text = "input_description_close"
		}
	},
	remove = {
		actions = {
			{
				input_action = "special_1",
				priority = 1,
				description_text = "input_description_remove"
			}
		}
	}
}

return {
	scenegraph_definition = scenegraph_definition,
	widgets = widgets_definitions,
    console_cursor_definition = UIWidgets.create_console_cursor("console_cursor"),
    animation_definitions = animation_definitions,
    generic_input_actions = generic_input_actions,
    viewport_definition = viewport_definition,
}