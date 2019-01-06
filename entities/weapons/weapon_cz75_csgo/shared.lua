SWEP.PrintName				= "CZ-75"		-- Weapon name (Shown on HUD)	

SWEP.Base				= "base_lidi_csgo"
SWEP.isCSGO = true
SWEP.ViewModel			= "models/weapons/tfa_csgo/c_cz75.mdl" --Viewmodel path
SWEP.WorldModel			= "models/weapons/tfa_csgo/w_cz75.mdl" -- Weapon world model path

SWEP.Sound 			= Sound("TFA_CSGO_CZ75.1")				-- This is the sound of the weapon, when you shoot.

SWEP.HoldType			= "pistol"
SWEP.Recoil				=0.5
SWEP.Damage				=50
SWEP.Rate				=.1
SWEP.ClipSize			=30
SWEP.MaxAmmo			=120
SWEP.Primary.Automatic	=true

-- Accuracy
SWEP.ConeCrouch			=.01
SWEP.ConeCrouchWalk		=.02
SWEP.ConeWalk			=.025
SWEP.ConeAir			=.1
SWEP.ConeStand			=.015
SWEP.ConeIronsights		=.015

SWEP.Offset = { --Procedural world model animation, defaulted for CS:S purposes.
        Pos = {
        Up = -1.6,
        Right = 0.8,
        Forward = 5.5,
        },
        Ang = {
        Up = 3,
        Right = 90,
        Forward = 178
        },
		Scale = 0.9
}