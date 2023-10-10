local mod = get_mod("Loremasters-Armoury")

math.randomseed(os.time())
utils = {}
utils.__index = utils

local table_of_skins = {}
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