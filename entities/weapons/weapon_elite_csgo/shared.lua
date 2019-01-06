SWEP.PrintName				= "Dual Berettas"		-- Weapon name (Shown on HUD)

SWEP.Base				= "base_lidi_csgo"
SWEP.isCSGO = true
SWEP.ViewModel			= "models/weapons/tfa_csgo/c_elite.mdl" --Viewmodel path
SWEP.ViewModelFOV		= 56		-- This controls how big the viewmodel looks.  Less is more.
SWEP.WorldModel			= "models/weapons/tfa_csgo/w_elite.mdl" -- Weapon world model path
SWEP.Sound 			= Sound("TFA_CSGO_ELITE.1")				-- This is the sound of the weapon, when you shoot.

SWEP.HoldType			= "duel"

SWEP.Recoil				=0.5
SWEP.Damage				=38
SWEP.Rate				=.1
SWEP.ClipSize			=30
SWEP.MaxAmmo			=60
SWEP.Primary.Automatic	=false
SWEP.SetSilenced = false

-- Accuracy
SWEP.Recoil				=0.5
SWEP.Damage				=24
SWEP.Rate				=0.15
SWEP.Automatic			=false


SWEP.Offset = { --Procedural world model animation, defaulted for CS:S purposes.
        Pos = {
        Up = -1.5,
        Right = 0.8,
        Forward = 6,
        },
        Ang = {
        Up = 0,
        Right = 81,
        Forward = 180
        },
		Scale = 1
}