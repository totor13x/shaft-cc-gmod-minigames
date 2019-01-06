SWEP.PrintName				= "PP-Bizon"		-- Weapon name (Shown on HUD)	

SWEP.Base				= "base_lidi_csgo"
SWEP.isCSGO = true
SWEP.ViewModel			= "models/weapons/tfa_csgo/c_bizon.mdl" --Viewmodel path
SWEP.ViewModelFOV		= 52		-- This controls how big the viewmodel looks.  Less is more.
SWEP.WorldModel			= "models/weapons/tfa_csgo/w_bizon.mdl" -- Weapon world model path

SWEP.Sound 			= Sound("TFA_CSGO_BIZON.1")	

SWEP.HoldType			= "ar2"

SWEP.Recoil				=0.5
SWEP.Damage				=50
SWEP.Rate				=.1
SWEP.ClipSize			=30
SWEP.MaxAmmo			=120
SWEP.Primary.Automatic	=true
SWEP.SetSilenced = true


-- Accuracy
SWEP.ConeCrouch			=.01
SWEP.ConeCrouchWalk		=.02
SWEP.ConeWalk			=.025
SWEP.ConeAir			=.1
SWEP.ConeStand			=.015
SWEP.ConeIronsights		=.015

SWEP.Offset = { --Procedural world model animation, defaulted for CS:S purposes.
        Pos = {
        Up = -4.5,
        Right = 0.5,
        Forward = 9,
        },
        Ang = {
        Up = 0,
        Right = 78,
        Forward = 178
        },
		Scale = 1.1
}