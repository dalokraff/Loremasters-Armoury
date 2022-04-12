local mod = get_mod("Loremasters-Armoury")
mod:dofile("scripts/mods/Loremasters-Armoury/skin_list")
mod:dofile("scripts/mods/Loremasters-Armoury/string_dict")
mod:dofile("scripts/mods/Loremasters-Armoury/utils/funcs")
mod:dofile("scripts/mods/Loremasters-Armoury/utils/hooks")

-- Your mod code goes here.
-- https://vmf-docs.verminti.de

local shield = "units/weapons/player/wpn_emp_gk_shield_05/wpn_emp_gk_shield_05"
local shield_3p = "units/weapons/player/wpn_emp_gk_shield_05/wpn_emp_gk_shield_05_3p"

mod.level_queue = {}
mod.preview_queue = {}
mod.current_skin = {}

local function spawn_package_to_player (package_name)
	local player = Managers.player:local_player()
	local world = Managers.world:world("level_world")
    local unit_spawner = Managers.state.unit_spawner
    local init_data = {}

	if world and player and player.player_unit then
        local player_unit = player.player_unit
    
        local position = Unit.local_position(player_unit, 0) + Vector3(0, 0, 1)
        local rotation = Unit.local_rotation(player_unit, 0)
        local unit_template_name = "interaction_unit"
        local extension_init_data  = {}
        local unit_spawner = Managers.state.unit_spawner
        local unit = unit_spawner:spawn_local_unit(package_name)--World.spawn_unit(world, package_name, position, rotation)

        mod:chat_broadcast(#NetworkLookup.inventory_packages + 1)
        mod:echo(Unit.world_position(unit, 0))
        return unit
	end
  
	return nil
end


mod:command("gk_shield", "", function()
    Managers.package:load(shield_3p, "global")
    local unit = spawn_package_to_player(shield_3p)
end)

mod:command("gk_shield_2", "", function()
    local unit = spawn_package_to_player("units/shield")
end)

mod:command("gk_shield_swap_textures", "", function()
    local diff_slot = "texture_map_c0ba2942" 
    local pack_slot = "texture_map_0205ba86"
    local norm_slot = "texture_map_59cd86b9"

    local diff = "textures/Kruber_Grail_Knight_shield02/Kruber_Grail_Knight_Bastonne02_diffuse"
    local MAB = "textures/Kruber_Grail_Knight_shield02/Kruber_Grail_Knight_shield02_combined"
    local norm = "textures/Kruber_Grail_Knight_shield02/Kruber_Grail_Knight_shield02_normal"

    local world = Managers.world:world("level_world")

    local units = World.units_by_resource(world, shield)
    for _,unit in pairs(units) do 
        
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            local mesh = Unit.mesh(unit, i)
            local num_mats = Mesh.num_materials(mesh)
            for j = 0, num_mats - 1, 1 do
                local mat = Mesh.material(mesh, j)
                Material.set_texture(mat, diff_slot, diff)
                Material.set_texture(mat, pack_slot, MAB)
                Material.set_texture(mat, norm_slot, norm)
                Unit.set_data(unit, "diff_map", diff)
                Unit.set_data(unit, "MAB_map", MAB)
                Unit.set_data(unit, "norm_map", norm)
            end
        end
        print(Unit.get_data(unit,"diff_map"))
    end

    local units = World.units_by_resource(world, shield_3p)
    for _,unit in pairs(units) do 
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            local mesh = Unit.mesh(unit, i)
            local num_mats = Mesh.num_materials(mesh)
            for j = 0, num_mats - 1, 1 do
                local mat = Mesh.material(mesh, j)
                Material.set_texture(mat, diff_slot, diff)
                Material.set_texture(mat, pack_slot, MAB)
                Material.set_texture(mat, norm_slot, norm)
            end
        end
    end

end)


mod:command("gk_shield_compare", "", function()
    Managers.package:load(shield_3p, "global")
    local diff_slot = "texture_map_c0ba2942" 
    local pack_slot = "texture_map_0205ba86"
    local norm_slot = "texture_map_59cd86b9"

    local diff1 = "textures/Kruber_Grail_Knight_shield02/default"
    local diff2 = "textures/Kruber_Grail_Knight_shield02/default_reinhard"
    local diff3 = "textures/Kruber_Grail_Knight_shield02/custom"
    local diff4 = "textures/Kruber_Grail_Knight_shield02/custom_reinhard"

    local world = Managers.world:world("level_world")


    local player = Managers.player:local_player()
	local world = Managers.world:world("level_world")
    local unit_spawner = Managers.state.unit_spawner
    local init_data = {}

	
    local player_unit = player.player_unit
    
    local position = Unit.local_position(player_unit, 0) + Vector3(0, 0, 1)
    local rotation = Unit.local_rotation(player_unit, 0)
    local unit_template_name = "interaction_unit"
    local extension_init_data  = {}
        
    local unit = World.spawn_unit(world, shield_3p, position, rotation)
    local num_meshes = Unit.num_meshes(unit)
    for i = 0, num_meshes - 1, 1 do
        local mesh = Unit.mesh(unit, i)
        local num_mats = Mesh.num_materials(mesh)
        for j = 0, num_mats - 1, 1 do
            local mat = Mesh.material(mesh, j)
            Material.set_texture(mat, diff_slot, diff1) 
        end
    end

    local position = Unit.local_position(player_unit, 0) + Vector3(1, 0, 1)
    local unit = World.spawn_unit(world, shield_3p, position, rotation)
    local num_meshes = Unit.num_meshes(unit)
    for i = 0, num_meshes - 1, 1 do
        local mesh = Unit.mesh(unit, i)
        local num_mats = Mesh.num_materials(mesh)
        for j = 0, num_mats - 1, 1 do
            local mat = Mesh.material(mesh, j)
            Material.set_texture(mat, diff_slot, diff2) 
        end
    end

    local position = Unit.local_position(player_unit, 0) + Vector3(2, 0, 1)
    local unit = World.spawn_unit(world, shield_3p, position, rotation)
    local num_meshes = Unit.num_meshes(unit)
    for i = 0, num_meshes - 1, 1 do
        local mesh = Unit.mesh(unit, i)
        local num_mats = Mesh.num_materials(mesh)
        for j = 0, num_mats - 1, 1 do
            local mat = Mesh.material(mesh, j)
            Material.set_texture(mat, diff_slot, diff3) 
        end
    end

    local position = Unit.local_position(player_unit, 0) + Vector3(3, 0, 1)
    local unit = World.spawn_unit(world, shield_3p, position, rotation)
    local num_meshes = Unit.num_meshes(unit)
    for i = 0, num_meshes - 1, 1 do
        local mesh = Unit.mesh(unit, i)
        local num_mats = Mesh.num_materials(mesh)
        for j = 0, num_mats - 1, 1 do
            local mat = Mesh.material(mesh, j)
            Material.set_texture(mat, diff_slot, diff4) 
        end
    end

    local position = Unit.local_position(player_unit, 0) + Vector3(4, 0, 1)
    local unit = World.spawn_unit(world, shield_3p, position, rotation)

end)


mod:command("gk_shield_swap_diffuse_textures", "", function()
    local diff_slot = "texture_map_c0ba2942" 
    local pack_slot = "texture_map_0205ba86"
    local norm_slot = "texture_map_59cd86b9"

    local diff = "textures/Kruber_Grail_Knight_shield02/Kruber_Grail_Knight_Bastonne02_diffuse"
    local MAB = "textures/Kruber_Grail_Knight_shield02/Kruber_Grail_Knight_shield02_combined"
    local norm = "textures/Kruber_Grail_Knight_shield02/Kruber_Grail_Knight_shield02_normal"

    local world = Managers.world:world("level_world")

    local units = World.units_by_resource(world, shield)
    for _,unit in pairs(units) do 
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            local mesh = Unit.mesh(unit, i)
            local num_mats = Mesh.num_materials(mesh)
            for j = 0, num_mats - 1, 1 do
                local mat = Mesh.material(mesh, j)
                Material.set_texture(mat, diff_slot, diff)
                -- Material.set_texture(mat, pack_slot, MAB)
                -- Material.set_texture(mat, norm_slot, norm)
                Unit.set_data(unit, "diff_map", diff)
                -- Unit.set_data(unit, "MAB_map", MAB)
                -- Unit.set_data(unit, "norm_map", norm)
            end
        end
        print(Unit.get_data(unit,"diff_map"))
    end

    local units = World.units_by_resource(world, shield_3p)
    for _,unit in pairs(units) do 
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            local mesh = Unit.mesh(unit, i)
            local num_mats = Mesh.num_materials(mesh)
            for j = 0, num_mats - 1, 1 do
                local mat = Mesh.material(mesh, j)
                Material.set_texture(mat, diff_slot, diff)
                -- Material.set_texture(mat, pack_slot, MAB)
                -- Material.set_texture(mat, norm_slot, norm)
            end
        end
    end

end)


function mod.update()
    local flush_preview = false
    local flush_level = false

    for skin,_ in pairs(mod.SKIN_CHANGED) do
        if Managers.world:has_world("level_world") then
            local Armoury_key = mod:get(skin)
            mod.re_apply_illusion(Armoury_key, skin)
        end
    end
    for unit,tisch in pairs(mod.level_queue) do
        if Managers.world:has_world("level_world") then
            local world = Managers.world:world("level_world")
            local Armoury_key = tisch.Armoury_key
            local skin = tisch.skin
            mod.SKIN_LIST[Armoury_key].swap_skin = skin or mod.SKIN_LIST[Armoury_key].swap_skin
            mod.apply_new_skin_from_texture(Armoury_key, world, skin, unit)
            flush_level = true
        end  
    end
    for unit,tisch in pairs(mod.preview_queue) do
        if Managers.world:has_world("character_preview") then
            local world = Managers.world:world("character_preview")
            local Armoury_key = tisch.Armoury_key
            local skin = tisch.skin
            mod.SKIN_LIST[Armoury_key].swap_skin = skin or mod.SKIN_LIST[Armoury_key].swap_skin
            mod.apply_new_skin_from_texture(Armoury_key, world, skin, unit)
            flush_preview = true
        end
    end

    if flush_level then 
        mod.level_queue = {}
    end
    if flush_preview then 
        mod.preview_queue = {}
    end
    
    
end