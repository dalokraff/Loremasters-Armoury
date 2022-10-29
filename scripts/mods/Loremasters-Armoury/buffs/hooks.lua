local mod = get_mod("Loremasters-Armoury")
mod:dofile("scripts/mods/Loremasters-Armoury/buffs/halescourge_boss_debuff")

mod:hook_safe(BTSpawningAction,"enter", function (self, unit, blackboard, t)
    local bb = blackboard
    if blackboard.breed then
        if blackboard.breed.name == "chaos_exalted_sorcerer" then
            local current_level_key = Managers.level_transition_handler:get_current_level_keys()
            if current_level_key == "ground_zero" then
                mod.halescourge_boss_debuff = HalescourgeDebuff:new(blackboard)
            end
        end
    end
end)