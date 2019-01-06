if (SERVER) then

	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
end

if ( CLIENT ) then
	SWEP.PrintName			= "Кирка"
	SWEP.DrawAmmo 			= false
	SWEP.DrawCrosshair 		= true
	SWEP.ViewModelFlip		= false
	SWEP.CSMuzzleFlashes	= true
	SWEP.UseHands			= true
	
	SWEP.ViewModelFOV		= 55
	SWEP.Slot				= 2
	SWEP.SlotPos			= 0
	--SWEP.IconLetter			= "j"

	--killicon.AddFont("weapon_knife", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ))
	--surface.CreateFont("CSKillIcons", {font = "csd", size = ScreenScale(30), weight = 500, antialias = true, additive = true})
	--surface.CreateFont("CSSelectIcons", {font = "csd", size = ScreenScale(60), weight = 500, antialias = true, additive = true})
end

SWEP.Base = "csgo_baseknife"

SWEP.ViewModel 			= "models/wep/pickaxe.mdl"
SWEP.WorldModel 		= "models/wep/w_pickaxe.mdl" 

SWEP.DrawWeaponInfoBox  	= false

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false
SWEP.Skin 					= 'marquis/pickaxe/material'
SWEP.SkinQ 					= 1
SWEP.SkinIndex 				= 1

SWEP.tableSkins = {
[0] = 'marquis/pickaxe/material',
[1] = 'marquis/pickaxe/stone',
[2] = 'marquis/pickaxe/iron',
[3] = 'marquis/pickaxe/gold',
[4] = 'marquis/pickaxe/diamond',
}

function SWEP:GetViewModelPosition( pos, ang )

	ang:RotateAroundAxis(ang:Up(),  -90)
	
	
	return pos, ang
end
/*
function SWEP:ChangeType()
	if self:GetSkinType() < 4 then
		self:SetSkinType( self:GetSkinType() + 1)
	end
end

function SWEP:Think()
	if self.Skin != self.tableSkins[self:GetSkinType()] then
		self.Skin = self.tableSkins[self:GetSkinType()]
	end
end
*/