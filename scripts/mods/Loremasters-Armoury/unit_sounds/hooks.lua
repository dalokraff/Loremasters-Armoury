local mod = get_mod("Loremasters-Armoury")

local unit_sound_map = require("scripts/mods/Loremasters-Armoury/unit_sounds/unit_sound_map")

mod:hook_safe(WeaponUnitExtension,'on_wield', function (self, ...)
    -- local tps_unit = self.owner_unit
    -- local unit = self.unit
    -- if Unit.alive(tps_unit) then
    --     local mod_skins = mod.current_skin
    --     local career_extension = ScriptUnit.extension(tps_unit, "career_system")
    --     if career_extension then
    --         local career_name = career_extension:career_name()
            
    --         local inventory_extension = ScriptUnit.extension(tps_unit, "inventory_system")
    --         local slot_data = inventory_extension:get_wielded_slot_data()
    --         local left_hand =  slot_data.left_hand_unit_name
    --         local right_hand = slot_data.right_hand_unit_name

    --         if right_hand then
    --             if unit_sound_map[right_hand] then
    --                 Unit.set_data(tps_unit, "LA_unit_wielded", right_hand)
    --             end
    --         elseif not left_hand then
    --             Unit.set_data(tps_unit, "LA_unit_wielded", nil)
    --         end

    --         if left_hand then
    --             if unit_sound_map[left_hand] then
    --                 Unit.set_data(tps_unit, "LA_unit_wielded", left_hand)
    --             end
    --         elseif not right_hand then
    --             Unit.set_data(tps_unit, "LA_unit_wielded", nil)
    --         end
    --     end
        
    -- end
end)