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



local function spawn_package_to_player (package_name, y,z)
	local player = Managers.player:local_player()
	local world = Managers.world:world("level_world")
    local unit_spawner = Managers.state.unit_spawner
    local init_data = {}
    local material = "units/props/tzeentch/tzeentch_faction_01"

	if world and player and player.player_unit then
        local player_unit = player.player_unit
    
        local position = Unit.local_position(player_unit, 0) + Vector3(0, y, z)
        local rotation = Unit.local_rotation(player_unit, 0)
        local unit_template_name = "interaction_unit"
        local extension_init_data  = {}
        
        --local unit, go_id = unit_spawner:spawn_network_unit(package_name, unit_template_name, extension_init_data, position, rotation, material)
        local unit = World.spawn_unit(world, package_name, position, rotation)

        mod:chat_broadcast(#NetworkLookup.inventory_packages + 1)
        return unit
	end
  
	return nil
end

mod:hook_safe(UnitSpawner, 'spawn_local_unit', function (self, unit_name, position, rotation, material)
    mod:echo(unit_name)
end)

mod.units_to_remove = {}

mod:command("spawn_fall_elf", "", function()
    local pack_hat = "units/beings/player/way_watcher_upgraded/headpiece/ww_u_hat_11"
    local pack_body = "units/beings/player/way_watcher_upgraded_skin_01/third_person_base/chr_third_person_mesh"
    local elf_table = {}
    elf_table[1] = {
        body = "textures/Kerillian_HeraldOfTheWeave_body_Autumn/Kerillian_HeraldOfTheWeave_body_Autumn_diffuse",
        hat = "textures/Kerillian_Evercrown_helm_AutumnHerald/Kerillian_Evercrown_helm_AutumnHerald_diffuse",
    }
    elf_table[2] = {
        body = "textures/Kerillian_HeraldOfTheWeave_body_Autumn/Kerillian_HeraldOfTheWeave_body_Autumn_diffuse2",
        hat = "textures/Kerillian_Evercrown_helm_AutumnHerald/Kerillian_Evercrown_helm_AutumnHerald_diffuse2",
    }
    elf_table[3] = {
        body = "textures/Kerillian_HeraldOfTheWeave_body_Autumn/Kerillian_HeraldOfTheWeave_body_Autumn_diffuse3",
        hat = "textures/Kerillian_Evercrown_helm_AutumnHerald/Kerillian_Evercrown_helm_AutumnHerald_diffuse3",
    }
    elf_table[4] = {
        body = "textures/Kerillian_HeraldOfTheWeave_body_Autumn/Kerillian_HeraldOfTheWeave_body_Autumn_diffuse4",
        hat = "textures/Kerillian_Evercrown_helm_AutumnHerald/Kerillian_Evercrown_helm_AutumnHerald_diffuse4",
    }

    Managers.package:load(pack_hat, "global")
    Managers.package:load(pack_body, "global")


    for i,text in pairs(elf_table) do
        local body = spawn_package_to_player(pack_body,i,0)
        local hat = spawn_package_to_player(pack_hat,i,0)
        mod:echo(i)
        local world = Managers.world:world("level_world")
        AttachmentUtils.link(world, body, hat, AttachmentNodeLinking.hat.slot_hat)
        mod.units_to_remove[body] = body
        mod.units_to_remove[hat] = hat
        local num_meshes = Unit.num_meshes(body)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if i < 12 or i > 16 then  
                    local mesh = Unit.mesh(body, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        mod:echo(text['body'])
                        Material.set_texture(mat, "texture_map_64cc5eb8", text['body'])      
                    end
                end
            end
        end
        local num_meshes = Unit.num_meshes(hat)
        mod:echo(num_meshes)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(hat, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        mod:echo(text['hat'])
                        Material.set_texture(mat, "texture_map_c0ba2942", text['hat'])      
                    end
                end
            end
        end
    end
end)

mod:command("swap_fall_elf", "", function()
    local pack_hat = "units/beings/player/way_watcher_upgraded/headpiece/ww_u_hat_11"
    local pack_body = "units/beings/player/way_watcher_upgraded_skin_01/third_person_base/chr_third_person_mesh"
    local elf_table = {}
    elf_table[1] = {
        body = "textures/Kerillian_HeraldOfTheWeave_body_Autumn/Kerillian_HeraldOfTheWeave_body_Autumn_diffuse",
        hat = "textures/Kerillian_Evercrown_helm_AutumnHerald/Kerillian_Evercrown_helm_AutumnHerald_diffuse",
    }

    Managers.package:load(pack_hat, "global")
    Managers.package:load(pack_body, "global")
    local world = Managers.world:world("level_world")
    local bodies = World.units_by_resource(world, pack_body)
    for _,unit in pairs(bodies) do
        
        mod:echo(i)
        
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if i < 12 or i > 16 then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_64cc5eb8", elf_table[1]['body'])      
                    end
                end
            end
        end
    end

    local hats = World.units_by_resource(world, pack_hat)
    for _,unit in pairs(hats) do
        
        mod:echo(i)
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", elf_table[1]['hat'])      
                    end
                end
            end
        end
    end

end)

mod:command("swap_fall_elf2", "", function()
    local pack_hat = "units/beings/player/way_watcher_upgraded/headpiece/ww_u_hat_11"
    local pack_body = "units/beings/player/way_watcher_upgraded_skin_01/third_person_base/chr_third_person_mesh"
    local elf_table = {}
    elf_table[1] = {
        body = "textures/Kerillian_HeraldOfTheWeave_body_Autumn/Kerillian_HeraldOfTheWeave_body_Autumn_diffuse2",
        hat = "textures/Kerillian_Evercrown_helm_AutumnHerald/Kerillian_Evercrown_helm_AutumnHerald_diffuse2",
    }

    Managers.package:load(pack_hat, "global")
    Managers.package:load(pack_body, "global")
    local world = Managers.world:world("level_world")
    local bodies = World.units_by_resource(world, pack_body)
    for _,unit in pairs(bodies) do
        
        mod:echo(i)
        
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if i < 12 or i > 16 then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_64cc5eb8", elf_table[1]['body'])      
                    end
                end
            end
        end
    end

    local hats = World.units_by_resource(world, pack_hat)
    for _,unit in pairs(hats) do
        
        mod:echo(i)
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", elf_table[1]['hat'])      
                    end
                end
            end
        end
    end

end)

mod:command("swap_fall_elf3", "", function()
    local pack_hat = "units/beings/player/way_watcher_upgraded/headpiece/ww_u_hat_11"
    local pack_body = "units/beings/player/way_watcher_upgraded_skin_01/third_person_base/chr_third_person_mesh"
    local elf_table = {}
    elf_table[1] = {
        body = "textures/Kerillian_HeraldOfTheWeave_body_Autumn/Kerillian_HeraldOfTheWeave_body_Autumn_diffuse3",
        hat = "textures/Kerillian_Evercrown_helm_AutumnHerald/Kerillian_Evercrown_helm_AutumnHerald_diffuse3",
    }

    Managers.package:load(pack_hat, "global")
    Managers.package:load(pack_body, "global")
    local world = Managers.world:world("level_world")
    local bodies = World.units_by_resource(world, pack_body)
    for _,unit in pairs(bodies) do
        
        mod:echo(i)
        
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if i < 12 or i > 16 then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_64cc5eb8", elf_table[1]['body'])      
                    end
                end
            end
        end
    end

    local hats = World.units_by_resource(world, pack_hat)
    for _,unit in pairs(hats) do
        
        mod:echo(i)
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", elf_table[1]['hat'])      
                    end
                end
            end
        end
    end

end)

mod:command("swap_fall_elf4", "", function()
    local pack_hat = "units/beings/player/way_watcher_upgraded/headpiece/ww_u_hat_11"
    local pack_body = "units/beings/player/way_watcher_upgraded_skin_01/third_person_base/chr_third_person_mesh"
    local elf_table = {}
    elf_table[1] = {
        body = "textures/Kerillian_HeraldOfTheWeave_body_Autumn/Kerillian_HeraldOfTheWeave_body_Autumn_diffuse4",
        hat = "textures/Kerillian_Evercrown_helm_AutumnHerald/Kerillian_Evercrown_helm_AutumnHerald_diffuse4",
    }

    Managers.package:load(pack_hat, "global")
    Managers.package:load(pack_body, "global")
    local world = Managers.world:world("level_world")
    local bodies = World.units_by_resource(world, pack_body)
    for _,unit in pairs(bodies) do
        
        mod:echo(i)
        
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if i < 12 or i > 16 then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_64cc5eb8", elf_table[1]['body'])      
                    end
                end
            end
        end
    end

    local hats = World.units_by_resource(world, pack_hat)
    for _,unit in pairs(hats) do
        
        mod:echo(i)
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", elf_table[1]['hat'])      
                    end
                end
            end
        end
    end

end)

mod:command("spawn_greenHerald", "", function()
    local pack_hat = "units/beings/player/way_watcher_upgraded/headpiece/ww_u_hat_11"
    local elf_table = {}
    elf_table[1] = {
        hat = "textures/Kerillian_Evercrown_helm_GreenHerald/Kerillian_Evercrown_helm_GreenHerald_diffuse",
    }
    elf_table[2] = {
        hat = "textures/Kerillian_Evercrown_helm_GreenHerald/Kerillian_Evercrown_helm_GreenHerald_diffuse2",
    }
    elf_table[3] = {
        hat = "textures/Kerillian_Evercrown_helm_GreenHerald/Kerillian_Evercrown_helm_GreenHerald_diffuse3",
    }
    elf_table[4] = {
        hat = "textures/Kerillian_Evercrown_helm_GreenHerald/Kerillian_Evercrown_helm_GreenHerald_diffuse4",
    }

    Managers.package:load(pack_hat, "global")
    
    for i,text in pairs(elf_table) do
        local hat = spawn_package_to_player(pack_hat, i,1.5)
        local world = Managers.world:world("level_world")
        mod.units_to_remove[hat] = hat
        local num_meshes = Unit.num_meshes(hat)
        mod:echo(num_meshes)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if i > 3 and i < 8 then  
                    local mesh = Unit.mesh(hat, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", text['hat'])      
                    end
                end
            end
        end
    end
end)

mod:command("swap_greenHerald", "", function()
    local pack_hat = "units/beings/player/way_watcher_upgraded/headpiece/ww_u_hat_11"
    local elf_table = {}
    elf_table[1] = {
        hat = "textures/Kerillian_Evercrown_helm_GreenHerald/Kerillian_Evercrown_helm_GreenHerald_diffuse"
    }

    Managers.package:load(pack_hat, "global")
    Managers.package:load(pack_body, "global")
    local world = Managers.world:world("level_world")

    local hats = World.units_by_resource(world, pack_hat)
    for _,unit in pairs(hats) do
        
        mod:echo(i)
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", elf_table[1]['hat'])      
                    end
                end
            end
        end
    end
end)

mod:command("swap_greenHerald2", "", function()
    local pack_hat = "units/beings/player/way_watcher_upgraded/headpiece/ww_u_hat_11"
    local elf_table = {}
    elf_table[1] = {
        hat = "textures/Kerillian_Evercrown_helm_GreenHerald/Kerillian_Evercrown_helm_GreenHerald_diffuse2"
    }

    Managers.package:load(pack_hat, "global")
    Managers.package:load(pack_body, "global")
    local world = Managers.world:world("level_world")

    local hats = World.units_by_resource(world, pack_hat)
    for _,unit in pairs(hats) do
        
        mod:echo(i)
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", elf_table[1]['hat'])      
                    end
                end
            end
        end
    end
end)

mod:command("swap_greenHerald3", "", function()
    local pack_hat = "units/beings/player/way_watcher_upgraded/headpiece/ww_u_hat_11"
    local elf_table = {}
    elf_table[1] = {
        hat = "textures/Kerillian_Evercrown_helm_GreenHerald/Kerillian_Evercrown_helm_GreenHerald_diffuse3"
    }

    Managers.package:load(pack_hat, "global")
    Managers.package:load(pack_body, "global")
    local world = Managers.world:world("level_world")

    local hats = World.units_by_resource(world, pack_hat)
    for _,unit in pairs(hats) do
        
        mod:echo(i)
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", elf_table[1]['hat'])      
                    end
                end
            end
        end
    end
end)

mod:command("swap_greenHerald4", "", function()
    local pack_hat = "units/beings/player/way_watcher_upgraded/headpiece/ww_u_hat_11"
    local elf_table = {}
    elf_table[1] = {
        hat = "textures/Kerillian_Evercrown_helm_GreenHerald/Kerillian_Evercrown_helm_GreenHerald_diffuse4"
    }

    Managers.package:load(pack_hat, "global")
    Managers.package:load(pack_body, "global")
    local world = Managers.world:world("level_world")

    local hats = World.units_by_resource(world, pack_hat)
    for _,unit in pairs(hats) do
        
        mod:echo(i)
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", elf_table[1]['hat'])      
                    end
                end
            end
        end
    end
end)


mod:command("spawn_BeastHorns", "", function()
    local pack_hat = "units/beings/player/way_watcher_upgraded/headpiece/ww_u_hat_02"
    local elf_table = {}
    elf_table[1] = {
        hat = "textures/Kerillian_HornOfKurnous_helm_Beaststalker/Kerillian_HornOfKurnous_helm_Beaststalker_diffuse",
    }
    elf_table[2] = {
        hat = "textures/Kerillian_HornOfKurnous_helm_Beaststalker/Kerillian_HornOfKurnous_helm_Beaststalker_diffuse2",
    }
    elf_table[3] = {
        hat = "textures/Kerillian_HornOfKurnous_helm_Beaststalker/Kerillian_HornOfKurnous_helm_Beaststalker_diffuse3",
    }
    elf_table[4] = {
        hat = "textures/Kerillian_HornOfKurnous_helm_Beaststalker/Kerillian_HornOfKurnous_helm_Beaststalker_diffuse4",
    }

    Managers.package:load(pack_hat, "global")

    for i,text in pairs(elf_table) do
        local hat = spawn_package_to_player(pack_hat, i, 1.5)
        local world = Managers.world:world("level_world")
        mod.units_to_remove[hat] = hat
        local num_meshes = Unit.num_meshes(hat)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if i > 3 and i < 8 then  
                    local mesh = Unit.mesh(hat, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", text['hat'])      
                    end
                end
            end
        end
    end
end)

mod:command("swap_BeastHorns", "", function()
    local pack_hat = "units/beings/player/way_watcher_upgraded/headpiece/ww_u_hat_02"
    local elf_table = {}
    elf_table[1] = {
        hat = "textures/Kerillian_HornOfKurnous_helm_Beaststalker/Kerillian_HornOfKurnous_helm_Beaststalker_diffuse",
    }

    Managers.package:load(pack_hat, "global")
    Managers.package:load(pack_body, "global")
    local world = Managers.world:world("level_world")

    local hats = World.units_by_resource(world, pack_hat)
    for _,unit in pairs(hats) do
        
        mod:echo(i)
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", elf_table[1]['hat'])      
                    end
                end
            end
        end
    end
end)

mod:command("swap_BeastHorns2", "", function()
    local pack_hat = "units/beings/player/way_watcher_upgraded/headpiece/ww_u_hat_02"
    local elf_table = {}
    elf_table[1] = {
        hat = "textures/Kerillian_HornOfKurnous_helm_Beaststalker/Kerillian_HornOfKurnous_helm_Beaststalker_diffuse2",
    }

    Managers.package:load(pack_hat, "global")
    Managers.package:load(pack_body, "global")
    local world = Managers.world:world("level_world")

    local hats = World.units_by_resource(world, pack_hat)
    for _,unit in pairs(hats) do
        
        mod:echo(i)
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", elf_table[1]['hat'])      
                    end
                end
            end
        end
    end
end)

mod:command("swap_BeastHorns3", "", function()
    local pack_hat = "units/beings/player/way_watcher_upgraded/headpiece/ww_u_hat_02"
    local elf_table = {}
    elf_table[1] = {
        hat = "textures/Kerillian_HornOfKurnous_helm_Beaststalker/Kerillian_HornOfKurnous_helm_Beaststalker_diffuse3",
    }

    Managers.package:load(pack_hat, "global")
    Managers.package:load(pack_body, "global")
    local world = Managers.world:world("level_world")

    local hats = World.units_by_resource(world, pack_hat)
    for _,unit in pairs(hats) do
        
        mod:echo(i)
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", elf_table[1]['hat'])      
                    end
                end
            end
        end
    end
end)

mod:command("swap_BeastHorns4", "", function()
    local pack_hat = "units/beings/player/way_watcher_upgraded/headpiece/ww_u_hat_02"
    local elf_table = {}
    elf_table[1] = {
        hat = "textures/Kerillian_HornOfKurnous_helm_Beaststalker/Kerillian_HornOfKurnous_helm_Beaststalker_diffuse4",
    }

    Managers.package:load(pack_hat, "global")
    Managers.package:load(pack_body, "global")
    local world = Managers.world:world("level_world")

    local hats = World.units_by_resource(world, pack_hat)
    for _,unit in pairs(hats) do
        
        mod:echo(i)
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", elf_table[1]['hat'])      
                    end
                end
            end
        end
    end
end)

mod:command("spawn_FrostHorns", "", function()
    local pack_hat = "units/beings/player/way_watcher_upgraded/headpiece/ww_u_hat_02"
    local elf_table = {}
    elf_table[1] = {
        hat = "textures/Kerillian_HornOfKurnous_helm_Frostwatcher/Kerillian_HornOfKurnous_helm_Frostwatcher_diffuse",
    }
    elf_table[2] = {
        hat = "textures/Kerillian_HornOfKurnous_helm_Frostwatcher/Kerillian_HornOfKurnous_helm_Frostwatcher_diffuse2",
    }
    elf_table[3] = {
        hat = "textures/Kerillian_HornOfKurnous_helm_Frostwatcher/Kerillian_HornOfKurnous_helm_Frostwatcher_diffuse3",
    }
    elf_table[4] = {
        hat = "textures/Kerillian_HornOfKurnous_helm_Frostwatcher/Kerillian_HornOfKurnous_helm_Frostwatcher_diffuse4",
    }

    Managers.package:load(pack_hat, "global")

    for i,text in pairs(elf_table) do
        local hat = spawn_package_to_player(pack_hat, i, 1.5)
        local world = Managers.world:world("level_world")
        mod.units_to_remove[hat] = hat
        local num_meshes = Unit.num_meshes(hat)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if i > 3 and i < 8 then  
                    local mesh = Unit.mesh(hat, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", text['hat'])      
                    end
                end
            end
        end
    end
end)

mod:command("swap_FrostHorns", "", function()
    local pack_hat = "units/beings/player/way_watcher_upgraded/headpiece/ww_u_hat_02"
    local elf_table = {}
    elf_table[1] = {
        hat = "textures/Kerillian_HornOfKurnous_helm_Frostwatcher/Kerillian_HornOfKurnous_helm_Frostwatcher_diffuse",
    }

    Managers.package:load(pack_hat, "global")
    Managers.package:load(pack_body, "global")
    local world = Managers.world:world("level_world")

    local hats = World.units_by_resource(world, pack_hat)
    for _,unit in pairs(hats) do
        
        mod:echo(i)
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", elf_table[1]['hat'])      
                    end
                end
            end
        end
    end
end)

mod:command("swap_FrostHorns2", "", function()
    local pack_hat = "units/beings/player/way_watcher_upgraded/headpiece/ww_u_hat_02"
    local elf_table = {}
    elf_table[1] = {
        hat = "textures/Kerillian_HornOfKurnous_helm_Frostwatcher/Kerillian_HornOfKurnous_helm_Frostwatcher_diffuse2",
    }

    Managers.package:load(pack_hat, "global")
    Managers.package:load(pack_body, "global")
    local world = Managers.world:world("level_world")

    local hats = World.units_by_resource(world, pack_hat)
    for _,unit in pairs(hats) do
        
        mod:echo(i)
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", elf_table[1]['hat'])      
                    end
                end
            end
        end
    end
end)

mod:command("swap_FrostHorns3", "", function()
    local pack_hat = "units/beings/player/way_watcher_upgraded/headpiece/ww_u_hat_02"
    local elf_table = {}
    elf_table[1] = {
        hat = "textures/Kerillian_HornOfKurnous_helm_Frostwatcher/Kerillian_HornOfKurnous_helm_Frostwatcher_diffuse3",
    }

    Managers.package:load(pack_hat, "global")
    Managers.package:load(pack_body, "global")
    local world = Managers.world:world("level_world")

    local hats = World.units_by_resource(world, pack_hat)
    for _,unit in pairs(hats) do
        
        mod:echo(i)
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", elf_table[1]['hat'])      
                    end
                end
            end
        end
    end
end)

mod:command("swap_FrostHorns4", "", function()
    local pack_hat = "units/beings/player/way_watcher_upgraded/headpiece/ww_u_hat_02"
    local elf_table = {}
    elf_table[1] = {
        hat = "textures/Kerillian_HornOfKurnous_helm_Frostwatcher/Kerillian_HornOfKurnous_helm_Frostwatcher_diffuse4",
    }

    Managers.package:load(pack_hat, "global")
    Managers.package:load(pack_body, "global")
    local world = Managers.world:world("level_world")

    local hats = World.units_by_resource(world, pack_hat)
    for _,unit in pairs(hats) do
        
        mod:echo(i)
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", elf_table[1]['hat'])      
                    end
                end
            end
        end
    end
end)

mod:command("spawn_NightHorns", "", function()
    local pack_hat = "units/beings/player/way_watcher_upgraded/headpiece/ww_u_hat_02"
    local elf_table = {}
    elf_table[1] = {
        hat = "textures/Kerillian_HornOfKurnous_helm_Nightstalker/Kerillian_HornOfKurnous_helm_Nightstalker_diffuse",
    }
    elf_table[2] = {
        hat = "textures/Kerillian_HornOfKurnous_helm_Nightstalker/Kerillian_HornOfKurnous_helm_Nightstalker_diffuse2",
    }
    elf_table[3] = {
        hat = "textures/Kerillian_HornOfKurnous_helm_Nightstalker/Kerillian_HornOfKurnous_helm_Nightstalker_diffuse3",
    }
    elf_table[4] = {
        hat = "textures/Kerillian_HornOfKurnous_helm_Nightstalker/Kerillian_HornOfKurnous_helm_Nightstalker_diffuse4",
    }

    Managers.package:load(pack_hat, "global")

    for i,text in pairs(elf_table) do
        local hat = spawn_package_to_player(pack_hat, i, 1.5)
        local world = Managers.world:world("level_world")
        mod.units_to_remove[hat] = hat
        local num_meshes = Unit.num_meshes(hat)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if i > 3 and i < 8 then  
                    local mesh = Unit.mesh(hat, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", text['hat'])      
                    end
                end
            end
        end
    end
end)

mod:command("swap_NightHorns", "", function()
    local pack_hat = "units/beings/player/way_watcher_upgraded/headpiece/ww_u_hat_02"
    local elf_table = {}
    elf_table[1] = {
        hat = "textures/Kerillian_HornOfKurnous_helm_Nightstalker/Kerillian_HornOfKurnous_helm_Nightstalker_diffuse",
    }

    Managers.package:load(pack_hat, "global")
    Managers.package:load(pack_body, "global")
    local world = Managers.world:world("level_world")

    local hats = World.units_by_resource(world, pack_hat)
    for _,unit in pairs(hats) do
        
        mod:echo(i)
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", elf_table[1]['hat'])      
                    end
                end
            end
        end
    end
end)

mod:command("swap_NightHorns2", "", function()
    local pack_hat = "units/beings/player/way_watcher_upgraded/headpiece/ww_u_hat_02"
    local elf_table = {}
    elf_table[1] = {
        hat = "textures/Kerillian_HornOfKurnous_helm_Nightstalker/Kerillian_HornOfKurnous_helm_Nightstalker_diffuse2",
    }

    Managers.package:load(pack_hat, "global")
    Managers.package:load(pack_body, "global")
    local world = Managers.world:world("level_world")

    local hats = World.units_by_resource(world, pack_hat)
    for _,unit in pairs(hats) do
        
        mod:echo(i)
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", elf_table[1]['hat'])      
                    end
                end
            end
        end
    end
end)

mod:command("swap_NightHorns3", "", function()
    local pack_hat = "units/beings/player/way_watcher_upgraded/headpiece/ww_u_hat_02"
    local elf_table = {}
    elf_table[1] = {
        hat = "textures/Kerillian_HornOfKurnous_helm_Nightstalker/Kerillian_HornOfKurnous_helm_Nightstalker_diffuse3",
    }

    Managers.package:load(pack_hat, "global")
    Managers.package:load(pack_body, "global")
    local world = Managers.world:world("level_world")

    local hats = World.units_by_resource(world, pack_hat)
    for _,unit in pairs(hats) do
        
        mod:echo(i)
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", elf_table[1]['hat'])      
                    end
                end
            end
        end
    end
end)

mod:command("swap_NightHorns4", "", function()
    local pack_hat = "units/beings/player/way_watcher_upgraded/headpiece/ww_u_hat_02"
    local elf_table = {}
    elf_table[1] = {
        hat = "textures/Kerillian_HornOfKurnous_helm_Nightstalker/Kerillian_HornOfKurnous_helm_Nightstalker_diffuse4",
    }

    Managers.package:load(pack_hat, "global")
    Managers.package:load(pack_body, "global")
    local world = Managers.world:world("level_world")

    local hats = World.units_by_resource(world, pack_hat)
    for _,unit in pairs(hats) do
        
        mod:echo(i)
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", elf_table[1]['hat'])      
                    end
                end
            end
        end
    end
end)

mod:command("spawn_PurifiedHorns", "", function()
    local pack_hat = "units/beings/player/way_watcher_upgraded/headpiece/ww_u_hat_02"
    local elf_table = {}
    elf_table[1] = {
        hat = "textures/Kerillian_HornOfKurnous_helm_Purified/Kerillian_HornOfKurnous_helm_Purified_diffuse",
        mask = "textures/Kerillian_HornOfKurnous_helm_Purified/Kerillian_HornOfKurnous_mask_Purified_diffuse",
    }
    elf_table[2] = {
        hat = "textures/Kerillian_HornOfKurnous_helm_Purified/Kerillian_HornOfKurnous_helm_Purified_diffuse2",
        mask = "textures/Kerillian_HornOfKurnous_helm_Purified/Kerillian_HornOfKurnous_mask_Purified_diffuse2",
    }
    elf_table[3] = {
        hat = "textures/Kerillian_HornOfKurnous_helm_Purified/Kerillian_HornOfKurnous_helm_Purified_diffuse3",
        mask = "textures/Kerillian_HornOfKurnous_helm_Purified/Kerillian_HornOfKurnous_mask_Purified_diffuse3",
    }
    elf_table[4] = {
        hat = "textures/Kerillian_HornOfKurnous_helm_Purified/Kerillian_HornOfKurnous_helm_Purified_diffuse4",
        mask = "textures/Kerillian_HornOfKurnous_helm_Purified/Kerillian_HornOfKurnous_mask_Purified_diffuse4",
    }
    Managers.package:load(pack_hat, "global")
    for i,text in pairs(elf_table) do
        local hat = spawn_package_to_player(pack_hat, i, 1.5)
        local world = Managers.world:world("level_world")
        mod.units_to_remove[hat] = hat
        local num_meshes = Unit.num_meshes(hat)
        mod:echo(num_meshes)
        for i = 0, num_meshes - 1, 1 do
            if i > 3 and i < 8 then
                if true then  
                    local mesh = Unit.mesh(hat, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", text['hat'])      
                    end
                end
            elseif i <= 3 then
                if true then  
                    local mesh = Unit.mesh(hat, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", text['mask'])      
                    end
                end
            end
        end
    end
end)

mod:command("swap_PurifiedHorns", "", function()
    local pack_hat = "units/beings/player/way_watcher_upgraded/headpiece/ww_u_hat_02"
    local elf_table = {}
    elf_table[1] = {
        hat = "textures/Kerillian_HornOfKurnous_helm_Purified/Kerillian_HornOfKurnous_helm_Purified_diffuse",
        mask = "textures/Kerillian_HornOfKurnous_helm_Purified/Kerillian_HornOfKurnous_mask_Purified_diffuse",
    }

    Managers.package:load(pack_hat, "global")
    Managers.package:load(pack_body, "global")
    local world = Managers.world:world("level_world")

    local hats = World.units_by_resource(world, pack_hat)
    for _,unit in pairs(hats) do
        
        mod:echo(i)
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            if i > 3 and i < 8 then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", elf_table[1]['hat'])      
                    end
                end
            elseif i <= 3 then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", elf_table[1]['mask'])      
                    end
                end
            end
        end
    end
end)

mod:command("swap_PurifiedHorns2", "", function()
    local pack_hat = "units/beings/player/way_watcher_upgraded/headpiece/ww_u_hat_02"
    local elf_table = {}
    elf_table[1] = {
        hat = "textures/Kerillian_HornOfKurnous_helm_Purified/Kerillian_HornOfKurnous_helm_Purified_diffuse2",
        mask = "textures/Kerillian_HornOfKurnous_helm_Purified/Kerillian_HornOfKurnous_mask_Purified_diffuse2",
    }

    Managers.package:load(pack_hat, "global")
    Managers.package:load(pack_body, "global")
    local world = Managers.world:world("level_world")

    local hats = World.units_by_resource(world, pack_hat)
    for _,unit in pairs(hats) do
        
        mod:echo(i)
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            if i > 3 and i < 8 then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", elf_table[1]['hat'])      
                    end
                end
            elseif i <= 3 then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", elf_table[1]['mask'])      
                    end
                end
            end
        end
    end
end)

mod:command("swap_PurifiedHorns3", "", function()
    local pack_hat = "units/beings/player/way_watcher_upgraded/headpiece/ww_u_hat_02"
    local elf_table = {}
    elf_table[1] = {
        hat = "textures/Kerillian_HornOfKurnous_helm_Purified/Kerillian_HornOfKurnous_helm_Purified_diffuse3",
        mask = "textures/Kerillian_HornOfKurnous_helm_Purified/Kerillian_HornOfKurnous_mask_Purified_diffuse3",
    }

    Managers.package:load(pack_hat, "global")
    Managers.package:load(pack_body, "global")
    local world = Managers.world:world("level_world")

    local hats = World.units_by_resource(world, pack_hat)
    for _,unit in pairs(hats) do
        
        mod:echo(i)
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            if i > 3 and i < 8 then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", elf_table[1]['hat'])      
                    end
                end
            elseif i <= 3 then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", elf_table[1]['mask'])      
                    end
                end
            end
        end
    end
end)

mod:command("swap_PurifiedHorns4", "", function()
    local pack_hat = "units/beings/player/way_watcher_upgraded/headpiece/ww_u_hat_02"
    local elf_table = {}
    elf_table[1] = {
        hat = "textures/Kerillian_HornOfKurnous_helm_Purified/Kerillian_HornOfKurnous_helm_Purified_diffuse4",
        mask = "textures/Kerillian_HornOfKurnous_helm_Purified/Kerillian_HornOfKurnous_mask_Purified_diffuse4",
    }

    Managers.package:load(pack_hat, "global")
    Managers.package:load(pack_body, "global")
    local world = Managers.world:world("level_world")

    local hats = World.units_by_resource(world, pack_hat)
    for _,unit in pairs(hats) do
        
        mod:echo(i)
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            if i > 3 and i < 8 then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", elf_table[1]['hat'])      
                    end
                end
            elseif i <= 3 then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", elf_table[1]['mask'])      
                    end
                end
            end
        end
    end
end)

mod:command("spawn_Midden", "", function()
    local pack_hat = "units/beings/player/empire_soldier_huntsman/headpiece/es_h_hat_02"
    local elf_table = {}
    elf_table[1] = {
        hat = "textures/Kruber_SunsetBonnet_helm_Middenland/Kruber_SunsetBonnet_helm_Middenland_diffuse",
    }
    elf_table[2] = {
        hat = "textures/Kruber_SunsetBonnet_helm_Middenland/Kruber_SunsetBonnet_helm_Middenland_diffuse2",
    }
    elf_table[3] = {
        hat = "textures/Kruber_SunsetBonnet_helm_Middenland/Kruber_SunsetBonnet_helm_Middenland_diffuse3",
    }
    elf_table[4] = {
        hat = "textures/Kruber_SunsetBonnet_helm_Middenland/Kruber_SunsetBonnet_helm_Middenland_diffuse4",
    }
    Managers.package:load(pack_hat, "global")
    for i,text in pairs(elf_table) do
        local hat = spawn_package_to_player(pack_hat, i, 1.5)
        local world = Managers.world:world("level_world")
        mod.units_to_remove[hat] = hat
        local num_meshes = Unit.num_meshes(hat)
        mod:echo(num_meshes)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(hat, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", text['hat'])      
                    end
                end
            end
        end
    end
end)

mod:command("swap_Midden", "", function()
    local pack_hat = "units/beings/player/empire_soldier_huntsman/headpiece/es_h_hat_02"
    local elf_table = {}
    elf_table[1] = {
        hat = "textures/Kruber_SunsetBonnet_helm_Middenland/Kruber_SunsetBonnet_helm_Middenland_diffuse",
    }

    Managers.package:load(pack_hat, "global")
    Managers.package:load(pack_body, "global")
    local world = Managers.world:world("level_world")

    local hats = World.units_by_resource(world, pack_hat)
    for _,unit in pairs(hats) do
        
        mod:echo(i)
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", elf_table[1]['hat'])      
                    end
                end
            end
        end
    end
end)

mod:command("swap_Midden2", "", function()
    local pack_hat = "units/beings/player/empire_soldier_huntsman/headpiece/es_h_hat_02"
    local elf_table = {}
    elf_table[1] = {
        hat = "textures/Kruber_SunsetBonnet_helm_Middenland/Kruber_SunsetBonnet_helm_Middenland_diffuse2",
    }

    Managers.package:load(pack_hat, "global")
    Managers.package:load(pack_body, "global")
    local world = Managers.world:world("level_world")

    local hats = World.units_by_resource(world, pack_hat)
    for _,unit in pairs(hats) do
        
        mod:echo(i)
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", elf_table[1]['hat'])      
                    end
                end
            end
        end
    end
end)

mod:command("swap_Midden3", "", function()
    local pack_hat = "units/beings/player/empire_soldier_huntsman/headpiece/es_h_hat_02"
    local elf_table = {}
    elf_table[1] = {
        hat = "textures/Kruber_SunsetBonnet_helm_Middenland/Kruber_SunsetBonnet_helm_Middenland_diffuse3",
    }

    Managers.package:load(pack_hat, "global")
    Managers.package:load(pack_body, "global")
    local world = Managers.world:world("level_world")

    local hats = World.units_by_resource(world, pack_hat)
    for _,unit in pairs(hats) do
        
        mod:echo(i)
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", elf_table[1]['hat'])      
                    end
                end
            end
        end
    end
end)

mod:command("swap_Midden4", "", function()
    local pack_hat = "units/beings/player/empire_soldier_huntsman/headpiece/es_h_hat_02"
    local elf_table = {}
    elf_table[1] = {
        hat = "textures/Kruber_SunsetBonnet_helm_Middenland/Kruber_SunsetBonnet_helm_Middenland_diffuse4",
    }

    Managers.package:load(pack_hat, "global")
    Managers.package:load(pack_body, "global")
    local world = Managers.world:world("level_world")

    local hats = World.units_by_resource(world, pack_hat)
    for _,unit in pairs(hats) do
        
        mod:echo(i)
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", elf_table[1]['hat'])      
                    end
                end
            end
        end
    end
end)

mod:command("spawn_Nuln", "", function()
    local pack_hat = "units/beings/player/empire_soldier_huntsman/headpiece/es_h_hat_02"
    local elf_table = {}
    elf_table[1] = {
        hat = "textures/Kruber_SunsetBonnet_helm_Nuln/Kruber_SunsetBonnet_helm_Nuln_diffuse",
    }
    elf_table[2] = {
        hat = "textures/Kruber_SunsetBonnet_helm_Nuln/Kruber_SunsetBonnet_helm_Nuln_diffuse2",
    }
    elf_table[3] = {
        hat = "textures/Kruber_SunsetBonnet_helm_Nuln/Kruber_SunsetBonnet_helm_Nuln_diffuse3",
    }
    elf_table[4] = {
        hat = "textures/Kruber_SunsetBonnet_helm_Nuln/Kruber_SunsetBonnet_helm_Nuln_diffuse4",
    }
    Managers.package:load(pack_hat, "global")
    for i,text in pairs(elf_table) do
        local hat = spawn_package_to_player(pack_hat, i, 1.5)
        local world = Managers.world:world("level_world")
        mod.units_to_remove[hat] = hat
        local num_meshes = Unit.num_meshes(hat)
        mod:echo(num_meshes)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(hat, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", text['hat'])      
                    end
                end
            end
        end
    end
end)

mod:command("swap_Nuln", "", function()
    local pack_hat = "units/beings/player/empire_soldier_huntsman/headpiece/es_h_hat_02"
    local elf_table = {}
    elf_table[1] = {
        hat = "textures/Kruber_SunsetBonnet_helm_Nuln/Kruber_SunsetBonnet_helm_Nuln_diffuse",
    }

    Managers.package:load(pack_hat, "global")
    Managers.package:load(pack_body, "global")
    local world = Managers.world:world("level_world")

    local hats = World.units_by_resource(world, pack_hat)
    for _,unit in pairs(hats) do
        
        mod:echo(i)
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", elf_table[1]['hat'])      
                    end
                end
            end
        end
    end
end)

mod:command("swap_Nuln2", "", function()
    local pack_hat = "units/beings/player/empire_soldier_huntsman/headpiece/es_h_hat_02"
    local elf_table = {}
    elf_table[1] = {
        hat = "textures/Kruber_SunsetBonnet_helm_Nuln/Kruber_SunsetBonnet_helm_Nuln_diffuse2",
    }

    Managers.package:load(pack_hat, "global")
    Managers.package:load(pack_body, "global")
    local world = Managers.world:world("level_world")

    local hats = World.units_by_resource(world, pack_hat)
    for _,unit in pairs(hats) do
        
        mod:echo(i)
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", elf_table[1]['hat'])      
                    end
                end
            end
        end
    end
end)

mod:command("swap_Nuln3", "", function()
    local pack_hat = "units/beings/player/empire_soldier_huntsman/headpiece/es_h_hat_02"
    local elf_table = {}
    elf_table[1] = {
        hat = "textures/Kruber_SunsetBonnet_helm_Nuln/Kruber_SunsetBonnet_helm_Nuln_diffuse3",
    }

    Managers.package:load(pack_hat, "global")
    Managers.package:load(pack_body, "global")
    local world = Managers.world:world("level_world")

    local hats = World.units_by_resource(world, pack_hat)
    for _,unit in pairs(hats) do
        
        mod:echo(i)
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", elf_table[1]['hat'])      
                    end
                end
            end
        end
    end
end)

mod:command("swap_Nuln4", "", function()
    local pack_hat = "units/beings/player/empire_soldier_huntsman/headpiece/es_h_hat_02"
    local elf_table = {}
    elf_table[1] = {
        hat = "textures/Kruber_SunsetBonnet_helm_Nuln/Kruber_SunsetBonnet_helm_Nuln_diffuse4",
    }

    Managers.package:load(pack_hat, "global")
    Managers.package:load(pack_body, "global")
    local world = Managers.world:world("level_world")

    local hats = World.units_by_resource(world, pack_hat)
    for _,unit in pairs(hats) do
        
        mod:echo(i)
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", elf_table[1]['hat'])      
                    end
                end
            end
        end
    end
end)

mod:command("spawn_Reik", "", function()
    local pack_hat = "units/beings/player/empire_soldier_huntsman/headpiece/es_h_hat_02"
    local elf_table = {}
    elf_table[1] = {
        hat = "textures/Kruber_SunsetBonnet_helm_Reikwald/Kruber_SunsetBonnet_helm_Reikwald_diffuse",
    }
    elf_table[2] = {
        hat = "textures/Kruber_SunsetBonnet_helm_Reikwald/Kruber_SunsetBonnet_helm_Reikwald_diffuse2",
    }
    elf_table[3] = {
        hat = "textures/Kruber_SunsetBonnet_helm_Reikwald/Kruber_SunsetBonnet_helm_Reikwald_diffuse3",
    }
    elf_table[4] = {
        hat = "textures/Kruber_SunsetBonnet_helm_Reikwald/Kruber_SunsetBonnet_helm_Reikwald_diffuse4",
    }
    Managers.package:load(pack_hat, "global")
    for i,text in pairs(elf_table) do
        local hat = spawn_package_to_player(pack_hat, i, 1.5)
        local world = Managers.world:world("level_world")
        mod.units_to_remove[hat] = hat
        local num_meshes = Unit.num_meshes(hat)
        mod:echo(num_meshes)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(hat, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", text['hat'])      
                    end
                end
            end
        end
    end
end)

mod:command("swap_Reik", "", function()
    local pack_hat = "units/beings/player/empire_soldier_huntsman/headpiece/es_h_hat_02"
    local elf_table = {}
    elf_table[1] = {
        hat = "textures/Kruber_SunsetBonnet_helm_Reikwald/Kruber_SunsetBonnet_helm_Reikwald_diffuse",
    }

    Managers.package:load(pack_hat, "global")
    Managers.package:load(pack_body, "global")
    local world = Managers.world:world("level_world")

    local hats = World.units_by_resource(world, pack_hat)
    for _,unit in pairs(hats) do
        
        mod:echo(i)
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", elf_table[1]['hat'])      
                    end
                end
            end
        end
    end
end)

mod:command("swap_Reik2", "", function()
    local pack_hat = "units/beings/player/empire_soldier_huntsman/headpiece/es_h_hat_02"
    local elf_table = {}
    elf_table[1] = {
        hat = "textures/Kruber_SunsetBonnet_helm_Reikwald/Kruber_SunsetBonnet_helm_Reikwald_diffuse2",
    }

    Managers.package:load(pack_hat, "global")
    Managers.package:load(pack_body, "global")
    local world = Managers.world:world("level_world")

    local hats = World.units_by_resource(world, pack_hat)
    for _,unit in pairs(hats) do
        
        mod:echo(i)
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", elf_table[1]['hat'])      
                    end
                end
            end
        end
    end
end)

mod:command("swap_Reik3", "", function()
    local pack_hat = "units/beings/player/empire_soldier_huntsman/headpiece/es_h_hat_02"
    local elf_table = {}
    elf_table[1] = {
        hat = "textures/Kruber_SunsetBonnet_helm_Reikwald/Kruber_SunsetBonnet_helm_Reikwald_diffuse3",
    }

    Managers.package:load(pack_hat, "global")
    Managers.package:load(pack_body, "global")
    local world = Managers.world:world("level_world")

    local hats = World.units_by_resource(world, pack_hat)
    for _,unit in pairs(hats) do
        
        mod:echo(i)
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", elf_table[1]['hat'])      
                    end
                end
            end
        end
    end
end)

mod:command("swap_Reik4", "", function()
    local pack_hat = "units/beings/player/empire_soldier_huntsman/headpiece/es_h_hat_02"
    local elf_table = {}
    elf_table[1] = {
        hat = "textures/Kruber_SunsetBonnet_helm_Reikwald/Kruber_SunsetBonnet_helm_Reikwald_diffuse4",
    }

    Managers.package:load(pack_hat, "global")
    Managers.package:load(pack_body, "global")
    local world = Managers.world:world("level_world")

    local hats = World.units_by_resource(world, pack_hat)
    for _,unit in pairs(hats) do
        
        mod:echo(i)
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", elf_table[1]['hat'])      
                    end
                end
            end
        end
    end
end)

mod:command("spawn_Stir", "", function()
    local pack_hat = "units/beings/player/empire_soldier_huntsman/headpiece/es_h_hat_02"
    local elf_table = {}
    elf_table[1] = {
        hat = "textures/Kruber_SunsetBonnet_helm_Stirland/Kruber_SunsetBonnet_helm_Stirland_diffuse",
    }
    elf_table[2] = {
        hat = "textures/Kruber_SunsetBonnet_helm_Stirland/Kruber_SunsetBonnet_helm_Stirland_diffuse2",
    }
    elf_table[3] = {
        hat = "textures/Kruber_SunsetBonnet_helm_Stirland/Kruber_SunsetBonnet_helm_Stirland_diffuse3",
    }
    elf_table[4] = {
        hat = "textures/Kruber_SunsetBonnet_helm_Stirland/Kruber_SunsetBonnet_helm_Stirland_diffuse4",
    }
    Managers.package:load(pack_hat, "global")
    for i,text in pairs(elf_table) do
        local hat = spawn_package_to_player(pack_hat, i, 1.5)
        mod.units_to_remove[hat] = hat
        local world = Managers.world:world("level_world")
        local num_meshes = Unit.num_meshes(hat)
        mod:echo(num_meshes)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(hat, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", text['hat'])      
                    end
                end
            end
        end
    end
end)

mod:command("swap_Stir", "", function()
    local pack_hat = "units/beings/player/empire_soldier_huntsman/headpiece/es_h_hat_02"
    local elf_table = {}
    elf_table[1] = {
        hat = "textures/Kruber_SunsetBonnet_helm_Stirland/Kruber_SunsetBonnet_helm_Stirland_diffuse",
    }

    Managers.package:load(pack_hat, "global")
    Managers.package:load(pack_body, "global")
    local world = Managers.world:world("level_world")

    local hats = World.units_by_resource(world, pack_hat)
    for _,unit in pairs(hats) do
        
        mod:echo(i)
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", elf_table[1]['hat'])      
                    end
                end
            end
        end
    end
end)

mod:command("swap_Stir2", "", function()
    local pack_hat = "units/beings/player/empire_soldier_huntsman/headpiece/es_h_hat_02"
    local elf_table = {}
    elf_table[1] = {
        hat = "textures/Kruber_SunsetBonnet_helm_Stirland/Kruber_SunsetBonnet_helm_Stirland_diffuse2",
    }

    Managers.package:load(pack_hat, "global")
    Managers.package:load(pack_body, "global")
    local world = Managers.world:world("level_world")

    local hats = World.units_by_resource(world, pack_hat)
    for _,unit in pairs(hats) do
        
        mod:echo(i)
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", elf_table[1]['hat'])      
                    end
                end
            end
        end
    end
end)

mod:command("swap_Stir3", "", function()
    local pack_hat = "units/beings/player/empire_soldier_huntsman/headpiece/es_h_hat_02"
    local elf_table = {}
    elf_table[1] = {
        hat = "textures/Kruber_SunsetBonnet_helm_Stirland/Kruber_SunsetBonnet_helm_Stirland_diffuse3",
    }

    Managers.package:load(pack_hat, "global")
    Managers.package:load(pack_body, "global")
    local world = Managers.world:world("level_world")

    local hats = World.units_by_resource(world, pack_hat)
    for _,unit in pairs(hats) do
        
        mod:echo(i)
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", elf_table[1]['hat'])      
                    end
                end
            end
        end
    end
end)

mod:command("swap_Stir4", "", function()
    local pack_hat = "units/beings/player/empire_soldier_huntsman/headpiece/es_h_hat_02"
    local elf_table = {}
    elf_table[1] = {
        hat = "textures/Kruber_SunsetBonnet_helm_Stirland/Kruber_SunsetBonnet_helm_Stirland_diffuse4",
    }

    Managers.package:load(pack_hat, "global")
    Managers.package:load(pack_body, "global")
    local world = Managers.world:world("level_world")

    local hats = World.units_by_resource(world, pack_hat)
    for _,unit in pairs(hats) do
        
        mod:echo(i)
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            if true then
                if true then  
                    local mesh = Unit.mesh(unit, i)
                    local num_mats = Mesh.num_materials(mesh)
                    for j = 0, num_mats - 1, 1 do
                        local mat = Mesh.material(mesh, j)
                        Material.set_texture(mat, "texture_map_c0ba2942", elf_table[1]['hat'])      
                    end
                end
            end
        end
    end
end)

mod:command("delete_units", "", function()
    local world = Managers.world:world("level_world")
    for _,unit in pairs(mod.units_to_remove) do
        if Unit.alive(unit) then
            World.destroy_unit(world, unit)
        end
        unit = nil
    end
end)

