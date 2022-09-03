local mod = get_mod("Loremasters-Armoury")

math.randomseed(os.time())
utils = {}
utils.__index = utils

local table_of_skins = {}
-- local skins_to_change = {}
-- table.append(skins_to_change, mod.bret_skins)
-- table.append(skins_to_change, mod.empire_spear_shield)
-- table.append(skins_to_change, mod.empire_sword_shield)
-- table.append(skins_to_change, mod.empire_mace_shield)
-- table.append(skins_to_change, mod.empire_sword_skins)
-- table.append(skins_to_change, mod.dwarf_axe_shield)
-- table.append(skins_to_change, mod.dwarf_ham_shield)
-- table.append(skins_to_change, mod.elf_skins)
-- table.append(skins_to_change, mod.elf_bow_skins)
-- table.append(skins_to_change, mod.elf_hat_skins)
-- table.append(skins_to_change, mod.krub_hat_skins)
-- table.append(skins_to_change, mod.krub_armor_skins)
-- table.append(skins_to_change, mod.elf_armor_skins)

-- for k,v in pairs(skins_to_change) do
--     table_of_skins[k] = v
-- end

function utils:skin_id_to_skin(skin_id)
    if skin_id then 
        local pattern = "_%d%d%d%d"
        local skin = string.gsub(skin_id, pattern, "")
        
        return skin
    end
    
    return skin_id
end

function utils:genSkinName(skin)
    local new_skin = skin.."_"..tostring(math.random(1000,9999))
    table_of_skins[new_skin] = skin
    return new_skin
end

function utils:getSkin(new_skin)
    local skin = table_of_skins[new_skin]

    return skin
end