// SHARED
MG = {}

GM.Name = "MiniGames"
GM.Author = "N/A"
GM.Email = "N/A"
GM.Website = "lidi.su"

TEAM_GARPIES = 3
TEAM_SATIRES = 2

team.SetUp(TEAM_GARPIES, "Гарпии", Color(200, 70, 70, 255))
team.SetUp(TEAM_SATIRES, "Сатиры", Color(70, 70, 200, 255))

function GM:Initialize()
	-- Do stuff
	self.BaseClass.Initialize(self)
end

function player.GetAllPlaying()
	local pool = {}
	for k,ply in ipairs(player.GetAll()) do
		if ply then
			if ( ply:ShouldStaySpectating() == false ) then
				table.insert(pool, ply)
			end
		end
	end
	return pool
end

local defaultFlags = FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE + FCVAR_CLIENTCMD_CAN_EXECUTE


hook.Add("StartCommand", "DeathrunDisableSpase", function( ply, mv, cmd )
	if ply:Alive() then
		if ROUND:GetCurrent() == ROUND_PREP then
			--mv:SetButtons( bit.band( mv:GetButtons(), bit.bnot( IN_JUMP ) ) )

			local block = hook.Call("DeathrunPreventPreptimeMovement") or true

			if block == true then
				mv:ClearButtons()
				mv:ClearMovement()
			end
		end
	end
end)

function GM:CreateTeams()

	team.SetUp(TEAM_GARPIES, "Гарпии", Color( 50, 50, 50 ), false)
	team.SetUp(TEAM_SATIRES, "Сатиры", Color( 150, 50, 50 ), false)

	team.SetSpawnPoint( TEAM_GARPIES, "info_player_terrorist" )
	team.SetSpawnPoint( TEAM_SATIRES, "info_player_counterterrorist" )

	team.SetColor( TEAM_SPECTATOR, Color(100,100,100) )
end

local lp, ft, ct, cap = LocalPlayer, FrameTime, CurTime
local mc, mr, bn, ba, bo, gf = math.Clamp, math.Round, bit.bnot, bit.band, bit.bor, {}

function GM:Move( ply, data )

	-- fixes jump and duck stop
	local og = ply:IsFlagSet( FL_ONGROUND )
	if og and not gf[ ply ] then
		gf[ ply ] = 0
	elseif og and gf[ ply ] then
		gf[ ply ] = gf[ ply ] + 1
		if gf[ ply ] > 4 then
			ply:SetDuckSpeed( 0.4 )
			ply:SetUnDuckSpeed( 0.2 )
		end
	end

	if og or not ply:Alive() then return end
	
	gf[ ply ] = 0
	ply:SetDuckSpeed(0)
	ply:SetUnDuckSpeed(0)

	if not IsValid( ply ) then return end
	if lp and ply ~= lp() then return end
	
	if ply:IsOnGround() or not ply:Alive() then return end
	
	local aim = data:GetMoveAngles()
	local forward, right = aim:Forward(), aim:Right()
	local fmove = data:GetForwardSpeed()
	local smove = data:GetSideSpeed()
	
	if data:KeyDown( IN_MOVERIGHT ) then smove = smove + 500 end
	if data:KeyDown( IN_MOVELEFT ) then smove = smove - 500 end
	
	forward.z, right.z = 0,0
	forward:Normalize()
	right:Normalize()

	local wishvel = forward * fmove + right * smove
	wishvel.z = 0

	local wishspeed = wishvel:Length()
	if wishspeed > data:GetMaxSpeed() then
		wishvel = wishvel * (data:GetMaxSpeed() / wishspeed)
		wishspeed = data:GetMaxSpeed()
	end

	local wishspd = wishspeed
	wishspd = mc( wishspd, 0, 30 )

	local wishdir = wishvel:GetNormal()
	local current = data:GetVelocity():Dot( wishdir )

	local addspeed = wishspd - current
	if addspeed <= 0 then return end

	local accelspeed = 1000 * ft() * wishspeed
	if accelspeed > addspeed then
		accelspeed = addspeed
	end
	
	local vel = data:GetVelocity()
	vel = vel + (wishdir * accelspeed)

	if ply.AutoJumpEnabled == true and GetConVar("deathrun_allow_autojump"):GetBool() == true and GetConVar("deathrun_autojump_velocity_cap"):GetFloat() ~= 0 then
		ply.SpeedCap = GetConVar("deathrun_autojump_velocity_cap"):GetFloat()
	else
		ply.SpeedCap = 99999
	end

	
	if ply.SpeedCap and vel:Length2D() > ply.SpeedCap and SERVER then
		local diff = vel:Length2D() - ply.SpeedCap
		vel:Sub( Vector( vel.x > 0 and diff or -diff, vel.y > 0 and diff or -diff, 0 ) )
	end
	data:SetVelocity( vel )
	return false
end

local function AutoHop( ply, data )
	
	if lp and ply ~= lp() then return end
	if not OPTIONS.enable_bhop then return end
	//if PRM.enable_bhop then
	if ply.AutoJumpEnabled == false then return end
	--print(ply.AutoJumpEnabled)
	
	local ButtonData = data:GetButtons()
	if ba( ButtonData, IN_JUMP ) > 0 then
		if ply:WaterLevel() < 2 and ply:GetMoveType() ~= MOVETYPE_LADDER and not ply:IsOnGround() then
			data:SetButtons( ba( ButtonData, bn( IN_JUMP ) ) )
		end
	end
end

hook.Add( "SetupMove", "AutoHop", AutoHop )
