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

--colected is probably dead/redundant code
mod.list_of_LA_levels_books = {
    dlc_bastion = {
        position = stingray.Vector3Box(70.4, -10.4, -0.85),
        rotation = QuaternionBox(Quaternion.multiply(Quaternion.from_elements(0,0,0,1), radians_to_quaternion(0, -3*math.pi/4, 0))),
        collected = false, 
    },
}