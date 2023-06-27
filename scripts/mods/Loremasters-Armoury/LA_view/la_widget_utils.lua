local LAWidgetUtils = {}

LAWidgetUtils.create_entry_widget = function(scenegraph_definition, entry_font_size)
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

LAWidgetUtils.create_dummy_entry_widget = function(scenegraph_definition)
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

LAWidgetUtils.create_list_mask = function(scenegraph_id, size, fade_height)
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

--taken and modified from Vermintide-2-Source-Code\scripts\ui\ui_widgets_honduras.lua line #15646 "UIWidgets.create_icon_and_name_button()"
--as is this function is broken. Seems that some typos were made with "texture_hover_id" vs "texture_hover" and "texture_icon_id" vs "texture_icon"
--also they were missing some hover colors for a couple styles
LAWidgetUtils.create_icon_and_remove_name_button = function(scenegraph_id, icon, text)

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

LAWidgetUtils.create_simple_window_button = function (scenegraph_id, size, text, font_size, background_texture)
	background_texture = background_texture or "button_bg_01"
	local background_texture_settings = UIAtlasHelper.get_atlas_settings_by_texture_name(background_texture)

	return {
		element = {
			passes = {
				{
					style_id = "background",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				},
				-- {
				-- 	texture_id = "background_fade",
				-- 	style_id = "background_fade",
				-- 	pass_type = "texture"
				-- },
				-- {
				-- 	texture_id = "hover_glow",
				-- 	style_id = "hover_glow",
				-- 	pass_type = "texture"
				-- },
				-- {
				-- 	pass_type = "rect",
				-- 	style_id = "clicked_rect"
				-- },
				-- {
				-- 	style_id = "disabled_rect",
				-- 	pass_type = "rect",
				-- 	content_check_function = function (content)
				-- 		local button_hotspot = content.button_hotspot

				-- 		return button_hotspot.disable_button
				-- 	end
				-- },
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (content)
						local button_hotspot = content.button_hotspot

						return not button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (content)
						local button_hotspot = content.button_hotspot

						return button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				},
				-- {
				-- 	texture_id = "glass",
				-- 	style_id = "glass_top",
				-- 	pass_type = "texture"
				-- },
				-- {
				-- 	texture_id = "glass",
				-- 	style_id = "glass_bottom",
				-- 	pass_type = "texture"
				-- }
			}
		},
		content = {
			-- glass = "button_glass_02",
			-- hover_glow = "button_state_default",
			-- background_fade = "button_bg_fade",
			button_hotspot = {},
			title_text = text or "n/a",
			background = {
				uvs = {
					{
						0,
						1 - size[2] / background_texture_settings.size[2]
					},
					{
						size[1] / background_texture_settings.size[1],
						1
					}
				},
				texture_id = background_texture
			}
		},
		style = {
			background = {
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
			-- background_fade = {
			-- 	color = {
			-- 		200,
			-- 		255,
			-- 		255,
			-- 		255
			-- 	},
			-- 	offset = {
			-- 		0,
			-- 		0,
			-- 		2
			-- 	},
			-- 	size = {
			-- 		size[1],
			-- 		size[2]
			-- 	}
			-- },
			-- hover_glow = {
			-- 	color = {
			-- 		0,
			-- 		255,
			-- 		255,
			-- 		255
			-- 	},
			-- 	offset = {
			-- 		0,
			-- 		0,
			-- 		3
			-- 	},
			-- 	size = {
			-- 		size[1],
			-- 		math.min(size[2] - 5, 80)
			-- 	}
			-- },
			-- clicked_rect = {
			-- 	color = {
			-- 		0,
			-- 		0,
			-- 		0,
			-- 		0
			-- 	},
			-- 	offset = {
			-- 		0,
			-- 		0,
			-- 		7
			-- 	}
			-- },
			-- disabled_rect = {
			-- 	color = {
			-- 		150,
			-- 		20,
			-- 		20,
			-- 		20
			-- 	},
			-- 	offset = {
			-- 		0,
			-- 		0,
			-- 		1
			-- 	}
			-- },
			title_text = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = font_size or 24,
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				select_text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					3,
					6
				}
			},
			title_text_disabled = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = font_size or 24,
				text_color = Colors.get_color_table_with_alpha("gray", 255),
				default_text_color = Colors.get_color_table_with_alpha("gray", 255),
				offset = {
					0,
					3,
					6
				}
			},
			title_text_shadow = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = font_size or 24,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					2,
					1,
					5
				}
			},
			-- glass_top = {
			-- 	color = {
			-- 		255,
			-- 		255,
			-- 		255,
			-- 		255
			-- 	},
			-- 	offset = {
			-- 		0,
			-- 		size[2] - 11,
			-- 		4
			-- 	},
			-- 	size = {
			-- 		size[1],
			-- 		11
			-- 	}
			-- },
			-- glass_bottom = {
			-- 	color = {
			-- 		100,
			-- 		255,
			-- 		255,
			-- 		255
			-- 	},
			-- 	offset = {
			-- 		0,
			-- 		-3,
			-- 		4
			-- 	},
			-- 	size = {
			-- 		size[1],
			-- 		11
			-- 	}
			-- }
		},
		scenegraph_id = scenegraph_id,
		offset = {
			0,
			0,
			0
		}
	}
end

LAWidgetUtils.create_trait_option = function(scenegraph_id, title_text, description_text, icon)
	local masked = false

	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "texture_id",
					texture_id = "texture_id"
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "description_text",
					pass_type = "text",
					text_id = "description_text"
				},
				{
					style_id = "description_text_shadow",
					pass_type = "text",
					text_id = "description_text"
				}
			}
		},
		content = {
			title_text = title_text,
			description_text = description_text,
			texture_id = icon
		},
		style = {
			texture_id = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				masked = masked,
				texture_size = {
					40,
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-- 0,
					-- 0,
					-- 1
					-150,
					-75,
					0,
				}
			},
			title_text = {
				-- word_wrap = true,
				upper_case = true,
				localize = false,
				font_size = 20,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				dynamic_font_size = true,
				size = {
					400,
					50
				},
				font_type = (masked and "hell_shark_masked") or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					30,
					-5,
					3
				}
			},
			title_text_shadow = {
				-- word_wrap = true,
				upper_case = true,
				localize = false,
				font_size = 20,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				dynamic_font_size = true,
				size = {
					400,
					50
				},
				font_type = (masked and "hell_shark_masked") or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					31,
					-6,
					2
				}
			},
			description_text = {
				word_wrap = true,
				upper_case = false,
				localize = false,
				font_size = 20,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				dynamic_font_size = false,
				size = {
					400,
					50
				},
				font_type = (masked and "hell_shark_masked") or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					30,
					-47,
					3
				}
			},
			description_text_shadow = {
				word_wrap = true,
				upper_case = false,
				localize = false,
				font_size = 20,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				dynamic_font_size = false,
				size = {
					400,
					50
				},
				font_type = (masked and "hell_shark_masked") or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					31,
					-48,
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

LAWidgetUtils.create_reward_option = function(scenegraph_id, title_text, description_text, icon)
	local masked = false

	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "texture_id",
					texture_id = "texture_id"
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "description_text",
					pass_type = "text",
					text_id = "description_text"
				},
				{
					style_id = "description_text_shadow",
					pass_type = "text",
					text_id = "description_text"
				}
			}
		},
		content = {
			title_text = title_text,
			description_text = description_text,
			texture_id = icon
		},
		style = {
			texture_id = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				masked = masked,
				texture_size = {
					100,
					100
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-- 0,
					-- 0,
					-- 1
					0,
					-50,
					0,
				}
			},
			title_text = {
				-- word_wrap = true,
				upper_case = true,
				localize = false,
				font_size = 20,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				dynamic_font_size = true,
				size = {
					400,
					50
				},
				font_type = (masked and "hell_shark_masked") or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					40,
					-5,
					3
				}
			},
			title_text_shadow = {
				-- word_wrap = true,
				upper_case = true,
				localize = false,
				font_size = 20,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				dynamic_font_size = true,
				size = {
					400,
					50
				},
				font_type = (masked and "hell_shark_masked") or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					41,
					-6,
					2
				}
			},
			description_text = {
				word_wrap = true,
				upper_case = false,
				localize = false,
				font_size = 20,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				dynamic_font_size = false,
				size = {
					400,
					50
				},
				font_type = (masked and "hell_shark_masked") or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					40,
					-47,
					3
				}
			},
			description_text_shadow = {
				word_wrap = true,
				upper_case = false,
				localize = false,
				font_size = 20,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				dynamic_font_size = false,
				size = {
					400,
					50
				},
				font_type = (masked and "hell_shark_masked") or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					41,
					-48,
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


LAWidgetUtils.create_sub_quest_option = function(scenegraph_id, title_text, description_text, icon)
	local masked = false

	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "texture_id",
					texture_id = "texture_id"
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "description_text",
					pass_type = "text",
					text_id = "description_text"
				},
				{
					style_id = "description_text_shadow",
					pass_type = "text",
					text_id = "description_text"
				}
			}
		},
		content = {
			title_text = title_text,
			description_text = description_text,
			texture_id = icon
		},
		style = {
			texture_id = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				masked = masked,
				texture_size = {
					100,
					100
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-- 0,
					-- 0,
					-- 1
					0,
					-50,
					0,
				}
			},
			title_text = {
				-- word_wrap = true,
				upper_case = true,
				localize = false,
				font_size = 20,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				dynamic_font_size = true,
				size = {
					400,
					50
				},
				font_type = (masked and "hell_shark_masked") or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					40,
					-5,
					3
				}
			},
			title_text_shadow = {
				-- word_wrap = true,
				upper_case = true,
				localize = false,
				font_size = 20,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				dynamic_font_size = true,
				size = {
					400,
					50
				},
				font_type = (masked and "hell_shark_masked") or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					41,
					-6,
					2
				}
			},
			description_text = {
				word_wrap = true,
				upper_case = false,
				localize = false,
				font_size = 20,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				dynamic_font_size = false,
				size = {
					400,
					50
				},
				font_type = (masked and "hell_shark_masked") or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					40,
					-47,
					3
				}
			},
			description_text_shadow = {
				word_wrap = true,
				upper_case = false,
				localize = false,
				font_size = 20,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				dynamic_font_size = false,
				size = {
					400,
					50
				},
				font_type = (masked and "hell_shark_masked") or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					41,
					-48,
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


LAWidgetUtils.create_rect_with_frame = function(scenegraph_id, size, rect_color)
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

LAWidgetUtils.create_list_mask = function(scenegraph_id, size, fade_height)
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

return LAWidgetUtils