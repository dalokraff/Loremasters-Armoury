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
        reward = 'sub_quest_01_reward',
        mission_brief = 'sub_quest_crate_tracker',
    },
    sub_quest_crate_tracker = {
        unit = "units/decorations/letters/LA_quest_message_stage02",
        name = "sub_quest_crate_tracker_message",
        desc = "sub_quest_crate_tracker_message_desc",
        requires = {
            "sub_quest_03",
            "sub_quest_04",
            "sub_quest_05",
        },
        reward = 'sub_quest_06_reward',
        mission_brief = 'sub_quest_06',
    },
    sub_quest_06 = {
        unit = "units/decorations/letters/LA_quest_message_stage03",
        name = "sub_quest_06_message",
        desc = "sub_quest_06_message_desc",
        reward = 'sub_quest_07_reward',
        mission_brief = 'sub_quest_07',
    },
    sub_quest_07 = {
        unit = "units/decorations/letters/LA_quest_message_stage04",
        name = "sub_quest_07_message",
        desc = "sub_quest_07_message_desc",
        reward = 'sub_quest_08_reward',
        mission_brief = 'sub_quest_08',
    },
    sub_quest_08 = {
        unit = "units/decorations/letters/LA_quest_message_stage05",
        name = "sub_quest_08_message",
        desc = "sub_quest_08_message_desc",
        reward = 'sub_quest_09_reward',
        mission_brief = 'sub_quest_09',
    },
    sub_quest_09 = {
        unit = "units/decorations/letters/LA_quest_message_stage06",
        name = "sub_quest_09_message",
        desc = "sub_quest_09_message_desc",
        reward = 'sub_quest_10_reward',
        mission_brief = 'sub_quest_10',
    },
}


for quest, subs in pairs(QuestLetters) do 
    for sub_quest, letter in pairs(subs) do 
        letter.sub_quest_name = sub_quest
    end
end

for quest, subs in pairs(QuestLetters) do 
    for sub_quest, letter in pairs(subs) do 
        local num_husk = #NetworkLookup.husks
        NetworkLookup.husks[letter.unit] = 1
        NetworkLookup.husks[letter.unit.."_visable"] = 1
        QuestLetters[quest][letter.unit] = letter
    end
end

return