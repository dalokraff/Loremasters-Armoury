local mod = get_mod("Loremasters-Armoury")
mod:dofile("scripts/mods/Loremasters-Armoury/string_dict")

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
		setting_id = "elf_shields",
		type = "dropdown",
		default_value = 1,
		title = "choose_char",
		tooltip = "choose_char",
		options = {
			{text = "pick_wep",   value = 1},
			{text = "bret_sword_shield",   value = 2, show_widgets = {}},
			{text = "emp_spear_shield",   value = 3, show_widgets = {}},
			{text = "emp_sword_shield",   value = 4, show_widgets = {}},
			{text = "emp_mace_shield",   value = 5, show_widgets = {}},
			{text = "elf_spear_shield",   value = 6, show_widgets = {}},
		},
		sub_widgets = {},
	}
}

local num_skins = 0

--bret sword and shield
for _,skin in ipairs(mod.bret_skins) do
	local widget = table.clone(shield_sub_choice)
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
	local widget = table.clone(shield_sub_choice)
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
	local widget = table.clone(shield_sub_choice)
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
	local widget = table.clone(shield_sub_choice)
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
	local widget = table.clone(shield_sub_choice)
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

return menu