local mod = get_mod("Loremasters-Armoury")
mod:dofile("scripts/mods/Loremasters-Armoury/string_dict")
-- mod:dofile("scripts/mods/Loremasters-Armoury/string_dict")

local menu = {
	name = "Loremasters-Armoury",
	description = "Loremasters-Armoury",
	is_togglable = false,
}

local shield_sub_choice = {
	setting_id = nil,
	type = "dropdown",
	default_value = "default",
	title = nil,
	tooltip = "choose_skin",
	options = {
		{text = "default",   value = "default"},
	},
	sub_widgets = {},
}

menu.options = {}
menu.options.widgets = {
	{
		setting_id = "weapons",
		type = "dropdown",
		default_value = 1,
		title = "choose_wep",
		tooltip = "choose_wep",
		options = {
			{text = "pick_wep",   value = 1},
			{text = "bret_sword_shield",   value = 2, show_widgets = {}},
			{text = "emp_spear_shield",   value = 3, show_widgets = {}},
			{text = "emp_sword_shield",   value = 4, show_widgets = {}},
			{text = "emp_mace_shield",   value = 5, show_widgets = {}},
			{text = "elf_spear_shield",   value = 6, show_widgets = {}},
			{text = "dwarf_axe_shield",   value = 7, show_widgets = {}},
			{text = "dwarf_ham_shield",   value = 8, show_widgets = {}},
			{text = "elf_bow",   value = 9, show_widgets = {}},
		},
		sub_widgets = {},
	},
	{
		setting_id = "hats",
		type = "dropdown",
		default_value = 1,
		title = "choose_char_hat",
		tooltip = "choose_char_hat",
		options = {
			{text = "choose_char_hat",   value = 1},
			{text = "krub",   value = 2, show_widgets = {}},
			{text = "bard",   value = 3, show_widgets = {}},
			{text = "salt",   value = 4, show_widgets = {}},
			{text = "elf",   value = 5, show_widgets = {}},
			{text = "wiz",   value = 6, show_widgets = {}},
		},
		sub_widgets = {},
	},
	{
		setting_id = "armor",
		type = "dropdown",
		default_value = 1,
		title = "choose_char_armor",
		tooltip = "choose_char_armor",
		options = {
			{text = "choose_char_armor",   value = 1},
			{text = "krub",   value = 2, show_widgets = {}},
			{text = "bard",   value = 3, show_widgets = {}},
			{text = "salt",   value = 4, show_widgets = {}},
			{text = "elf",   value = 5, show_widgets = {}},
			{text = "wiz",   value = 6, show_widgets = {}},
		},
		sub_widgets = {},
	}
}

local num_skins = 0

--bret sword and shield
for _,skin in ipairs(mod.bret_skins) do
	local widget = table.clone(shield_sub_choice, true)
	widget.setting_id = skin
	widget.title = skin
	local x = 1
	for Amoury_key,skin_name  in pairs(mod.bret_shields) do
		local choice = {text = Amoury_key,   value = Amoury_key}
		table.insert(widget.options, choice)
	end
	num_skins = num_skins + 1
	table.insert(menu.options.widgets[1].options[2].show_widgets, num_skins)
	table.insert(menu.options.widgets[1].sub_widgets, widget)
end

--emp spear and shield
for _,skin in ipairs(mod.empire_spear_shield) do
	local widget = table.clone(shield_sub_choice, true)
	widget.setting_id = skin
	widget.title = skin
	local x = 1
	for Amoury_key,skin_name  in pairs(mod.empire_shields) do
		local choice = {text = Amoury_key,   value = Amoury_key}
		table.insert(widget.options, choice)
	end
	num_skins = num_skins + 1
	table.insert(menu.options.widgets[1].options[3].show_widgets, num_skins)
	table.insert(menu.options.widgets[1].sub_widgets, widget)
end

--emp sword and shield
for _,skin in ipairs(mod.empire_sword_shield) do
	local widget = table.clone(shield_sub_choice, true)
	widget.setting_id = skin
	widget.title = skin
	local x = 1
	for Amoury_key,skin_name  in pairs(mod.empire_shields) do
		local choice = {text = Amoury_key,   value = Amoury_key}
		table.insert(widget.options, choice)
	end
	num_skins = num_skins + 1
	table.insert(menu.options.widgets[1].options[4].show_widgets, num_skins)
	table.insert(menu.options.widgets[1].sub_widgets, widget)
end

--emp mace and shield
for _,skin in ipairs(mod.empire_mace_shield) do
	local widget = table.clone(shield_sub_choice, false)
	widget.setting_id = skin
	widget.title = skin
	local x = 1
	for Amoury_key,skin_name  in pairs(mod.empire_shields) do
		local choice = {text = Amoury_key,   value = Amoury_key}
		table.insert(widget.options, choice)
	end
	num_skins = num_skins + 1
	table.insert(menu.options.widgets[1].options[5].show_widgets, num_skins)
	table.insert(menu.options.widgets[1].sub_widgets, widget)
end

--elf spear and shield
for _,skin in ipairs(mod.elf_skins) do
	local widget = table.clone(shield_sub_choice, true)
	widget.setting_id = skin
	widget.title = skin
	local x = 1
	for Amoury_key,skin_name  in pairs(mod.elf_shields) do
		local choice = {text = Amoury_key,   value = Amoury_key}
		table.insert(widget.options, choice)
	end
	num_skins = num_skins + 1
	table.insert(menu.options.widgets[1].options[6].show_widgets, num_skins)
	table.insert(menu.options.widgets[1].sub_widgets, widget)
end

--dwarf axe and shield
for _,skin in ipairs(mod.dwarf_axe_shield) do
	local widget = table.clone(shield_sub_choice, true)
	widget.setting_id = skin
	widget.title = skin
	local x = 1
	for Amoury_key,skin_name  in pairs(mod.dwarf_shields) do
		local choice = {text = Amoury_key,   value = Amoury_key}
		table.insert(widget.options, choice)
	end
	num_skins = num_skins + 1
	table.insert(menu.options.widgets[1].options[7].show_widgets, num_skins)
	table.insert(menu.options.widgets[1].sub_widgets, widget)
end

--dwarf hammer and shield
for _,skin in ipairs(mod.dwarf_ham_shield) do
	local widget = table.clone(shield_sub_choice, true)
	widget.setting_id = skin
	widget.title = skin
	local x = 1
	for Amoury_key,skin_name  in pairs(mod.dwarf_shields) do
		local choice = {text = Amoury_key,   value = Amoury_key}
		table.insert(widget.options, choice)
	end
	num_skins = num_skins + 1
	table.insert(menu.options.widgets[1].options[8].show_widgets, num_skins)
	table.insert(menu.options.widgets[1].sub_widgets, widget)
end

--elf long bow
for _,skin in ipairs(mod.elf_bow_skins) do
	local widget = table.clone(shield_sub_choice, true)
	widget.setting_id = skin
	widget.title = skin
	local x = 1
	for Amoury_key,skin_name in pairs(mod.elf_bows[skin]) do
		local choice = {text = Amoury_key,   value = Amoury_key}
		table.insert(widget.options, choice)
	end
	num_skins = num_skins + 1
	table.insert(menu.options.widgets[1].options[9].show_widgets, num_skins)
	table.insert(menu.options.widgets[1].sub_widgets, widget)
end


--reset skins for elf hats
num_skins = 0
--elf hats
for _,skin in ipairs(mod.elf_hat_skins) do
	local widget = table.clone(shield_sub_choice, true)
	widget.setting_id = skin
	widget.title = skin
	print("here:	"..tostring(menu.options.widgets[2].options[5].text))
	local x = 1
	for Amoury_key,skin_name  in pairs(mod.elf_hats[skin]) do
		local choice = {text = Amoury_key,   value = Amoury_key}
		table.insert(widget.options, choice)
	end
	num_skins = num_skins + 1
	table.insert(menu.options.widgets[2].options[5].show_widgets, num_skins)
	table.insert(menu.options.widgets[2].sub_widgets, widget)
end

--reset skins for krub hats
-- num_skins = 0
--krub hats
for _,skin in ipairs(mod.krub_hat_skins) do
	local widget = table.clone(shield_sub_choice, true)
	widget.setting_id = skin
	widget.title = skin
	print("here:	"..tostring(menu.options.widgets[2].options[2].text))
	local x = 1
	for Amoury_key,skin_name in pairs(mod.krub_hats[skin]) do
		local choice = {text = Amoury_key,   value = Amoury_key}
		table.insert(widget.options, choice)
	end
	-- for Amoury_key,skin_name  in pairs(mod.krub_hats) do
	-- 	local choice = {text = Amoury_key,   value = Amoury_key}
	-- 	table.insert(widget.options, choice)
	-- end
	num_skins = num_skins + 1
	table.insert(menu.options.widgets[2].options[2].show_widgets, num_skins)
	table.insert(menu.options.widgets[2].sub_widgets, widget)
end

--reset skins for krub armor
num_skins = 0
--krub armor
for _,skin in ipairs(mod.krub_armor_skins) do
	local widget = table.clone(shield_sub_choice, true)
	widget.setting_id = skin
	widget.title = skin
	local x = 1
	for Amoury_key,skin_name  in pairs(mod.krub_armors) do
		local choice = {text = Amoury_key,   value = Amoury_key}
		table.insert(widget.options, choice)
	end
	num_skins = num_skins + 1
	table.insert(menu.options.widgets[3].options[2].show_widgets, num_skins)
	table.insert(menu.options.widgets[3].sub_widgets, widget)
end

--reset skins for ker armor
-- num_skins = 0
--ker armor
for _,skin in ipairs(mod.elf_armor_skins) do
	local widget = table.clone(shield_sub_choice, true)
	widget.setting_id = skin
	widget.title = skin
	local x = 1
	for Amoury_key,skin_name  in pairs(mod.ker_armors) do
		local choice = {text = Amoury_key,   value = Amoury_key}
		table.insert(widget.options, choice)
	end
	num_skins = num_skins + 1
	table.insert(menu.options.widgets[3].options[5].show_widgets, num_skins)
	table.insert(menu.options.widgets[3].sub_widgets, widget)
end

menu.custom_gui_texture = {}
menu.custom_gui_textures = {
	atlases = {
		{
			"materials/Loremasters-Armoury/amoury_atlas",
			"amoury_atlas",
			"amoury_atlas_masked",
		},
	},

	textures = {
		"textures/hud/amoury_atlas/amoury_atlas"
	},

	-- Injections
	ui_renderer_injections = {
		{
			"ingame_ui",
			"materials/Loremasters-Armoury/amoury_atlas",
		},
	},
}

return menu