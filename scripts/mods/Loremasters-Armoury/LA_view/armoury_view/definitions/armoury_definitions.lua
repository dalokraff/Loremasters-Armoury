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
			1
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
			30
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
			0
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
    my_button = {
      parent = "root",
      vertical_alignment = "center",
      horizontal_alignment = "center",
      size = { 50, 35 },
      position = { 0, 0, 0 }
    }
  }
  
local widgets_definitions = {    
    window = UIWidgets.create_frame("window_frame", scenegraph_definition.window_frame.size, "menu_frame_11"),
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
	},
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
				params.render_settings.alpha_multiplier = 1
			end,
			on_complete = function (ui_scenegraph, scenegraph_definition, widgets, params)
				return
			end
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
		}
	}
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
}