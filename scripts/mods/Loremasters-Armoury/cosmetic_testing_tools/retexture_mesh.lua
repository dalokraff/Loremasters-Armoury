local mod = get_mod("Loremasters-Armoury")

RetextureMesh = class(RetextureMesh)

RetextureMesh.init = function (self, unit_path, unit_spawner, pos, rot)
    self.texture_resources = {}
    self.world = Managers.world:world("level_world")
    self.unit_path = unit_path
    self.unit_spawner = unit_spawner
    self.unit = unit_spawner:spawn_local_unit(unit_path, pos, rot)
    
end

RetextureMesh.set_texture = function(self, text_slot, texture_file, meshes_to_skip)
    local skip_meshes = meshes_to_skip or {}

    local unit = self.unit

    if Unit.alive(unit) and texture_file and text_slot then
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            if not skip_meshes[i] then
                local mesh = Unit.mesh(unit, i)
                local num_mats = Mesh.num_materials(mesh)
                for j = 0, num_mats - 1, 1 do
                    local mat = Mesh.material(mesh, j)
                    if texture_file ~= "nil" then
                        Material.set_texture(mat, text_slot, texture_file)
                    end
                end
            end
        end
    end    
end

RetextureMesh.set_texture_resoruce = function(self, text_slot, meshes_to_skip, texture_file_key, texture_resource)
    local skip_meshes = meshes_to_skip or {}
    self.texture_resources[texture_file_key] = texture_resource
    local unit = self.unit

    if Unit.alive(unit) and texture_resource and text_slot then
        
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            if not skip_meshes[i] then
                local mesh = Unit.mesh(unit, i)
                local num_mats = Mesh.num_materials(mesh)
                for j = 0, num_mats - 1, 1 do
                    local mat = Mesh.material(mesh, j)
                    if texture_resource ~= nil then
                        Material.set_resource(mat, text_slot, texture_resource)
                    end
                end
            end
        end
    end    
end

RetextureMesh.set_texture_from_url = function(self, text_slot, texture_file_key, meshes_to_skip, texture_url)
    local cb = callback(self, "set_texture_resoruce", text_slot, meshes_to_skip, texture_file_key)
    Managers.url_loader:load_resource(
    texture_file_key,
	texture_url,
	cb,
	texture_url -- cache key
)
end

RetextureMesh.destroy = function(self) 

    self.unit_spawner:mark_for_deletion(self.unit)

    self.world = nil
    self.unit_path = nil
    self.unit_spawner = nil
    self.unit = nil

end