local mod = get_mod("Loremasters-Armoury")

LaRewardPopup = class(LaRewardPopup)

LaRewardPopup.init = function (self, ingame_ui_context, reward_name, rarity, display_name, icon, quest_callback, ...)

    self.reward_name = reward_name

    local reward_params = {
        wwise_world = ingame_ui_context.wwise_world,
        ui_renderer = ingame_ui_context.ui_renderer,
        ui_top_renderer = ingame_ui_context.ui_top_renderer,
        input_manager = ingame_ui_context.input_manager
    }

    self.popup = RewardPopupUI:new(reward_params)

    self.popup:set_input_manager(ingame_ui_context.input_manager)

    local description = {}
    local entry = {}
    local presentation_data = {}
    description[1] = Localize(display_name)
    description[2] = Localize("achv_menu_reward_claimed_title")
    entry[#entry + 1] = {
        widget_type = "description",
        value = description
    }
    entry[#entry + 1] = {
        widget_type = "weapon_skin",
        value = {
            icon = icon,
            rarity = rarity
        }
    }
    presentation_data[#presentation_data + 1] = entry

    print(quest_callback)
    if quest_callback then
        local value = quest_callback(...)
        print(reward_name, value)
    end

    self.popup:display_presentation(presentation_data)
end

LaRewardPopup.update = function (self, dt)
    if not self.popup then
        self:destroy()
    end
    self.popup:update(dt)
end

LaRewardPopup.destroy = function(self)

    mod.reward_popups[reward_name] = nil

    return
end
