local mod = get_mod("Loremasters-Armoury")
local LAWidgetUtils = local_require("scripts/mods/Loremasters-Armoury/LA_view/la_widget_utils")

local disable_with_gamepad = true
local info_window_size = {
	-- 450,
	-- 720
	600,
	900
}

local info_corner_size = {
	244 * 4/3,
	95 * 5/4,
}

local info_window_right_side_size = {
	500,
	800
}

local info_window_left_side_size = {
	550,
	400,
}



local reward_display_size = {
	413,
	300
}

local reward_display_corner_size = {
	244 * 1/2,
	95 * 1/6,
}

local scenegraph_definition = {
	--size of the enitre UI menu
	root = {
	  scale = "fit",
	  size = { 1920, 1080 },
	  position = { 0, 0, 0 }
	},
	-- my_button = {
	--   parent = "root",
	--   vertical_alignment = "center",
	--   horizontal_alignment = "center",
	--   size = { 150, 50 },
	--   position = { 0, 0, 0 }
	-- },
	--the close button
	close_button = {
		vertical_alignment = "bottom",
		parent = "root",
		horizontal_alignment = "right",
		size = {
			300,
			70
		},
		position = {
			-100,
			10,
			10
		}
	},
	--the window containing the letter
	info_window = {
		vertical_alignment = "center",
		parent = "root",
		horizontal_alignment = "center",
		size = info_window_size,
		position = {
			0,
			0,
			0
		}
	},
	--=========================================
	--the gold borders capping the top and bottom of the letter
	info_top_left = {
		vertical_alignment = "top",
		parent = "info_window",
		horizontal_alignment = "left",
		size = info_corner_size,
		position = {
			0,
			40,
			2
		}
	},
	info_top_right = {
		vertical_alignment = "top",
		parent = "info_window",
		horizontal_alignment = "right",
		size = info_corner_size,
		position = {
			0,
			40,
			2
		}
	},
	info_bottom_left = {
		vertical_alignment = "bottom",
		parent = "info_window",
		horizontal_alignment = "left",
		size = info_corner_size,
		position = {
			0,
			-40,
			2
		}
	},
	info_bottom_right = {
		vertical_alignment = "bottom",
		parent = "info_window",
		horizontal_alignment = "right",
		size = info_corner_size,
		position = {
			0,
			-40,
			2
		}
	},
	--=========================================
	title_text = {
		vertical_alignment = "top",
		parent = "info_window",
		horizontal_alignment = "center",
		size = {
			info_window_size[1] - 40,
			300
		},
		position = {
			0,
			-30,
			1
		}
	},
	title_divider = {
		vertical_alignment = "bottom",
		parent = "title_text",
		horizontal_alignment = "center",
		size = {
			78,
			28
		},
		position = {
			0,
			-45,
			1
		}
	},
	description_text = {
		vertical_alignment = "top",
		parent = "title_divider",
		horizontal_alignment = "center",
		size = {
			info_window_size[1] - 40,
			300
		},
		position = {
			0,
			-50,
			1
		}
	},
	artist_text = {
		vertical_alignment = "bottom",
		parent = "info_window",
		horizontal_alignment = "center",
		size = {
			info_window_size[1] - 40,
			300
		},
		position = {
			0,
			10,
			1
		}
	},

	info_window_right_side = {
		vertical_alignment = "top",
		parent = "root",
		horizontal_alignment = "right",
		size = info_window_right_side_size,
		position = {
			-50,
			-90,
			0
		}
	},
	info_window_right_title = {
		vertical_alignment = "top",
		parent = "info_window_right_side",
		horizontal_alignment = "center",
		size = {
			info_window_right_side_size[1],
			60
		},
		position = {
			0,
			34,
			22
		}
	},
	info_window_right_title_bg = {
		vertical_alignment = "top",
		parent = "info_window_right_title",
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
	info_window_right_title_text = {
		vertical_alignment = "center",
		parent = "info_window_right_title",
		horizontal_alignment = "center",
		size = {
			350,
			50
		},
		position = {
			0,
			-8,
			1
		}
	},
	sub_quest_display = {
		vertical_alignment = "top",
		parent = "info_window_right_side",
		horizontal_alignment = "center",
		size = {
			413,
			300
		},
		position = {
			0,
			0,
			2
		}
	},
	trait_options = {
		vertical_alignment = "center",
		parent = "info_window_right_side",
		horizontal_alignment = "center",
		size = {
			300,
			150
		},
		position = {
			0,
			0,
			2
		}
	},



	info_window_left_side = {
		vertical_alignment = "top",
		parent = "root",
		horizontal_alignment = "left",
		size = info_window_left_side_size,
		position = {
			50,
			-90,
			0
		}
	},
	info_window_left_title = {
		vertical_alignment = "top",
		parent = "info_window_left_side",
		horizontal_alignment = "center",
		size = {
			info_window_right_side_size[1],
			60
		},
		position = {
			0,
			34,
			22
		}
	},
	info_window_left_title_bg = {
		vertical_alignment = "top",
		parent = "info_window_left_title",
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
	info_window_left_title_text = {
		vertical_alignment = "center",
		parent = "info_window_left_title",
		horizontal_alignment = "center",
		size = {
			350,
			50
		},
		position = {
			0,
			-8,
			1
		}
	},
	reward_display = {
		vertical_alignment = "top",
		parent = "info_window_left_side",
		horizontal_alignment = "left",
		size = reward_display_size,
		position = {
			50,
			100,
			2
		}
	},

}


local rect_color = {
	200,
	10,
	10,
	10
}
local title_text_style = {
	dynamic_height = false,
	upper_case = true,
	localize = false,
	word_wrap = true,
	font_size = 32,
	vertical_alignment = "top",
	horizontal_alignment = "center",
	use_shadow = true,
	dynamic_font_size = false,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local info_window_title_text_style = {
	dynamic_height = false,
	upper_case = true,
	localize = false,
	word_wrap = true,
	font_size = 28,
	vertical_alignment = "top",
	horizontal_alignment = "center",
	use_shadow = true,
	dynamic_font_size = false,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local description_text_style = {
	word_wrap = true,
	upper_case = false,
	localize = false,
	dynamic_font_size_word_wrap = true,
	font_size = 26,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local artist_text_style = {
	word_wrap = true,
	upper_case = false,
	localize = false,
	dynamic_font_size_word_wrap = true,
	font_size = 18,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
	offset = {
		0,
		0,
		2
	}
}

local widgets_definitions = {
	title_text = UIWidgets.create_simple_text("n/a", "title_text", nil, nil, title_text_style),
	title_divider = UIWidgets.create_simple_texture("keep_decorations_divider_02", "title_divider"),
	description_text = UIWidgets.create_simple_text("n/a", "description_text", nil, nil, description_text_style),
	artist_text = UIWidgets.create_simple_text("n/a", "artist_text", nil, nil, artist_text_style),
	background = UIWidgets.create_simple_texture("options_window_fade_01", "root"),
	info_window = LAWidgetUtils.create_rect_with_frame("info_window", {
		info_window_size[1] - 20,
		info_window_size[2]
	}, rect_color),
	info_bottom_right = UIWidgets.create_simple_uv_texture("keep_decorations_01", {
		{
			0.5,
			1
		},
		{
			1,
			0
		}
	}, "info_bottom_right"),
	info_bottom_left = UIWidgets.create_simple_uv_texture("keep_decorations_01", {
		{
			1,
			1
		},
		{
			0.5,
			0
		}
	}, "info_bottom_left"),
	info_top_right = UIWidgets.create_simple_uv_texture("keep_decorations_01", {
		{
			0.5,
			0
		},
		{
			1,
			1
		}
	}, "info_top_right"),
	info_top_left = UIWidgets.create_simple_uv_texture("keep_decorations_01", {
		{
			1,
			0
		},
		{
			0.5,
			1
		}
	}, "info_top_left"),
	close_button = UIWidgets.create_default_button("close_button", scenegraph_definition.close_button.size, "button_frame_01_gold", nil, Localize("interaction_action_close"), 32, nil, "button_detail_01_gold", nil, disable_with_gamepad),

	info_window_right_side = UIWidgets.create_background_with_frame("info_window_right_side", scenegraph_definition.info_window_right_side.size, "menu_frame_bg_02", "menu_frame_11"),
	info_window_right_side_shadow = UIWidgets.create_simple_texture("options_window_fade_01", "info_window_right_side", nil, nil, nil, 1),
	info_window_right_title = UIWidgets.create_simple_texture("frame_title_bg", "info_window_right_title"),
	info_window_right_title_bg = UIWidgets.create_background("info_window_right_title_bg", scenegraph_definition.info_window_right_title_bg.size, "menu_frame_bg_02"),
    info_window_right_title_text = UIWidgets.create_simple_text("mission_summary", "info_window_right_title_text", nil, nil, info_window_title_text_style),

	info_window_left_side = UIWidgets.create_background_with_frame("info_window_left_side", scenegraph_definition.info_window_right_side.size, "menu_frame_bg_02", "menu_frame_11"),
	info_window_left_side_shadow = UIWidgets.create_simple_texture("options_window_fade_01", "info_window_left_side", nil, nil, nil, 1),
	info_window_left_title = UIWidgets.create_simple_texture("frame_title_bg", "info_window_left_title"),
	info_window_left_title_bg = UIWidgets.create_background("info_window_left_title_bg", scenegraph_definition.info_window_left_title_bg.size, "menu_frame_bg_02"),
    info_window_left_title_text = UIWidgets.create_simple_text("mission_reward", "info_window_left_title_text", nil, nil, info_window_title_text_style),


	-- reward_info = UIWidgets.create_item_feature("item_feature", scenegraph_definition.item_feature.size, "title_text", "value_text", "la_mq01_reward_sub9_icon", false)
	-- info_window_right_side = UIWidgets.create_game_option_window("info_window_right_side", scenegraph_definition.info_window_right_side.size, {
	-- 	128,
	-- 	0,
	-- 	0,
	-- 	0
	-- }),
	-- my_button = {
	-- 	element = {
	-- 	  passes = {
	-- 		{
	-- 		  pass_type = "hotspot",
	-- 		  content_id = "button_hotspot"
	-- 		},
	-- 		{
	-- 		  pass_type = "rect",
	-- 		  style_id = "rect"
	-- 		},
	-- 		{
	-- 		  pass_type = "text",
	-- 		  text_id = "text",
	-- 		  style_id = "text"
	-- 		}
	-- 	  }
	-- 	},
	-- 	content = {
	-- 	  button_hotspot = {},
	-- 	  text = "Click to Close"
	-- 	},
	-- 	style = {
	-- 	  rect = {
	-- 		color = { 255, 0, 0, 0 },
	-- 		offset = { 0, 0, 0 }
	-- 	  },
	-- 	  text = {
	-- 		text_color = { 255, 255, 255, 255 },
	-- 		font_type = "hell_shark",
	-- 		font_size = 18,
	-- 		vertical_alignment = "center",
	-- 		horizontal_alignment = "center",
	-- 		offset = { 0, 0, 1 }
	-- 	  }
	-- 	},
	-- 	scenegraph_id = "my_button",
	-- 	offset = { 0, 0, 0 }
	-- }
}


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
				params.render_settings.alpha_multiplier = anim_progress
				local offset = 200 * (1 - anim_progress)
				local close_button_default_position = scenegraph_definition.close_button.position
				ui_scenegraph.close_button.position[1] = close_button_default_position[1] + offset
			end,
			on_complete = function (ui_scenegraph, scenegraph_definition, widgets, params)
				return
			end
		}
	}
}


return {
	scenegraph_definition = scenegraph_definition,
	widgets = widgets_definitions,
	animation_definitions = animation_definitions,
	create_trait_option = LAWidgetUtils.create_trait_option,
	create_reward_option = LAWidgetUtils.create_reward_option,
	create_sub_quest_option = LAWidgetUtils.create_sub_quest_option,
}