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

    skin_wh_zealot_middenland = {},
    skin_we_thornsister = {},
    skin_bw_default = {},
    skin_ww_moonmantle = {},
    skin_dr_irondrake = {},
    skin_es_huntsman_nuln = {},
    skin_bw_adept_ostermark = {},
    skin_wh_zealot_executioner = {},
    skin_bw_pyromancer_redemption = {},
    skin_wh_captain_black_and_gold = {},
    skin_ww_handmaiden_spirit = {},
    skin_wh_flagellant = {},
    skin_wh_captain_ostermark = {},
    skin_ww_shade_emerald = {},
    skin_bw_adept_ash = {},
    skin_wh_zealot_ostermark = {},
    skin_bw_adept_helmgart = {},
    skin_wh_captain_grey_and_yellow = {},
    skin_bw_adept_white = {},
    skin_es_knight_white = {},
    skin_wh_captain_executioner = {},
    skin_dr_ranger_helmgart = {},
    skin_es_knight = {},
    skin_dr_slayer_white = {},
    skin_wh_zealot_white = {},
    skin_wh_priest_white = {},
    skin_wh_captain_white = {},
    skin_es_mercenary_ostermark = {},
    skin_ww_maidenguard_white = {},
    skin_ww_shade_white = {},
    skin_es_mercenary_white = {},
    skin_es_huntsman_white = {},
    skin_ww_shade_black_and_gold = {},
    skin_bw_scholar_white = {},
    skin_dr_ironbreaker_barak_varr = {},
    skin_bw_pyromancer_ostermark = {},
    skin_es_longshark = {},
    skin_ww_waywatcher_tirsyth = {},
    skin_es_knight_encarmine = {},
    skin_ww_waywatcher_black_and_gold = {},
    skin_es_default = {},
    skin_wh_priest_0002_a = {},
    skin_bw_myrmidia = {},
    skin_es_mercenary = {},
    skin_es_knight_blazing_sun = {},
    skin_ww_handmaiden_tirsyth = {},
    skin_bw_unchained_white = {},
    skin_es_questingknight_white = {},
    skin_es_mercenary_helmgart = {},
    skin_wh_bounty_hunter_black_and_gold = {},
    skin_es_huntsman_middenland = {},
    skin_dr_ranger = {},
    skin_dr_slayer = {},
    skin_es_huntsman_green = {},
    skin_dr_ranger_barak_varr = {},
    skin_dr_slayer_skavenslayer = {},
    skin_wh_bountyhunter_white = {},
    skin_ww_shade = {},
    skin_dr_slayer_skullslayer = {},
    skin_bw_unchained_brown_and_yellow = {},
    skin_dr_ironbreaker_black_and_gold = {},
    skin_dr_engineer_white = {},
    skin_ww_shade_midnight = {},
    skin_wh_bounty_hunter_executioner = {},
    skin_bw_pyromancer_brown_and_yellow = {},
    skin_ww_waywatcher = {},
    skin_es_knight_hermit = {},
    skin_bw_unchained_redemption = {},
    skin_wh_captain = {},
    skin_dr_ranger_karak_norn = {},
    skin_ww_default = {},
    skin_dr_ironbreaker_brown_and_yellow = {},
    skin_es_huntsman = {},
    skin_wh_default = {},
    skin_es_mercenary_middenland = {},
    skin_es_knight_brass_keep = {},
    skin_wh_priest = {},
    skin_es_huntsman_ostermark = {},
    skin_wh_bountyhunter = {},
    skin_dr_slayer_dragonslayer = {},
    skin_dr_ironbreaker_karak_norn = {},
    skin_ww_waywatcher_cythral = {},
    skin_bw_adept_redemption = {},
    skin_dr_ranger_brown_and_yellow = {},
    skin_dr_ranger_white = {},
    skin_wh_zealot = {},
    skin_bw_adept_brown_and_yellow = {},
    skin_dr_ironbreaker_zhufbar = {},
    skin_wh_bounty_hunter_middenland = {},
    skin_bw_pyromancer_black_and_gold = {},
    skin_es_mercenary_talabecland = {},
    skin_bw_unchained_ash = {},
    skin_wh_captain_middenland = {},
    skin_wh_zealot_grey_and_yellow = {},
    skin_dr_slayer_quickslayer = {},
    skin_ww_shade_ash = {},
    skin_bw_unchained_black_and_gold = {},
    skin_bw_unchained_ostermark = {},
    skin_dr_ironbreaker_white = {},
    skin_wh_zealot_black_and_gold = {},
    skin_es_mercenary_black_and_gold = {},
    skin_bw_unchained = {},
    skin_ww_shade_crimson = {},
    skin_dr_slayer_oldslayer = {},
    skin_ww_handmaiden_black_and_gold = {},
    skin_wh_captain_helmgart = {},
    skin_dr_ranger_zhufbar = {},
    skin_ww_handmaiden = {},
    skin_es_mercenary_carroburg = {},
    skin_es_huntsman_talabecland = {},
    skin_ww_handmaiden_anmyr = {},
    skin_ww_waywatcher_anmyr = {},
    skin_dr_ironbreaker = {},
    skin_ww_waywatcher_helmgart = {},
    skin_wh_bounty_hunter_ostermark = {},
    skin_bw_adept_black_and_gold = {},
    skin_bw_adept = {},
    skin_es_knight_wolf_knight = {},
    skin_dr_ranger_black_and_gold = {},
    skin_wh_priest_0002 = {},
    skin_bw_pyromancer_ash = {},
    skin_dr_slayer_ravenslayer = {},
    skin_ww_thornsister_white = {},
    skin_ww_waywatcher_atylwyth = {},
    skin_ww_handmaiden_frostmaiden = {},
    skin_ww_waywatcher_white = {},
    skin_dr_ranger_upgraded = {},
    skin_bw_scholar = {},
    skin_wh_bounty_hunter_grey_and_yellow = {},
}


local item_master_list = ItemMasterList

for item_name, item_data in pairs(item_master_list) do
    if item_data.item_type == "skin" or item_data.item_type == "hat" then
        armoury[item_name] = {}
    end
end

for weapon_name, weapon_data in pairs(armoury) do

    for item_name, item_data in pairs(item_master_list) do
        local display_name = item_data.display_name
        if display_name then
            if weapon_name == string.gsub(item_name, "_skin.+", "") then
                weapon_data[item_name] = {
                    right = "default",
                    left = "default",
                }
            end
        end
    end
end

return armoury

-- local moode = get_mod("Loremasters-Armoury")
-- moode.Terra = {
--     firma = {1,2,3,4,5}
-- }

-- local moode = get_mod("Loremasters-Armoury")
-- mod.terracopy = table.clone(moode.Terra)
-- moode.Terra.firma[2] = 8
-- require 'pl.pretty'.dump(moode.Terra)
-- require 'pl.pretty'.dump(mod.terracopy)

-- local moode = get_mod("Loremasters-Armoury")
-- moode.Terra = mod.terracopy
-- require 'pl.pretty'.dump(moode.Terra)


-- local mutator = mod:persistent_table("DenseOnslaught")
-- require 'pl.pretty'.dump(mutator.OriginalTerrorEventBlueprints)
