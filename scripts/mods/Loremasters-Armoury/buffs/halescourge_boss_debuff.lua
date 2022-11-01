local mod = get_mod("Loremasters-Armoury")

HalescourgeDebuff = class(HalescourgeDebuff)


local health_stages = {
    0.95,
    0.6,
    0.5,
    0.1,
}

local lighting_delays = {
    2.22,
    1.27,
    nil,
    1.32,
}

local incantation_sounds = {
    "LA_magic_effect_01_sound",
    "LA_magic_effect_02_sound",
    nil,
    "LA_magic_effect_03_sound",
}

HalescourgeDebuff.init = function (self, unit)
    self.current_time = 0
    self.wait_time = 999999
    self.world = Managers.world:world("level_world")
    self.HealthExtension = ScriptUnit.extension(unit, "health_system")
    -- self.bb = blackboard
    -- self.unit = blackboard.unit
    self.unit = unit
    self.is_server = Managers.player.is_server

    self.playing = false

    self.stage = 1

end

HalescourgeDebuff.update = function (self, dt)
    self.current_time = self.current_time + dt
    self:health_check()
    
    if self.current_time >= self.wait_time then
        self:lightning_strike()
    end
    
    if not Unit.alive(self.unit) then
        self:destroy()
    end
    if self.stage >= 5 then
        self:destroy()
    end
    
end

HalescourgeDebuff.health_check = function(self)
    -- local health = self.bb.current_health_percent
    local health = self.HealthExtension:current_health_percent()
    if health <= health_stages[self.stage] and not self.playing then
        self:play_incantation()
    end
end

HalescourgeDebuff.play_incantation = function(self)
    local sound = incantation_sounds[self.stage]
    if sound then
        local wwise_world = Wwise.wwise_world(self.world)
        WwiseWorld.trigger_event(wwise_world, sound)
        local delay = lighting_delays[self.stage]
        if delay then
            self.wait_time = delay + self.current_time
            self.playing = true
        end
    else
        self:lightning_strike()
    end

end

HalescourgeDebuff.lightning_strike = function(self)
    local player = Managers.player:local_player()
    local player_unit = player.player_unit
    local unit = self.unit
    local position = Unit.local_position(unit, 0)
    local rotation = Unit.local_rotation(unit, 0)
    local attacker_unit_id = Managers.state.unit_storage:go_id(player_unit)
    local explosion_template_id = NetworkLookup.explosion_templates["lightning_strike_twitch"]
    local explosion_template = ExplosionTemplates["lightning_strike_twitch"]
    local damage_source = "buff"
    local damage_source_id = NetworkLookup.damage_sources[damage_source]
    local is_husk = true
    local world = Managers.world:world("level_world")

    ExplosionTemplates.lightning_strike_twitch.explosion.sound_event_name = "LA_lightning_strike_01_sound"

    if Managers.player.is_server then
		Managers.state.network.network_transmit:send_rpc_clients("rpc_create_explosion", attacker_unit_id, false, 
            position, Quaternion.identity(), explosion_template_id, 1, damage_source_id, 600, false, attacker_unit_id)
        Managers.state.network.network_transmit:send_rpc_server("rpc_create_explosion", attacker_unit_id, false, 
            position, Quaternion.identity(), explosion_template_id, 1, damage_source_id, 600, false, attacker_unit_id)
	else
		Managers.state.network.network_transmit:send_rpc_server("rpc_create_explosion", attacker_unit_id, false, 
            position, Quaternion.identity(), explosion_template_id, 1, damage_source_id, 600, false, attacker_unit_id)
        DamageUtils.create_explosion(world, player_unit, position, rotation, explosion_template, 1, 
            damage_source, false, is_husk, unit, 600, false, player_unit)
	end

    self:update_stage()

end

HalescourgeDebuff.update_stage = function(self)
    self.stage = self.stage + 1
    self.playing = false
    self.wait_time = 999999
end

HalescourgeDebuff.destroy = function(self)
    mod.halescourge_boss_debuff = nil
    ExplosionTemplates.lightning_strike_twitch.explosion.sound_event_name = "Play_mutator_enemy_split_large"
    return
end
