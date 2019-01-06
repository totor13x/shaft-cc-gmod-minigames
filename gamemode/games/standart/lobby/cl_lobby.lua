f = true
local CTeamDelay = 100
cooldown = true
hook.Add("CreateMove",'CheckClientsideKeyBinds', function() 
	if OPTIONS.isTwoTeam then
		if input.WasKeyReleased(KEY_F1) then 
			if f then
				drawLobbyDerma() 
				f = false 
			else 
				frame:Remove() 
				f=true
			end
		end
	end
end)

local fontstandard = "Arial"
local Title = "[LiDi] Minigames"


function drawLobbyDerma()
	
	surface.CreateFont("f2_title", {
		font = fontstandard,
		size = 30,
		antialias = true,
		weight = 5000
	})
	surface.CreateFont("f2_close", {
		font = fontstandard,
		size = 15,
		antialias = true,
		weight = 10
	})
	surface.CreateFont("f2_team", {
		font = fontstandard,
		size = 20,
		antialias = true,
		weight = 1500
	})
	frame = vgui.Create("DFrame")
	frame:SetSize(600,200)
	frame:Center()
	frame:MakePopup()
	frame:SetTitle("")
	frame:ShowCloseButton(false)
	function frame:Paint(w,h)
		draw.RoundedBox(1, 30, 0, w-60, h, Color(60,60,60,235))
		draw.RoundedBox(1, 0, 40, w, 10, Color(0,0,0,255))
		draw.DrawText(Title, "f2_title", 300, 0, Color(255,255,255,255), 1)
		draw.DrawText("Смена команды", "f2_title", 300, 50, Color(255,255,255,255), 1)
		frame:SetBackgroundBlur(true)
	end
	local close_button = vgui.Create("DButton", frame)
	close_button:SetPos(515,5)
	close_button:SetSize(50, 20)
	close_button:SetText("")
	function close_button:OnCursorExited()
		function close_button:Paint(w,h)
		draw.RoundedBox(1, 0,0,w,h,Color(0,0,0,255))
		draw.DrawText("Close", "f2_close",w/2,0,Color(255,255,255,255),1 )
	end
	end
	function close_button:OnCursorEntered()
		function close_button:Paint(w,h)
		draw.RoundedBox(1, 0,0,w,h,Color(200,200,200,255))
		draw.DrawText("Close", "f2_close",w/2,0,Color(0,0,0,255),1 )
	end
	end
	function close_button:Paint(w,h)
		draw.RoundedBox(1, 0,0,w,h,Color(0,0,0,255))
		draw.DrawText("Close", "f2_close",w/2,0,Color(255,255,255,255),1 )
	end
	
	function close_button:DoClick()
		frame:Remove()
	end
	
	local teams = team.GetAllTeams()
	
	button1 = vgui.Create("DButton", frame)
	button1:SetPos(80, 100)
	button1:SetSize(200, 40)
	button1:SetText("")
	button1.cteam = TEAM_SATIRES
	function button1:Paint(w,h)
			draw.RoundedBox(1, 0,0,w,h, Color(0,0,0,255))
			draw.RoundedBox(1, 2,2,w-4,h-4,team.GetColor(self.cteam))
			draw.DrawText(team.GetName(self.cteam),"f2_team",w/2,7, Color(0,0,0,255), 1)
		end
	function button1:OnCursorExited()
		function button1:Paint(w,h)
			draw.RoundedBox(1, 0,0,w,h, Color(0,0,0,255))
			draw.RoundedBox(1, 2,2,w-4,h-4,team.GetColor(self.cteam))
			draw.DrawText(team.GetName(self.cteam),"f2_team",w/2,7, Color(0,0,0,255), 1)
		end
	end
	function button1:OnCursorEntered()
		function button1:Paint(w,h)
			draw.RoundedBox(1, 0,0,w,h, Color(255,255,255,255))
			draw.RoundedBox(1, 2,2,w-4,h-4,Color(0,0,0,255))
			draw.DrawText(team.GetName(self.cteam),"f2_team",w/2,7, Color(255,255,255,255), 1)
		end
	end
	function button1:DoClick()
		if cooldown then
			cooldown = false
			timer.Create("CDelay", CTeamDelay, 1, function() cooldown = true end)
			net.Start("ct")
			net.WriteInt(button1.cteam, 4)
			net.SendToServer()
		else
		notification.AddLegacy("Wait " .. math.Round(timer.TimeLeft("CDelay"),0) .. " seconds before changing the team", 1, 3)
		end
	end
	
		
	button2 = vgui.Create("DButton", frame)
	button2:SetPos(320, 100)
	button2:SetSize(200, 40)
	button2:SetText("")
	button2.cteam = TEAM_GARPIES
	function button2:Paint(w,h)
			draw.RoundedBox(1, 0,0,w,h, Color(0,0,0,255))
			draw.RoundedBox(1, 2,2,w-4,h-4,team.GetColor(self.cteam))
			draw.DrawText(team.GetName(self.cteam),"f2_team",w/2,7, Color(0,0,0,255), 1)
		end
	function button2:OnCursorExited()
		function button2:Paint(w,h)
			draw.RoundedBox(1, 0,0,w,h, Color(0,0,0,255))
			draw.RoundedBox(1, 2,2,w-4,h-4,team.GetColor(self.cteam))
			draw.DrawText(team.GetName(self.cteam),"f2_team",w/2,7, Color(0,0,0,255), 1)
		end
	end
	function button2:OnCursorEntered()
		function button2:Paint(w,h)
			draw.RoundedBox(1, 0,0,w,h, Color(255,255,255,255))
			draw.RoundedBox(1, 2,2,w-4,h-4,Color(0,0,0,255))
			draw.DrawText(team.GetName(self.cteam),"f2_team",w/2,7, Color(255,255,255,255), 1)
		end
	end
	function button2:DoClick()
		if cooldown then
			cooldown = false
			timer.Create("CDelay", CTeamDelay, 1, function() cooldown = true end)
			net.Start("ct")
			net.WriteInt(button2.cteam, 4)
			net.SendToServer()
		else
		notification.AddLegacy("Wait " .. math.Round(timer.TimeLeft("CDelay"),0) .. " seconds before changing the team", 1, 3)
		end
	end
	frame:SetBackgroundBlur(true)
end