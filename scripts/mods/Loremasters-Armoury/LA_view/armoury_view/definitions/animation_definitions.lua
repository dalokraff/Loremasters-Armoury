
local generate_animation_definition = function()
    return {
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
end

return generate_animation_definition