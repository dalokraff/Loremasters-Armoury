local mod = get_mod("Loremasters-Armoury")

local menu = {
	name = "Loremasters-Armoury",
	description = "Loremasters-Armoury",
	is_togglable = false,
}
 
menu.options_widgets = {	
	{
		["setting_name"] = "elf_shields",
		["widget_type"] = "dropdown",
		["default_value"] = 1,
		["text"] = "Choose Character",
		["tooltip"] = "Choose Character",
		["options"] = {
			{text = "Pick Weapon",   value = 1},
			{text = "Breton Long Sword and Shield",   value = 2},
			{text = "Empire Spear and Shield",   value = 3},
			{text = "Empire Sword and Shield",   value = 4},
			{text = "Empire Mace and Shield",   value = 5},
			{text = "High Elf Spear and Shield",   value = 6},
		},
		["sub_widgets"] = {
			{
				["show_widget_condition"] = {2},
				["setting_name"] = "es_sword_shield_breton_skin_01",
				["widget_type"] = "dropdown",
				["default_value"] = "default",
				["text"] = "Stalwart's Sword and Shield",
				["tooltip"] = "Choose active skin for Shield of Honor Renewed",
				["options"] = {
					{text = "The Scale of Smearghus",   value = "Kruber_Grail_Knight_Bastonne02"},
					{text = "Protecteur d'Arden",   value = "Kruber_bret_shield_basic1_Reynard01"},
					{text = "Le Faucon Rouge",   value = "Kruber_bret_shield_basic2_Luidhard01"},
					{text = "Knight Shield of the Golden Hart",   value = "Kruber_bret_shield_basic3_Lothar01"},
					{text = "Bastion de la Tempete",   value = "Kruber_bret_shield_hero1_Alberic01"},
					{text = "default skin",   value = "default"},
				},
				["sub_widgets"] = {},
			},
			{
				["show_widget_condition"] = {2},
				["setting_name"] = "es_sword_shield_breton_skin_02",
				["widget_type"] = "dropdown",
				["default_value"] = "default",
				["text"] = "Hero's Sword and Shield",
				["tooltip"] = "Choose active skin for Shield of Honor Renewed",
				["options"] = {
					{text = "The Scale of Smearghus",   value = "Kruber_Grail_Knight_Bastonne02"},
					{text = "Protecteur d'Arden",   value = "Kruber_bret_shield_basic1_Reynard01"},
					{text = "Le Faucon Rouge",   value = "Kruber_bret_shield_basic2_Luidhard01"},
					{text = "Knight Shield of the Golden Hart",   value = "Kruber_bret_shield_basic3_Lothar01"},
					{text = "Bastion de la Tempete",   value = "Kruber_bret_shield_hero1_Alberic01"},
					{text = "default skin",   value = "default"},
				},
				["sub_widgets"] = {},
			},
			{
				["show_widget_condition"] = {2},
				["setting_name"] = "es_sword_shield_breton_skin_03",
				["widget_type"] = "dropdown",
				["default_value"] = "default",
				["text"] = "Shield of Honor Renewed",
				["tooltip"] = "Choose active skin for Shield of Honor Renewed",
				["options"] = {
					{text = "The Scale of Smearghus",   value = "Kruber_Grail_Knight_Bastonne02"},
					{text = "Protecteur d'Arden",   value = "Kruber_bret_shield_basic1_Reynard01"},
					{text = "Le Faucon Rouge",   value = "Kruber_bret_shield_basic2_Luidhard01"},
					{text = "Knight Shield of the Golden Hart",   value = "Kruber_bret_shield_basic3_Lothar01"},
					{text = "Bastion de la Tempete",   value = "Kruber_bret_shield_hero1_Alberic01"},
					{text = "default skin",   value = "default"},
				},
				["sub_widgets"] = {},
			},
			{
				["show_widget_condition"] = {2},
				["setting_name"] = "es_sword_shield_breton_skin_03_runed_01",
				["widget_type"] = "dropdown",
				["default_value"] = "default",
				["text"] = "Pegasus Bulwark",
				["tooltip"] = "Choose active skin for Pegasus Bulwark",
				["options"] = {
					{text = "The Scale of Smearghus",   value = "Kruber_Grail_Knight_Bastonne02"},
					{text = "Protecteur d'Arden",   value = "Kruber_bret_shield_basic1_Reynard01"},
					{text = "Le Faucon Rouge",   value = "Kruber_bret_shield_basic2_Luidhard01"},
					{text = "Knight Shield of the Golden Hart",   value = "Kruber_bret_shield_basic3_Lothar01"},
					{text = "Bastion de la Tempete",   value = "Kruber_bret_shield_hero1_Alberic01"},
					{text = "default skin",   value = "default"},
				},
				["sub_widgets"] = {},
			},
			{
				["show_widget_condition"] = {2},
				["setting_name"] = "es_sword_shield_breton_skin_03_runed_02",
				["widget_type"] = "dropdown",
				["default_value"] = "default",
				["text"] = "Sable Shield of Parandot",
				["tooltip"] = "Choose active skin for Sable Shield of Parandot",
				["options"] = {
					{text = "The Scale of Smearghus",   value = "Kruber_Grail_Knight_Bastonne02"},
					{text = "Protecteur d'Arden",   value = "Kruber_bret_shield_basic1_Reynard01"},
					{text = "Le Faucon Rouge",   value = "Kruber_bret_shield_basic2_Luidhard01"},
					{text = "Knight Shield of the Golden Hart",   value = "Kruber_bret_shield_basic3_Lothar01"},
					{text = "Bastion de la Tempete",   value = "Kruber_bret_shield_hero1_Alberic01"},
					{text = "default skin",   value = "default"},
				},
				["sub_widgets"] = {},
			},
			{
				["show_widget_condition"] = {2},
				["setting_name"] = "es_sword_shield_breton_skin_04",
				["widget_type"] = "dropdown",
				["default_value"] = "default",
				["text"] = "The Sword and Shield of Altruin",
				["tooltip"] = "Choose active skin for Shield of Honor Renewed",
				["options"] = {
					{text = "The Scale of Smearghus",   value = "Kruber_Grail_Knight_Bastonne02"},
					{text = "Protecteur d'Arden",   value = "Kruber_bret_shield_basic1_Reynard01"},
					{text = "Le Faucon Rouge",   value = "Kruber_bret_shield_basic2_Luidhard01"},
					{text = "Knight Shield of the Golden Hart",   value = "Kruber_bret_shield_basic3_Lothar01"},
					{text = "Bastion de la Tempete",   value = "Kruber_bret_shield_hero1_Alberic01"},
					{text = "default skin",   value = "default"},
				},
				["sub_widgets"] = {},
			},
			{
				["show_widget_condition"] = {999},
				["setting_name"] = "es_sword_shield_breton_skin_04_magic_01_magic_01",
				["widget_type"] = "dropdown",
				["default_value"] = "default",
				["text"] = "es_sword_shield_breton_skin_04_magic_01_magic_01",
				["tooltip"] = "Choose active skin for Shield of Honor Renewed",
				["options"] = {
					{text = "The Scale of Smearghus",   value = "Kruber_Grail_Knight_Bastonne02"},
					{text = "Protecteur d'Arden",   value = "Kruber_bret_shield_basic1_Reynard01"},
					{text = "Le Faucon Rouge",   value = "Kruber_bret_shield_basic2_Luidhard01"},
					{text = "Knight Shield of the Golden Hart",   value = "Kruber_bret_shield_basic3_Lothar01"},
					{text = "Bastion de la Tempete",   value = "Kruber_bret_shield_hero1_Alberic01"},
					{text = "default skin",   value = "default"},
				},
				["sub_widgets"] = {},
			},
			{
				["show_widget_condition"] = {2},
				["setting_name"] = "es_sword_shield_breton_skin_05",
				["widget_type"] = "dropdown",
				["default_value"] = "default",
				["text"] = "Blacksmith's Training Sword and Shield",
				["tooltip"] = "Choose active skin for Shield of Honor Renewed",
				["options"] = {
					{text = "The Scale of Smearghus",   value = "Kruber_Grail_Knight_Bastonne02"},
					{text = "Protecteur d'Arden",   value = "Kruber_bret_shield_basic1_Reynard01"},
					{text = "Le Faucon Rouge",   value = "Kruber_bret_shield_basic2_Luidhard01"},
					{text = "Knight Shield of the Golden Hart",   value = "Kruber_bret_shield_basic3_Lothar01"},
					{text = "Bastion de la Tempete",   value = "Kruber_bret_shield_hero1_Alberic01"},
					{text = "default skin",   value = "default"},
				},
				["sub_widgets"] = {},
			},
			{
				["show_widget_condition"] = {3},
				["setting_name"] = "es_deus_01_skin_01",
				["widget_type"] = "dropdown",
				["default_value"] = "default",
				["text"] = "Recruit's Spear and Shield",
				["tooltip"] = "Choose active skin for Recruit's Spear and Shield",
				["options"] = {
					{text = "Reikland Captain's Shield",   value = "Kruber_empire_shield_basic1"},
					{text = "Wolfenburg Guard Shield",   value = "Kruber_empire_shield_basic2"},
					{text = "Sol Invictus",   value = "Kruber_empire_shield_basic2_Kotbs01"},
					{text = "Kruber_empire_shield_hero1_Kotbs01",   value = "Kruber_empire_shield_hero1_Kotbs01"},
					{text = "Shield of Ostermark Spearman",   value = "Kruber_empire_shield_hero1_Ostermark01"},
					{text = "Shield of Ostermark Spearman (Sergeant's mesh)",   value = "Kruber_empire_shield_basic1_Ostermark01"},
					{text = "The White Wolf",   value = "Kruber_empire_shield_basic2_Middenheim"},
					{text = "The White Wolf (spear)",   value = "Kruber_empire_shield_basic3_Middenheim01"},
					{text = "default skin",   value = "default"},
				},
				["sub_widgets"] = {},
			},
			{
				["show_widget_condition"] = {3},
				["setting_name"] = "es_deus_01_skin_02",
				["widget_type"] = "dropdown",
				["default_value"] = "default",
				["text"] = "Riverman's Spear and Shield",
				["tooltip"] = "Choose active skin for Riverman's Spear and Shield",
				["options"] = {
					{text = "Reikland Captain's Shield",   value = "Kruber_empire_shield_basic1"},
					{text = "Wolfenburg Guard Shield",   value = "Kruber_empire_shield_basic2"},
					{text = "Sol Invictus",   value = "Kruber_empire_shield_basic2_Kotbs01"},
					{text = "Kruber_empire_shield_hero1_Kotbs01",   value = "Kruber_empire_shield_hero1_Kotbs01"},
					{text = "Shield of Ostermark Spearman",   value = "Kruber_empire_shield_hero1_Ostermark01"},
					{text = "Shield of Ostermark Spearman (Sergeant's mesh)",   value = "Kruber_empire_shield_basic1_Ostermark01"},
					{text = "The White Wolf",   value = "Kruber_empire_shield_basic2_Middenheim"},
					{text = "The White Wolf (spear)",   value = "Kruber_empire_shield_basic3_Middenheim01"},
					{text = "default skin",   value = "default"},
				},
				["sub_widgets"] = {},
			},
			{
				["show_widget_condition"] = {3},
				["setting_name"] = "es_deus_01_skin_03",
				["widget_type"] = "dropdown",
				["default_value"] = "default",
				["text"] = "Talabecland Waldguarder",
				["tooltip"] = "Choose active skin for Talabecland Waldguarder",
				["options"] = {
					{text = "Reikland Captain's Shield",   value = "Kruber_empire_shield_basic1"},
					{text = "Wolfenburg Guard Shield",   value = "Kruber_empire_shield_basic2"},
					{text = "Sol Invictus",   value = "Kruber_empire_shield_basic2_Kotbs01"},
					{text = "Kruber_empire_shield_hero1_Kotbs01",   value = "Kruber_empire_shield_hero1_Kotbs01"},
					{text = "Shield of Ostermark Spearman",   value = "Kruber_empire_shield_hero1_Ostermark01"},
					{text = "Shield of Ostermark Spearman (Sergeant's mesh)",   value = "Kruber_empire_shield_basic1_Ostermark01"},
					{text = "The White Wolf",   value = "Kruber_empire_shield_basic2_Middenheim"},
					{text = "The White Wolf (spear)",   value = "Kruber_empire_shield_basic3_Middenheim01"},
					{text = "default skin",   value = "default"},
				},
				["sub_widgets"] = {},
			},
			{
				["show_widget_condition"] = {3},
				["setting_name"] = "es_deus_01_skin_01_runed",
				["widget_type"] = "dropdown",
				["default_value"] = "default",
				["text"] = "Grauber's Arms",
				["tooltip"] = "Choose active skin for Grauber's Arms",
				["options"] = {
					{text = "Reikland Captain's Shield",   value = "Kruber_empire_shield_basic1"},
					{text = "Wolfenburg Guard Shield",   value = "Kruber_empire_shield_basic2"},
					{text = "Sol Invictus",   value = "Kruber_empire_shield_basic2_Kotbs01"},
					{text = "Kruber_empire_shield_hero1_Kotbs01",   value = "Kruber_empire_shield_hero1_Kotbs01"},
					{text = "Shield of Ostermark Spearman",   value = "Kruber_empire_shield_hero1_Ostermark01"},
					{text = "Shield of Ostermark Spearman (Sergeant's mesh)",   value = "Kruber_empire_shield_basic1_Ostermark01"},
					{text = "The White Wolf",   value = "Kruber_empire_shield_basic2_Middenheim"},
					{text = "The White Wolf (spear)",   value = "Kruber_empire_shield_basic3_Middenheim01"},
					{text = "default skin",   value = "default"},
				},
				["sub_widgets"] = {},
			},
			{
				["show_widget_condition"] = {3},
				["setting_name"] = "es_deus_01_skin_02_runed",
				["widget_type"] = "dropdown",
				["default_value"] = "default",
				["text"] = "Dantov's Guard",
				["tooltip"] = "Choose active skin for Dantov's Guard",
				["options"] = {
					{text = "Reikland Captain's Shield",   value = "Kruber_empire_shield_basic1"},
					{text = "Wolfenburg Guard Shield",   value = "Kruber_empire_shield_basic2"},
					{text = "Sol Invictus",   value = "Kruber_empire_shield_basic2_Kotbs01"},
					{text = "Kruber_empire_shield_hero1_Kotbs01",   value = "Kruber_empire_shield_hero1_Kotbs01"},
					{text = "Shield of Ostermark Spearman",   value = "Kruber_empire_shield_hero1_Ostermark01"},
					{text = "Shield of Ostermark Spearman (Sergeant's mesh)",   value = "Kruber_empire_shield_basic1_Ostermark01"},
					{text = "The White Wolf",   value = "Kruber_empire_shield_basic2_Middenheim"},
					{text = "The White Wolf (spear)",   value = "Kruber_empire_shield_basic3_Middenheim01"},
					{text = "default skin",   value = "default"},
				},
				["sub_widgets"] = {},
			},
			{
				["show_widget_condition"] = {3},
				["setting_name"] = "es_deus_01_skin_03_runed",
				["widget_type"] = "dropdown",
				["default_value"] = "default",
				["text"] = "Kellerman's Arms",
				["tooltip"] = "Choose active skin for Kellerman's Arms",
				["options"] = {
					{text = "Reikland Captain's Shield",   value = "Kruber_empire_shield_basic1"},
					{text = "Wolfenburg Guard Shield",   value = "Kruber_empire_shield_basic2"},
					{text = "Sol Invictus",   value = "Kruber_empire_shield_basic2_Kotbs01"},
					{text = "Kruber_empire_shield_hero1_Kotbs01",   value = "Kruber_empire_shield_hero1_Kotbs01"},
					{text = "Shield of Ostermark Spearman",   value = "Kruber_empire_shield_hero1_Ostermark01"},
					{text = "Shield of Ostermark Spearman (Sergeant's mesh)",   value = "Kruber_empire_shield_basic1_Ostermark01"},
					{text = "The White Wolf",   value = "Kruber_empire_shield_basic2_Middenheim"},
					{text = "The White Wolf (spear)",   value = "Kruber_empire_shield_basic3_Middenheim01"},
					{text = "default skin",   value = "default"},
				},
				["sub_widgets"] = {},
			},
			{
				["show_widget_condition"] = {4},
				["setting_name"] = "es_1h_sword_shield_skin_01",
				["widget_type"] = "dropdown",
				["default_value"] = "default",
				["text"] = "Sergeant's Longsword and Shield",
				["tooltip"] = "Choose active skin for Sergeant's Longsword and Shield",
				["options"] = {
					{text = "Reikland Captain's Shield",   value = "Kruber_empire_shield_basic1"},
					{text = "Wolfenburg Guard Shield",   value = "Kruber_empire_shield_basic2"},
					{text = "Sol Invictus",   value = "Kruber_empire_shield_basic2_Kotbs01"},
					{text = "Kruber_empire_shield_hero1_Kotbs01",   value = "Kruber_empire_shield_hero1_Kotbs01"},
					{text = "Shield of Ostermark Spearman",   value = "Kruber_empire_shield_hero1_Ostermark01"},
					{text = "Shield of Ostermark Spearman (Sergeant's mesh)",   value = "Kruber_empire_shield_basic1_Ostermark01"},
					{text = "The White Wolf",   value = "Kruber_empire_shield_basic2_Middenheim"},
					{text = "The White Wolf (spear)",   value = "Kruber_empire_shield_basic3_Middenheim01"},
					{text = "default skin",   value = "default"},
				},
				["sub_widgets"] = {},
			},
			{
				["show_widget_condition"] = {4},
				["setting_name"] = "es_1h_sword_shield_skin_02",
				["widget_type"] = "dropdown",
				["default_value"] = "default",
				["text"] = "Recruit's Longsword and Shield",
				["tooltip"] = "Choose active skin for Recruit's Longsword and Shield",
				["options"] = {
					{text = "Reikland Captain's Shield",   value = "Kruber_empire_shield_basic1"},
					{text = "Wolfenburg Guard Shield",   value = "Kruber_empire_shield_basic2"},
					{text = "Sol Invictus",   value = "Kruber_empire_shield_basic2_Kotbs01"},
					{text = "Kruber_empire_shield_hero1_Kotbs01",   value = "Kruber_empire_shield_hero1_Kotbs01"},
					{text = "Shield of Ostermark Spearman",   value = "Kruber_empire_shield_hero1_Ostermark01"},
					{text = "Shield of Ostermark Spearman (Sergeant's mesh)",   value = "Kruber_empire_shield_basic1_Ostermark01"},
					{text = "The White Wolf",   value = "Kruber_empire_shield_basic2_Middenheim"},
					{text = "The White Wolf (spear)",   value = "Kruber_empire_shield_basic3_Middenheim01"},
					{text = "default skin",   value = "default"},
				},
				["sub_widgets"] = {},
			},
			{
				["show_widget_condition"] = {4},
				["setting_name"] = "es_1h_sword_shield_skin_02_runed_01",
				["widget_type"] = "dropdown",
				["default_value"] = "default",
				["text"] = "Leopold's Favorite",
				["tooltip"] = "Choose active skin for Leopold's Favorite",
				["options"] = {
					{text = "Reikland Captain's Shield",   value = "Kruber_empire_shield_basic1"},
					{text = "Wolfenburg Guard Shield",   value = "Kruber_empire_shield_basic2"},
					{text = "Sol Invictus",   value = "Kruber_empire_shield_basic2_Kotbs01"},
					{text = "Kruber_empire_shield_hero1_Kotbs01",   value = "Kruber_empire_shield_hero1_Kotbs01"},
					{text = "Shield of Ostermark Spearman",   value = "Kruber_empire_shield_hero1_Ostermark01"},
					{text = "Shield of Ostermark Spearman (Sergeant's mesh)",   value = "Kruber_empire_shield_basic1_Ostermark01"},
					{text = "The White Wolf",   value = "Kruber_empire_shield_basic2_Middenheim"},
					{text = "The White Wolf (spear)",   value = "Kruber_empire_shield_basic3_Middenheim01"},
					{text = "default skin",   value = "default"},
				},
				["sub_widgets"] = {},
			},
			{
				["show_widget_condition"] = {4},
				["setting_name"] = "es_1h_sword_shield_skin_03",
				["widget_type"] = "dropdown",
				["default_value"] = "default",
				["text"] = "Soldier's Longsword and Shield",
				["tooltip"] = "Choose active skin for Soldier's Longsword and Shield",
				["options"] = {
					{text = "Reikland Captain's Shield",   value = "Kruber_empire_shield_basic1"},
					{text = "Wolfenburg Guard Shield",   value = "Kruber_empire_shield_basic2"},
					{text = "Sol Invictus",   value = "Kruber_empire_shield_basic2_Kotbs01"},
					{text = "Kruber_empire_shield_hero1_Kotbs01",   value = "Kruber_empire_shield_hero1_Kotbs01"},
					{text = "Shield of Ostermark Spearman",   value = "Kruber_empire_shield_hero1_Ostermark01"},
					{text = "Shield of Ostermark Spearman (Sergeant's mesh)",   value = "Kruber_empire_shield_basic1_Ostermark01"},
					{text = "The White Wolf",   value = "Kruber_empire_shield_basic2_Middenheim"},
					{text = "The White Wolf (spear)",   value = "Kruber_empire_shield_basic3_Middenheim01"},
					{text = "default skin",   value = "default"},
				},
				["sub_widgets"] = {},
			},
			{
				["show_widget_condition"] = {4},
				["setting_name"] = "es_1h_sword_shield_skin_03",
				["widget_type"] = "dropdown",
				["default_value"] = "default",
				["text"] = "Soldier's Longsword and Shield",
				["tooltip"] = "Choose active skin for Soldier's Longsword and Shield",
				["options"] = {
					{text = "Reikland Captain's Shield",   value = "Kruber_empire_shield_basic1"},
					{text = "Wolfenburg Guard Shield",   value = "Kruber_empire_shield_basic2"},
					{text = "Sol Invictus",   value = "Kruber_empire_shield_basic2_Kotbs01"},
					{text = "Kruber_empire_shield_hero1_Kotbs01",   value = "Kruber_empire_shield_hero1_Kotbs01"},
					{text = "Shield of Ostermark Spearman",   value = "Kruber_empire_shield_hero1_Ostermark01"},
					{text = "Shield of Ostermark Spearman (Sergeant's mesh)",   value = "Kruber_empire_shield_basic1_Ostermark01"},
					{text = "The White Wolf",   value = "Kruber_empire_shield_basic2_Middenheim"},
					{text = "The White Wolf (spear)",   value = "Kruber_empire_shield_basic3_Middenheim01"},
					{text = "default skin",   value = "default"},
				},
				["sub_widgets"] = {},
			},
			{
				["show_widget_condition"] = {4},
				["setting_name"] = "es_1h_sword_shield_skin_03_runed_01",
				["widget_type"] = "dropdown",
				["default_value"] = "default",
				["text"] = "The Bastion",
				["tooltip"] = "Choose active skin for The Bastion",
				["options"] = {
					{text = "Reikland Captain's Shield",   value = "Kruber_empire_shield_basic1"},
					{text = "Wolfenburg Guard Shield",   value = "Kruber_empire_shield_basic2"},
					{text = "Sol Invictus",   value = "Kruber_empire_shield_basic2_Kotbs01"},
					{text = "Kruber_empire_shield_hero1_Kotbs01",   value = "Kruber_empire_shield_hero1_Kotbs01"},
					{text = "Shield of Ostermark Spearman",   value = "Kruber_empire_shield_hero1_Ostermark01"},
					{text = "Shield of Ostermark Spearman (Sergeant's mesh)",   value = "Kruber_empire_shield_basic1_Ostermark01"},
					{text = "The White Wolf",   value = "Kruber_empire_shield_basic2_Middenheim"},
					{text = "The White Wolf (spear)",   value = "Kruber_empire_shield_basic3_Middenheim01"},
					{text = "default skin",   value = "default"},
				},
				["sub_widgets"] = {},
			},
			{
				["show_widget_condition"] = {4},
				["setting_name"] = "es_1h_sword_shield_skin_03_runed_02",
				["widget_type"] = "dropdown",
				["default_value"] = "default",
				["text"] = "Duty and Courage",
				["tooltip"] = "Choose active skin for Duty and Courage",
				["options"] = {
					{text = "Reikland Captain's Shield",   value = "Kruber_empire_shield_basic1"},
					{text = "Wolfenburg Guard Shield",   value = "Kruber_empire_shield_basic2"},
					{text = "Sol Invictus",   value = "Kruber_empire_shield_basic2_Kotbs01"},
					{text = "Kruber_empire_shield_hero1_Kotbs01",   value = "Kruber_empire_shield_hero1_Kotbs01"},
					{text = "Shield of Ostermark Spearman",   value = "Kruber_empire_shield_hero1_Ostermark01"},
					{text = "Shield of Ostermark Spearman (Sergeant's mesh)",   value = "Kruber_empire_shield_basic1_Ostermark01"},
					{text = "The White Wolf",   value = "Kruber_empire_shield_basic2_Middenheim"},
					{text = "The White Wolf (spear)",   value = "Kruber_empire_shield_basic3_Middenheim01"},
					{text = "default skin",   value = "default"},
				},
				["sub_widgets"] = {},
			},
			{
				["show_widget_condition"] = {4},
				["setting_name"] = "es_1h_sword_shield_skin_04",
				["widget_type"] = "dropdown",
				["default_value"] = "default",
				["text"] = "Shelter and Slaughter",
				["tooltip"] = "Choose active skin for Shelter and Slaughter",
				["options"] = {
					{text = "Reikland Captain's Shield",   value = "Kruber_empire_shield_basic1"},
					{text = "Wolfenburg Guard Shield",   value = "Kruber_empire_shield_basic2"},
					{text = "Sol Invictus",   value = "Kruber_empire_shield_basic2_Kotbs01"},
					{text = "Kruber_empire_shield_hero1_Kotbs01",   value = "Kruber_empire_shield_hero1_Kotbs01"},
					{text = "Shield of Ostermark Spearman",   value = "Kruber_empire_shield_hero1_Ostermark01"},
					{text = "Shield of Ostermark Spearman (Sergeant's mesh)",   value = "Kruber_empire_shield_basic1_Ostermark01"},
					{text = "The White Wolf",   value = "Kruber_empire_shield_basic2_Middenheim"},
					{text = "The White Wolf (spear)",   value = "Kruber_empire_shield_basic3_Middenheim01"},
					{text = "default skin",   value = "default"},
				},
				["sub_widgets"] = {},
			},
			{
				["show_widget_condition"] = {4},
				["setting_name"] = "es_1h_sword_shield_skin_05",
				["widget_type"] = "dropdown",
				["default_value"] = "default",
				["text"] = "Verbel's Masterwork",
				["tooltip"] = "Choose active skin for Verbel's Masterwork",
				["options"] = {
					{text = "Reikland Captain's Shield",   value = "Kruber_empire_shield_basic1"},
					{text = "Wolfenburg Guard Shield",   value = "Kruber_empire_shield_basic2"},
					{text = "Sol Invictus",   value = "Kruber_empire_shield_basic2_Kotbs01"},
					{text = "Kruber_empire_shield_hero1_Kotbs01",   value = "Kruber_empire_shield_hero1_Kotbs01"},
					{text = "Shield of Ostermark Spearman",   value = "Kruber_empire_shield_hero1_Ostermark01"},
					{text = "Shield of Ostermark Spearman (Sergeant's mesh)",   value = "Kruber_empire_shield_basic1_Ostermark01"},
					{text = "The White Wolf",   value = "Kruber_empire_shield_basic2_Middenheim"},
					{text = "The White Wolf (spear)",   value = "Kruber_empire_shield_basic3_Middenheim01"},
					{text = "default skin",   value = "default"},
				},
				["sub_widgets"] = {},
			},
			{
				["show_widget_condition"] = {5},
				["setting_name"] = "es_1h_mace_shield_skin_01",
				["widget_type"] = "dropdown",
				["default_value"] = "default",
				["text"] = "Sergeant's Mace and Shield",
				["tooltip"] = "Choose active skin for Sergeant's Mace and Shield",
				["options"] = {
					{text = "Reikland Captain's Shield",   value = "Kruber_empire_shield_basic1"},
					{text = "Wolfenburg Guard Shield",   value = "Kruber_empire_shield_basic2"},
					{text = "Sol Invictus",   value = "Kruber_empire_shield_basic2_Kotbs01"},
					{text = "Kruber_empire_shield_hero1_Kotbs01",   value = "Kruber_empire_shield_hero1_Kotbs01"},
					{text = "Shield of Ostermark Spearman",   value = "Kruber_empire_shield_hero1_Ostermark01"},
					{text = "Shield of Ostermark Spearman (Sergeant's mesh)",   value = "Kruber_empire_shield_basic1_Ostermark01"},
					{text = "The White Wolf",   value = "Kruber_empire_shield_basic2_Middenheim"},
					{text = "The White Wolf (spear)",   value = "Kruber_empire_shield_basic3_Middenheim01"},
					{text = "default skin",   value = "default"},
				},
				["sub_widgets"] = {},
			},
			{
				["show_widget_condition"] = {999},
				["setting_name"] = "es_1h_mace_shield_skin_02",
				["widget_type"] = "dropdown",
				["default_value"] = "default",
				["text"] = "es_1h_mace_shield_skin_02",
				["tooltip"] = "Choose active skin for Soldier's Longsword and Shield",
				["options"] = {
					{text = "Reikland Captain's Shield",   value = "Kruber_empire_shield_basic1"},
					{text = "Wolfenburg Guard Shield",   value = "Kruber_empire_shield_basic2"},
					{text = "Sol Invictus",   value = "Kruber_empire_shield_basic2_Kotbs01"},
					{text = "Kruber_empire_shield_hero1_Kotbs01",   value = "Kruber_empire_shield_hero1_Kotbs01"},
					{text = "Shield of Ostermark Spearman",   value = "Kruber_empire_shield_hero1_Ostermark01"},
					{text = "Shield of Ostermark Spearman (Sergeant's mesh)",   value = "Kruber_empire_shield_basic1_Ostermark01"},
					{text = "The White Wolf",   value = "Kruber_empire_shield_basic2_Middenheim"},
					{text = "The White Wolf (spear)",   value = "Kruber_empire_shield_basic3_Middenheim01"},
					{text = "default skin",   value = "default"},
				},
				["sub_widgets"] = {},
			},
			{
				["show_widget_condition"] = {5},
				["setting_name"] = "es_1h_mace_shield_skin_02_runed_01",
				["widget_type"] = "dropdown",
				["default_value"] = "default",
				["text"] = "Kell's Vanguard",
				["tooltip"] = "Choose active skin for Kell's Vanguard",
				["options"] = {
					{text = "Reikland Captain's Shield",   value = "Kruber_empire_shield_basic1"},
					{text = "Wolfenburg Guard Shield",   value = "Kruber_empire_shield_basic2"},
					{text = "Sol Invictus",   value = "Kruber_empire_shield_basic2_Kotbs01"},
					{text = "Kruber_empire_shield_hero1_Kotbs01",   value = "Kruber_empire_shield_hero1_Kotbs01"},
					{text = "Shield of Ostermark Spearman",   value = "Kruber_empire_shield_hero1_Ostermark01"},
					{text = "Shield of Ostermark Spearman (Sergeant's mesh)",   value = "Kruber_empire_shield_basic1_Ostermark01"},
					{text = "The White Wolf",   value = "Kruber_empire_shield_basic2_Middenheim"},
					{text = "The White Wolf (spear)",   value = "Kruber_empire_shield_basic3_Middenheim01"},
					{text = "default skin",   value = "default"},
				},
				["sub_widgets"] = {},
			},
			{
				["show_widget_condition"] = {5},
				["setting_name"] = "es_1h_mace_shield_skin_03",
				["widget_type"] = "dropdown",
				["default_value"] = "default",
				["text"] = "Soldier's Mace and Shield",
				["tooltip"] = "Choose active skin for Soldier's Longsword and Shield",
				["options"] = {
					{text = "Reikland Captain's Shield",   value = "Kruber_empire_shield_basic1"},
					{text = "Wolfenburg Guard Shield",   value = "Kruber_empire_shield_basic2"},
					{text = "Sol Invictus",   value = "Kruber_empire_shield_basic2_Kotbs01"},
					{text = "Kruber_empire_shield_hero1_Kotbs01",   value = "Kruber_empire_shield_hero1_Kotbs01"},
					{text = "Shield of Ostermark Spearman",   value = "Kruber_empire_shield_hero1_Ostermark01"},
					{text = "Shield of Ostermark Spearman (Sergeant's mesh)",   value = "Kruber_empire_shield_basic1_Ostermark01"},
					{text = "The White Wolf",   value = "Kruber_empire_shield_basic2_Middenheim"},
					{text = "The White Wolf (spear)",   value = "Kruber_empire_shield_basic3_Middenheim01"},
					{text = "default skin",   value = "default"},
				},
				["sub_widgets"] = {},
			},
			{
				["show_widget_condition"] = {5},
				["setting_name"] = "es_1h_mace_shield_skin_03_runed_01",
				["widget_type"] = "dropdown",
				["default_value"] = "default",
				["text"] = "Effinghast's Striker",
				["tooltip"] = "Choose active skin for Effinghast's Striker",
				["options"] = {
					{text = "Reikland Captain's Shield",   value = "Kruber_empire_shield_basic1"},
					{text = "Wolfenburg Guard Shield",   value = "Kruber_empire_shield_basic2"},
					{text = "Sol Invictus",   value = "Kruber_empire_shield_basic2_Kotbs01"},
					{text = "Kruber_empire_shield_hero1_Kotbs01",   value = "Kruber_empire_shield_hero1_Kotbs01"},
					{text = "Shield of Ostermark Spearman",   value = "Kruber_empire_shield_hero1_Ostermark01"},
					{text = "Shield of Ostermark Spearman (Sergeant's mesh)",   value = "Kruber_empire_shield_basic1_Ostermark01"},
					{text = "The White Wolf",   value = "Kruber_empire_shield_basic2_Middenheim"},
					{text = "The White Wolf (spear)",   value = "Kruber_empire_shield_basic3_Middenheim01"},
					{text = "default skin",   value = "default"},
				},
				["sub_widgets"] = {},
			},
			{
				["show_widget_condition"] = {5},
				["setting_name"] = "es_1h_mace_shield_skin_03_runed_02",
				["widget_type"] = "dropdown",
				["default_value"] = "default",
				["text"] = "Burden and Boon",
				["tooltip"] = "Choose active skin for Burden and Boon",
				["options"] = {
					{text = "Reikland Captain's Shield",   value = "Kruber_empire_shield_basic1"},
					{text = "Wolfenburg Guard Shield",   value = "Kruber_empire_shield_basic2"},
					{text = "Sol Invictus",   value = "Kruber_empire_shield_basic2_Kotbs01"},
					{text = "Kruber_empire_shield_hero1_Kotbs01",   value = "Kruber_empire_shield_hero1_Kotbs01"},
					{text = "Shield of Ostermark Spearman",   value = "Kruber_empire_shield_hero1_Ostermark01"},
					{text = "Shield of Ostermark Spearman (Sergeant's mesh)",   value = "Kruber_empire_shield_basic1_Ostermark01"},
					{text = "The White Wolf",   value = "Kruber_empire_shield_basic2_Middenheim"},
					{text = "The White Wolf (spear)",   value = "Kruber_empire_shield_basic3_Middenheim01"},
					{text = "default skin",   value = "default"},
				},
				["sub_widgets"] = {},
			},
			{
				["show_widget_condition"] = {5},
				["setting_name"] = "es_1h_mace_shield_skin_04",
				["widget_type"] = "dropdown",
				["default_value"] = "default",
				["text"] = "Hammer and Anvil",
				["tooltip"] = "Choose active skin for Hammer and Anvil",
				["options"] = {
					{text = "Reikland Captain's Shield",   value = "Kruber_empire_shield_basic1"},
					{text = "Wolfenburg Guard Shield",   value = "Kruber_empire_shield_basic2"},
					{text = "Sol Invictus",   value = "Kruber_empire_shield_basic2_Kotbs01"},
					{text = "Kruber_empire_shield_hero1_Kotbs01",   value = "Kruber_empire_shield_hero1_Kotbs01"},
					{text = "Shield of Ostermark Spearman",   value = "Kruber_empire_shield_hero1_Ostermark01"},
					{text = "Shield of Ostermark Spearman (Sergeant's mesh)",   value = "Kruber_empire_shield_basic1_Ostermark01"},
					{text = "The White Wolf",   value = "Kruber_empire_shield_basic2_Middenheim"},
					{text = "The White Wolf (spear)",   value = "Kruber_empire_shield_basic3_Middenheim01"},
					{text = "default skin",   value = "default"},
				},
				["sub_widgets"] = {},
			},
			{
				["show_widget_condition"] = {5},
				["setting_name"] = "es_1h_mace_shield_skin_05",
				["widget_type"] = "dropdown",
				["default_value"] = "default",
				["text"] = "The Honour of Ubersreik",
				["tooltip"] = "Choose active skin for The Honour of Ubersreik",
				["options"] = {
					{text = "Reikland Captain's Shield",   value = "Kruber_empire_shield_basic1"},
					{text = "Wolfenburg Guard Shield",   value = "Kruber_empire_shield_basic2"},
					{text = "Sol Invictus",   value = "Kruber_empire_shield_basic2_Kotbs01"},
					{text = "Kruber_empire_shield_hero1_Kotbs01",   value = "Kruber_empire_shield_hero1_Kotbs01"},
					{text = "Shield of Ostermark Spearman",   value = "Kruber_empire_shield_hero1_Ostermark01"},
					{text = "Shield of Ostermark Spearman (Sergeant's mesh)",   value = "Kruber_empire_shield_basic1_Ostermark01"},
					{text = "The White Wolf",   value = "Kruber_empire_shield_basic2_Middenheim"},
					{text = "The White Wolf (spear)",   value = "Kruber_empire_shield_basic3_Middenheim01"},
					{text = "default skin",   value = "default"},
				},
				["sub_widgets"] = {},
			},
			{
				["show_widget_condition"] = {6},
				["setting_name"] = "we_1h_spears_shield_skin_01",
				["widget_type"] = "dropdown",
				["default_value"] = "default",
				["text"] = "Tiranoc Watch-Shield",
				["tooltip"] = "Choose active skin for Tiranoc Watch-Shield",
				["options"] = {
					{text = "Avelorn Levy-Shield",   value = "Kerillian_elf_shield_basic_Avelorn01"},
					{text = "Avelorn Levy-Shield (new mesh)",   value = "Kerillian_elf_shield_basic_Avelorn01_mesh"},
					{text = "Cython-Ildir-Minaith",   value = "Kerillian_elf_shield_heroClean_Saphery01"},
					{text = "Dragon Shield of Caledor",   value = "Kerillian_elf_shield_heroClean_Caledor01"},
					{text = "Shield of the Maiden Guard",   value = "Kerillian_elf_shield_heroClean_Avelorn02"},
					{text = "Eagle Gate Sentry-Shield",   value = "Kerillian_elf_shield_basic2_Eaglegate01"},
					-- {text = "Griffon Gate Sentry-Shield",   value = "Kerillian_elf_shield_basic2"}, --uses default mesh
					{text = "Griffon Gate Sentry-Shield",   value = "Kerillian_elf_shield_basic2_mesh"},
					{text = "Avalu-Asur",   value = "Kerillian_elf_shield_basicClean"},
					{text = "default skin",   value = "default"},
				},
				["sub_widgets"] = {},
			},
			{
				["show_widget_condition"] = {6},
				["setting_name"] = "we_1h_spears_shield_skin_01_runed_01",
				["widget_type"] = "dropdown",
				["default_value"] = "default",
				["text"] = "Princess's Glamour Shield",
				["tooltip"] = "Choose active skin for Princess's Glamour Shield",
				["options"] = {
					{text = "Avelorn Levy-Shield",   value = "Kerillian_elf_shield_basic_Avelorn01"},
					{text = "Avelorn Levy-Shield (new mesh)",   value = "Kerillian_elf_shield_basic_Avelorn01_mesh"},
					{text = "Cython-Ildir-Minaith",   value = "Kerillian_elf_shield_heroClean_Saphery01"},
					{text = "Dragon Shield of Caledor",   value = "Kerillian_elf_shield_heroClean_Caledor01"},
					{text = "Shield of the Maiden Guard",   value = "Kerillian_elf_shield_heroClean_Avelorn02"},
					{text = "Eagle Gate Sentry-Shield",   value = "Kerillian_elf_shield_basic2_Eaglegate01"},
					-- {text = "Griffon Gate Sentry-Shield",   value = "Kerillian_elf_shield_basic2"}, --uses default mesh
					{text = "Griffon Gate Sentry-Shield",   value = "Kerillian_elf_shield_basic2_mesh"},
					{text = "Avalu-Asur",   value = "Kerillian_elf_shield_basicClean"},
					{text = "default skin",   value = "default"},
				},
				["sub_widgets"] = {},
			},
			{
				["show_widget_condition"] = {6},
				["setting_name"] = "we_1h_spears_shield_skin_02",
				["widget_type"] = "dropdown",
				["default_value"] = "default",
				["text"] = "Sea Guard's Drannach-Isalt",
				["tooltip"] = "Choose active skin for Sea Guard's Drannach-Isalt",
				["options"] = {
					-- {text = "Avelorn Levy-Shield",   value = "Kerillian_elf_shield_basic_Avelorn01"},
					{text = "Avelorn Levy-Shield (new mesh)",   value = "Kerillian_elf_shield_basic_Avelorn01_mesh"},
					{text = "Cython-Ildir-Minaith",   value = "Kerillian_elf_shield_heroClean_Saphery01"},
					{text = "Dragon Shield of Caledor",   value = "Kerillian_elf_shield_heroClean_Caledor01"},
					{text = "Shield of the Maiden Guard",   value = "Kerillian_elf_shield_heroClean_Avelorn02"},
					{text = "Eagle Gate Sentry-Shield",   value = "Kerillian_elf_shield_basic2_Eaglegate01"},
					-- {text = "Griffon Gate Sentry-Shield",   value = "Kerillian_elf_shield_basic2"},
					{text = "Griffon Gate Sentry-Shield",   value = "Kerillian_elf_shield_basic2_mesh"},
					{text = "Avalu-Asur",   value = "Kerillian_elf_shield_basicClean"},
					{text = "default skin",   value = "default"},
				},
				["sub_widgets"] = {},
			},
		},
	},

}
return menu