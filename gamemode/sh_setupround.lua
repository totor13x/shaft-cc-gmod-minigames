ROUND_WAITING = 3
ROUND_PREP = 4
ROUND_PREPARING = ROUND_PREP
ROUND_ACTIVE = 5
ROUND_OVER = 6
ROUND_ENDING = ROUND_OVER

RoundDuration = 60*5
AutoSlay = 60*5
PrepDuration = 4
FinishDuration = 10
RoundLimit = 10

ROUND_TIMER = ROUND_TIMER or 0

WIN_GARPIES = 997
WIN_SATIRES = 998
STAND_OFF = 999

ROUND_TIMER = ROUND_TIMER or 0
function ROUND:GetTimer() 
	return ROUND_TIMER or 0
end

timer.Create("TimerCooldown", 0.2, 0, function()
	ROUND_TIMER = ROUND_TIMER - 0.2
	if ROUND_TIMER < 0 then ROUND_TIMER = 0 end
end)


if SERVER then
	util.AddNetworkString("SyncTimer")
	function ROUND:SyncTimer()
		net.Start("SyncTimer")
		net.WriteInt( ROUND:GetTimer(), 16 )
		net.Broadcast()
	end
	function ROUND:SyncTimerPlayer( ply )
		net.Start("SyncTimer")
		net.WriteInt( ROUND:GetTimer(), 16 )
		net.Send( ply )
	end
	function ROUND:SetTimer( s )
		ROUND_TIMER = s
		ROUND:SyncTimer()
	end
else
	net.Receive("SyncTimer", function( len, ply )
		ROUND_TIMER = net.ReadInt( 16 )
	end)
end

local rounds_played = 0

function ROUND:GetRoundsPlayed()
	return rounds_played
end

function ROUND:SetRoundPlayed(num)
	rounds_played = num
end

function SpawnedSinglePlayer(ply)
	if #player.GetAll() <= 1 then
		if SERVER then
			ply:SetTeam(TEAM_GARPIES)
			ply:Spawn()
			game.CleanUpMap()
			
			umsg.Start( "ChatBroadcastMurder", ply)
				umsg.String("Карта очищена!")
				umsg.Vector(Vector(255,255,255))
			umsg.End()
		end
	end
	ROUND:SyncTimerPlayer( ply )
	
	net.Start("ROUND_STATE")
	net.WriteInt( ROUND:GetCurrent(), 16 )
	net.Send( ply )
end

hook.Add("PlayerInitialSpawn", "SpawnedSinglePlayer", SpawnedSinglePlayer, 2)

ROUND:AddState( ROUND_WAITING,
	function()
	
		if SERVER then
			for k,ply in ipairs(player.GetAllPlaying()) do
				ply:StripWeapons()
				ply:StripAmmo()
				ply:Spawn()
			end

			timer.Create("StaringStateCheck", 5, 0, function()
				if #player.GetAllPlaying() >= 2 then
					ROUND:RoundSwitch( ROUND_PREP )
					timer.Destroy( "StaringStateCheck" )
				end
			end)
		end

	end,
	function()
	--thinking
	end,
	function()
		print("Exiting: WAITING")
	end
)

ROUND:AddState( ROUND_PREP,
	function()
		print("Round State: PREP")
		
		if SERVER then

			game.CleanUpMap()

			timer.Simple( PrepDuration, function()
				ROUND:RoundSwitch( ROUND_ACTIVE )
			end)

			ROUND:SetTimer( PrepDuration )

			for k,ply in ipairs(player.GetAll()) do
				if not ply:ShouldStaySpectating() then 
					ply:KillSilent()
					ply:SetTeam( TEAM_SPECTATOR )
				end
			end
			if OPTIONS.isTwoTeam then
				local GARPIES = {}
				local SATIRES = {}
				local pool = table.Copy( player.GetAllPlaying() )
							
				local timesLooped = 0
				while #player.GetAllPlaying()/2 > #GARPIES and timesLooped < 100 do
					//print(#player.GetAllPlaying()/2, #GARPIES)
						local randnum, randkey = table.Random(pool)
						if randnum:IsValid() then
							table.insert( GARPIES, randnum )
							table.remove( pool, randkey )
						end

					timesLooped = timesLooped + 1
				end

				if timesLooped >= 100 then
					print("---WARNING!!!!! WHILE LOOP EXCEEDED ALLOWED LOOP TIME!!!!-----")
				end

				SATIRES = table.Copy( pool )
				pool = {}
				
				--now, spawn all deaths
				for k,SATIR in ipairs( SATIRES ) do
					SATIR:StripWeapons()
					SATIR:StripAmmo()

					SATIR:SetTeam( TEAM_SATIRES )
					SATIR:Spawn()
				end

				--now, spawn all runners
				for k,GARPIE in ipairs( GARPIES ) do
					GARPIE:StripWeapons()
					GARPIE:StripAmmo()

					GARPIE:SetTeam( TEAM_GARPIES )
					GARPIE:Spawn()
				end
				for k,v in ipairs(player.GetAllPlaying()) do
					if not v:Alive() then
						v:Spawn()
					end
				end
			else
				for k,GARPIE in ipairs( player.GetAllPlaying() ) do
					GARPIE:StripWeapons()
					GARPIE:StripAmmo()

					GARPIE:SetTeam( TEAM_GARPIES )
					GARPIE:Spawn()
				end
				for k,v in ipairs(player.GetAllPlaying()) do
					if not v:Alive() then
						v:Spawn()
					end
				end
			end
		end
	end,
	function()
	end,
	function()
	end
)

ROUND:AddState( ROUND_ACTIVE,
	function()
		if SERVER then
			ROUND:SetTimer( RoundDuration )
		end
	end,
	function()
		if SERVER then
			if #player.GetAllPlaying() < 2 then
				ROUND:RoundSwitch( ROUND_WAITING )
				return
			end
			if OPTIONS.isTwoTeam then
				local SATIRES = {}
				local GARPIES = {}

				for k,v in ipairs(player.GetAllPlaying()) do
					if v:Alive() then
						if v:Team() == TEAM_SATIRES then
							table.insert(SATIRES, v)
						elseif v:Team() == TEAM_GARPIES then
							table.insert( GARPIES, v )
						end
					end
				end

				if (#SATIRES == 0 and #GARPIES == 0) or ROUND:GetTimer() == 0 then
					ROUND:FinishRound( STAND_OFF, true )
				elseif #SATIRES == 0 then
					ROUND:FinishRound( WIN_GARPIES, true )
				elseif #GARPIES == 0 then
					ROUND:FinishRound( WIN_SATIRES, true )
				end
			else
				local GARPIES = {}
				for k,v in ipairs(player.GetAllPlaying()) do
					if v:Alive() then
						table.insert( GARPIES, v )
					end
				end
				if #GARPIES <= 0 or ROUND:GetTimer() == 0 then
					ROUND:FinishRound( STAND_OFF, false )
				elseif #GARPIES == 1 then
					ROUND:FinishRound( GARPIES[1], false )
				end
			end
		end
	end,
	function()
		print("Exiting: ACTIVE")
	end
)
ROUND:AddState( ROUND_OVER,
	function()
		print("Round State: OVER")
		rounds_played = rounds_played + 1
		if SERVER then
			local tetd, teter
			if rounds_played < RoundLimit then
				if rounds_played == 0 then
					tetd = 'раундов'
				elseif rounds_played == 1 then
					tetd = 'раунд'
				elseif rounds_played < 5 then
					tetd = 'раунда'
				else 
					tetd = 'раундов'
				end

				if RoundLimit - rounds_played == 0 then
					teter = 'раундов'
				elseif RoundLimit - rounds_played == 1 then
					teter = 'раунд'
				elseif RoundLimit - rounds_played < 5 then
					teter = 'раунда'
				else 
					teter = 'раундов'
				end

				for i,v in pairs(player.GetAll()) do
					umsg.Start( "ChatBroadcastMurder", v)
						umsg.String("Прош"..(rounds_played~=1 and "ло" or "ел").." "..tostring(rounds_played).." "..tetd..". Остал"..(rounds_played~=1 and "ось " or "ся ")..tostring(RoundLimit - rounds_played).." "..teter..".")
						umsg.Vector(Vector(255,255,255))
					umsg.End()
				end
				//BroadcastLua('chat.AddText(Color(50, 50, 200), "Прош'..(rounds_played~=1 and "ло" or "ел").." "..tostring(rounds_played).." "..tetd..". Остал"..(rounds_played~=1 and "ось " or "ся ")..tostring(RoundLimit - rounds_played).." "..teter..'.")')
				
				ROUND:SetTimer( FinishDuration )
				timer.Simple(FinishDuration , function()
					ROUND:RoundSwitch( ROUND_PREP )
				end)
			else
				local shouldswitch = hook.Call("DeathrunShouldMapSwitch") or true
				
				if shouldswitch == true then
				
					for i,v in pairs(player.GetAll()) do
						umsg.Start( "ChatBroadcastMurder", v)
							umsg.String("Количество раундов достигло предела. Запускаем RTV...")
							umsg.Vector(Vector(255,255,255))
						umsg.End()
					end
					//BroadcastLua('chat.AddText(Color(150, 150, 200), "Количество раундов достигло предела. Запускаем RTV...")')
					timer.Simple(3, function()
						MV:BeginMapVote()
					end)
				end
			end
		end
	end,
	function()
	--thinking
	end,
	function()
		print("Exiting: OVER")
	end
)



if SERVER then
	
	function ROUND:FinishRound( winteam, isTwoTeam )
		if isTwoTeam then
			local nonesds
			if winteam == WIN_GARPIES then
				nonesds = "Гарпии"
			elseif winteam == WIN_SATIRES then
				nonesds = "Сатиры"
			end
			
			for i,v in pairs(player.GetAll()) do
				umsg.Start( "ChatBroadcastMurder", v)
					umsg.String("Раунд закончился! " ..( winteam == WIN_GARPIES and nonesds.." победили!" or winteam == WIN_SATIRES and nonesds.." победили!" or "Ой, все!" ))
					umsg.Vector(Vector(255,255,255))
				umsg.End()
			end
			//BroadcastLua("chat.AddText(Color(150, 150, 200), 'Раунд закончился! " ..( winteam == WIN_GARPIES and nonesds.." победили!" or winteam == WIN_SATIRES and nonesds.." победили!" or "Ой, все!" ).."')")
			//DR:ChatBroadcast("Раунд закончился! "..( winteam == WIN_GARPIES and nonesds.." победили!" or winteam == WIN_SATIRES and nonesds.." победили!" or "Ой, все!" ) )
		--calculate MVPs
		else 
			if winteam == STAND_OFF then
			
				for i,v in pairs(player.GetAll()) do
					umsg.Start( "ChatBroadcastMurder", v)
						umsg.String('Раунд закончился! Ой, все!')
						umsg.Vector(Vector(255,255,255))
					umsg.End()
				end
				//BroadcastLua("chat.AddText(Color(150, 150, 200), 'Раунд закончился! Ой, все!')")
			else
				for i,v in pairs(player.GetAll()) do
					umsg.Start( "ChatBroadcastMurder", v)
						umsg.String("Раунд закончился! " .. (winteam:IsValid() and winteam:Nick() .." победил!" or "Ой, все!" ))
						umsg.Vector(Vector(255,255,255))
					umsg.End()
				end
				//BroadcastLua("chat.AddText(Color(150, 150, 200), 'Раунд закончился! " .. (winteam:IsValid() and winteam:Nick() .." победил!" or "Ой, все!" ).."')")
			end
		end
		ROUND:RoundSwitch( ROUND_OVER )
	end

	--initial round

	hook.Add("InitPostEntity", "DeathrunInitialRoundState", function()
		ROUND:RoundSwitch( ROUND_WAITING )
	end)
end
