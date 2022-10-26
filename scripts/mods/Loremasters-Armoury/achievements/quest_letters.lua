local mod = get_mod("Loremasters-Armoury")

QuestLetters = {}

QuestLetters.test_painting = {
    sub_quest_01 = {
        unit = "units/decorations/letters/LA_loremaster_message_small",
        name = "sub_quest_05_message",
        desc = "",
    },
    sub_quest_02 = {
        unit = "units/decorations/letters/LA_loremaster_message_medium",
        name = "sub_quest_06_message",
        desc = "",
    },
    sub_quest_03 = {
        unit = "units/decorations/letters/LA_loremaster_message_large",
        name = "sub_quest_07_message",
        desc = "",
    },
    sub_quest_04 = {
        unit = "units/decorations/letters/LA_loremaster_message_small",
        name = "sub_quest_08_message",
        desc = "",
    },
    sub_quest_05 = {
        unit = "units/decorations/letters/LA_loremaster_message_medium",
        name = "sub_quest_09_message",
        desc = "",
    },
    sub_quest_06 = {
        unit = "units/decorations/letters/LA_loremaster_message_large",
        name = "sub_quest_05_message",
        desc = "",
    },
    sub_quest_07 = {
        unit = "units/decorations/letters/LA_loremaster_message_small",
        name = "sub_quest_06_message",
        desc = "",
    },
    sub_quest_08 = {
        unit = "units/decorations/letters/LA_loremaster_message_medium",
        name = "sub_quest_07_message",
        desc = "",
    },
    sub_quest_09 = {
        unit = "units/decorations/letters/LA_loremaster_message_large",
        name = "sub_quest_08_message",
        desc = "",
    },
    sub_quest_10 = {
        unit = "units/decorations/letters/LA_loremaster_message_small",
        name = "sub_quest_09_message",
        desc = "",
    },
}
QuestLetters.test_quest_select = {
    sub_quest_01 = {
        unit = "units/decorations/letters/LA_quest_message_stage01",
        name = "sub_quest_01_message",
        desc = "",
    },
    sub_quest_02 = {
        unit = "units/decorations/letters/LA_quest_message_stage02",
        name = "sub_quest_02_message",
        desc = "",
    },
    sub_quest_03 = {
        unit = "units/decorations/letters/LA_quest_message_stage03",
        name = "sub_quest_03_message",
        desc = "",
    },
    sub_quest_04 = {
        unit = "units/decorations/letters/LA_quest_message_stage04",
        name = "sub_quest_04_message",
        desc = "",
    },
    sub_quest_05 = {
        unit = "units/decorations/letters/LA_quest_message_stage05",
        name = "sub_quest_05_message",
        desc = "",
    },
    sub_quest_06 = {
        unit = "units/decorations/letters/LA_quest_message_stage06",
        name = "sub_quest_06_message",
        desc = "",
    },
    sub_quest_07 = {
        unit = "units/decorations/letters/LA_quest_message_stage07",
        name = "sub_quest_07_message",
        desc = "",
    },
    sub_quest_08 = {
        unit = "units/decorations/letters/LA_quest_message_stage08",
        name = "sub_quest_08_message",
        desc = "",
    },
    sub_quest_09 = {
        unit = "units/decorations/letters/LA_quest_message_stage09",
        name = "sub_quest_09_message",
        desc = "",
    },
    sub_quest_10 = {
        unit = "units/decorations/letters/LA_quest_message_stage10",
        name = "sub_quest_10_message",
        desc = "",
    },
}
QuestLetters.main_01 = {
    sub_quest_prologue = {
        unit = "units/decorations/letters/LA_quest_message_stage01",
        name = "sub_quest_prologue_message",
        desc = "sub_quest_prologue_message_desc",
    },
    sub_quest_05 = {
        unit = "units/decorations/letters/LA_quest_message_stage02",
        name = "sub_quest_05_message",
        desc = "sub_quest_05_message_desc",
        requires = {
            "sub_quest_03",
            "sub_quest_04",
        },
    },
    sub_quest_06 = {
        unit = "units/decorations/letters/LA_quest_message_stage03",
        name = "sub_quest_06_message",
        desc = "sub_quest_06_message_desc",
    },
    sub_quest_07 = {
        unit = "units/decorations/letters/LA_quest_message_stage04",
        name = "sub_quest_07_message",
        desc = "sub_quest_07_message_desc",
    },
    sub_quest_08 = {
        unit = "units/decorations/letters/LA_quest_message_stage05",
        name = "sub_quest_08_message",
        desc = "sub_quest_08_message_desc",
    },
    sub_quest_09 = {
        unit = "units/decorations/letters/LA_quest_message_stage06",
        name = "sub_quest_09_message",
        desc = "sub_quest_09_message_desc",
    },
}



for quest, subs in pairs(QuestLetters) do 
    for sub_quest, letter in pairs(subs) do 
        local num_husk = #NetworkLookup.husks
        -- NetworkLookup.husks[num_husk +1] = letter.unit
        NetworkLookup.husks[letter.unit] = 1
        -- NetworkLookup.husks[num_husk +2] = letter.unit.."_visable"
        NetworkLookup.husks[letter.unit.."_visable"] = 1
    end
end

return


-- require("core/gwnav/lua/safe_require")
-- NavWorld = safe_require("core/gwnav/lua/runtime/navworld")
-- mod:echo(NavWorld)
-- mod:hook(NavWorld, "add_navdata", function (func, self, resource_name)
-- 	mod:echo(resource_name)
--     return func(self, resource_name)
-- end)



-- local tisch = {
--     GwNavWorld = "",
--     GwNavBotConfiguration = "",
--     GwNavGraphConnector = "",
--     GwNavTagBox = "",
--     GwNavBoxObstacle = "",
--     GwNavCylinderObstacle = "",
--     GwNavMarker = "",
--     GwNavBot = "",
-- }
-- mod:hook(Unit, "alive", function (func, self)
-- 	if self then
--         Unit.set_data(self, "checked_data", true)
--         if not Unit.has_data(self, "checked_data") then
--             for k,v in pairs(tisch) do
--                 if Unit.alive(self) then
--                     if Unit.has_data(self, tostring(k)) then
--                         mod:echo(tostring(self).."      "..tostring(k))
--                         if Unit.has_data(self, "unit_name") then
--                             mod:echo(tostring(self).."      "..tostring(Unit.get_data(self, "unit_name")))
--                         end
--                         mod:echo("===============================================")
--                     end
--                 end
--             end
--         end
--     end
--     return func(self)
-- end)

-- require("core/gwnav/lua/safe_require")
-- NavWorld = safe_require("core/gwnav/lua/runtime/navworld")
-- mod:echo(NavWorld)

-- units/props/chest/chest_01/props_chest_01

-- units/props/lanterns/lantern_01/prop_lantern_01
-- units/props/generic/generic_prop_stool
-- units/architecture/town/town_walkway_02
-- local function is_available(type, name)
-- 	printf("%s.%s : available? => %s", name, type, Application.can_get(type, name))
-- end
-- is_available("unit", "units/architecture/town/landmarks/clock_tower_01")

-- Managers.package:load("core/gwnav/boot", "global")

-- levels/whitebox/world