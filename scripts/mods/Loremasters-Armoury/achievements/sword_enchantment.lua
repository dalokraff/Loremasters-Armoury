local mod = get_mod("Loremasters-Armoury")

local function radians_to_quaternion(theta, ro, phi)
    local c1 =  math.cos(theta/2)
    local c2 = math.cos(ro/2)
    local c3 = math.cos(phi/2)
    local s1 = math.sin(theta/2)
    local s2 = math.sin(ro/2)
    local s3 = math.sin(phi/2)
    local x = (s1*s2*c3) + (c1*c2*s3)
    local y = (s1*c2*c3) + (c1*s2*s3)
    local z = (c1*s2*c3) - (s1*c2*s3)
    local w = (c1*c2*c3) - (s1*s2*s3)
    local rot = Quaternion.from_elements(x, y, z, w)
    return rot
end


SwordEnchantment = class(SwordEnchantment)

SwordEnchantment.init = function (self, world)
    self.current_time = 0
    self.wait_time = 0
    self.world = world
    self.wwise_world = Wwise.wwise_world(world)
    
    local position = Vector3(4.8, -9.15, -2.0437)
    local rotation = radians_to_quaternion(0, math.pi/16, 0)
    self.scroll_unit = Managers.state.unit_spawner:spawn_local_unit("units/pickups/Loremaster_magicscroll_mesh", position, rotation)
    Unit.set_local_scale(self.scroll_unit, 0, Vector3(0.75, 0.75, 0.75))

    self.sword_unit = mod.sword_unit

    
    self.wait = self:play_enchanting_sound()

    self.stage = "stage_one"
    
end

SwordEnchantment.update = function (self, dt)
    self.current_time = self.current_time + dt
    
    if self.current_time >= self.wait_time then
        local stage = self[self.stage]
        stage(self)
    end
end

SwordEnchantment.stage_one = function(self)
    
    WwiseWorld.trigger_event(self.wwise_world, "Loremaster_enchanting_sound")    
    self.wait_time = self.current_time + 7
    self.stage = "stage_two"
end

SwordEnchantment.stage_two = function(self)
    self:update_scroll()
    self:update_sword()
    self.stage = "stage_three"
    self.wait_time = self.current_time + 1
end

SwordEnchantment.stage_three = function(self)
    
    mod.show_reward = "main_quest_reward"
    self:destroy()
end

SwordEnchantment.play_enchanting_sound = function(self)
    WwiseWorld.trigger_event(self.wwise_world, "Loremaster_scroll_place_sound")    
    self.wait_time = self.current_time + 1
end

SwordEnchantment.update_scroll = function(self)
    local scroll_unit = self.scroll_unit
    if Unit.alive(scroll_unit) then
        local position = Unit.local_position(scroll_unit, 0)
        local rotation = Unit.local_rotation(scroll_unit, 0)
        self.scroll_unit = Managers.state.unit_spawner:spawn_local_unit("units/pickups/Loremaster_magicscroll_used_mesh", position, rotation)
        Unit.set_local_scale(self.scroll_unit, 0, Vector3(0.75, 0.75, 0.75))
        POSITION_LOOKUP[scroll_unit] = nil
        mod.marker_list[scroll_unit] = nil
        World.destroy_unit(self.world, scroll_unit)
    end
end

SwordEnchantment.update_sword = function(self)
    local sword_unit = self.sword_unit
    if Unit.alive(sword_unit) then
        local position = Unit.local_position(sword_unit, 0)
        local rotation = Unit.local_rotation(sword_unit, 0)
        self.sword_unit = Managers.state.unit_spawner:spawn_local_unit("units/empire_sword/Kruber_KOTBS_empire_sword_01_mesh_gold_3p", position, rotation)                       
        if Unit.has_data(self.sword_unit, "use_vanilla_glow") then
            local glow = Unit.get_data(self.sword_unit, "use_vanilla_glow")
            GearUtils.apply_material_settings(self.sword_unit, WeaponMaterialSettingsTemplates[glow])
        end
        POSITION_LOOKUP[sword_unit] = nil
        World.destroy_unit(self.world, sword_unit)
    end
end

SwordEnchantment.destroy = function(self)
    self.current_time = -99999
    self.wait_time = 99999
    mod.sword_ritual = nil
    
    return
end
