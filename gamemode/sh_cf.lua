OPTIONS = {}
OPTIONS.enable_bhop = false
OPTIONS.isTwoTeam = false
OPTIONS.colliderPlayer = false
OPTIONS.disableFallDamage = false
MAPS = {}

MAPS["mg_randomizer_v5"] = function()
	OPTIONS.enable_bhop = true
end

MAPS["mg_ka_trains_detach_evo_v2_3"] = function()
	OPTIONS.isTwoTeam = true
end

MAPS["mg_simonsays"] = function()
	OPTIONS.isTwoTeam = true
end

MAPS["mg_oaks_chutes_n_ladders_v1"] = function()
	OPTIONS.enable_bhop = true
	OPTIONS.isTwoTeam = true
	OPTIONS.disableFallDamage = true
end

MAPS["mg_piratewars_extended_fixed"] = function()
	//OPTIONS.enable_bhop = true
	OPTIONS.isTwoTeam = true
end

MAPS["mg_3xcp_jakes_v3_0"] = function()
	OPTIONS.enable_bhop = true
	OPTIONS.colliderPlayer = true
end

MAPS["mg_minecraft_multigames"] = function()
	OPTIONS.enable_bhop = true
	OPTIONS.isTwoTeam = true
	for i,v in pairs(ents.GetAll()) do
		if v:GetClass() == 'filter_activator_team' then
			if v:GetName() == "T" then
				v:SetKeyValue('filterteam', TEAM_SATIRES)
			end
			if v:GetName() == "CT" then
				v:SetKeyValue('filterteam', TEAM_GARPIES)
			end
			
		end
	end
end

if MAPS[game.GetMap()] != nil then
MAPS[game.GetMap()]()
end
