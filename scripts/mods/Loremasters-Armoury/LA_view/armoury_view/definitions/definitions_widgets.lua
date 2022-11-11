local mod = get_mod("Loremasters-Armoury")

local disable_with_gamepad = true
local list_window_size = {
	480,
	700
}
local list_scrollbar_size = {
	16,
	list_window_size[2] - 20
}
local info_window_size = {
	450,
	list_window_size[2] + 20
}

local scenegraph_definition = {
	root = {
	  scale = "fit",
	  size = { 1920, 1080 },
	  position = { 0, 0, 0 }  
	},
	my_button = {
	  parent = "root",
	  vertical_alignment = "center",
	  horizontal_alignment = "center",
	  size = { 150, 50 },
	  position = { 0, 0, 0 }
	},
	close_button = {
		vertical_alignment = "bottom",
		parent = "root",
		horizontal_alignment = "right",
		size = {
			300,
			70
		},
		position = {
			-80,
			30,
			10
		}
	},
	list_window = {
		vertical_alignment = "top",
		parent = "root",
		horizontal_alignment = "left",
		size = list_window_size,
		position = {
			120,
			-140,
			10
		}
	},
	list_scrollbar = {
		vertical_alignment = "top",
		parent = "list_window",
		horizontal_alignment = "left",
		size = list_scrollbar_size,
		position = {
			-30,
			-10,
			10
		}
	},
	list_scroll_root = {
		vertical_alignment = "top",
		parent = "list_window",
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
	list_entry = {
		vertical_alignment = "top",
		parent = "list_scroll_root",
		horizontal_alignment = "left",
		size = list_entry_size,
		position = {
			25,
			0,
			0
		}
	},
	list_detail_top = {
		vertical_alignment = "top",
		parent = "list_scrollbar",
		horizontal_alignment = "left",
		size = {
			488,
			95
		},
		position = {
			-45,
			60,
			2
		}
	},
	list_detail_bottom = {
		vertical_alignment = "bottom",
		parent = "list_scrollbar",
		horizontal_alignment = "left",
		size = {
			488,
			95
		},
		position = {
			-45,
			-60,
			2
		}
	},
	confirm_button = {
		vertical_alignment = "bottom",
		parent = "root",
		horizontal_alignment = "center",
		size = {
			380,
			70
		},
		position = {
			0,
			30,
			10
		}
	},
	info_window = {
		vertical_alignment = "top",
		parent = "root",
		horizontal_alignment = "right",
		size = info_window_size,
		position = {
			-70,
			-130,
			10
		}
	},
	info_top_left = {
		vertical_alignment = "top",
		parent = "info_window",
		horizontal_alignment = "left",
		size = {
			244,
			95
		},
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
		size = {
			244,
			95
		},
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
		size = {
			244,
			95
		},
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
		size = {
			244,
			95
		},
		position = {
			0,
			-40,
			2
		}
	},
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
	}
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


local function create_rect_with_frame(scenegraph_id, size, rect_color)
	local widget = {
		element = {}
	}
	local passes = {
		{
			-- pass_type = "rect",
			-- style_id = "background"

			pass_type = "texture",
        	texture_id = "texture_id",
        	style_id = "texture_id",
		},
		{
			pass_type = "texture_frame",
			style_id = "frame",
			texture_id = "frame"
		}
	}
	local content = {
		frame = "menu_frame_13",
		texture_id = "paper_back",
	}
	local style = {
		background = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = size,
			color = rect_color or {
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
		frame = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			area_size = size,
			texture_size = {
				84,
				84
			},
			texture_sizes = {
				corner = {
					32,
					32
				},
				vertical = {
					27,
					1
				},
				horizontal = {
					1,
					27
				}
			},
			frame_margins = {
				-27,
				-27
			},
			color = rect_color or {
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
		}
	}
	widget.element.passes = passes
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






local widgets_definitions = {
	list_detail_top = UIWidgets.create_simple_uv_texture("keep_decorations_01", {
		{
			0,
			0
		},
		{
			1,
			1
		}
	}, "list_detail_top"),
	list_detail_bottom = UIWidgets.create_simple_uv_texture("keep_decorations_01", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "list_detail_bottom"),
	list_scrollbar = UIWidgets.create_chain_scrollbar("list_scrollbar", "list_window", scenegraph_definition.list_scrollbar.size, "gold"),
	list_mask = create_list_mask("list_window", scenegraph_definition.list_window.size, 10),
	title_text = UIWidgets.create_simple_text("n/a", "title_text", nil, nil, title_text_style),
	title_divider = UIWidgets.create_simple_texture("keep_decorations_divider_02", "title_divider"),
	description_text = UIWidgets.create_simple_text("n/a", "description_text", nil, nil, description_text_style),
	artist_text = UIWidgets.create_simple_text("n/a", "artist_text", nil, nil, artist_text_style),
	background = UIWidgets.create_simple_texture("options_window_fade_01", "root"),
	info_window = create_rect_with_frame("info_window", {
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
	confirm_button = UIWidgets.create_default_button("confirm_button", scenegraph_definition.confirm_button.size, "button_frame_01_gold", nil, Localize("menu_settings_apply"), 32, nil, "button_detail_01_gold", nil, disable_with_gamepad),
	close_button = UIWidgets.create_default_button("close_button", scenegraph_definition.close_button.size, "button_frame_01_gold", nil, Localize("interaction_action_close"), 32, nil, "button_detail_01_gold", nil, disable_with_gamepad),

	my_button = {
		element = {
		  passes = {
			{
			  pass_type = "hotspot",
			  content_id = "button_hotspot"
			},
			{
			  pass_type = "rect",
			  style_id = "rect"
			},
			{
			  pass_type = "text",
			  text_id = "text",
			  style_id = "text"
			}
		  }
		},
		content = {
		  button_hotspot = {},
		  text = "Click to Close"
		},
		style = {
		  rect = {
			color = { 255, 0, 0, 0 },
			offset = { 0, 0, 0 }
		  },
		  text = {
			text_color = { 255, 255, 255, 255 },
			font_type = "hell_shark",
			font_size = 18,
			vertical_alignment = "center",
			horizontal_alignment = "center",
			offset = { 0, 0, 1 }
		  }
		},
		scenegraph_id = "my_button",
		offset = { 0, 0, 0 }
	}
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
}