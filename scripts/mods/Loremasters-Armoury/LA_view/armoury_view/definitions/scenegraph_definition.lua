local generate_scenegraph_definition = function(
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

    return {
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
                LA_preview_background_size[2]*1.05
            },
            position = {
                0,
                30,
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
                -20,
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
        original_skins_sub_title_bg = {
            vertical_alignment = "top",
            parent = "original_skins_list_scroll_root",
            horizontal_alignment = "left",
            size = la_ui_headersmall_size,
            position = {
                0,
                15,
                30
            }
        },
        original_skins_sub_title = {
            vertical_alignment = "center",
            parent = "original_skins_sub_title_bg",
            horizontal_alignment = "center",
            size = la_ui_headersmall_size,
            position = {
                0,
                1,
                32
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
        original_skins_list_skin_title_bg = {
            vertical_alignment = "top",
            parent = "original_skins_list_scroll_root",
            horizontal_alignment = "left",
            size = la_ui_headersmall_size,
            position = {
                0,
                5,
                30
            }
        },
        original_skins_list_skin_sub_title = {
            vertical_alignment = "center",
            parent = "original_skins_list_skin_title_bg",
            horizontal_alignment = "center",
            size = la_ui_headersmall_size,
            position = {
                0,
                1,
                32
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
        -- original_skins_equiped_skin_hand_bg = {
        -- 	vertical_alignment = "bottom",
        -- 	parent = "original_skins_list_scroll_root",
        -- 	horizontal_alignment = "left",
        -- 	size = la_ui_headersmall_size,
        -- 	position = {
        -- 		0,
        -- 		-550,
        -- 		30
        -- 	}
        -- },
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
                -5,
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
        LA_skins_main_hand_header_root = {
            vertical_alignment = "top",
            parent = "LA_skins_list_scroll_root",
            horizontal_alignment = "center",
            size = {
                300,
                300
            },
            position = {
                0,
                0,
                30
            }
        },
        LA_skins_main_hand_bg = {
            vertical_alignment = "top",
            parent = "LA_skins_main_hand_header_root",
            horizontal_alignment = "center",
            size = la_ui_headersmall_size,
            position = {
                -142.5,
                2.5,
                -1
            }
        },
        LA_skins_main_hand_text = {
            vertical_alignment = "center",
            parent = "LA_skins_main_hand_header_root",
            horizontal_alignment = "center",
            size = {
                list_window_size[1] - 40,
                300
            },
            position = {
                82.5,
                1,
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
        LA_skins_off_hand_header_root = {
            vertical_alignment = "top",
            parent = "LA_skins_list_scroll_root",
            horizontal_alignment = "center",
            size = {
                300,
                300
            },
            position = {
                0,
                -299,
                30
            }
        },
        LA_skins_off_hand_bg = {
            vertical_alignment = "top",
            parent = "LA_skins_off_hand_header_root",
            horizontal_alignment = "center",
            size = la_ui_headersmall_size,
            position = {
                -142.5,
                2.5,
                30
            }
        },
        LA_skins_off_hand_text = {
            vertical_alignment = "center",
            parent = "LA_skins_off_hand_header_root",
            horizontal_alignment = "center",
            size = {
                list_window_size[1] - 40,
                300
            },
            position = {
                82.5,
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

        LA_skins_outfits_header_root = {
            vertical_alignment = "top",
            parent = "LA_skins_list_scroll_root",
            horizontal_alignment = "center",
            size = {
                300,
                300
            },
            position = {
                0,
                0,
                30
            }
        },
        LA_skins_outfits_bg = {
            vertical_alignment = "top",
            parent = "LA_skins_outfits_header_root",
            horizontal_alignment = "center",
            size = la_ui_headersmall_size,
            position = {
                -225,
                2.5,
                30
            }
        },
        LA_skins_outfits_text = {
            vertical_alignment = "center",
            parent = "LA_skins_outfits_header_root",
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

        LA_skins_list_divider = {
            parent = "LA_skins_list_scroll_root",
            vertical_alignment = "center",
            horizontal_alignment = "left",
            size = la_ui_separator,
            position = {
                -450,
                -265,
                32
            },
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

        -- menu tutorial scengraph definitions
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
        tutorial_1 = {
            parent = "hero_selection",
            vertical_alignment = "center",
            horizontal_alignment = "center",
            size = {
                807,
                116
            },
            position = {
                -397,
                70,
                100
            },
        },
        tutorial_2 = {
            parent = "gear_icon_frame",
            vertical_alignment = "center",
            horizontal_alignment = "center",
            size = {
                664,
                252
            },
            position = {
                135*gear_icon_seperation_factor + 350,
                120,
                100
            },
        },
        tutorial_3 = {
            parent = "original_skins_frame",
            vertical_alignment = "center",
            horizontal_alignment = "center",
            size = {
                625,
                247
            },
            position = {
                0,
                250,
                100
            },
        },
        tutorial_4 = {
            parent = "original_skins_list_window",
            vertical_alignment = "center",
            horizontal_alignment = "center",
            size = {
                558,
                205
            },
            position = {
                -15,
                -175,
                100
            },
        },
        tutorial_5 = {
            parent = "LA_skins_frame",
            vertical_alignment = "center",
            horizontal_alignment = "center",
            size = {
                505,
                322
            },
            position = {
                -75,
                0,
                100
            },
        },
        tutorial_0 = {
            parent = "window",
            vertical_alignment = "bottom",
            horizontal_alignment = "right",
            size = {
                281,
                127
            },
            position = {
                0,
                0,
                100
            },
        },
    }
end

return generate_scenegraph_definition
