print("Loaded cl_voicepanel.lua...")

PANEL = {}

AccessorFunc( PANEL, "Padding", "Padding", FORCE_NUMBER )

AccessorFunc( PANEL, "alpha", "Alphas", FORCE_NUMBER )
AccessorFunc( PANEL, "destroytime", "DestroyTime", FORCE_NUMBER )

function PANEL:Init()
	self:SetTall(28)
	self.Padding = 2
	self.alpha = 255
	self.destroytime = 0.7

	self:DockPadding( 4, 4, 4, 4 )
	self:DockMargin( 2, 2, 2, 2 )
	self:Dock( BOTTOM )
end

function PANEL:Setup(ply)
	self.dend = 0
	self.trigger = 0
	self.ply = ply
	self.plyname = ply:GetName()
	
	local x,y = self:GetPos()
	
	self.ava = vgui.Create( "AvatarImage", self )
	self.ava:SetSize( 32, 32 )
	self.ava:SetPos( 0, 0 )
	self.ava:SetPlayer( ply, 32 )
end

function PANEL:Paint(w,h)
	if !self.ply then return end
	 vv = 100
	
	if not IsValid(self.ply) then return end
	
	local tcol = Color(255,255,255,150)
	local textcolor = Color(100,30,30)
	if OPTIONS.isTwoTeam then
		tcol = team.GetColor(self.ply:Team())
		textcolor = Color(255,255,255)
	end
	//tcol = team.GetColor(ply:Team())
	
	surface.SetDrawColor(tcol )
	surface.DrawRect(0,0,w,h)

	if self.ply:GetNWBool("IsLisen") then
		draw.SimpleText(self.plyname.." (SILENT)" ,"deathrun_hud_Medium",self.Padding*2+32,h/2,textcolor,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	else
			draw.SimpleText(self.plyname ,"deathrun_hud_Medium",self.Padding*2+32,h/2,textcolor,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	end
	draw.SimpleText(self.plyname,"deathrun_hud_Medium",self.Padding*2+32,h/2,textcolor,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
end

function PANEL:SetDestroy(func)
	if self.trigger != 1 then
		self.dend = CurTime()+self.destroytime
		self.trigger = 1
	end
end
function PANEL:UnSetDestroy()
	self:SetAlpha(self.alpha)
	self.dend = 0
end

function PANEL:Think()
if LocalPlayer():GetNWBool("IsLisen") then
		self:SetAlpha(0)
		self.ava:SetAlpha(0)
		return 
end
	if self.dend == nil then return end
	if self.dend == 0 then 
		self:SetAlpha(self.alpha)
		self.ava:SetAlpha(self.alpha)
		return
	end
	self:SetAlpha((self.alpha/(self.destroytime*100))*(math.Round(self.dend-CurTime(),2)*100))
	
	self.ava:SetAlpha(math.min((self.alpha/(self.destroytime*100))*(math.Round(self.dend-CurTime(),2)*100)+50,255))
	
	if self.dend < CurTime() then
		self.ava:Remove()
		self:Remove() 
	end
	
end

vgui.Register("DVoicePanel2",PANEL,"Panel")