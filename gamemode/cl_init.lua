//CLIENTSIDE


/*include "cf.lua" 
include "cl_hud.lua"
include "roundsystem/cl_round.lua" 
include "roundsystem/sh_round.lua" 
include "sh_setupround.lua" 
include "sh_functions.lua" 
include "lobby/cl_lobby.lua"
include "cl_voicepanel.lua"

include "mapvote/sh_mapvote.lua"
include "mapvote/cl_mapvote.lua"*/

include ("shared.lua")
include ("modulesloader.lua")

include "sh_cf.lua" 
include "cl_hud.lua"

include "sh_setupround.lua" 
include "sh_functions.lua" 

include "cl_voicepanel.lua"

hook.Add("PrePlayerDraw", "TransparencyPlayers", function( ply )

	if ply:GetRenderMode() ~= RENDERMODE_TRANSALPHA then
		ply:SetRenderMode( RENDERMODE_TRANSALPHA )
	end

	local fadedistance = 75

	local eyedist = LocalPlayer():EyePos():Distance( ply:EyePos() )
	local col = ply:GetColor()

	if eyedist < fadedistance and LocalPlayer() ~= ply then
		local frac = InverseLerp( eyedist, 5, fadedistance )
		
		col.a = Lerp( frac, 20, 255 )

		if ply:Team() ~= LocalPlayer():Team() then col.a = 255 end

		ply:SetColor( col )
	elseif LocalPlayer() == ply then
		col.a = 255
		ply:SetColor( col )
	else
		col.a = 255
		ply:SetColor( col )
	end

end)

function GM:PreDrawViewModel( vm, ply, wep )
	local ply = LocalPlayer()
	if ply:GetObserverMode() == OBS_MODE_CHASE or ply:GetObserverMode() == OBS_MODE_ROAMING then
		return true
	end
	if ( !IsValid( wep ) ) then return false end



	player_manager.RunClass( ply, "PreDrawViewModel", vm, wep )



	if ( wep.PreDrawViewModel == nil ) then return false end

	return wep:PreDrawViewModel( vm, wep, ply )
end
function GM:PreDrawPlayerHands( hands, vm, ply, wep )
	if ply:GetObserverMode() == OBS_MODE_CHASE or ply:GetObserverMode() == OBS_MODE_ROAMING then
		return true
	end
end


CreateClientConVar("deathrun_spectate_only", 0, true, false)
cvars.AddChangeCallback( "deathrun_spectate_only", function( name, old, new )
	RunConsoleCommand( "deathrun_set_spectate", new )
end)

-- thirdperson support -- from arizard_thirdperson.lua
if CLIENT then
	local ThirdpersonOn = CreateClientConVar("deathrun_thirdperson_enabled", 0, true, false)

	local function CalcViewThirdPerson( ply, pos, ang, fov, nearz, farz )
			-- test for thirdperson scoped weapons

		if ThirdpersonOn:GetBool() == true and ply:Alive() and (ply:Team() ~= TEAM_SPECTATOR) then
			local view = {}

			local newpos = Vector(0,0,0)
			local dist = 100
			local nije = 9
			
			local vR = 0
			local vF = 0
			local iai = false
			/* First */
			if iai then
				dist = -100
				nije = -9
				vR = 180
				vF = 180
			end
			local tr = util.TraceHull(
				{
				start = pos, 
				endpos = pos + ang:Forward()*-dist + Vector(0,0,nije) + ang:Right()+ ang:Up(),
				mins = Vector(-5,-5,-5),
				maxs = Vector(5,5,5),
				filter = player.GetAll(),
				mask = MASK_SHOT_HULL
				
			})

			newpos = tr.HitPos
			view.origin = newpos

			local newang = ang
			newang:RotateAroundAxis( ply:EyeAngles():Right(), vR )
			newang:RotateAroundAxis( ply:EyeAngles():Up(), 0 )
			newang:RotateAroundAxis( ply:EyeAngles():Forward(), vF )

			view.angles = newang
			view.fov = fov



			--print( tracedist )

			return view
		end

	end
	hook.Add("CalcView", "deathrun_thirdperson_script", CalcViewThirdPerson )
	
	function GM:PlayerStartVoice() end
	function GM:PlayerEndVoice() end
	
		
	window = {}
	
	window.panels = vgui.Create("Panel", self)
	window.panels:ParentToHUD()
	window.panels:SetPos( ScrW() - 300, 100 )
	window.panels:SetSize( 250, ScrH() - 200 )
	
		timer.Simple(2,function()
		hook.Add("PlayerStartVoice","hud2",function( ply )
			if !IsValid(LocalPlayer()) or !LocalPlayer():IsPlayer() then return end
			if IsValid(ply.vp) and ispanel(ply.vp) then
				ply.vp:Remove()
			end
			ply.vp = vgui.Create("DVoicePanel2",window.panels)
			if !IsValid(ply.vp) or !ispanel(ply.vp) then return end

			ply.vp:Setup(ply)
		end)
	end)
		hook.Add("Tick","destroy",function()
		for _,ply in pairs(player.GetAll())do
			if !ply.vp or !ispanel(ply.vp) then continue end
			if !ply:IsSpeaking() and IsValid(ply.vp) then
				ply.vp:SetDestroy(EndVoice)
			end
		end
	end)
	local function DrawLocalPlayerThirdPerson()
		local ply = LocalPlayer()
		if ThirdpersonOn:GetBool() == true and ply:Alive() and (ply:Team() ~= TEAM_SPECTATOR) then
			return true
		end
	end
	hook.Add("ShouldDrawLocalPlayer", "deathrun_thirdperson_script", DrawLocalPlayerThirdPerson)
else

end


concommand.Add("+menu", function()
	RunConsoleCommand("dropweapon")
end)
