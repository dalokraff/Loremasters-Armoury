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
    self.is_server = Managers.player.is_server

    self.stage = 1
    
end

HalescourgeDebuff.update = function (self, dt)
    self:health_check()
    if not Unit.alive(self.unit) then
        self:destroy()
    end
    if self.stage >= 5 then
        self:destroy()
    end
end

HalescourgeDebuff.health_check = function(self)
    local health = self.bb.current_health_percent
    if health <= health_stages[self.stage] then
        self:lightning_strike()
    end
end


HalescourgeDebuff.lightning_strike = function(self)

    
    local player = Managers.player:local_player()
    local player_unit = player.player_unit
    local position = Unit.local_position(self.unit, 0)
    local attacker_unit_id = Managers.state.unit_storage:go_id(player_unit)
    local explosion_template_id = NetworkLookup.explosion_templates["lightning_strike"]
    local damage_source = "buff"
    local damage_source_id = NetworkLookup.damage_sources[damage_source]
    
    if Managers.player.is_server then
		Managers.state.network.network_transmit:send_rpc_clients("rpc_create_explosion", attacker_unit_id, false, 
            position, Quaternion.identity(), explosion_template_id, 1, damage_source_id, 600, false, attacker_unit_id)
        Managers.state.network.network_transmit:send_rpc_server("rpc_create_explosion", attacker_unit_id, false, 
            position, Quaternion.identity(), explosion_template_id, 1, damage_source_id, 600, false, attacker_unit_id)
	else
		Managers.state.network.network_transmit:send_rpc_server("rpc_create_explosion", attacker_unit_id, false, 
            position, Quaternion.identity(), explosion_template_id, 1, damage_source_id, 600, false, attacker_unit_id)
	end

    self.stage = self.stage + 1
end

HalescourgeDebuff.destroy = function(self)
    mod.halescourge_boss_debuff = nil
    return
end
