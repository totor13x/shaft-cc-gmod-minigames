// Comparable with Deathrun
local XHairThickness = CreateClientConVar("deathrun_crosshair_thickness", 2, true, false)
local XHairGap = CreateClientConVar("deathrun_crosshair_gap", 8, true, false)
local XHairSize = CreateClientConVar("deathrun_crosshair_size", 8, true, false)
local XHairRed = CreateClientConVar("deathrun_crosshair_red", 255, true, false)
local XHairGreen = CreateClientConVar("deathrun_crosshair_green", 255, true, false)
local XHairBlue = CreateClientConVar("deathrun_crosshair_blue", 255, true, false)
local XHairAlpha = CreateClientConVar("deathrun_crosshair_alpha", 255, true, false)

local HideElements = {
	["CHudBattery"] = true,
	["CHudCrosshair"] = true,
	["CHudHealth"] = true,
	["CHudAmmo"] = true
}

function GM:HUDShouldDraw( el )
	if HideElements[ el ] then
			return false
	else
		return true
	end
end


function GM:HUDPaint()
	
if LocalPlayer():GetNWBool("tonah") then return end


	-- draw crosshair and account for thirdperson mode
	if GetConVar("deathrun_thirdperson_enabled"):GetBool() == true then
		local x,y = 0,0
		local tr = LocalPlayer():GetEyeTrace()
		x = tr.HitPos:ToScreen().x
		y = tr.HitPos:ToScreen().y

		MG:DrawCrosshair( x,y )
	else
		MG:DrawCrosshair( ScrW()/2, ScrH()/2 )
	end

	//MG:DrawTargetID()

	local hx = 8
	local hy = ScrH() - 108 - 8
	local ax = ScrW() - 228 - 8
	local ay = ScrH() - 108 - 8
	
	MG:DrawPlayerHUD( hx, hy )
	//MG:DrawPlayerHUDAmmo( ax, ay )
	
end
	
	
function MG:DrawPlayerHUD( x, y )


	local alpha = 150

	local ply = LocalPlayer()

	if ply:GetObserverMode() ~= OBS_MODE_NONE then
		if IsValid( ply:GetObserverTarget() ) then
			ply = ply:GetObserverTarget()
		end
	end
	if ply:GetClass() == "prop_ragdoll" then return end
	if LocalPlayer():GetObserverMode() ~= OBS_MODE_NONE and LocalPlayer() != ply then
		draw.SimpleText("Набл.: "..ply:Nick(), "deathrun_hud_Large_ssd",  ScrW()-(35), 50-13.5, tcol, TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT )
		LocalPlayer():SetPos( ply:EyePos() )
	end
	
	local tcol = Color(255,255,255,150)
	local textcolor = Color(100,30,30)
	local textcolorExt = textcolor
	local colorHP = textcolor
	local colorOutHP = Color(0,0,0,0)
	local tcolToHP = Color(255,255,255,0)
	colorHPDie = nil
	if OPTIONS.isTwoTeam then
	tcol = team.GetColor(ply:Team())
	textcolorExt = Color(255,255,255,255)
	textcolor = tcol
	colorOutHP = tcol
	colorHP = textcolorExt
	tcolToHP = tcol
	colorHPDie = tcol
	end
	
	local dx, dy = x, y

	
	surface.SetDrawColor( Color(255,255,255,150) )
	surface.DrawRect( 50, dy, 200, 16 )

	draw.SimpleText(  ply:Nick(), "Default", 50+4,  dy + 16/2, textcolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

	dy = dy + 16

	surface.SetDrawColor( Color(255,255,255,150) )

	local curhp = math.Clamp( ply:Health(), 0, 100 )

	surface.DrawRect( 50, dy, 200, 50 )
	surface.SetDrawColor( tcolToHP )
	surface.DrawRect( 50+(100-curhp), dy, curhp*2, 50 )

	surface.SetDrawColor( Color(255,255,255,150) )

		if ply:Health() < 1 then
			draw.SimpleText( "0", "deathrun_hud_Large", 150, ScreenScale(4)+dy+32/2-1,  colorHPDie or colorHP , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, tcol )
		elseif ply:Health() > 255 then
			draw.SimpleText( 'MAR', "deathrun_hud_Large", 150, ScreenScale(4)+dy+32/2-1,  colorHP, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, tcol )
		else
			draw.SimpleTextOutlined( tostring(ply:Health()), "deathrun_hud_Large", 150, ScreenScale(4)+dy+32/2-1,colorHP , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, colorOutHP )
		end

	surface.DrawRect( ScrW()/2-35, 50-13.4, 70, 25 )
	//draw.SimpleText(string.ToMinutesSeconds( math.Clamp( ROUND:GetTimer(), 0, 99999 ) ),"deathrun_hud_Medium",ScrW()/2,48,textcolor,TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
	surface.SetDrawColor( tcol )
	
	
	surface.DrawRect( ScrW()/2-35, 75-13.4, 70, 30 )
	draw.SimpleText(normalize_time(2),"deathrun_hud_Medium_clock",ScrW()/2,69.5,textcolorExt,TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText(normalize_time(1),"deathrun_hud_Small_clock",ScrW()/2,83,textcolorExt,TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	surface.SetDrawColor( Color(255,255,255,150) )

	local spectatePlayers = {}
	local x = 50-13.4
		for k,v in pairs(player.GetAll()) do
		if v:GetObserverTarget() == LocalPlayer() then
			table.insert(spectatePlayers, v:Name())
		end
	end	

	local speed = 0
	local str = ""
		if !IsValid(ob) then
			speed = ply:GetVelocity():Length2D( )/50
		elseif ob:IsPlayer() and ob:Alive() then
			speed = ob:GetVelocity():Length2D( )/50
		end
		if ply:WaterLevel() >= 3 or (IsValid(ob) and ob:WaterLevel() >= 3) then
			speed = speed/5
		end
		speed = tostring(speed)
		if string.sub(speed,3,3) == "." then
			point = string.sub(speed,4,4)
		else
			point = string.sub(speed,3,3)
		end
			if point == "" then
				point = "0"
			end
		if string.sub(speed,2,2) == "." then
			notpoint = string.sub(speed,1,1)
		else
			notpoint = string.sub(speed,1,2)
		end
		str = notpoint.."."..point

		if LocalPlayer():GetNWBool("PlayREC") then 
		local stra = ply:GetVelocity():Length2D( )
			stra = string.Explode( ".", stra )
			
			str = stra[1]
		
		end
	
	surface.DrawRect( ScrW()/2-20, dy+20, 40, 27 )
	draw.SimpleText(str,"deathrun_hud_Medium_clock",ScrW()/2,dy+20+12,textcolor,TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	
	if #spectatePlayers != 0 and LocalPlayer():Alive() then
		surface.SetDrawColor( tcol)
	
		surface.DrawRect( ScrW()-(200+50-13.4), 50-13.4, 200, 20 )
		draw.SimpleText("Наблюдатели","deathrun_hud_Small",ScrW()-(200-4+50-13.4),50-13.4+8,textcolorExt ,TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		
		surface.SetDrawColor( Color(255,255,255,150) )
			for k, v in pairs(spectatePlayers) do
				x = x + 20
				surface.DrawRect( ScrW()-(200+50-13.4), x, 200, 20 )
				draw.SimpleText(v,"deathrun_hud_Small",ScrW()-(100+50-13.4),x+8,textcolor,TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end

	end
if LocalPlayer():GetNWBool("ulx_gagged") and LocalPlayer():GetNWBool("ulx_muted") then
	surface.SetFont("deathrun_hud_Small")
	//local x = surface.GetTextSize("Вам был отключен микрофон: Остался 1 час до включения")
	//local x2 = x/2
	
		if LocalPlayer():GetNWInt('gagend') == 0 and LocalPlayer():GetNWInt('muteend') == 0 then
			surface.DrawRect( 0, 0, ScrW(), 20 )
			draw.SimpleText('Вам были отключены средства связи навсегда.',"deathrun_hud_Small",ScrW()/2,8, Color(148,0,0,255) ,TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			surface.DrawRect( 0, 0, ScrW(), 35 )
			draw.SimpleText('Вам были отключены средства связи',"deathrun_hud_Small",ScrW()/2,6, Color(148,0,0,255) ,TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			if LocalPlayer():GetNWInt('gagend') == 0 then
				draw.SimpleText('Микрофон отключен навсегда',"deathrun_hud_Small",ScrW()/2,6+10, Color(148,0,0,255) ,TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			else
				draw.SimpleText(sec2Min(LocalPlayer():GetNWInt('gagtime'))..' до включения микрофона',"deathrun_hud_Small",ScrW()/2,6+10, Color(148,0,0,255) ,TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
			
			if LocalPlayer():GetNWInt('muteend') == 0 then
				draw.SimpleText('Чат отключен навсегда',"deathrun_hud_Small",ScrW()/2,6+20, Color(148,0,0,255) ,TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			else
				draw.SimpleText(sec2Min(LocalPlayer():GetNWInt('mutetime'))..' до включения чата',"deathrun_hud_Small",ScrW()/2,6+20, Color(148,0,0,255) ,TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
elseif LocalPlayer():GetNWBool("ulx_gagged") then
	surface.SetFont("deathrun_hud_Small")
	surface.DrawRect( 0, 0, ScrW(), 20 )
		if LocalPlayer():GetNWInt('gagend') == 0 then
			draw.SimpleText('Вам был отключен микрофон навсегда.',"deathrun_hud_Small",ScrW()/2,8, Color(148,0,0,255) ,TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			draw.SimpleText('Вам был отключен микрофон: '..sec2Min(LocalPlayer():GetNWInt('gagtime'))..' до включения',"deathrun_hud_Small",ScrW()/2,8, Color(148,0,0,255) ,TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
elseif LocalPlayer():GetNWBool("ulx_muted") then
	surface.SetFont("deathrun_hud_Small")
	//local x = surface.GetTextSize("Вам был отключен микрофон: Остался 1 час до включения")
	//local x2 = x/2
	
	surface.DrawRect( 0, 0, ScrW(), 20 )
		if LocalPlayer():GetNWInt('muteend') == 0 then
			draw.SimpleText('Вам был отключен чат навсегда.',"deathrun_hud_Small",ScrW()/2,8, Color(148,0,0,255) ,TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			draw.SimpleText('Вам был отключен чат: '..sec2Min(LocalPlayer():GetNWInt('mutetime'))..' до включения',"deathrun_hud_Small",ScrW()/2,8, Color(148,0,0,255) ,TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
end


if Glob_Platers != nil and Glob_Platers != 0 then
surface.SetDrawColor( tcol )
surface.DrawRect( 50, 50-13.4, 270, 20 )
draw.SimpleText("Статусы игроков","deathrun_hud_Small",50+4,50-13.4+8, textcolorExt,TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end


end
	

function sec2Min(secs)
local rounds_played2
local ostalost = "Осталось"

	if (secs < 60) then
	
	rounds_played2 = secs;
	local clear_explode = string.sub(rounds_played2, -1)
	clear_explode =	tonumber(clear_explode)
		if(clear_explode == 0) then
			tetd = 'секунд';
		elseif ((rounds_played2 == 11) or (rounds_played2 == 12) or (rounds_played2 == 13) or (rounds_played2 == 14)) then
			tetd = 'секунд';
		elseif (clear_explode == 1) then
			ostalost = "Осталась"
			tetd = 'секунда';
		elseif (clear_explode < 5) then
			tetd = 'секунды';
		else 
			tetd = 'секунд';
		end
	elseif (secs < 3600) then
		rounds_played2 = math.Round(secs / 60);
		
		local clear_explode = string.sub(rounds_played2, -1)
			  clear_explode =	tonumber(clear_explode)
		
		if(clear_explode == 0) then
			tetd = 'минут';
		elseif ((rounds_played2 == 11) or (rounds_played2 == 12) or (rounds_played2 == 13) or (rounds_played2 == 14)) then
			tetd = 'минут';
		elseif (clear_explode == 1) then
			ostalost = "Осталась"
			tetd = 'минута';
		elseif (clear_explode < 5) then
			tetd = 'минуты';
		else 
			tetd = 'минут';
		end
	elseif (secs < 86400) then
		rounds_played2 = math.Round(secs / 3600);
		
		local clear_explode = string.sub(rounds_played2, -1)
			  clear_explode =	tonumber(clear_explode)
		
		if(clear_explode == 0) then
			tetd = 'часов';
		elseif ((rounds_played2 == 11) or (rounds_played2 == 12) or (rounds_played2 == 13) or (rounds_played2 == 14)) then
			tetd = 'часов';
		elseif (clear_explode == 1) then
			ostalost = "Остался"
			tetd = 'час';
		elseif (clear_explode < 5) then
			tetd = 'часа';
		else 
			tetd = 'часов';
		end
	elseif (secs < 2629743) then
		rounds_played2 = math.Round(secs / 86400);
		
		local clear_explode = string.sub(rounds_played2, -1)
			  clear_explode =	tonumber(clear_explode)
		
		if(clear_explode == 0) then
			tetd = 'дней';
		elseif ((rounds_played2 == 11) or (rounds_played2 == 12) or (rounds_played2 == 13) or (rounds_played2 == 14)) then
			tetd = 'дней';
		elseif (clear_explode == 1) then
			ostalost = "Остался"
			tetd = 'день';
		elseif (clear_explode < 5) then
			tetd = 'дня';
		else 
			tetd = 'дней';
		end
	elseif (secs < 31556926) then
		rounds_played2 = math.Round(secs / 2629743);
		
		local clear_explode = string.sub(rounds_played2, -1)
			  clear_explode =	tonumber(clear_explode)
		
		if(clear_explode == 0) then
			tetd = 'месяцев';
		elseif ((rounds_played2 == 11) or (rounds_played2 == 12) or (rounds_played2 == 13) or (rounds_played2 == 14)) then
			tetd = 'месяцев';
		elseif (clear_explode == 1) then
			ostalost = "Остался"
			tetd = 'месяц';
		elseif (clear_explode < 5) then
			tetd = 'месяца';
		else 
			tetd = 'месяцев';
		end
	else
		rounds_played2 = math.Round(secs / 31556926);
		
		local clear_explode = string.sub(rounds_played2, -1)
			  clear_explode =	tonumber(clear_explode)
		
		if(clear_explode == 0) then
			tetd = 'лет';
		elseif ((rounds_played2 == 11) or (rounds_played2 == 12) or (rounds_played2 == 13) or (rounds_played2 == 14)) then
			tetd = 'лет';
		elseif (clear_explode == 1) then
			ostalost = "Остался"
			tetd = 'год';
		elseif (clear_explode < 5) then
			tetd = 'года';
		else 
			tetd = 'лет';
		end
	end
	
	return ostalost..' '..rounds_played2..' '..tetd
end

function normalize_time(typein)
	if typein == 1 then
		return tostring(os.date("%d.%m.%Y",os.time()))
	end
	if typein == 2 then
		return tostring(os.date("%H:%M",os.time()))
	end
end 

	
function MG:DrawCrosshair( x, y )
	local thick = XHairThickness:GetInt()
	local gap = XHairGap:GetInt()
	local size = XHairSize:GetInt()

	surface.SetDrawColor(XHairRed:GetInt(), XHairGreen:GetInt(), XHairBlue:GetInt(), XHairAlpha:GetInt())
	surface.DrawRect(x - (thick/2), y - (size + gap/2), thick, size )
	surface.DrawRect(x - (thick/2), y + (gap/2), thick, size )
	surface.DrawRect(x + (gap/2), y - (thick/2), size, thick )
	surface.DrawRect(x - (size + gap/2), y - (thick/2), size, thick )
end
	
	
	
	

function deathrunShadowText( text, font, x, y, col, ax, ay , d)
	d = d or 1
	if d ~= 0 and d ~= nil then
		draw.DrawText( text, font, x+d*2, y+d*2, Color(0,0,0,col.a/4), ax, ay )
		draw.DrawText( text, font, x+d, y+d, Color(0,0,0,col.a/2), ax, ay )
	end
	draw.DrawText( text, font, x, y, col, ax, ay)
end

function deathrunShadowTextSimple( text, font, x, y, col, ax, ay , d)
	d = d or 1
	if d ~= 0 and d ~= nil then
		draw.SimpleText( text, font, x+d*2, y+d*2, Color(0,0,0,col.a/4), ax, ay )
		draw.SimpleText( text, font, x+d, y+d, Color(0,0,0,col.a/2), ax, ay )
	end
	draw.SimpleText( text, font, x, y, col, ax, ay)
end

local fontstandard = "Default"
local fontstandard2 = "Roboto Medium"

-- modified version of my derma thingzzzz

surface.CreateFont("deathrun_derma_Large", {
	font = "Roboto Black",
	size = 45,
	antialias = true,
})
surface.CreateFont("deathrun_derma_Medium", {
	font = fontstandard2,
	size = 34,
	antialias = true,
	weight = 200
})
surface.CreateFont("deathrun_derma_Medium_button", {
	font = fontstandard2,
	size = 24,
	antialias = true,
	weight = 200
})

surface.CreateFont("deathrun_derma_Small", {
	font = "Roboto Medium",
	size = 24,
	antialias = true,
})
surface.CreateFont("deathrun_derma_Tiny", {
	font = "Roboto Regular",
	size = 18,
	antialias = true,
	weight = 500
})
surface.CreateFont("deathrun_derma_WindowTitle", {
	font = "Roboto Black",
	size = 18,
	antialias = true,
	})


surface.CreateFont("deathrun_hud_Xlarge", {
	font = fontstandard,
	size = 48,
	antialias = true,
	weight = 1200
})

surface.CreateFont("deathrun_hud_Large", {
	font = fontstandard,
	size = 48,
	antialias = true,
	weight = 800
})
surface.CreateFont("deathrun_hud_Large_ssd", {
	font = fontstandard,
	size = 32,
	antialias = true,
	weight = 800
})
surface.CreateFont("deathrun_hud_Medium", {
	font = fontstandard,
	size = 20,
	antialias = true,
	weight = 800
})
surface.CreateFont("deathrun_hud_Medium_light", {
	font = fontstandard,
	size = 20,
	antialias = true,
	weight = 800
})
surface.CreateFont("deathrun_hud_Medium_light_def", {
	font = "Default",
	size = 20,
	antialias = true,
})
surface.CreateFont("deathrun_hud_Small", {
	font = fontstandard,
	size = 14,
	antialias = true,
	weight = 800
})

surface.CreateFont("deathrun_hud_Medium_clock", {
	font = fontstandard,
	size = 20,
	antialias = true,
	weight = 800
})

surface.CreateFont("deathrun_hud_Small_clock", {
	font = fontstandard,
	size = 13,
	antialias = true,
})


-- make a notification thing
local notifications = {}
local emptynotification = {
	x = 0,
	y = 0,
	text = "",
	dx = 0,
	dy = 0,
	ddx = 0,
	ddy = 0,
	dur = 10,
	born = 0,
}

net.Receive("DeathNotification", function()
	MG:AddNotification( net.ReadString(), ScrW()-32,ScrH()/7, 0, -0.35, 0, -0.00025, 10 )
end)

function MG:AddNotification( msg, x, y, dx, dy, ddx, ddy, dur )

	msg = string.Replace(msg, "%newline%","\n")

	local new = table.Copy( emptynotification )
	new.text = msg
	new.x = x or 0
	new.y = y or 0
	new.dx = dx or 0
	new.dy = dy or 0
	new.ddx = ddx or 0 
	new.ddy = ddy or 0 
	new.dur = dur or 10
	new.born = CurTime()



	table.insert(notifications, new)
end

concommand.Add("deathrun_test_notification", function(ply, cmd, args)

	local msg = ""
	for i = 1, #args do
		msg = msg .. args[i].." "
	end

	MG:AddNotification( msg, ScrW()/2, ScrH()/2, 0, 0, 0, 0, 10 )

end)


local lastCycle = CurTime()
function MG:UpdateNotifications( )
	local dt = CurTime() - lastCycle
	lastCycle = CurTime()

	local fps = (1/dt)
	local fmul = 100/fps

	for k,v in ipairs( notifications ) do
		
		local aliveFor = CurTime() - v.born
		local fadein = math.Clamp( Lerp( InverseLerp(aliveFor,0,0.5), 0, 255 ), 0, 255 )
		local scalein = math.pow(fadein/255, 1/4)

		

		deathrunShadowTextSimple( v.text, "deathrun_hud_Medium", v.x+1, v.y+1, Color(0,0,0,fadein), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )
		deathrunShadowTextSimple( v.text, "deathrun_hud_Medium", v.x, v.y, Color(255,255,255,fadein), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )


		v.x = v.x + v.dx * fmul
		v.y = v.y + v.dy * fmul

		v.dx = v.dx + v.ddx * fmul
		v.dy = v.dy + v.ddy * fmul

		if CurTime() - v.born > v.dur then
			table.remove( notifications, k )
		end
	end

end

hook.Add("HUDPaint","DeathrunNotifications", function()
	MG:UpdateNotifications()
	draw.SimpleText(ROUND:GetTimer(), 'default', 2, 2, Color(255,255,255), TEXT_ALIGN_LEFT,TEXT_ALIGN_LEFT)
end)
