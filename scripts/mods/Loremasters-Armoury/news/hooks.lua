local mod = get_mod("Loremasters-Armoury")

--hook that adds in notification when letter is unread
mod:hook(NewsFeedUI,"init", function (func, self, parent, ingame_ui_context)
    local num_new_feed = #NewsFeedTemplates
    if not FindNewsTemplateIndex("LA_unread_letter") then
        NewsFeedTemplates[num_new_feed+1] = {
            description = "letter_recieved",
            name = "LA_unread_letter",
            duration = 10,
            cooldown = -1,
            infinite = false,
            title = "LA_unread_letter",
            icon = "la_notification_icon",
            icon_offset = {
                40,
                20,
                3
            },
            icon_size = {
                70,
                70
            },
            condition_func = function (params)
                if mod.letter_board then
                    for quest, units in pairs(mod.letter_board:active_letters_list()) do
                        if not mod:get(quest.."_letter_read") then
                            local news_index = FindNewsTemplateIndex("LA_unread_letter")
                            NewsFeedTemplates[news_index].title = quest
                            return true
                        end
                    end
                end
                
                return false
            end,
        }
    end
    return func(self, parent, ingame_ui_context)
end)