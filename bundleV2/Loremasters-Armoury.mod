return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`Loremasters-Armoury` mod must be lower than Vermintide Mod Framework in your launcher's load order.")

		new_mod("Loremasters-Armoury", {
			mod_script       = "scripts/mods/Loremasters-Armoury/Loremasters-Armoury",
			mod_data         = "scripts/mods/Loremasters-Armoury/Loremasters-Armoury_data",
			mod_localization = "scripts/mods/Loremasters-Armoury/Loremasters-Armoury_localization",
		})
	end,
	packages = {
		"resource_packages/Loremasters-Armoury/Loremasters-Armoury",
	},
}
