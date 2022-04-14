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





local function spawn_package_to_player (package_name, offset)
	local player = Managers.player:local_player()
	local world = Managers.world:world("level_world")
  
	if world and player and player.player_unit then
	  local player_unit = player.player_unit
  
        local pos_off = offset or 0
	  local position = Unit.local_position(player_unit, 0) + Vector3(0, 0+offset, 1)
	  local rotation = Unit.local_rotation(player_unit, 0)
	  local unit = World.spawn_unit(world, package_name, position, rotation)
  
	  mod:chat_broadcast(#NetworkLookup.inventory_packages + 1)
	  return unit
	end
  
	return nil
end

mod:command("HM_hat", "", function()
    local package = "units/beings/player/way_watcher_maiden_guard/headpiece/ww_mg_hat_15"
    local diff_slot = "texture_map_c0ba2942"
    local diff = "textures/Kerillian_Ellyrion_helm_base/Kerillian_Ellyrion_helm_base_diffuse"
    local diff_mask = "textures/Kerillian_Ellyrion_helm_base/Ellyrion_helm_mask_diffuse"
    local world = Managers.world:world("level_world")
    local units = World.units_by_resource(world, package)
    for _,unit in pairs(units) do 
        local num_meshes = Unit.num_meshes(unit)
        mod:echo(num_meshes)
        for i = 0, num_meshes - 1, 1 do
            if i < 6 or i >= 9 then  
                local mesh = Unit.mesh(unit, i)
                local num_mats = Mesh.num_materials(mesh)
                for j = 0, num_mats - 1, 1 do
                    local mat = Mesh.material(mesh, j)
                    Material.set_texture(mat, diff_slot, diff)
                end
            elseif i >= 6 or i < 9 then
                local mesh = Unit.mesh(unit, i)
                local num_mats = Mesh.num_materials(mesh)
                for j = 0, num_mats - 1, 1 do
                    local mat = Mesh.material(mesh, j)
                    Material.set_texture(mat, diff_slot, diff_mask)
                end
            end
        end
    end
end)

mod:command("HM_hat_2", "", function()
    local package = "units/beings/player/way_watcher_maiden_guard/headpiece/ww_mg_hat_15"
    local diff_slot = "texture_map_c0ba2942"
    local diff = "textures/Kerillian_Ellyrion_helm_base/Kerillian_Ellyrion_helm_base_diffuse_3"
    local diff_mask = "textures/Kerillian_Ellyrion_helm_base/Ellyrion_helm_mask_diffuse"
    local world = Managers.world:world("level_world")
    local units = World.units_by_resource(world, package)
    for _,unit in pairs(units) do 
        local num_meshes = Unit.num_meshes(unit)
        mod:echo(num_meshes)
        for i = 0, num_meshes - 1, 1 do
            if i < 6 or i >= 9 then  
                local mesh = Unit.mesh(unit, i)
                local num_mats = Mesh.num_materials(mesh)
                for j = 0, num_mats - 1, 1 do
                    local mat = Mesh.material(mesh, j)
                    Material.set_texture(mat, diff_slot, diff)
                end
            elseif i >= 6 or i < 9 then
                local mesh = Unit.mesh(unit, i)
                local num_mats = Mesh.num_materials(mesh)
                for j = 0, num_mats - 1, 1 do
                    local mat = Mesh.material(mesh, j)
                    Material.set_texture(mat, diff_slot, diff_mask)
                end
            end
        end
    end
end)

mod:command("HM_hat_3", "", function()
    local package = "units/beings/player/way_watcher_maiden_guard/headpiece/ww_mg_hat_15"
    local diff_slot = "texture_map_c0ba2942"
    local diff = "textures/Kerillian_Ellyrion_helm_base/Kerillian_Ellyrion_helm_base_diffuse_3"
    local diff_mask = "textures/Kerillian_Ellyrion_helm_base/Ellyrion_helm_mask_diffuse"
    local world = Managers.world:world("level_world")
    local units = World.units_by_resource(world, package)
    for _,unit in pairs(units) do 
        local num_meshes = Unit.num_meshes(unit)
        mod:echo(num_meshes)
        for i = 0, num_meshes - 1, 1 do
            if i < 6 or i >= 9 then  
                local mesh = Unit.mesh(unit, i)
                local num_mats = Mesh.num_materials(mesh)
                for j = 0, num_mats - 1, 1 do
                    local mat = Mesh.material(mesh, j)
                    Material.set_texture(mat, diff_slot, diff)
                end
            elseif i >= 6 or i < 9 then
                local mesh = Unit.mesh(unit, i)
                local num_mats = Mesh.num_materials(mesh)
                for j = 0, num_mats - 1, 1 do
                    local mat = Mesh.material(mesh, j)
                    Material.set_texture(mat, diff_slot, diff_mask)
                end
            end
        end
    end
end)

mod.units = {}
mod:command("HM_hat_compare", "", function()
    local package = "units/beings/player/way_watcher_maiden_guard/headpiece/ww_mg_hat_15"
    local unit1 = spawn_package_to_player(package, 0)
    local unit2 = spawn_package_to_player(package, 1)
    local unit3 = spawn_package_to_player(package, 2)
    local unit4 = spawn_package_to_player(package, 3)
    
    mod.units[unit1] = {
        diff_slot = "texture_map_c0ba2942",
        diff = nil,
        diff_mask = "textures/Kerillian_Ellyrion_helm_base/Ellyrion_helm_mask_diffuse",
    }
    mod.units[unit2] = {
        diff_slot = "texture_map_c0ba2942",
        diff = "textures/Kerillian_Ellyrion_helm_base/Kerillian_Ellyrion_helm_base_diffuse",
        diff_mask = "textures/Kerillian_Ellyrion_helm_base/Ellyrion_helm_mask_diffuse",
    }
    mod.units[unit3] = {
        diff_slot = "texture_map_c0ba2942",
        diff = "textures/Kerillian_Ellyrion_helm_base/Kerillian_Ellyrion_helm_base_diffuse_2",
        diff_mask = "textures/Kerillian_Ellyrion_helm_base/Ellyrion_helm_mask_diffuse",
    }
    mod.units[unit4] = {
        diff_slot = "texture_map_c0ba2942",
        diff = "textures/Kerillian_Ellyrion_helm_base/Kerillian_Ellyrion_helm_base_diffuse_3",
        diff_mask = "textures/Kerillian_Ellyrion_helm_base/Ellyrion_helm_mask_diffuse",
    }
    for unit,data in pairs(mod.units) do 
        local num_meshes = Unit.num_meshes(unit)
        mod:echo(num_meshes)
        for i = 0, num_meshes - 1, 1 do
            if data.diff then
                if i < 6 or i >= 9  then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, data.diff_slot, data.diff)
                    end
                elseif i >= 6 or i < 9 then
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, data.diff_slot, data.diff_mask)
                    end
                end
            end
        end
    end
end)

mod:command("HM_hat_del", "", function()
    local world = Managers.world:world("level_world") 
    for unit,_ in pairs(mod.units) do 
        World.destroy_unit(world, unit)
    end
end)