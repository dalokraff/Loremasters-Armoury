local mod = get_mod("Loremasters-Armoury")
-- for k,v in pairs(mod.SKIN_CHANGED) do
-- 	mod:echo(k)
-- end
-- mod:echo(mod.current_skin["es_1h_sword_shield_skin_03_runed_01_rightHand"])

local VANILLA_TO_MODDED_TABLE = local_require("scripts/mods/Loremasters-Armoury/LA_view/armoury_view/definitions/vanilla_to_modded_table")


local armoury = {
    we_sword = {},
    bw_dagger = {},
    es_repeating_handgun = {},
    es_1h_flail = {},
    dw_2h_hammer = {},
    dr_steam_pistol = {},
    dw_1h_hammer = {},
    wh_crossbow = {},
    wh_1h_hammer = {},
    we_dual_dagger = {},
    we_dual_sword = {},
    we_crossbow = {},
    we_javelin = {},
    we_dual_sword_dagger = {},
    bw_1h_flail_flaming = {},
    wh_dual_hammer = {},
    es_2h_heavy_spear = {},
    dw_2h_axe = {},
    bw_flamethrower_staff = {},
    bw_fireball_staff = {},
    bw_1h_sword = {},
    we_2h_axe = {},
    es_1h_mace_shield = {},
    dw_crossbow = {},
    wh_1h_falchion = {},
    dw_drakegun = {},
    we_1h_axe = {},
    dr_dual_wield_hammers = {},
    bw_deus_01 = {},
    dr_deus_01 = {},
    bw_1h_flaming_sword = {},
    wh_1h_axe = {},
    we_hagbane = {},
    es_bastard_sword = {},
    bw_1h_crowbill = {},
    we_1h_spears_shield = {},
    dw_1h_hammer_shield = {},
    we_longbow = {},
    es_dual_wield_hammer_sword = {},
    bw_spear_staff = {},
    dw_grudge_raker = {},
    we_spear = {},
    es_longbow = {},
    wh_hammer_book = {},
    es_blunderbuss = {},
    wh_brace_of_pistols = {},
    es_1h_sword = {},
    es_halberd = {},
    we_deus_01 = {},
    wh_hammer_shield = {},
    es_2h_hammer = {},
    es_deus_01 = {},
    dw_drake_pistol = {},
    we_shortbow = {},
    dw_1h_axe = {},
    dw_1h_axe_shield = {},
    es_2h_sword = {},
    wh_deus_01 = {},
    bw_beam_staff = {},
    es_1h_sword_shield = {},
    dw_handgun = {},
    wh_2h_billhook = {},
    wh_repeating_crossbow = {},
    es_handgun = {},
    we_life_staff = {},
    es_1h_mace = {},
    bw_1h_mace = {},
    es_2h_sword_exe = {},
    dw_2h_pick = {},
    wh_2h_sword = {},
    wh_flail_shield = {},
    es_sword_shield_breton = {},
    wh_repeating_pistol = {},
    bw_conflagration_staff = {},
    dw_dual_axe = {},
    wh_dual_wield_axe_falchion = {},
    wh_fencing_sword = {},
    dr_2h_cog_hammer = {},
    wh_2h_hammer = {},
    dr_1h_throwing_axes = {},
    we_2h_sword = {},
}


local item_master_list = ItemMasterList
for weapon_name, weapon_data in pairs(armoury) do
    
    for item_name, item_data in pairs(item_master_list) do
        local display_name = item_data.display_name
        if display_name then
            if weapon_name == string.gsub(display_name, "_skin.+", "") then
                weapon_data[item_name] = {
                    right = "default",
                    left = "default",
                }
            end
        end
    end
end

return armoury


-- local ARMOURY_TABLE = local_require("scripts/mods/Loremasters-Armoury/LA_view/armoury_view/armoury_db")
-- local item_master_list = ItemMasterList
-- for weapon_name, weapon_data in pairs(ARMOURY_TABLE) do
    
--     for item_name, item_data in pairs(item_master_list) do
--         local display_name = item_data.display_name
--         if weapon_name == string.gsub(display_name, "_skin.+", "") then
--             mod:echo(weapon_name)
--         end
--     end
-- end