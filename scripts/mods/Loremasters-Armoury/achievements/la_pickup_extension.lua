local mod = get_mod("Loremasters-Armoury")

LaPickupExtension = class(LaPickupExtension)

LaPickupExtension.init = function (self, unit)
    self.unit = unit
    Unit.set_unit_visibility(self.unit, false)
    self:spawn_visable_unit()
    self:link_units()
end

LaPickupExtension.spawn_visable_unit = function(self)
    local unit = self.unit
    local unit_name = Unit.get_data(unit, "unit_name")
    local position = POSITION_LOOKUP[unit]
    local rotation = Unit.local_rotation(unit, 0)
    self.visable_unit = Managers.state.unit_spawner:spawn_local_unit(unit_name, position, rotation)
end

LaPickupExtension.link_units = function(self)
    local world = Managers.world:world("level_world")
    World.link_unit(world, self.visable_unit, self.unit, 0 )
end

LaPickupExtension.update = function (self, dt)

end

LaPickupExtension.destroy = function(self)
    Managers.state.unit_spawner:mark_for_deletion(self.visable_unit)
    Managers.state.unit_spawner:mark_for_deletion(self.unit)
    LA_PICKUPS[self.unit] = nil
    return
end
