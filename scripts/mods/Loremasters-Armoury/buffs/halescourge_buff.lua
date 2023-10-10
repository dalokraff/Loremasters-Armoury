local mod = get_mod("Loremasters-Armoury")

HalescourgeBuff = class(HalescourgeBuff)

HalescourgeBuff.init = function (self, world)
    self.current_time = 0
    self.wait_time = 0
    self.world = world
    self.wwise_world = Wwise.wwise_world(world)


    local player = Managers.player:local_player()
    self.player_unit = player.player_unit
    self.buff_extension = ScriptUnit.extension(self.player_unit, "buff_system")

    self.wait = self:start_countdown()

    self.stage = "stage_one"

end

HalescourgeBuff.update = function (self, dt)

    if not self.buff_extension then
        local player = Managers.player:local_player()
        self.player_unit = player.player_unit
        self.buff_extension = ScriptUnit.extension(self.player_unit, "buff_system")
    end

    self.current_time = self.current_time + dt

    if self.current_time >= self.wait_time then
        local stage = self[self.stage]
        stage(self)
    end
end

HalescourgeBuff.stage_one = function(self)
    WwiseWorld.trigger_event(self.wwise_world, "Loremaster_magicboon_sound")
    self.stage = "stage_two"
    self.wait_time = self.current_time + 6
end

HalescourgeBuff.stage_two = function(self)
    self.buff_extension:add_buff("sub_quest_08_cdr_buff", nil)
    self.buff_extension:add_buff("sub_quest_08_stamina_buff", nil)
    self.buff_extension:add_buff("sub_quest_08_heatgen_buff", nil)
    local message = mod:localize("halescourge_buff_chat_message")
    Managers.chat:add_local_system_message(1, "The Loremaster is chanelling supportive magic your way: +20% CDR, +4 Stamina and -30% Overcharge", true)
    self:destroy()
end

HalescourgeBuff.start_countdown = function(self)

    self.wait_time = self.current_time + 25
end


HalescourgeBuff.destroy = function(self)
    self.current_time = -99999
    self.wait_time = 99999
    mod.halescourge_buff = nil
    mod.halescourge_buff_applied = true
    return
end
