local mod = get_mod("Loremasters-Armoury")

HalescourgeDebuff = class(HalescourgeDebuff)


local health_stages = {
    0.95,
    0.6,
    0.5,
    0.1,
}

HalescourgeDebuff.init = function (self, blackboard)
    self.current_time = 0
    self.wait_time = 0
    self.world = Managers.world:world("level_world")
    self.bb = blackboard
    self.unit = blackboard.unit

    self.stage = 1
    
end

HalescourgeDebuff.update = function (self, dt)
    if not Unit.alive(self.unit) then
        self:destroy()
    end
    if self.stage >= 5 then
        self:destroy()
    end
    self:health_check()
end

HalescourgeDebuff.health_check = function(self)
    local health = self.bb.current_health_percent
    if health <= health_stages[self.stage] then
        self:lightning_strike()
    end
end


HalescourgeDebuff.lightning_strike = function(self)

    local position = Unit.local_position(self.unit, 0)
    local world = self.world
    local wwise_world = Wwise.wwise_world(world)
    local fx = "fx/magic_wind_heavens_lightning_strike_01"

    local particle_id = World.create_particles(world, fx, position)
    local sound_id = WwiseWorld.trigger_event(wwise_world, "Play_mutator_enemy_split_large", self.unit)
    self.stage = self.stage + 1
end

HalescourgeDebuff.destroy = function(self)
    mod.halescourge_boss_debuff = nil
    return
end
