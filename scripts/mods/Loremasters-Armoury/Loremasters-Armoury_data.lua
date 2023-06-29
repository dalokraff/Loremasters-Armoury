local mod = get_mod("Loremasters-Armoury")
mod:dofile("scripts/mods/Loremasters-Armoury/string_dict")
-- mod:dofile("scripts/mods/Loremasters-Armoury/string_dict")

local menu = {
	name = "Loremasters-Armoury",
	description = "Loremasters-Armoury",
	is_togglable = false,
}

menu.options = {}
menu.options.widgets = {
	{
        setting_id = "armoury_view",
        type = "keybind",
        keybind_type = "view_toggle",
		keybind_trigger = "pressed",
		default_value = {

		},
        view_name = "armoury_view",
        transition_data = {
          open_view_transition_name = "open_armoury_view",
          close_view_transition_name = "close_armoury_view",
          transition_fade = true
        }
	}
}

menu.custom_gui_texture = {}
menu.custom_gui_textures = {
	atlases = {
		{
			"materials/Loremasters-Armoury/armoury_atlas",
			"armoury_atlas",
			"armoury_atlas_masked",
			nil,
			nil,
			"armoury_atlas",
		},
		{
			"materials/Loremasters-Armoury/armoury_backgrounds_atlas",
			"armoury_backgrounds_atlas",
			"armoury_backgrounds_atlas_masked",
			nil,
			nil,
			"armoury_backgrounds_atlas",
		},
		{
			"materials/Loremasters-Armoury/armoury_equipment_icons_atlas",
			"armoury_equipment_icons_atlas",
			"armoury_equipment_icons_atlas_masked",
			nil,
			nil,
			"armoury_equipment_icons_atlas",
		},
		{
			"materials/Loremasters-Armoury/armoury_ui_elements_atlas",
			"armoury_ui_elements_atlas",
			"armoury_ui_elements_atlas_masked",
			nil,
			nil,
			"armoury_ui_elements_atlas",
		},
	},

	-- Injections
	ui_renderer_injections = {
		{
			"ingame_ui",
			"materials/Loremasters-Armoury/armoury_atlas",
			"materials/Loremasters-Armoury/armoury_backgrounds_atlas",
			"materials/Loremasters-Armoury/armoury_equipment_icons_atlas",
			"materials/Loremasters-Armoury/armoury_ui_elements_atlas",
		},
		{
			"hero_view",
			"materials/Loremasters-Armoury/armoury_atlas",
			"materials/Loremasters-Armoury/armoury_backgrounds_atlas",
			"materials/Loremasters-Armoury/armoury_equipment_icons_atlas",
			"materials/Loremasters-Armoury/armoury_ui_elements_atlas",
		},
		{
			"loading_view",
			"materials/Loremasters-Armoury/armoury_atlas",
			"materials/Loremasters-Armoury/armoury_backgrounds_atlas",
			"materials/Loremasters-Armoury/armoury_equipment_icons_atlas",
			"materials/Loremasters-Armoury/armoury_ui_elements_atlas",
		},
		{
			"rcon_manager",
			"materials/Loremasters-Armoury/armoury_atlas",
			"materials/Loremasters-Armoury/armoury_backgrounds_atlas",
			"materials/Loremasters-Armoury/armoury_equipment_icons_atlas",
			"materials/Loremasters-Armoury/armoury_ui_elements_atlas",
		},
		{
			"chat_manager",
			"materials/Loremasters-Armoury/armoury_atlas",
			"materials/Loremasters-Armoury/armoury_backgrounds_atlas",
			"materials/Loremasters-Armoury/armoury_equipment_icons_atlas",
			"materials/Loremasters-Armoury/armoury_ui_elements_atlas",
		},
		{
			"popup_manager",
			"materials/Loremasters-Armoury/armoury_atlas",
			"materials/Loremasters-Armoury/armoury_backgrounds_atlas",
			"materials/Loremasters-Armoury/armoury_equipment_icons_atlas",
			"materials/Loremasters-Armoury/armoury_ui_elements_atlas",
		},
		{
			"splash_view",
			"materials/Loremasters-Armoury/armoury_atlas",
			"materials/Loremasters-Armoury/armoury_backgrounds_atlas",
			"materials/Loremasters-Armoury/armoury_equipment_icons_atlas",
			"materials/Loremasters-Armoury/armoury_ui_elements_atlas",
		},
		{
			"twitch_icon_view",
			"materials/Loremasters-Armoury/armoury_atlas",
			"materials/Loremasters-Armoury/armoury_backgrounds_atlas",
			"materials/Loremasters-Armoury/armoury_equipment_icons_atlas",
			"materials/Loremasters-Armoury/armoury_ui_elements_atlas",
		},
		{
			"disconnect_indicator_view",
			"materials/Loremasters-Armoury/armoury_atlas",
			"materials/Loremasters-Armoury/armoury_backgrounds_atlas",
			"materials/Loremasters-Armoury/armoury_equipment_icons_atlas",
			"materials/Loremasters-Armoury/armoury_ui_elements_atlas",
		},
	},
}

return menu