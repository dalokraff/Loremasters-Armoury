local mod = get_mod("Loremasters-Armoury")


local rpc_table = require("scripts/mods/Loremasters-Armoury/rpc_hooks/new_rpc_funcs")


mod:hook(NetworkTransmit, "send_rpc_server", function (func, self, rpc_name, ...)
    if rpc_table[rpc_name] then
        local should_return = rpc_table[rpc_name]

        if should_return(...) then
            return
        end
    end

    return func(self, rpc_name, ...)
end)