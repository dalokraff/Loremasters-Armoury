local mod = get_mod("Loremasters-Armoury")

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
local la_ui_separator = {
	509*0.9,
	34*0.9
}
local la_ui_gear_icon = {
	462*0.9, 
	63*0.9
}

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
			60
		},
		position = {
			0,
			34,
			30
		}
	},
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
			LA_preview_background_size[1]*0.9,
			LA_preview_background_size[2]*0.9
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
		size = list_window_size,
		position = {
			-- 120,
			-- -140,
			-- 10
            100,
			-230,
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
			430,
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
		size = list_window_size,
		position = {
			-- 120,
			-- -140,
			-- 10
            -100,
			-230,
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
	LA_skins_main_hand_text = {
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
	LA_skins_off_hand_text = {
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
      position = { 0, -25, 50 },
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
			-110, 
			31
		},
	},
	melee_item_select = {
		parent = "gear_icon_frame",
		vertical_alignment = "center",
		horizontal_alignment = "center",
		size = { 
			50, 
			50
		},
		position = { 
			-135,
			0, 
			32 
		},
	},
	ranged_item_select = {
		parent = "gear_icon_frame",
		vertical_alignment = "center",
		horizontal_alignment = "center",
		size = { 
			50, 
			50 
		},
		position = { 
			-45,
			0, 
			32 
		},
	},
	skin_item_select = {
		parent = "gear_icon_frame",
		vertical_alignment = "center",
		horizontal_alignment = "center",
		size = { 
			50, 
			50 
		},
		position = { 
			45,
			0, 
			32 
		},
	},
	hat_item_select = {
		parent = "gear_icon_frame",
		vertical_alignment = "center",
		horizontal_alignment = "center",
		size = { 
			50, 
			50 
		},
		position = { 
			135,
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












local function create_list_mask(scenegraph_id, size, fade_height)
	fade_height = fade_height or 20
	local element = {
		passes = {
			{
				pass_type = "hotspot",
				content_id = "hotspot"
			},
			{
				pass_type = "texture",
				style_id = "mask",
				texture_id = "mask_texture"
			},
			{
				pass_type = "texture",
				style_id = "mask_top",
				texture_id = "mask_edge"
			},
			{
				pass_type = "rotated_texture",
				style_id = "mask_bottom",
				texture_id = "mask_edge"
			}
		}
	}
	local content = {
		mask_texture = "mask_rect",
		mask_edge = "mask_rect_edge_fade",
		hotspot = {}
	}
	local style = {
		mask = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				size[1],
				size[2]
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
				0
			}
		},
		mask_top = {
			vertical_alignment = "top",
			horizontal_alignment = "center",
			texture_size = {
				size[1],
				fade_height
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				fade_height,
				0
			}
		},
		mask_bottom = {
			vertical_alignment = "bottom",
			horizontal_alignment = "center",
			texture_size = {
				size[1],
				fade_height
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				-fade_height,
				0
			},
			angle = math.pi,
			pivot = {
				size[1] / 2,
				fade_height / 2
			}
		}
	}
	local widget = {
		element = element,
		content = content,
		style = style,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = scenegraph_id
	}

	return widget
end

local function create_entry_widget()
	local masked = true
	local hover_frame_settings = UIFrameSettings.frame_outer_glow_04
	local hover_frame_spacing = hover_frame_settings.texture_sizes.horizontal[2]
	local new_frame_settings = UIFrameSettings.frame_outer_glow_01
	local new_frame_spacing = new_frame_settings.texture_sizes.horizontal[2]
	local pulse_frame_name = "frame_outer_glow_04_big"
	local pulse_frame_settings = UIFrameSettings[pulse_frame_name]
	local pulse_frame_spacing = pulse_frame_settings.texture_sizes.horizontal[2]
	local scenegraph_id = "list_entry"
	local size = scenegraph_definition[scenegraph_id].size
	local passes = {
		{
			style_id = "background",
			pass_type = "hotspot",
			content_id = "button_hotspot"
		},
		{
			style_id = "title",
			pass_type = "text",
			text_id = "title",
			content_check_function = function (content)
				return not content.locked
			end
		},
		{
			style_id = "locked_title",
			pass_type = "text",
			text_id = "title",
			content_check_function = function (content)
				return content.locked
			end
		},
		{
			style_id = "title_shadow",
			pass_type = "text",
			text_id = "title"
		},
		{
			pass_type = "texture",
			style_id = "background",
			texture_id = "background"
		},
		{
			pass_type = "texture",
			style_id = "edge_fade",
			texture_id = "edge_fade"
		},
		{
			pass_type = "texture_frame",
			style_id = "hover_frame",
			texture_id = "hover_frame"
		},
		{
			style_id = "new_frame",
			texture_id = "new_frame",
			pass_type = "texture_frame",
			content_check_function = function (content)
				return content.new and not content.button_hotspot.is_hover
			end,
			content_change_function = function (content, style)
				local progress = 0.5 + math.sin(Managers.time:time("ui") * 5) * 0.5
				style.color[1] = 55 + progress * 200
			end
		},
		{
			pass_type = "texture",
			style_id = "dot_texture",
			texture_id = "dot_texture",
			content_check_function = function (content)
				local locked = content.locked
				local equipped = content.equipped
				local new = content.new
				local in_use = content.in_use

				return not locked and not equipped and not new and not in_use
			end
		},
		{
			pass_type = "texture",
			style_id = "lock_texture",
			texture_id = "lock_texture",
			content_check_function = function (content)
				return content.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "equipped_texture",
			texture_id = "equipped_texture",
			content_check_function = function (content)
				return content.equipped
			end
		},
		{
			pass_type = "texture",
			style_id = "equipped_shadow_texture",
			texture_id = "equipped_texture",
			content_check_function = function (content)
				return content.equipped
			end
		},
		{
			pass_type = "texture",
			style_id = "in_use_texture",
			texture_id = "equipped_texture",
			content_check_function = function (content)
				return content.in_use and not content.equipped
			end
		},
		{
			style_id = "new_texture",
			texture_id = "new_texture",
			pass_type = "texture",
			content_check_function = function (content)
				return content.new
			end,
			content_change_function = function (content, style)
				local progress = 0.5 + math.sin(Managers.time:time("ui") * 5) * 0.5
				style.color[1] = 55 + progress * 200
			end
		},
		{
			pass_type = "texture_frame",
			style_id = "pulse_frame",
			texture_id = "pulse_frame"
		}
	}
	local content = {
		background = "rect_masked",
		locked = false,
		title = "",
		lock_texture = "achievement_symbol_lock",
		equipped = false,
		equipped_texture = "matchmaking_checkbox",
		new_texture = "list_item_tag_new",
		edge_fade = "playername_bg_02",
		new = false,
		dot_texture = "tooltip_marker",
		button_hotspot = {},
		hover_frame = hover_frame_settings.texture,
		new_frame = new_frame_settings.texture,
		pulse_frame = pulse_frame_settings.texture,
		size = size
	}
	local style = {
		title = {
			localize = false,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			font_size = entry_font_size,
			font_type = (masked and "hell_shark_masked") or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			hover_text_color = Colors.get_color_table_with_alpha("white", 255),
			default_text_color = Colors.get_color_table_with_alpha("font_default", 255),
			offset = {
				40,
				0,
				2
			},
			size = {
				size[1] - 55,
				size[2]
			}
		},
		locked_title = {
			localize = false,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			font_size = entry_font_size,
			font_type = (masked and "hell_shark_masked") or "hell_shark",
			text_color = {
				255,
				80,
				80,
				80
			},
			hover_text_color = {
				255,
				80,
				80,
				80
			},
			default_text_color = {
				255,
				80,
				80,
				80
			},
			offset = {
				40,
				0,
				2
			},
			size = {
				size[1] - 55,
				size[2]
			}
		},
		title_shadow = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			localize = false,
			font_size = entry_font_size,
			font_type = (masked and "hell_shark_masked") or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				41,
				-1,
				1
			},
			size = {
				size[1] - 55,
				size[2]
			}
		},
		background = {
			masked = masked,
			size = {
				size[1] - 20,
				size[2]
			},
			color = {
				180,
				0,
				0,
				0
			},
			offset = {
				0,
				0,
				0
			}
		},
		edge_fade = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			masked = masked,
			texture_size = {
				20,
				size[2]
			},
			color = {
				180,
				0,
				0,
				0
			},
			offset = {
				0,
				0,
				0
			}
		},
		hover_frame = {
			masked = masked,
			texture_size = hover_frame_settings.texture_size,
			texture_sizes = hover_frame_settings.texture_sizes,
			color = {
				0,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				6
			},
			size = {
				size[1],
				size[2]
			},
			frame_margins = {
				-hover_frame_spacing,
				-hover_frame_spacing
			}
		},
		pulse_frame = {
			horizontal_alignment = "left",
			vertical_alignment = "bottom",
			masked = masked,
			area_size = size,
			texture_size = pulse_frame_settings.texture_size,
			texture_sizes = pulse_frame_settings.texture_sizes,
			frame_margins = {
				-pulse_frame_spacing,
				-pulse_frame_spacing
			},
			color = {
				0,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				12
			}
		},
		new_frame = {
			masked = masked,
			texture_size = new_frame_settings.texture_size,
			texture_sizes = new_frame_settings.texture_sizes,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				6
			},
			size = {
				size[1],
				size[2]
			},
			frame_margins = {
				-new_frame_spacing,
				-new_frame_spacing
			}
		},
		dot_texture = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = masked,
			texture_size = {
				13,
				13
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				11,
				-1,
				5
			}
		},
		lock_texture = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = masked,
			texture_size = {
				56,
				40
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-10,
				0,
				2
			}
		},
		equipped_texture = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = masked,
			texture_size = {
				37,
				31
			},
			color = Colors.get_color_table_with_alpha("green", 255),
			offset = {
				4,
				0,
				3
			}
		},
		equipped_shadow_texture = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = masked,
			texture_size = {
				37,
				31
			},
			color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				5,
				-1,
				2
			}
		},
		new_texture = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = masked,
			texture_size = {
				113.4,
				45.9
			},
			color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				-64,
				0,
				2
			}
		},
		in_use_texture = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = masked,
			texture_size = {
				37,
				31
			},
			color = Colors.get_color_table_with_alpha("gray", 255),
			offset = {
				4,
				0,
				3
			}
		}
	}
	local widget = {}
	local element = {
		passes = passes
	}
	widget.element = element
	widget.content = content
	widget.style = style
	widget.offset = {
		0,
		0,
		0
	}
	widget.scenegraph_id = scenegraph_id

	return widget
end

local function create_dummy_entry_widget()
	local masked = true
	local scenegraph_id = "list_entry"
	local size = scenegraph_definition[scenegraph_id].size
	local passes = {
		{
			pass_type = "texture",
			style_id = "background",
			texture_id = "background"
		},
		{
			pass_type = "texture",
			style_id = "edge_fade",
			texture_id = "edge_fade"
		}
	}
	local content = {
		title = "",
		locked = false,
		background = "rect_masked",
		edge_fade = "playername_bg_02",
		new = false,
		equipped = false,
		button_hotspot = {},
		size = size
	}
	local style = {
		background = {
			masked = masked,
			size = {
				size[1] - 20,
				size[2]
			},
			color = {
				180,
				0,
				0,
				0
			},
			offset = {
				0,
				0,
				0
			}
		},
		edge_fade = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			masked = masked,
			texture_size = {
				20,
				size[2]
			},
			color = {
				180,
				0,
				0,
				0
			},
			offset = {
				0,
				0,
				0
			}
		}
	}
	local widget = {}
	local element = {
		passes = passes
	}
	widget.element = element
	widget.content = content
	widget.style = style
	widget.offset = {
		0,
		0,
		0
	}
	widget.scenegraph_id = scenegraph_id

	return widget
end

--taken and modified from Vermintide-2-Source-Code\scripts\ui\ui_widgets_honduras.lua line #15646 "UIWidgets.create_icon_and_name_button()"
--as is this function is broken. Seems that some typos were made with "texture_hover_id" vs "texture_hover" and "texture_icon_id" vs "texture_icon"
--also they were missing some hover colors for a couple styles
local function create_icon_and_remove_name_button(scenegraph_id, icon, text)

	return {
		element = {
			passes = {
				{
					style_id = "button_hotspot",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					pass_type = "texture",
					style_id = "texture_id",
					texture_id = "texture_id",
					content_check_function = function (content)
						return not content.button_hotspot.disable_button
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_disabled_id",
					texture_id = "texture_id",
					content_check_function = function (content)
						return content.button_hotspot.disable_button
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_hover",
					texture_id = "texture_hover",
					content_check_function = function (content)
						local button_hotspot = content.button_hotspot

						return not button_hotspot.disable_button and (button_hotspot.is_selected or button_hotspot.is_hover)
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_icon",
					texture_id = "texture_icon",
					content_check_function = function (content)
						local button_hotspot = content.button_hotspot

						return not button_hotspot.disable_button
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_icon_hover_id",
					texture_id = "texture_icon",
					content_check_function = function (content)
						local button_hotspot = content.button_hotspot

						return not button_hotspot.disable_button
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_icon_disabled_id",
					texture_id = "texture_icon",
					content_check_function = function (content)
						return content.button_hotspot.disable_button
					end
				},
				-- {
				-- 	pass_type = "texture",
				-- 	style_id = "texture_text_bg_id",
				-- 	texture_id = "texture_text_bg_id"
				-- },
				-- {
				-- 	pass_type = "texture",
				-- 	style_id = "texture_text_bg_effect_id",
				-- 	texture_id = "texture_text_bg_effect_id"
				-- },
				-- {
				-- 	style_id = "text",
				-- 	pass_type = "text",
				-- 	text_id = "text",
				-- 	content_check_function = function (content)
				-- 		local button_hotspot = content.button_hotspot

				-- 		return not button_hotspot.disable_button
				-- 	end
				-- },
				-- {
				-- 	style_id = "text_hover",
				-- 	pass_type = "text",
				-- 	text_id = "text",
				-- 	content_check_function = function (content)
				-- 		local button_hotspot = content.button_hotspot

				-- 		return not button_hotspot.disable_button
				-- 	end
				-- },
				-- {
				-- 	style_id = "text_disabled",
				-- 	pass_type = "text",
				-- 	text_id = "text",
				-- 	content_check_function = function (content)
				-- 		return content.button_hotspot.disable_button
				-- 	end
				-- },
				-- {
				-- 	style_id = "text_shadow",
				-- 	pass_type = "text",
				-- 	text_id = "text"
				-- }
			}
		},
		content = {
			texture_id = "button_small",
			texture_text_bg_id = "item_slot_side_fade",
			texture_hover = "button_small_glow",
			texture_text_bg_effect_id = "item_slot_side_effect",
			text = text or "n/a",
			texture_icon = icon or "icons_placeholder",
			button_hotspot = {}
		},
		style = {
			button_hotspot = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size = {
					80,
					80
				},
				offset = {
					0,
					7,
					0
				}
			},
			texture_icon = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					50,
					50
				},
				color = {
					255,
					255,
					255,
					255
				},
				default_color = {
					0,
					255,
					255,
					255
				},
				hover_color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					5,
					3
				}
			},
			-- texture_icon = {
			-- 	vertical_alignment = "center",
			-- 	horizontal_alignment = "center",
			-- 	texture_size = {
			-- 		50,
			-- 		50
			-- 	},
			-- 	color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			-- 	offset = {
			-- 		0,
			-- 		5,
			-- 		3
			-- 	}
			-- },
			texture_icon_hover_id = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					50,
					50
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					5,
					4
				}
			},
			texture_icon_disabled_id = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					50,
					50
				},
				color = {
					255,
					70,
					70,
					70
				},
				offset = {
					0,
					5,
					4
				}
			},
			texture_id = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					113,
					114
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
					2
				}
			},
			texture_disabled_id = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					113,
					114
				},
				color = {
					255,
					120,
					120,
					120
				},
				offset = {
					0,
					0,
					2
				}
			},
			texture_hover = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					113,
					114
				},
				color = {
					0,
					255,
					255,
					255
				},
				default_color = {
					0,
					255,
					255,
					255
				},
				hover_color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					3
				}
			},
			texture_text_bg_id = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				texture_size = {
					300,
					72
				},
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					0,
					5,
					0
				}
			},
			texture_text_bg_effect_id = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				texture_size = {
					300,
					76
				},
				color = Colors.get_color_table_with_alpha("font_title", 0),
				offset = {
					0,
					5,
					1
				}
			},
			text = {
				font_size = 52,
				upper_case = true,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				font_type = "hell_shark",
				size = {
					300,
					50
				},
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				offset = {
					60,
					-28,
					3
				}
			},
			text_hover = {
				font_size = 52,
				upper_case = true,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				font_type = "hell_shark",
				size = {
					300,
					50
				},
				text_color = Colors.get_color_table_with_alpha("white", 0),
				offset = {
					60,
					-28,
					4
				}
			},
			text_disabled = {
				font_size = 52,
				upper_case = true,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				font_type = "hell_shark",
				size = {
					300,
					50
				},
				text_color = {
					255,
					70,
					70,
					70
				},
				offset = {
					60,
					-28,
					3
				}
			},
			text_shadow = {
				font_size = 52,
				upper_case = true,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				font_type = "hell_shark",
				size = {
					300,
					50
				},
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					62,
					-30,
					2
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = scenegraph_id
	}

end




  
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
	original_skins_list_mask = create_list_mask("original_skins_list_window", scenegraph_definition.original_skins_list_window.size, 10),

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
	LA_skins_list_mask = create_list_mask("LA_skins_list_window", scenegraph_definition.LA_skins_list_window.size, 10),

    window = UIWidgets.create_frame("window_frame", scenegraph_definition.window_frame.size, "menu_frame_11"),
    window_bg_fill = UIWidgets.create_background("window_bg_fill", scenegraph_definition.window_bg_fill.size, "la_ui_background_01darker"),
	window_bg_vignette = UIWidgets.create_background("window_bg_vignette", scenegraph_definition.window_bg_vignette.size, "la_ui_background_vignette"),
    window_title = UIWidgets.create_simple_texture("frame_title_bg", "window_title"),
	window_title_bg = UIWidgets.create_background("window_title_bg", scenegraph_definition.window_title_bg.size, "menu_frame_bg_02"),
    window_title_text = UIWidgets.create_simple_text("mod_name", "window_title_text", nil, nil, window_title_text_style),

	tutorial_overlay_toggle = UIWidgets.create_icon_button("tutorial_overlay_toggle", scenegraph_definition.tutorial_overlay_toggle.size, nil, nil, "tabs_icon_all_selected"),

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

	LA_preview_background = UIWidgets.create_simple_texture("la_ui_itempreviewframe", "LA_preview_background"),



	es_hero_select = create_icon_and_remove_name_button("es_hero_select", "la_kruber_button_icon", "es"),
	dr_hero_select = create_icon_and_remove_name_button("dr_hero_select", "la_bardin_button_icon", "dr"),
	we_hero_select = create_icon_and_remove_name_button("we_hero_select", "la_kerillian_button_icon", "we"),
	wh_hero_select = create_icon_and_remove_name_button("wh_hero_select", "la_saltzpyre_button_icon", "wh"),
	bw_hero_select = create_icon_and_remove_name_button("bw_hero_select", "la_sienna_button_icon", "bw"),

	hero_select_divider = UIWidgets.create_simple_texture("la_ui_separatorcenter", "hero_select_divider"),
	original_skins_frame_texture = UIWidgets.create_simple_texture("la_ui_frameleft", "original_skins_frame_texture"),
	LA_skins_frame_texture = UIWidgets.create_simple_texture("la_ui_frameright", "LA_skins_frame_texture"),

	gear_icon_frame = UIWidgets.create_simple_texture("la_ui_geariconframe_new", "gear_icon_frame"),
	melee_item_select = UIWidgets.create_icon_button("melee_item_select", scenegraph_definition.melee_item_select.size, nil, nil, "tabs_inventory_icon_melee_normal"),
	ranged_item_select = UIWidgets.create_icon_button("ranged_item_select", scenegraph_definition.ranged_item_select.size, nil, nil, "tabs_inventory_icon_ranged_normal"),
	skin_item_select = UIWidgets.create_icon_button("skin_item_select", scenegraph_definition.skin_item_select.size, nil, nil, "store_tag_icon_skin_exotic"),
	hat_item_select = UIWidgets.create_icon_button("hat_item_select", scenegraph_definition.hat_item_select.size, nil, nil, "tabs_inventory_icon_hats_normal"),
	

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
	my_button = UIWidgets.create_default_button("my_button", scenegraph_definition.my_button.size, "menu_frame_bg_06", "la_ui_closebutton", Localize("interaction_action_close"), 28, nil, "la_ui_closebutton", nil, true)
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