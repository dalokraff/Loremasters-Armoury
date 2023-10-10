local LAWidgetUtils = local_require("scripts/mods/Loremasters-Armoury/LA_view/la_widget_utils")

local generate_widgets_definitions = function(
    scenegraph_definition,
    window_title_text_style,
    original_skins_title_text_style,
    LA_skins_title_text_style
    )

    local widgets_definitions = {
        original_skins_title_text = UIWidgets.create_simple_text("original_skin", "original_skins_title_text", nil, nil, original_skins_title_text_style),
        original_skins_title_bg = UIWidgets.create_simple_texture("la_ui_headerlarge", "original_skins_title_bg"),
        original_skins_list_mask = LAWidgetUtils.create_list_mask("original_skins_list_window", scenegraph_definition.original_skins_list_window.size, 10),

        LA_skins_title_bg = UIWidgets.create_simple_texture("la_ui_headerlarge", "LA_skins_title_bg"),
        LA_skins_title_text = UIWidgets.create_simple_text("LA_skin", "LA_skins_title_text", nil, nil, LA_skins_title_text_style),

        LA_skins_list_mask = LAWidgetUtils.create_list_mask("LA_skins_list_window", scenegraph_definition.LA_skins_list_window.size, 10),

        window = UIWidgets.create_frame("window_frame", scenegraph_definition.window_frame.size, "la_ui_framecorners", nil, nil, {0,0}, nil, false, true, true),

        window_bg_fill = UIWidgets.create_background("window_bg_fill", scenegraph_definition.window_bg_fill.size, "la_ui_background_01darker"),
        window_bg_vignette = UIWidgets.create_background("window_bg_vignette", scenegraph_definition.window_bg_vignette.size, "la_ui_background_vignette"),
        window_title = UIWidgets.create_simple_texture("la_ui_frameheader", "window_title"),
        window_title_bg = UIWidgets.create_background("window_title_bg", scenegraph_definition.window_title_bg.size, "menu_frame_bg_02"),
        window_title_text = UIWidgets.create_simple_text("mod_name", "window_title_text", nil, nil, window_title_text_style),

        -- tutorial_overlay_toggle = LAWidgetUtils.create_button_with_hover_highlight("tutorial_overlay_toggle", scenegraph_definition.tutorial_overlay_toggle.size, nil, "la_questionmark_icon", "la_questionmark_icon", "la_questionmark_icon"),
        tutorial_overlay_toggle = LAWidgetUtils.create_button_with_hover_highlight(
                                    "tutorial_overlay_toggle",
                                    scenegraph_definition.tutorial_overlay_toggle.size,
                                    nil,
                                    "la_questionmark_icon",
                                    "la_questionmark_icon",
                                    "la_ui_arrowright_large_active"
                                ),

        LA_preview_background = UIWidgets.create_simple_texture("la_ui_itempreviewframe_armour", "LA_preview_background"),

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
        my_button = LAWidgetUtils.create_simple_window_button("my_button", scenegraph_definition.my_button.size, Localize("interaction_action_close"), 28, "la_ui_closebutton", "la_ui_closebutton_active")
    }

    widgets_definitions.gear_icon_frame.content.texture_hover = "la_ui_icon_active"
    widgets_definitions.melee_item_select.content.texture_hover = "la_ui_icon_active"
    widgets_definitions.ranged_item_select.content.texture_hover = "la_ui_icon_active"
    widgets_definitions.skin_item_select.content.texture_hover = "la_ui_icon_active"
    widgets_definitions.hat_item_select.content.texture_hover = "la_ui_icon_active"

    return widgets_definitions
end

return generate_widgets_definitions