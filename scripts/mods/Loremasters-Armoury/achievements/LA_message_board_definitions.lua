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
	list_window = {
		vertical_alignment = "top",
		parent = "screen",
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
		parent = "screen",
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
	close_button = {
		vertical_alignment = "bottom",
		parent = "screen",
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
	info_window = {
		vertical_alignment = "top",
		parent = "screen",
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

return {
	scenegraph_definition = scenegraph_definition,
}