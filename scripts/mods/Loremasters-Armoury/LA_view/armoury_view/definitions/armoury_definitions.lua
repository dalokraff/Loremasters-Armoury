local mod = get_mod("Loremasters-Armoury")
local LAWidgetUtils = local_require("scripts/mods/Loremasters-Armoury/LA_view/la_widget_utils")

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
local la_ui_separator = {
	509*0.9,
	34*0.9
}
local la_ui_gear_icon = {
	462*0.85, 
	63*0.85
}
local gear_icon_seperation_factor = 0.85/0.90

local scenegraph_definition = {
    root = {
		is_root = true,
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.default
		}
	},
	menu_root = {
		vertical_alignment = "center",
		parent = "root",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			0
		}
	},
	screen = {
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.default
		}
	},
	console_cursor = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			0
		}
	},
	header = {
		vertical_alignment = "top",
		parent = "menu_root",
		horizontal_alignment = "center",
		size = {
			1920,
			50
		},
		position = {
			0,
			-20,
			100
		}
	},
	window = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = window_size,
		position = {
			0,
			0,
			0
		}
	},
    window_title = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			window_size[1]/2.2,
			58
		},
		position = {
			0,
			30,
			30
		}
	},
	-- gem_header = {
	-- 	vertical_alignment = "top",
	-- 	parent = "window",
	-- 	horizontal_alignment = "center",
	-- 	size = {
	-- 		27,
	-- 		22
	-- 	},
	-- 	-- position = {
	-- 	-- 	-240,
	-- 	-- 	4,
	-- 	-- 	29
	-- 	-- }
	-- 	position = {
	-- 		-245,
	-- 		12,
	-- 		15
	-- 	}
	-- },
	window_title_bg = {
		vertical_alignment = "top",
		parent = "window_title",
		horizontal_alignment = "center",
		size = {
			410,
			40
		},
		position = {
			0,
			-15,
			-1
		}
	},
	window_title_text = {
		vertical_alignment = "center",
		parent = "window_title",
		horizontal_alignment = "center",
		size = {
			350,
			50
		},
		position = {
			0,
			-8,
			31
		}
	},
    window_title_banner_left = {
        vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			90,
			180
		},
		position = {
			342,
			-90,
			35
		}
    },
    window_title_banner_right = {
        vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			90, --528x1060
			180
		},
		position = {
			-342,
			-90,
			35
		}
    },

	window_frame = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = window_size,
		position = {
			0,
			0,
			5
		}
	},
	window_frame_left = {
		vertical_alignment = "center",
		parent = "window_frame",
		horizontal_alignment = "left",
		size = {
			30,
			window_size[2]
		},
		position = {
			0,
			0,
			5
		}
	},
	window_frame_right = {
		vertical_alignment = "center",
		parent = "window_frame",
		horizontal_alignment = "right",
		size = {
			30,
			window_size[2]
		},
		position = {
			0,
			0,
			5
		}
	},
	window_frame_bottom = {
		vertical_alignment = "bottom",
		parent = "window_frame",
		horizontal_alignment = "center",
		size = {
			window_size[1],
			30
		},
		position = {
			0,
			0,
			5
		}
	},
	window_frame_top = {
		vertical_alignment = "top",
		parent = "window_frame",
		horizontal_alignment = "center",
		size = {
			window_size[1],
			30
		},
		position = {
			0,
			0,
			5
		}
	},

	window_background = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			window_size[1] - 5,
			window_size[2] - 5
		},
		position = {
			0,
			0,
			-1
		}
	},
    LA_preview = {
		vertical_alignment = "bottom",
		parent = "window_background",
		horizontal_alignment = "center",
		size = {
			400,
			600
		},
		position = {
			0,
			80,
			0
		}
	},
	LA_preview_background = {
		vertical_alignment = "center",
		parent = "LA_preview",
		horizontal_alignment = "center",
		size = {
			LA_preview_background_size[1]*1.14,
			LA_preview_background_size[2]*1.14
		},
		position = {
			0,
			0,
			80
		}
	},
    sword_left_bottom = {
		vertical_alignment = "bottom",
		parent = "LA_preview",
		horizontal_alignment = "center",
		size = {
			161,
			47
		},
		position = {
			-120,
			-40,
			32
		}
	},
	sword_right_bottom = {
		vertical_alignment = "bottom",
		parent = "LA_preview",
		horizontal_alignment = "center",
		size = {
			161,
			47
		},
		position = {
			120,
			-40,
			32
		}
	},
    sword_left_top = {
		vertical_alignment = "top",
		parent = "LA_preview",
		horizontal_alignment = "center",
		size = {
			161,
			47
		},
		position = {
			-120,
			40,
			32
		}
	},
	sword_right_top = {
		vertical_alignment = "top",
		parent = "LA_preview",
		horizontal_alignment = "center",
		size = {
			161,
			47
		},
		position = {
			120,
			40,
			32
		}
	},
    window_bg_fill = {
		vertical_alignment = "center",
		parent = "window_background",
		horizontal_alignment = "center",
		size = {
			window_size[1] - 5,
			window_size[2] - 5
		},
		position = {
			0,
			0,
			0
		}
	},
	window_bg_vignette = {
		vertical_alignment = "center",
		parent = "window_background",
		horizontal_alignment = "center",
		size = {
			window_size[1] - 5,
			window_size[2] - 5
		},
		position = {
			0,
			0,
			1
		}
	},
	tutorial_overlay = {
		vertical_alignment = "center",
		parent = "window_background",
		horizontal_alignment = "center",
		size = inner_window_size,
		position = {
			0,
			0,
			100
		}
	},
	tutorial_overlay_toggle = {
		vertical_alignment = "top",
		parent = "window_background",
		horizontal_alignment = "right",
		size = list_entry_size,
		position = {
			0,
			0,
			50
		}
	},
    loading_icon = {
		vertical_alignment = "center",
		parent = "window_frame",
		horizontal_alignment = "center",
		size = window_size,
		position = {
			0,
			0,
			-1
		}
	},

    original_skins_frame = {
        vertical_alignment = "center",
		parent = "window_background",
		horizontal_alignment = "left",
		size = original_skins_frame_size,
		position = {
			20,
			0,
			30
		}
    },
	original_skins_frame_texture = {
        vertical_alignment = "center",
		parent = "original_skins_frame",
		horizontal_alignment = "left",
		size = LA_UI_frame_size,
		position = {
			20,
			-50,
			30
		}
    },
	original_skins_title_bg = {
		vertical_alignment = "top",
		parent = "original_skins_frame",
		horizontal_alignment = "center",
		size = la_ui_headerlarge_size,
		position = {
			100,
			-50,
			31
		}
	},
	original_skins_title_text = {
		vertical_alignment = "top",
		parent = "original_skins_title_bg",
		horizontal_alignment = "center",
		size = {
			list_window_size[1] - 40,
			300
		},
		position = {
			0,
			-10,
			32
		}
	},
    original_skins_list_window = {
		vertical_alignment = "top",
		parent = "original_skins_frame",
		horizontal_alignment = "left",
		size = {
			list_window_size[1]*1.1,
			list_window_size[2]
		},
		position = {
			-- 120,
			-- -140,
			-- 10
            100,
			-200,
			10
		}
	},
	original_skins_list_scrollbar = {
		vertical_alignment = "top",
		parent = "original_skins_list_window",
		horizontal_alignment = "left",
		size = list_scrollbar_size,
		position = {
			-30,
			-10,
			10
		}
	},
	original_skins_list_scroll_root = {
		vertical_alignment = "top",
		parent = "original_skins_list_window",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			0
		}
	},
	original_skins_list_entry = {
		vertical_alignment = "top",
		parent = "original_skins_list_scroll_root",
		horizontal_alignment = "left",
		size = list_entry_size,
		position = {
			0,
			0,
			-1
		}
	},
	original_skins_list_skin_entry = {
		vertical_alignment = "top",
		parent = "original_skins_list_scroll_root",
		horizontal_alignment = "left",
		size = list_entry_size,
		position = {
			0,
			0,
			-1
		}
	},
	original_skins_equiped_skin_page_button = {
		vertical_alignment = "top",
		parent = "original_skins_list_scroll_root",
		horizontal_alignment = "left",
		size = list_entry_size,
		position = {
			380,
			-70,
			32
		}
	},
	original_skins_list_divider = {
		parent = "original_skins_list_scroll_root",
		vertical_alignment = "center",
		horizontal_alignment = "right",
		size = la_ui_separator,
		position = { 
			450,
			0, 
			32 
		},
	},
	original_equipped_skins_title_text = {
		vertical_alignment = "bottom",
		parent = "original_skins_list_scroll_root",
		horizontal_alignment = "left",
		size = {
			200,
			50
		},
		position = {
			0,
			-550,
			32
		}
	},
	original_skins_equiped_skin = {
		vertical_alignment = "bottom",
		parent = "original_equipped_skins_title_text",
		horizontal_alignment = "center",
		size = list_entry_size,
		position = {
			150,
			-100,
			32
		}
	},
	original_skins_equiped_skin_hand_title = {
		vertical_alignment = "bottom",
		parent = "original_skins_equiped_skin",
		horizontal_alignment = "center",
		size = list_entry_size,
		position = {
			0,
			0,
			32
		}
	},
	original_skins_list_detail_top = {
		vertical_alignment = "top",
		parent = "original_skins_list_scrollbar",
		horizontal_alignment = "left",
		size = {
			488,
			95
		},
		position = {
			-45,
			60,
			32
		}
	},
	original_skins_list_detail_bottom = {
		vertical_alignment = "bottom",
		parent = "original_skins_list_scrollbar",
		horizontal_alignment = "left",
		size = {
			488,
			95
		},
		position = {
			-45,
			-60,
			32
		}
	},


    LA_skins_frame = {
        vertical_alignment = "center",
		parent = "window_background",
		horizontal_alignment = "right",
		size = original_skins_frame_size,
		position = {
			-20,
			0,
			30
		}
    },
	LA_skins_frame_texture = {
        vertical_alignment = "center",
		parent = "LA_skins_frame",
		horizontal_alignment = "right",
		size = LA_UI_frame_size,
		position = {
			-20,
			-50,
			30
		}
    },
	LA_skins_title_bg = {
		vertical_alignment = "top",
		parent = "LA_skins_frame",
		horizontal_alignment = "center",
		size = la_ui_headerlarge_size,
		position = {
			-100,
			-50,
			31
		}
	},
    LA_skins_title_text = {
		vertical_alignment = "top",
		parent = "LA_skins_title_bg",
		horizontal_alignment = "center",
		size = {
			list_window_size[1] - 40,
			300
		},
		position = {
			0,
			-10,
			32
		}
	},
    LA_skins_list_window = {
		vertical_alignment = "top",
		parent = "LA_skins_frame",
		horizontal_alignment = "right",
		size = {
			list_window_size[1]*1.1,
			list_window_size[2]
		},
		position = {
			-- 120,
			-- -140,
			-- 10
            -100,
			-200,
			10
		}
	},
	LA_skins_list_scrollbar = {
		vertical_alignment = "top",
		parent = "LA_skins_list_window",
		horizontal_alignment = "right",
		size = list_scrollbar_size,
		position = {
			30,
			-10,
			10
		}
	},
	LA_skins_list_scroll_root = {
		vertical_alignment = "top",
		parent = "LA_skins_list_window",
		horizontal_alignment = "right",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			0
		}
	},

	LA_skins_list_entry_main_hand = {
		vertical_alignment = "top",
		parent = "LA_skins_list_scroll_root",
		horizontal_alignment = "right",
		size = list_entry_size,
		position = {
			0,
			0,
			-1
		}
	},
	LA_skins_main_hand_bg = {
		vertical_alignment = "top",
		parent = "LA_skins_list_scroll_root",
		horizontal_alignment = "center",
		size = {
			list_window_size[1] - 40,
			300
		},
		position = {
			0,
			0,
			31
		}
	},
	LA_skins_main_hand_text = {
		vertical_alignment = "center",
		parent = "LA_skins_main_hand_bg",
		horizontal_alignment = "center",
		size = {
			list_window_size[1] - 40,
			300
		},
		position = {
			0,
			0,
			31
		}
	},

	LA_skins_list_entry_off_hand = {
		vertical_alignment = "top",
		parent = "LA_skins_list_scroll_root",
		horizontal_alignment = "right",
		size = list_entry_size,
		position = {
			0,
			0,
			-1
		}
	},
	LA_skins_off_hand_bg = {
		vertical_alignment = "top",
		parent = "LA_skins_list_scroll_root",
		horizontal_alignment = "center",
		size = {
			list_window_size[1] - 40,
			300
		},
		position = {
			0,
			0,
			31
		}
	},
	LA_skins_off_hand_text = {
		vertical_alignment = "center",
		parent = "LA_skins_off_hand_bg",
		horizontal_alignment = "center",
		size = {
			list_window_size[1] - 40,
			300
		},
		position = {
			0,
			0,
			31
		}
	},

	
	LA_skins_list_entry_outfits = {
		vertical_alignment = "top",
		parent = "LA_skins_list_scroll_root",
		horizontal_alignment = "right",
		size = list_entry_size,
		position = {
			0,
			0,
			-1
		}
	},
	LA_skins_outfits_text = {
		vertical_alignment = "top",
		parent = "LA_skins_list_scroll_root",
		horizontal_alignment = "center",
		size = {
			list_window_size[1] - 40,
			300
		},
		position = {
			0,
			0,
			31
		}
	},

	LA_skins_list_detail_top = {
		vertical_alignment = "top",
		parent = "LA_skins_list_scrollbar",
		horizontal_alignment = "right",
		size = {
			488,
			95
		},
		position = {
			45,
			60,
			2
		}
	},
	LA_skins_list_detail_bottom = {
		vertical_alignment = "bottom",
		parent = "LA_skins_list_scrollbar",
		horizontal_alignment = "right",
		size = {
			488,
			95
		},
		position = {
			45,
			-60,
			2
		}
	},

    my_button = {
      parent = "window",
      vertical_alignment = "bottom",
      horizontal_alignment = "center",
      size = { 438, 44 },
      position = { 12.5, -25, 50 },
    },

	hero_selection = {
		parent = "window_background",
		vertical_alignment = "top",
		horizontal_alignment = "center",
		size = { 
			200, 
			100 
		},
		position = { 
			0,
			0, 
			2 
		},
	},
	es_hero_select = {
		parent = "hero_selection",
		vertical_alignment = "center",
		horizontal_alignment = "center",
		size = { 
			50, 
			50 
		},
		position = { 
			-220,
			-15, 
			32 
		},
	},
	dr_hero_select = {
		parent = "hero_selection",
		vertical_alignment = "center",
		horizontal_alignment = "center",
		size = { 
			50, 
			50 
		},
		position = { 
			-110,
			-15, 
			32 
		},
	},
	we_hero_select = {
		parent = "hero_selection",
		vertical_alignment = "center",
		horizontal_alignment = "center",
		size = { 
			50, 
			50 
		},
		position = { 
			0,
			-15, 
			32 
		},
	},
	wh_hero_select = {
		parent = "hero_selection",
		vertical_alignment = "center",
		horizontal_alignment = "center",
		size = { 
			50, 
			50 
		},
		position = { 
			110,
			-15, 
			32 
		},
	},
	bw_hero_select = {
		parent = "hero_selection",
		vertical_alignment = "center",
		horizontal_alignment = "center",
		size = { 
			50, 
			50 
		},
		position = { 
			220,
			-15, 
			32 
		},
	},
	hero_select_divider = {
		parent = "hero_selection",
		vertical_alignment = "center",
		horizontal_alignment = "center",
		size = { 
			530, 
			20 
		},
		position = { 
			0,
			-75, 
			32 
		},
	},
	gear_icon_frame = {
		parent = "hero_selection",
		vertical_alignment = "center",
		horizontal_alignment = "center",
		size = la_ui_gear_icon,
		position = { 
			0,
			-107.5, 
			31
		},
	},
	melee_item_select = {
		parent = "gear_icon_frame",
		vertical_alignment = "center",
		horizontal_alignment = "center",
		size = { 
			42.5, 
			42.5
		},
		position = { 
			-135*gear_icon_seperation_factor,
			0, 
			32 
		},
	},
	ranged_item_select = {
		parent = "gear_icon_frame",
		vertical_alignment = "center",
		horizontal_alignment = "center",
		size = { 
			42.5, 
			42.5
		},
		position = { 
			-45*gear_icon_seperation_factor,
			0, 
			32 
		},
	},
	skin_item_select = {
		parent = "gear_icon_frame",
		vertical_alignment = "center",
		horizontal_alignment = "center",
		size = { 
			42.5, 
			42.5
		},
		position = { 
			45*gear_icon_seperation_factor,
			0, 
			32 
		},
	},
	hat_item_select = {
		parent = "gear_icon_frame",
		vertical_alignment = "center",
		horizontal_alignment = "center",
		size = { 
			42.5, 
			42.5
		},
		position = { 
			135*gear_icon_seperation_factor,
			0, 
			32 
		},
	},
	


}

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

  
local widgets_definitions = {    
    original_skins_title_text = UIWidgets.create_simple_text("original_skin", "original_skins_title_text", nil, nil, original_skins_title_text_style),
	original_skins_title_bg = UIWidgets.create_simple_texture("la_ui_headerlarge", "original_skins_title_bg"),
    -- original_skins_list_detail_top = UIWidgets.create_simple_uv_texture("keep_decorations_01", {
	-- 	{
	-- 		0,
	-- 		0
	-- 	},
	-- 	{
	-- 		1,
	-- 		1
	-- 	}
	-- }, "original_skins_list_detail_top"),
	-- original_skins_list_detail_bottom = UIWidgets.create_simple_uv_texture("keep_decorations_01", {
	-- 	{
	-- 		0,
	-- 		1
	-- 	},
	-- 	{
	-- 		1,
	-- 		0
	-- 	}
	-- }, "original_skins_list_detail_bottom"),
	-- original_skins_list_scrollbar = UIWidgets.create_chain_scrollbar("original_skins_list_scrollbar", "original_skins_list_window", scenegraph_definition.original_skins_list_scrollbar.size, "gold"),
	original_skins_list_mask = LAWidgetUtils.create_list_mask("original_skins_list_window", scenegraph_definition.original_skins_list_window.size, 10),

	-- original_skins_list_divider = UIWidgets.create_simple_texture("small_divider", "original_skins_list_divider"),

	LA_skins_title_bg = UIWidgets.create_simple_texture("la_ui_headerlarge", "LA_skins_title_bg"),
    LA_skins_title_text = UIWidgets.create_simple_text("LA_skin", "LA_skins_title_text", nil, nil, LA_skins_title_text_style),
	
    -- LA_skins_list_detail_top = UIWidgets.create_simple_uv_texture("keep_decorations_01", {
	-- 	{
	-- 		1,
	-- 		0
	-- 	},
	-- 	{
	-- 		0,
	-- 		1
	-- 	}
	-- }, "LA_skins_list_detail_top"),
	-- LA_skins_list_detail_bottom = UIWidgets.create_simple_uv_texture("keep_decorations_01", {
	-- 	{
	-- 		1,
	-- 		1
	-- 	},
	-- 	{
	-- 		0,
	-- 		0
	-- 	}
	-- }, "LA_skins_list_detail_bottom"),
	-- LA_skins_list_scrollbar = UIWidgets.create_chain_scrollbar("LA_skins_list_scrollbar", "LA_skins_list_window", scenegraph_definition.LA_skins_list_scrollbar.size, "gold"),
	LA_skins_list_mask = LAWidgetUtils.create_list_mask("LA_skins_list_window", scenegraph_definition.LA_skins_list_window.size, 10),

    -- window = UIWidgets.create_frame("window_frame", scenegraph_definition.window_frame.size, "la_ui_framecorners"),
	window = UIWidgets.create_frame("window_frame", scenegraph_definition.window_frame.size, "la_ui_framecorners", nil, nil, {0,0}, nil, false, true, true),
	-- window_frame_left = UIWidgets.create_simple_texture("la_ui_frame_left_side", "window_frame_left"),
	-- window_frame_right = UIWidgets.create_simple_texture("la_ui_frame_right_side", "window_frame_right"),
	-- window_frame_bottom = UIWidgets.create_simple_texture("la_ui_frame_bottom_side", "window_frame_bottom"),
	-- window_frame_top = UIWidgets.create_simple_texture("la_ui_frame_top_side", "window_frame_top"),

    window_bg_fill = UIWidgets.create_background("window_bg_fill", scenegraph_definition.window_bg_fill.size, "la_ui_background_01darker"),
	window_bg_vignette = UIWidgets.create_background("window_bg_vignette", scenegraph_definition.window_bg_vignette.size, "la_ui_background_vignette"),
    window_title = UIWidgets.create_simple_texture("la_ui_frameheader", "window_title"),
	-- gem_header = LAWidgetUtils.create_simple_texture("gem_blue", "gem_header"),
	-- window_title = LAWidgetUtils.create_simple_animated_texture("window_title", scenegraph_definition.window_title.size),
	window_title_bg = UIWidgets.create_background("window_title_bg", scenegraph_definition.window_title_bg.size, "menu_frame_bg_02"),
    window_title_text = UIWidgets.create_simple_text("mod_name", "window_title_text", nil, nil, window_title_text_style),

	-- tutorial_overlay_toggle = UIWidgets.create_icon_button("tutorial_overlay_toggle", scenegraph_definition.tutorial_overlay_toggle.size, nil, nil, "la_questionmark_icon"),
	tutorial_overlay_toggle = LAWidgetUtils.create_button_with_hover_highlight("tutorial_overlay_toggle", scenegraph_definition.tutorial_overlay_toggle.size, nil, nil, "la_questionmark_icon"),

    -- window_title_banner_left = UIWidgets.create_simple_texture("loremasters_armoury_banner2", "window_title_banner_left"),
    -- window_title_banner_right = UIWidgets.create_simple_texture("loremasters_armoury_banner2", "window_title_banner_right"),
    
    -- sword_left_bottom = UIWidgets.create_simple_texture("frame_detail_sword", "sword_left_bottom"),
	-- sword_right_bottom = UIWidgets.create_simple_uv_texture("frame_detail_sword", {
	-- 	{
	-- 		1,
	-- 		0
	-- 	},
	-- 	{
	-- 		0,
	-- 		1
	-- 	}
	-- }, "sword_right_bottom"),
    -- sword_left_top = UIWidgets.create_simple_texture("frame_detail_sword", "sword_left_top"),
	-- sword_right_top = UIWidgets.create_simple_uv_texture("frame_detail_sword", {
	-- 	{
	-- 		1,
	-- 		0
	-- 	},
	-- 	{
	-- 		0,
	-- 		1
	-- 	}
	-- }, "sword_right_top"),

	LA_preview_background = UIWidgets.create_simple_texture("la_ui_itempreviewframe_armour_recenter", "LA_preview_background"),
	-- LA_preview_background = UIWidgets.create_simple_texture("la_ui_itempreviewframe_armour_recenter", "LA_preview_background", nil, nil, nil, nil, {
	-- 	LA_preview_background_size[1]*1.1,
	-- 	LA_preview_background_size[2]*1.1
	-- }),



	es_hero_select = LAWidgetUtils.create_icon_and_remove_name_button("es_hero_select", "la_kruber_button_icon", "es"),
	dr_hero_select = LAWidgetUtils.create_icon_and_remove_name_button("dr_hero_select", "la_bardin_button_icon", "dr"),
	we_hero_select = LAWidgetUtils.create_icon_and_remove_name_button("we_hero_select", "la_kerillian_button_icon", "we"),
	wh_hero_select = LAWidgetUtils.create_icon_and_remove_name_button("wh_hero_select", "la_saltzpyre_button_icon", "wh"),
	bw_hero_select = LAWidgetUtils.create_icon_and_remove_name_button("bw_hero_select", "la_sienna_button_icon", "bw"),

	hero_select_divider = UIWidgets.create_simple_texture("la_ui_separatorcenter", "hero_select_divider"),
	original_skins_frame_texture = UIWidgets.create_simple_texture("la_ui_frameleft", "original_skins_frame_texture"),
	LA_skins_frame_texture = UIWidgets.create_simple_texture("la_ui_frameright", "LA_skins_frame_texture"),

	gear_icon_frame = UIWidgets.create_simple_texture("la_ui_geariconframe_new", "gear_icon_frame"),
	melee_item_select = UIWidgets.create_icon_button("melee_item_select", scenegraph_definition.melee_item_select.size, nil, nil, "tabs_inventory_icon_melee_normal"),
	ranged_item_select = UIWidgets.create_icon_button("ranged_item_select", scenegraph_definition.ranged_item_select.size, nil, nil, "tabs_inventory_icon_ranged_normal"),
	skin_item_select = UIWidgets.create_icon_button("skin_item_select", scenegraph_definition.skin_item_select.size, nil, nil, "store_tag_icon_skin_exotic"),
	hat_item_select = UIWidgets.create_icon_button("hat_item_select", scenegraph_definition.hat_item_select.size, nil, nil, "tabs_inventory_icon_hats_normal"),
	
	background_rect_original_skins = UIWidgets.create_rect_with_outer_frame("original_skins_list_window", 
			scenegraph_definition.original_skins_list_window.size, 
			"frame_outer_fade_02", 
			nil, 
			Colors.get_color_table_with_alpha("console_menu_rect", 100)),

	background_rect_LA_skins = UIWidgets.create_rect_with_outer_frame("LA_skins_list_window", 
			scenegraph_definition.LA_skins_list_window.size, 
			"frame_outer_fade_02", 
			nil, 
			Colors.get_color_table_with_alpha("console_menu_rect", 100)),

	-- original_skins_list_entry = UIWidgets.create_icon_button("original_skins_list_entry", scenegraph_definition.original_skins_list_entry.size, nil, nil, "tabs_inventory_icon_hats_normal"),

    loading_icon = {
		scenegraph_id = "loading_icon",
		element = {
			passes = {
				{
					style_id = "texture_id",
					pass_type = "rotated_texture",
					texture_id = "texture_id",
					content_change_function = function (content, style, _, dt)
						local progress = style.progress or 0
						progress = (progress + dt) % 1
						local angle = math.pow(2, math.smoothstep(progress, 0, 1)) * math.pi * 2
						style.angle = angle
						style.progress = progress
					end
				},
				{
					pass_type = "rect",
					style_id = "overlay_1"
				}
			}
		},
		content = {
			texture_id = "loot_loading"
		},
		style = {
			texture_id = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				angle = 0,
				texture_size = {
					150,
					150
				},
				pivot = {
					75,
					75
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					1
				}
			},
			overlay_1 = {
				color = {
					200,
					5,
					5,
					5
				},
				offset = {
					0,
					0,
					0
				}
			}
		},
		offset = {
			0,
			0,
			0
		}
	},
	my_button = LAWidgetUtils.create_simple_window_button("my_button", scenegraph_definition.my_button.size, Localize("interaction_action_close"), 28, "la_ui_closebutton")
	-- my_button = UIWidgets.create_default_button("my_button", scenegraph_definition.my_button.size, "menu_frame_16_white", "la_ui_closebutton", Localize("interaction_action_close"), 28, nil, nil, nil, true)
}


--gaussing function that handles size of waypoint based on distance from it
local gaussian_size_decrease = function(current_distance, min_size, max_size, max_distance)

    local lambda = -(1^2)/math.log(min_size/max_size)

    local gaussian_size = max_size*math.exp(-(current_distance-max_distance)^2/lambda)

    return gaussian_size
end

local animation_definitions = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (ui_scenegraph, scenegraph_definition, widgets, params)
				params.render_settings.alpha_multiplier = 0
			end,
			update = function (ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)
				params.render_settings.alpha_multiplier = 1
			end,
			on_complete = function (ui_scenegraph, scenegraph_definition, widgets, params)
				return
			end
		},
		{
			name = "detail_extend",
			start_progress = 0,
			end_progress = 1,
			init = NOP,
			update = function(ui_scenegraph, scenegraph_def, widgets, progress, params)
			  local anim_progress = math.easeOutCubic(progress)
			  local scenegraph_id = widgets.scenegraph_id
			--   ui_scenegraph.original_skins_list_entry.position[1] = scenegraph_def.original_skins_list_entry.position[1] -10* anim_progress
			  ui_scenegraph[scenegraph_id].position[2] = scenegraph_def[scenegraph_id].position[2] -10* anim_progress
			end,
			on_complete = NOP
		  }
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (ui_scenegraph, scenegraph_definition, widgets, params)
				params.render_settings.alpha_multiplier = 1
			end,
			update = function (ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)
				params.render_settings.alpha_multiplier = 1
			end,
			on_complete = function (ui_scenegraph, scenegraph_definition, widgets, params)
				return
			end
		},
	},
	on_list_initialized = {
		{
		  name = "delay",
		  start_progress = 0,
		  end_progress = 0.3,
		  init = NOP,
		  update = NOP,
		  on_complete = NOP
		},
		{
		  name = "fade_and_slide_in",
		  start_progress = 0,
		  end_progress = 0.6,
		  init = function(ui_scenegraph, scenegraph_definition, widgets, params)
			params.render_settings.list_alpha_multiplier = 0
			local list_widget = widgets.list_widget
			local style = list_widget.style
			local mask_style = style.mask
			local mask_default_width = mask_style.texture_size[1]
			params.mask_default_width = mask_default_width
		  end,
		  update = function(ui_scenegraph, scenegraph_definition, widgets, progress, params)
			local anim_progress = math.easeOutCubic(progress)
			params.render_settings.list_alpha_multiplier = anim_progress
			local list_widgets = widgets.list_items
			local longest_anim_distance = 0
	
			for index, widget in ipairs(list_widgets) do
			  local content = widget.content
			  local offset = widget.offset
			  local default_offset = widget.default_offset
			  local row = content.row
			  local column = content.col
			  local anim_offset = math.min(row * 50 + (4 - column) * 20, 300)
			  offset[1] = math.floor(default_offset[1] - anim_offset + anim_offset * anim_progress)
			  longest_anim_distance = math.max(longest_anim_distance, anim_offset)
			end
	
			local mask_default_width = params.mask_default_width
			local mask_size = math.floor((mask_default_width + longest_anim_distance) - longest_anim_distance * anim_progress)
			local list_widget = widgets.list_widget
			local style = list_widget.style
			style.mask.texture_size[1] = mask_size
			style.mask_top.texture_size[1] = mask_size
			style.mask_bottom.texture_size[1] = mask_size
		  end,
		  on_complete = NOP
		}
	  },
}

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