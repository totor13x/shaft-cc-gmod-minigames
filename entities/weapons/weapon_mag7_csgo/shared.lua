SWEP.PrintName 		= "Mag-7"

SWEP.Base				= "base_lidi_csgo"
SWEP.isCSGO = true
SWEP.ViewModel				= "models/weapons/tfa_csgo/c_mag7.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/tfa_csgo/w_mag7.mdl"	-- Weapon world model

SWEP.Sound 			= Sound("TFA_CSGO_MAG7.1")	-- This is the sound of the weapon, when you shoot.
SWEP.HoldType			= "ar2"

SWEP.Recoil				=1.5
SWEP.Damage				=23
SWEP.Rate				=1
SWEP.ClipSize			=8
SWEP.MaxAmmo			=32
SWEP.NumShots			=16
SWEP.Primary.Automatic	=false
SWEP.Shotgun = true

-- Accuracy
SWEP.ConeCrouch			=.2
SWEP.ConeCrouchWalk		=.5
SWEP.ConeWalk			=.125
SWEP.ConeAir			=.2
SWEP.ConeStand			=.15
SWEP.ConeIronsights		=.15

SWEP.Offset = { --Procedural world model animation, defaulted for CS:S purposes.
        Pos = {
        Up = -3.5,
        Right = 0.8,
        Forward = 4,
        },
        Ang = {
        Up = 3,
        Right = 90,
        Forward = 178
        },
		Scale = 1
}


function SWEP:Reload()
	
	//if ( CLIENT ) then return end
	// Already reloading
	if ( self.Weapon:GetNetworkedBool( "reloading", false ) ) then return end
	
	// Start reloading if we can
	if ( self.Clip < self.ClipSize && self.Ammo > 0 ) then
		
		self.Weapon:SetNetworkedBool( "reloading", true )
		self.Weapon:SetVar( "reloadtimer", CurTime() + 0.7 )
		self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
		self.Owner:DoReloadEvent()
	end
	
end