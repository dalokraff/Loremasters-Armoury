local mod = get_mod("Loremasters-Armoury")
mod:dofile("scripts/mods/Loremasters-Armoury/utils/hooks")

-- Your mod code goes here.
-- https://vmf-docs.verminti.de

--thesse tables are used as queues that get filled and flushed as skins and their respective units are changed
mod.level_queue = {}
mod.preview_queue = {}
mod.current_skin = {}


--on mod update:
--the level_queue and previe_queue are checked to see if the respective worlds have any units that need to be retextured
--the SKIN_CHANGED table is updated with info from the vmf menu about which skins are currently being used by which weapons
function mod.update()
    local flush_preview = false
    local flush_level = false

    for skin,tisch in pairs(mod.SKIN_CHANGED) do
        if Managers.world:has_world("level_world") then
            local Armoury_key = mod:get(skin)
            mod.re_apply_illusion(Armoury_key, skin, tisch.unit)
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
            if Armoury_key ~= "default" and mod.SKIN_LIST[Armoury_key] then
                mod.SKIN_LIST[Armoury_key].swap_skin = skin or mod.SKIN_LIST[Armoury_key].swap_skin
                mod.apply_new_skin_from_texture(Armoury_key, world, skin, unit)
            end
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

local function spawn_package_to_player (package_name, hieght, offset)
	local player = Managers.player:local_player()
	local world = Managers.world:world("level_world")
  
	if world and player and player.player_unit then
	  local player_unit = player.player_unit
  
        local pos_off = offset or 0
	  local position = Unit.local_position(player_unit, 0) + Vector3(0, 0+offset, hieght)
	  local rotation = Unit.local_rotation(player_unit, 0)
	  local unit = World.spawn_unit(world, package_name, position, rotation)
  
	  mod:chat_broadcast(#NetworkLookup.inventory_packages + 1)
	  return unit
	end
  
	return nil
end


mod:command("GK_hat2", "", function()
    local package = "units/beings/player/empire_soldier_breton/headpiece/es_gk_hat_02"
    -- local skin_package = "units/beings/player/empire_soldier_knight/skins/black_and_gold/chr_empire_soldier_knight_black_and_gold"
    -- local skin_mtr = "units/beings/player/empire_soldier_knight/skins/black_and_gold/mtr_outfit_black_and_gold"

    local diff_slot = "texture_map_c0ba2942"
    local norm_slot = "texture_map_59cd86b9"
    local comb_slot = "texture_map_0205ba86"

    Managers.package:load(package, "global")
    -- Managers.package:load(skin_package, "global")

    local unit0 = spawn_package_to_player(package,1,-1)
    -- Unit.set_material(unit0, "mtr_outfit",skin_mtr)

    local unit1 = spawn_package_to_player(package,1,0)
    -- Unit.set_material(unit1, "mtr_outfit",skin_mtr)

    local unit2 = spawn_package_to_player(package,1,1)
    -- Unit.set_material(unit2, "mtr_outfit",skin_mtr)

    local unit3 = spawn_package_to_player(package,1,2)
    -- Unit.set_material(unit3, "mtr_outfit",skin_mtr)

    local tisch = {}

    tisch[unit1] = {
        diff = 'textures/GK_PURE_HAT/one/diff',
        norm = 'textures/GK_PURE_HAT/one/norm',
        comb = 'textures/GK_PURE_HAT/one/comb',
    }
    tisch[unit2] = {
        diff = 'textures/GK_PURE_HAT/two/diff',
        norm = 'textures/GK_PURE_HAT/two/norm',
        comb = 'textures/GK_PURE_HAT/two/comb',
    }
    tisch[unit3] = {
        diff = 'textures/GK_PURE_HAT/three/diff',
        norm = 'textures/GK_PURE_HAT/three/norm',
        comb = 'textures/GK_PURE_HAT/three/comb',
    }
    
    for unit,textures in pairs(tisch) do
        local num_meshes = Unit.num_meshes(unit)
        mod:echo(num_meshes)
        for i = 0, num_meshes - 1, 1 do
            if textures then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, diff_slot, textures.diff)
                        Material.set_texture(mat, norm_slot, textures.norm)
                        Material.set_texture(mat, comb_slot, textures.comb)
                        
                    end
                elseif false then
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, diff_slot, textures.diff)
                        Material.set_texture(mat, norm_slot, textures.norm)
                        Material.set_texture(mat, comb_slot, textures.comb)
                    end
                end
            end
        end
    end

end)

mod:command("GK_swap_hat1_02", "", function()
    local world = Managers.world:world("level_world")
    local unit_path = "units/beings/player/empire_soldier_breton/headpiece/es_gk_hat_02"
    local diff = 'textures/GK_PURE_HAT/one/diff'
    local norm = 'textures/GK_PURE_HAT/one/norm'
    local comb = 'textures/GK_PURE_HAT/one/comb'
    local diff_slot = "texture_map_c0ba2942"
    local norm_slot = "texture_map_59cd86b9"
    local comb_slot = "texture_map_0205ba86"
    local units = World.units_by_resource(world, unit_path)
    for _,unit in pairs(units) do 
        local num_meshes = Unit.num_meshes(unit)
        mod:echo(num_meshes)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, diff_slot, diff)
                        Material.set_texture(mat, norm_slot, norm)
                        Material.set_texture(mat, comb_slot, comb)
                        
                    end
                elseif false then
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, diff_slot, diff)
                        Material.set_texture(mat, norm_slot, norm)
                        Material.set_texture(mat, comb_slot, comb)
                    end
                end
            end
        end
    end
end)
mod:command("GK_swap_hat2_02", "", function()
    local world = Managers.world:world("level_world")
    local unit_path = "units/beings/player/empire_soldier_breton/headpiece/es_gk_hat_02"
    local diff = 'textures/GK_PURE_HAT/two/diff'
    local norm = 'textures/GK_PURE_HAT/two/norm'
    local comb = 'textures/GK_PURE_HAT/two/comb'
    local diff_slot = "texture_map_c0ba2942"
    local norm_slot = "texture_map_59cd86b9"
    local comb_slot = "texture_map_0205ba86"
    local units = World.units_by_resource(world, unit_path)
    for _,unit in pairs(units) do 
        local num_meshes = Unit.num_meshes(unit)
        mod:echo(num_meshes)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, diff_slot, diff)
                        Material.set_texture(mat, norm_slot, norm)
                        Material.set_texture(mat, comb_slot, comb)
                        
                    end
                elseif false then
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, diff_slot, diff)
                        Material.set_texture(mat, norm_slot, norm)
                        Material.set_texture(mat, comb_slot, comb)
                    end
                end
            end
        end
    end
end)
mod:command("GK_swap_hat3_02", "", function()
    local world = Managers.world:world("level_world")
    local unit_path = "units/beings/player/empire_soldier_breton/headpiece/es_gk_hat_02"
    local diff = 'textures/GK_PURE_HAT/three/diff'
    local norm = 'textures/GK_PURE_HAT/three/norm'
    local comb = 'textures/GK_PURE_HAT/three/comb'
    local diff_slot = "texture_map_c0ba2942"
    local norm_slot = "texture_map_59cd86b9"
    local comb_slot = "texture_map_0205ba86"
    local units = World.units_by_resource(world, unit_path)
    for _,unit in pairs(units) do 
        local num_meshes = Unit.num_meshes(unit)
        mod:echo(num_meshes)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, diff_slot, diff)
                        Material.set_texture(mat, norm_slot, norm)
                        Material.set_texture(mat, comb_slot, comb)
                        
                    end
                elseif false then
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, diff_slot, diff)
                        Material.set_texture(mat, norm_slot, norm)
                        Material.set_texture(mat, comb_slot, comb)
                    end
                end
            end
        end
    end
end)

mod:command("GK_hat3", "", function()
    local package = "units/beings/player/empire_soldier_breton/headpiece/es_gk_hat_03"
    -- local skin_package = "units/beings/player/empire_soldier_knight/skins/black_and_gold/chr_empire_soldier_knight_black_and_gold"
    -- local skin_mtr = "units/beings/player/empire_soldier_knight/skins/black_and_gold/mtr_outfit_black_and_gold"

    local diff_slot = "texture_map_c0ba2942"
    local norm_slot = "texture_map_59cd86b9"
    local comb_slot = "texture_map_0205ba86"

    Managers.package:load(package, "global")
    -- Managers.package:load(skin_package, "global")

    local unit0 = spawn_package_to_player(package,1,-1)
    -- Unit.set_material(unit0, "mtr_outfit",skin_mtr)

    local unit1 = spawn_package_to_player(package,1,0)
    -- Unit.set_material(unit1, "mtr_outfit",skin_mtr)

    local unit2 = spawn_package_to_player(package,1,1)
    -- Unit.set_material(unit2, "mtr_outfit",skin_mtr)

    local unit3 = spawn_package_to_player(package,1,2)
    -- Unit.set_material(unit3, "mtr_outfit",skin_mtr)

    local tisch = {}

    tisch[unit1] = {
        diff = 'textures/GK_HIPPO_HAT/one/diff',
        norm = 'textures/GK_HIPPO_HAT/one/norm',
        comb = 'textures/GK_HIPPO_HAT/one/comb',
    }
    tisch[unit2] = {
        diff = 'textures/GK_HIPPO_HAT/two/diff',
        norm = 'textures/GK_HIPPO_HAT/two/norm',
        comb = 'textures/GK_HIPPO_HAT/two/comb',
    }
    tisch[unit3] = {
        diff = 'textures/GK_HIPPO_HAT/three/diff',
        norm = 'textures/GK_HIPPO_HAT/three/norm',
        comb = 'textures/GK_HIPPO_HAT/three/comb',
    }
    
    for unit,textures in pairs(tisch) do
        local num_meshes = Unit.num_meshes(unit)
        mod:echo(num_meshes)
        for i = 0, num_meshes - 1, 1 do
            if textures then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, diff_slot, textures.diff)
                        Material.set_texture(mat, norm_slot, textures.norm)
                        Material.set_texture(mat, comb_slot, textures.comb)
                        
                    end
                elseif false then
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, diff_slot, textures.diff)
                        Material.set_texture(mat, norm_slot, textures.norm)
                        Material.set_texture(mat, comb_slot, textures.comb)
                    end
                end
            end
        end
    end

end)

mod:command("GK_swap_hat1_03", "", function()
    local world = Managers.world:world("level_world")
    local unit_path = "units/beings/player/empire_soldier_breton/headpiece/es_gk_hat_03"
    local diff = 'textures/GK_HIPPO_HAT/one/diff'
    local norm = 'textures/GK_HIPPO_HAT/one/norm'
    local comb = 'textures/GK_HIPPO_HAT/one/comb'
    local diff_slot = "texture_map_c0ba2942"
    local norm_slot = "texture_map_59cd86b9"
    local comb_slot = "texture_map_0205ba86"
    local units = World.units_by_resource(world, unit_path)
    for _,unit in pairs(units) do 
        local num_meshes = Unit.num_meshes(unit)
        mod:echo(num_meshes)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, diff_slot, diff)
                        Material.set_texture(mat, norm_slot, norm)
                        Material.set_texture(mat, comb_slot, comb)
                        
                    end
                elseif false then
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, diff_slot, diff)
                        Material.set_texture(mat, norm_slot, norm)
                        Material.set_texture(mat, comb_slot, comb)
                    end
                end
            end
        end
    end
end)
mod:command("GK_swap_hat2_03", "", function()
    local world = Managers.world:world("level_world")
    local unit_path = "units/beings/player/empire_soldier_breton/headpiece/es_gk_hat_03"
    local diff = 'textures/GK_HIPPO_HAT/two/diff'
    local norm = 'textures/GK_HIPPO_HAT/two/norm'
    local comb = 'textures/GK_HIPPO_HAT/two/comb'
    local diff_slot = "texture_map_c0ba2942"
    local norm_slot = "texture_map_59cd86b9"
    local comb_slot = "texture_map_0205ba86"
    local units = World.units_by_resource(world, unit_path)
    for _,unit in pairs(units) do 
        local num_meshes = Unit.num_meshes(unit)
        mod:echo(num_meshes)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, diff_slot, diff)
                        Material.set_texture(mat, norm_slot, norm)
                        Material.set_texture(mat, comb_slot, comb)
                        
                    end
                elseif false then
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, diff_slot, diff)
                        Material.set_texture(mat, norm_slot, norm)
                        Material.set_texture(mat, comb_slot, comb)
                    end
                end
            end
        end
    end
end)
mod:command("GK_swap_hat3_03", "", function()
    local world = Managers.world:world("level_world")
    local unit_path = "units/beings/player/empire_soldier_breton/headpiece/es_gk_hat_03"
    local diff = 'textures/GK_HIPPO_HAT/three/diff'
    local norm = 'textures/GK_HIPPO_HAT/three/norm'
    local comb = 'textures/GK_HIPPO_HAT/three/comb'
    local diff_slot = "texture_map_c0ba2942"
    local norm_slot = "texture_map_59cd86b9"
    local comb_slot = "texture_map_0205ba86"
    local units = World.units_by_resource(world, unit_path)
    for _,unit in pairs(units) do 
        local num_meshes = Unit.num_meshes(unit)
        mod:echo(num_meshes)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, diff_slot, diff)
                        Material.set_texture(mat, norm_slot, norm)
                        Material.set_texture(mat, comb_slot, comb)
                        
                    end
                elseif false then
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, diff_slot, diff)
                        Material.set_texture(mat, norm_slot, norm)
                        Material.set_texture(mat, comb_slot, comb)
                    end
                end
            end
        end
    end
end)



mod:command("Averlorn_Runner_helm", "", function()
    local package = "units/beings/player/way_watcher_maiden_guard/headpiece/ww_mg_hat_12"
    Managers.package:load(package, "global")
    local player = Managers.player:local_player()
    local player_unit = player.player_unit
    local position = Unit.local_position(player_unit, 0) + Vector3(0,0,1)
    local rotation = Unit.local_rotation(player_unit, 0)
    local unit_spawner = Managers.state.unit_spawner
    local unit_template_name = "interaction_unit"
    local extension_init_data = {}
    local unit, go_id = unit_spawner:spawn_local_unit(package, position, rotation)

    local diff = "textures/Kerillian_Wildrunner_helm/Avelorn/Kerillian_Wildrunner_helm_Avelorn_diffuse"
    local norm = "textures/Kerillian_Wildrunner_helm/Avelorn/Kerillian_Wildrunner_helm_Avelorn_normal"
    -- local comb = 'textures/GK_HIPPO_HAT/three/comb'
    local diff_slot = "texture_map_c0ba2942"
    local norm_slot = "texture_map_59cd86b9"
    local comb_slot = "texture_map_0205ba86"

    local num_meshes = Unit.num_meshes(unit)
        mod:echo(num_meshes)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, diff_slot, diff)
                        Material.set_texture(mat, norm_slot, norm)
                        -- Material.set_texture(mat, comb_slot, comb)
                        
                    end
                elseif false then
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, diff_slot, diff)
                        Material.set_texture(mat, norm_slot, norm)
                        -- Material.set_texture(mat, comb_slot, comb)
                    end
                end
            end
        end
end)