-- Totor - Minigames

local modulesPath = "minigames/gamemode/games/" .. OPTIONS.regime
local modulesFolder = "games/" .. OPTIONS.regime
local regime_files, modules = file.Find(modulesPath .. "/*", "LUA")

if SERVER then
	if !file.Exists(modulesPath .. "/cl_init.lua", "LUA") or
		!file.Exists(modulesPath .. "/sv_init.lua", "LUA") or
		!file.Exists(modulesPath .. "/sh_init.lua", "LUA")
	then
		print("GAMEREGIME CANNOT BE INITIATED BECAUSE IT'S GENERAL FILES ARE NOT EXIST")
		return
	end
end

if SERVER then print("--- MODULES ---") end
for _, mod in ipairs(modules) do
	//if GM.CONFIG["disabled_modules"][mod] then continue end
	/*local _,sub_directories = file.Find(modulesPath .. "/" .. mod .. "/*", "LUA")
	for _, v in ipairs(sub_directories) do
		sub_files = file.Find(modulesPath .. "/" .. mod .. "/" .. v .."/*.lua", "LUA")
		if #sub_files > 0 then
			if SERVER then print("LOADING " .. mod) end
		end
		for _, vf in ipairs(sub_files) do
			local ext = string.sub(vf, 1, 3)
			if ext == "cl_" || ext == "sh_" then
				if SERVER then
					AddCSLuaFile(modulesFolder .. "/" .. mod .. "/" .. v .. "/" .. vf)
				else
					include(modulesFolder .. "/" .. mod .. "/" .. v .. "/" .. vf)
				end
			end
			if ext == "sv_" || ext == "sh_" then
				if SERVER then
					include(modulesFolder .. "/" .. mod .. "/" .. v .. "/" .. vf)
				end
			end
		end
	end*/
	
	for _, v in ipairs(regime_files) do
		local ext = string.sub(v, 1, 3)
		if ext == "cl_" || ext == "sh_" then
			if SERVER then
				AddCSLuaFile(modulesFolder .. "/" .. v)
			else
				include(modulesFolder .. "/" .. v)
			end
		end
		if ext == "sv_" || ext == "sh_" then
			if SERVER then
				include(modulesFolder .. "/" .. v)
			end
		end
	end
	
	files = file.Find(modulesPath .. "/" .. mod .. "/*.lua", "LUA")
	if #files > 0 then
		if SERVER then print("LOADING " .. mod) end
	end
	for _, v in ipairs(files) do
		local ext = string.sub(v, 1, 3)
		if ext == "cl_" || ext == "sh_" then
			if SERVER then
				AddCSLuaFile(modulesFolder .. "/" .. mod .. "/" .. v)
			else
				include(modulesFolder .. "/" .. mod .. "/" .. v)
			end
		end
		if ext == "sv_" || ext == "sh_" then
			if SERVER then
				include(modulesFolder .. "/" .. mod .. "/" .. v)
			end
		end
	end
end
