local mod = get_mod("Loremasters-Armoury")

QuestLetters = {}

QuestLetters.test_painting = {
    sub_quest_01 = "units/decorations/LA_loremaster_message_small",
    sub_quest_02 =  "units/decorations/LA_loremaster_message_medium",
    sub_quest_03 = "units/decorations/LA_loremaster_message_large",
    sub_quest_04 = "units/decorations/LA_loremaster_message_small",
    sub_quest_05 = "units/decorations/LA_loremaster_message_medium",
    sub_quest_06 = "units/decorations/LA_loremaster_message_large",
    sub_quest_07 = "units/decorations/LA_loremaster_message_small",
    sub_quest_08 = "units/decorations/LA_loremaster_message_medium",
    sub_quest_09 = "units/decorations/LA_loremaster_message_large",
    sub_quest_10 = "units/decorations/LA_loremaster_message_small",
}
QuestLetters.main_01 = {
    sub_quest_01 = "units/decorations/letters/LA_quest_message_stage01",
    sub_quest_02 = "units/decorations/letters/LA_quest_message_stage02",
    sub_quest_03 = "units/decorations/letters/LA_quest_message_stage03",
    sub_quest_04 = "units/decorations/letters/LA_quest_message_stage04",
    sub_quest_05 = "units/decorations/letters/LA_quest_message_stage05",
    sub_quest_06 = "units/decorations/letters/LA_quest_message_stage06",
    sub_quest_07 = "units/decorations/letters/LA_quest_message_stage07",
    sub_quest_08 = "units/decorations/letters/LA_quest_message_stage08",
    sub_quest_09 = "units/decorations/letters/LA_quest_message_stage09",
    sub_quest_10 = "units/decorations/letters/LA_quest_message_stage10",
}


for quest, subs in pairs(QuestLetters) do 
    for sub_quest, letter in pairs(subs) do 
        local num_husk = #NetworkLookup.husks
        NetworkLookup.husks[num_husk +1] = letter
        NetworkLookup.husks[letter] = num_husk +1
        NetworkLookup.husks[num_husk +2] = letter.."_visable"
        NetworkLookup.husks[letter.."_visable"] = num_husk +2
    end
end

return