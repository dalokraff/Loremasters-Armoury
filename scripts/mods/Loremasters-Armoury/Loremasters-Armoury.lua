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



local function spawn_package_to_player (package_name)
	local player = Managers.player:local_player()
	local world = Managers.world:world("level_world")
    local unit_spawner = Managers.state.unit_spawner
    local init_data = {}
    local material = "units/props/tzeentch/tzeentch_faction_01"

	if world and player and player.player_unit then
        local player_unit = player.player_unit
    
        local position = Unit.local_position(player_unit, 0) + Vector3(0, 0, 0)
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


mod:command("spawn_fall_elf", "", function()
    local pack_hat = "units/beings/player/way_watcher_upgraded/headpiece/ww_u_hat_11"
    local pack_body = "units/beings/player/way_watcher_upgraded_skin_01/third_person_base/chr_third_person_mesh"
    
    Managers.package:load(pack_hat, "global")
    Managers.package:load(pack_body, "global")
    local body = spawn_package_to_player(pack_body)
    local hat = spawn_package_to_player(pack_hat)
    local world = Managers.world:world("level_world")
    AttachmentUtils.link(world, body, hat, AttachmentNodeLinking.hat.slot_hat)

    local num_meshes = Unit.num_meshes(body)
    for i = 0, num_meshes - 1, 1 do
        if true then
            if i < 12 or i > 16 then  
                local mesh = Unit.mesh(body, i)
                local num_mats = Mesh.num_materials(mesh)
                for j = 0, num_mats - 1, 1 do
                    local mat = Mesh.material(mesh, j)
                    Material.set_texture(mat, "texture_map_64cc5eb8", "textures/Kerillian_HeraldOfTheWeave_body_Autumn/Kerillian_HeraldOfTheWeave_body_Autumn_diffuse")      
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
                    Material.set_texture(mat, "texture_map_c0ba2942", "textures/Kerillian_Evercrown_helm_AutumnHerald/Kerillian_Evercrown_helm_AutumnHerald_diffuse")      
                end
            end
        end
    end

end)

mod:command("spawn_greenHerald", "", function()
    local pack_hat = "units/beings/player/way_watcher_upgraded/headpiece/ww_u_hat_11"

    Managers.package:load(pack_hat, "global")
    Managers.package:load(pack_body, "global")
    -- local body = spawn_package_to_player(pack_body)
    local hat = spawn_package_to_player(pack_hat)
    local world = Managers.world:world("level_world")
    -- AttachmentUtils.link(world, body, hat, AttachmentNodeLinking.hat.slot_hat)

    local num_meshes = Unit.num_meshes(hat)
    for i = 0, num_meshes - 1, 1 do
        if true then
            if i < 12 or i > 16 then  
                local mesh = Unit.mesh(body, i)
                local num_mats = Mesh.num_materials(mesh)
                for j = 0, num_mats - 1, 1 do
                    local mat = Mesh.material(mesh, j)
                    Material.set_texture(mat, "texture_map_64cc5eb8", "textures/Kerillian_Evercrown_helm_GreenHerald/Kerillian_Evercrown_helm_GreenHerald_diffuse")      
                end
            end
        end
    end
end)

