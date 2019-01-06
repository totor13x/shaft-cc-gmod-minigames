print('Init')

include( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include("modulesloader.lua")
AddCSLuaFile("modulesloader.lua")

-- // Configurating maps

AddCSLuaFile( "sh_cf.lua" )
include ( "sh_cf.lua" )

-- // ROUND System
/*
AddCSLuaFile( "roundsystem/cl_round.lua" )
include( "roundsystem/cl_round.lua" )

AddCSLuaFile( "roundsystem/sh_round.lua" )
include( "roundsystem/sh_round.lua" )

include( "roundsystem/sv_round.lua" )
*/
AddCSLuaFile( "sh_setupround.lua" )
include( "sh_setupround.lua" )

-- // Player Settings 

include( "sv_player.lua" )

-- // Functions

AddCSLuaFile( "sh_functions.lua" )
include( "sh_functions.lua" )

AddCSLuaFile( "cl_hud.lua" )

-- // Select Team
/*
AddCSLuaFile("lobby/cl_lobby.lua")
include("lobby/cl_lobby.lua")
include("lobby/sv_lobby.lua")*/

-- // VoicePanel

AddCSLuaFile "cl_voicepanel.lua"

-- // MapVote
/*include "mapvote/sh_mapvote.lua"
include "mapvote/sv_mapvote.lua"

AddCSLuaFile "mapvote/cl_mapvote.lua"
AddCSLuaFile "mapvote/sh_mapvote.lua"*/


RunConsoleCommand("sv_friction", 5)
RunConsoleCommand("sv_sticktoground", 0)
RunConsoleCommand("sv_airaccelerate", 120)
RunConsoleCommand("sv_gravity", 860)

util.AddNetworkString("DeathNotification")

local playermodels = {
	"models/player/group01/male_01.mdl",
	"models/player/group01/male_02.mdl",
	"models/player/group01/male_03.mdl",
	"models/player/group01/male_04.mdl",
	"models/player/group01/male_05.mdl",
	"models/player/group01/male_06.mdl",
	"models/player/group01/male_07.mdl",
	"models/player/group01/male_08.mdl",
	"models/player/group01/male_09.mdl",
}
local playermodels_fem = {
	"models/player/group01/female_01.mdl",
	"models/player/group01/female_02.mdl",
	"models/player/group01/female_03.mdl",
	"models/player/group01/female_04.mdl",
	"models/player/group01/female_05.mdl",
	"models/player/group01/female_06.mdl",
}

local function SpawnSpectator( ply )
	ply:KillSilent()
	ply:SetTeam(  TEAM_SPECTATOR )
	ply:BeginSpectate()

	return GAMEMODE:PlayerSpawnAsSpectator( ply )
end

hook.Add("PlayerInitialSpawn", "DeathrunPlayerInitialSpawn", function( ply )

	ply.FirstSpawn = true
	ply.LastActiveTime = CurTime()
	ply:SetTeam(TEAM_GARPIES)
	
/*
	ply:SetTeam(math.random(1,2))
	ply:SetModel("models/player/Group01/female_0".. math.random(1,9) .. ".mdl")
	ply:SetSkin(3)
	ply:SendLua([[chat.AddText(Color(0, 255, 0), "Добро пожаловать!")]])
*/
end)

hook.Add("PlayerSpawn", "SetModelAfterSpawn", function( ply )
	local pltable
	if ply:GetPData("woman") == "true" then
		pltable = playermodels_fem
	else
		pltable = playermodels
	end
	ply:SetModel( table.Random( pltable ) )
	
	local mdl = hook.Call("ChangePlayerModel", nil, ply)
	if mdl then
		ply:SetModel( mdl )
	else
		if (not ply:GetModel()) or ply:GetModel() == "models/player.mdl" then
			ply:SetModel( table.Random( pltable ) )
		end
	end
	
end)


function GM:EntityTakeDamage( target, dmginfo )
	local ply = target
	local attacker = dmginfo:GetAttacker()

	if target:IsPlayer() && attacker:IsPlayer() && attacker:IsSuperAdmin() then
			umsg.Start( "ChatBroadcastMurder",attacker)
				umsg.String("Нанес "..tostring(dmginfo:GetDamage()).." урона.")
				umsg.Vector(Vector(255,255,255))
			umsg.End()
			
		//attacker:DeathrunChatPrint("Нанес "..tostring(dmginfo:GetDamage()).." урона.")
	end
	
	if target:IsPlayer() then
		if ROUND:GetCurrent() == ROUND_WAITING or ROUND:GetCurrent() == ROUND_PREP then
		
			umsg.Start( "ChatBroadcastMurder", target)
				umsg.String("Вы получили "..tostring(dmginfo:GetDamage()).." урона.")
				umsg.Vector(Vector(255,255,255))
			umsg.End()
			
			dmginfo:SetDamage(0)
		end
	end
	if OPTIONS.isTwoTeam then
		if target:IsPlayer() and attacker:IsPlayer() then
			if target:Team() == attacker:Team() and target ~= attacker then
				local od = dmginfo:GetDamage()
				dmginfo:SetDamage(0)				
			end
		end
	end

	if ( target:IsPlayer()) and target:GetNWBool("dissole") then //на будущее.
		if target:Health() <= dmginfo:GetDamage() then
			dmginfo:SetDamageType(DMG_DISSOLVE)
		end
	end

	local dmg = dmginfo:GetDamage()
	if dmg > 0 then
		if dmginfo:GetDamageType() == DMG_DROWN then
			local drownsounds = {
				"player/pl_drown1.wav",
				"player/pl_drown2.wav",
				"player/pl_drown3.wav",
			}
			ply:EmitSound( table.Random( drownsounds ), 400, 100, 1 )
		end
	end
end

MG.SpecBuffer = {}

function ADasd(ply)
	//print(ply:ShouldStaySpectating(), ply)
	
	if ply:ShouldStaySpectating() then
		//print(ply)
		return SpawnSpectator( ply )
	end
end


hook.Add("PlayerSpawn", "First", ADasd, -1)

hook.Add("PlayerSpawn", "DeathrunPlayerSpawn", function( ply )
	ply:AllowFlashlight( true )
	ply:SetMoveType(MOVETYPE_WALK)
	
	
	if OPTIONS.isTwoTeam then
		ply:SetRenderMode( RENDERMODE_TRANSALPHA )
		ply:SetNoCollideWithTeammates( true )
	end
	
	if OPTIONS.colliderPlayer then
		ply:SetNoCollideWithTeammates( true )
	end
	
	ply:SetLagCompensated( true )
	if ply.FirstSpawn then
		ply.FirstSpawn = false
		if ROUND:GetCurrent() != ROUND_WAITING then
			if #player.GetAllPlaying() > 1 then
				table.insert(MG.SpecBuffer, ply)
				timer.Simple(0, function() 
					for k, ply in pairs( MG.SpecBuffer ) do
						if IsValid( ply ) then
							ply:SetShouldStaySpectating( true, false )
							table.remove(MG.SpecBuffer, k)
						end
					end
				end)
				return SpawnSpectator( ply )
			end
		end
		hook.Call("PlayerLoadout", self, ply)
	end
	
	local spawns = team.GetSpawnPoints( ply:Team() ) or {}
	if #spawns > 0 then
		ply:SetPos( table.Random(spawns):GetPos() )
	end

end)


function GM:PlayerLoadout( ply )
	ply:SetRunSpeed( 255 )
	ply:SetWalkSpeed( 255 )
	ply:SetJumpPower( 290 )

	ply:DrawViewModel( true )
	ply:SetupHands( ply )
	ply:StopSpectate()
	
	if ROUND:GetCurrent() == ROUND_WAITING then
		if #player.GetAllPlaying() <= 1 then
			if ply:Team() == 1001 then
				ply:SetTeam(TEAM_GARPIES)
			else
				ply:SetTeam(ply:Team())
			end
		end
	end
	//return self.BaseClass:PlayerLoadout( ply )
	
end	


function GM:PlayerDeath( ply, inflictor2, attacker2 )

	ply:Extinguish()
	
	ply:SetupHands( nil )
	ply:DrawViewModel( false )

	for k,v in ipairs(ply:GetWeapons()) do
			
		if not v:IsValid() then continue end
		if v:GetClass() == 'weapon_boombox' then continue end				
		if string.find( v:GetClass(), "csgo_tridagger" ) ~= nil or string.find( v:GetClass(), "csgo_scifi" ) ~= nil  or string.find( v:GetClass(), 'csgo_pickaxe' ) ~= nil  then continue end

		if weapons.Get(v:GetClass() ) == nil then
			ply:DropWeapon( v )
			continue
		end

		if string.find( weapons.Get( v:GetClass() ).WorldModel, "_csgo_" ) ~= nil then
			continue 
		end

		ply:DropWeapon( v )

	end
	
	/*
	if attacker2:IsValid() and attacker2:IsPlayer() then
		if attacker2:GetActiveWeapon():GetClass() == 'csgo_pickaxe' then
			attacker2:GetActiveWeapon():ChangeType()
		end
	end
	*/
	timer.Simple(5, function()
		if not IsValid( ply ) then return end
		if not ply:Alive() then

			local pool = {}
			for k,ply in ipairs(player.GetAll()) do
				if ply:Alive() and not ply:Team() == TEAM_SPECTATOR then
					table.insert(pool, ply)
				end
			end
			ply:BeginSpectate()
			if #pool > 0 then
				local randplay = table.Random(pool)
				ply:SpectateEntity( randplay )
				ply:SetupHands( randplay )
				ply:SetObserverMode( OBS_MODE_IN_EYE )
				ply:SetPos( randplay:GetPos() )
			end

		end
	end)
	
	table.insert( MG.KillList, ply )
end

MG.KillList = {}

timer.Create("DeathrunSendKillList", 0.7,0,function()
	if #MG.KillList > 0 then
		local message = ""
		local femtext
		local femtext2
		-- remove the invalid players
		for k,v in ipairs(MG.KillList) do
			if not IsValid(v) then
				table.remove( MG.KillList, k )
			end
		end

		for i = 1, #MG.KillList do
			local ply = MG.KillList[i]
			if IsValid(ply) then
				if i < #MG.KillList-1 then
					message = message..(i == 1 and "" or " ")..ply:Nick()..","
					if i%4 == 0 then
						message = message.."%newline%"
					end
				elseif i == #MG.KillList - 1 then
					message = message.." "..ply:Nick().." и"
				else
					message = message.." "..ply:Nick()
				end
			
				if ply:GetPData("woman") == "true" then
					femtext = "была"
					femtext2 = "убита"
				else
					femtext = "был"
					femtext2 = "убит"
				end
			end
			

		end
		message = message .." "..femtext.." "..femtext2.."!"
		MG:DeathNotification( message )
		MG.KillList = {}
	end
end)

function MG:DeathNotification( msg ) 
	net.Start("DeathNotification")
	net.WriteString( msg )
	net.Broadcast( )
end

function GM:PlayerDeathThink( ply )

	return false
end

hook.Add( "PlayerCanPickupWeapon", "Pickup", function( ply, wep )

	local class = wep:GetClass()
	local weps = ply:GetWeapons()
	local wepsclasses = {}
	local filledslots = {}

	local slot0, slot1, slot3 = 0,0,0

	local secondaries = 0
	local primaries = 0
	
	if wep:GetClass() == "weapon_knife" then 
		if ply:GetNWString("ps_weapon") == '' then
			ply:SetNWString("ps_weapon",'csgo_default_knife')
		end
			
		local KnifeTable = util.JSONToTable(ply:GetPData("KnifeTable") or '{}')
		//PrintTable(KnifeTable)
		//print(KnifeTable == nil)
		if KnifeTable ~= nil then
		if #KnifeTable > 1 and ply:GetPData("KnifeTableON") == 'true' then
			local localtable = {}
			for k, v in pairs(KnifeTable) do
				//if v  ply:GetNWString("ps_weapon") then
				if PS.Items[v].WeaponClass ~= ply:GetNWString("ps_weapon_lastknife") then
				
				local name = PS.Items[v].WeaponClass
					table.insert( localtable, name)
					//PrintTable(PS.Items[v])
				end
			end
			local randtablekn = table.Random(localtable)
			//if 
			if randtablekn == '' then
				ply:SetNWString("ps_weapon",'csgo_default_knife')
			end
			
			ply:SetNWString("ps_weapon", randtablekn)
			ply:SetNWString("ps_weapon_lastknife", randtablekn)
		end
		end
			
		
		ply:Give( ply:GetNWString("ps_weapon") )
		

		wep:Remove()
	end
	
	for k,v in ipairs(weps) do
		table.insert( wepsclasses, v:GetClass() )
		if v.Slot ~= nil then
			if v.Slot == 0 then
				slot0 = slot0 + 1
			end			
			if v.Slot == 1 then
				slot1 = slot1 + 1
			end
			if v.Slot == 2 then
				slot3 = slot3 + 1
			end
			if v.Slot == 3 then
				slot3 = slot3 + 1
			end
		end
	end
	
	if wep.Slot == 0 and slot0 > 0 then return false end
	if wep.Slot == 1 and slot1 > 0 then return false end
	if wep.Slot == 2 and slot1 > 0 then return false end
	//if wep.Slot == 3 and slot3 > 0 then return false end
	if table.HasValue(wepsclasses, class) then return false end

	if type(ply.ADWPN) ~= "table" then
		ply.ADWPN = {}
		return
	end
end)


-- stop people whoring the weapons
hook.Add("WeaponEquip", "Check", function( weapon )
	timer.Simple(0, function()
		if not weapon:IsValid() then return false end
		local ply = weapon:GetOwner() -- no longer a null entity.
 
 
		for k, v in pairs(ply.ADWPN) do
			local words = string.Explode( "_", v )
			if words[1].."_"..words[2] == weapon:GetClass() then
				ply:StripWeapon( weapon:GetClass() )
				ply:Give(v)
				//ply:PrintMessage(3, "1Picked Up: "..weapon:GetClass()) -- inform the player.
			end
		end
	end) 
end)

timer.Create("DeathrunDrowningStuff", 0.5,0,function()
	for k,ply in ipairs( player.GetAll() ) do
		ply.LastOxygenTime = ply.LastOxygenTime or CurTime()

		if ply:WaterLevel() == 3 then --they are submerged completely
			local timeUnder = CurTime() - ply.LastOxygenTime
			if timeUnder > 20 then
				local di = DamageInfo()
				di:SetDamage( 5 )
				di:SetDamageType( DMG_DROWN )
				ply:TakeDamageInfo( di )
				ply:ViewPunch( Angle( 0,0,math.random(-1,1) ) )
			end
		else
			ply.LastOxygenTime = CurTime()
		end

		if not ply:Alive() or ply:GetSpectate() then
			ply.LastOxygenTime = CurTime()
		end
	end
end)



concommand.Add("dropweapon", function( ply, cmd, args)//"fist" or "knife"
	if not ply:GetActiveWeapon():IsValid() then return end
 	if !ply:Alive() then return end
	if ply:GetActiveWeapon():GetClass() == 'weapon_boombox' then
	return 
	end
	 
	if string.find( ply:GetActiveWeapon():GetClass(), "csgo_tridagger" ) ~= nil or string.find( ply:GetActiveWeapon():GetClass(), "csgo_scifi" ) ~= nil or string.find( ply:GetActiveWeapon():GetClass(), "csgo_pickaxe" ) ~= nil  then
		return 
	end
	if weapons.Get( ply:GetActiveWeapon():GetClass() ) == nil then
		if ply:Alive() and ply:GetActiveWeapon() ~= nil and IsValid( ply:GetActiveWeapon() ) then
			ply:DropWeapon( ply:GetActiveWeapon() )
			return
		end
	end

	if string.find( weapons.Get( ply:GetActiveWeapon():GetClass() ).WorldModel, "_csgo_" ) ~= nil then
		return 
	end

	if ply:Alive() and ply:GetActiveWeapon() ~= nil and IsValid( ply:GetActiveWeapon() ) then
		ply:DropWeapon( ply:GetActiveWeapon() )
	end

end)

hook.Add("PlayerSay", "tt", function(ply,text)

	if text == '1' then
		game.CleanUpMap()
	end
	
	if text == '2' then
		game.ConsoleCommand('target awp_tele-CT')
	end
	
	if text == '3' then
		for i,v in pairs(ents.GetAll()) do
			if v:GetClass() == 'filter_activator_team' then
				if v:GetName() == "T" then
					v:SetKeyValue('filterteam', 2)
				end
				if v:GetName() == "CT" then
					v:SetKeyValue('filterteam', 1)
				end
				
			end
		end
	end

end)


function GM:GetFallDamage( ply, speed )
	if OPTIONS.disableFallDamage then
		return 0
	end

	local damage = math.max( 0, math.ceil( 0.2418*speed - 141.75 ) )
	return damage
end

function GM:PlayerNoClip( ply )
	return ply:IsSuperAdmin() || ply:GetMoveType() == MOVETYPE_NOCLIP
end

local CallInput = {
	phys_pushscale = function(args)
		game.ConsoleCommand("phys_pushscale " .. args[1] .. "\n");
	end,
	say = function(args)
		tableex = table.concat(args, " ");
		BroadcastLua("chat.AddText(Color(255,255,255),'[',Color(96,24,140),'MAP',Color(255,255,255),'] "..tableex.."')");
	end,
}

function GM:AcceptInput(ent, command, _, _, values)
		if values ~= nil then
			
			print(ent:GetClass(),command, values)
		end
	if ent:GetClass() == 'point_servercommand' and command == 'Command' then
		local args = string.Explode(" ", values)
			//PrintTable(args)
		if CallInput[args[1]] then
			tables = table.Copy(args)
			table.remove(tables, 1)
			CallInput[args[1]](tables)
		end
		
	end
end
