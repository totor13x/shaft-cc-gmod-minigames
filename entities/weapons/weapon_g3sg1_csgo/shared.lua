SWEP.PrintName				= "G3SG1"		-- Weapon name (Shown on HUD)

SWEP.Base				= "base_lidi_csgo"
SWEP.isCSGO = true
SWEP.ViewModel			= "models/weapons/tfa_csgo/c_g3sg1.mdl" --Viewmodel path
SWEP.WorldModel			= "models/weapons/tfa_csgo/w_g3sg1.mdl" -- Weapon world model path


SWEP.Sound 			= Sound("TFA_CSGO_G3SG1.1")				-- This is the sound of the weapon, when you shoot.

SWEP.HoldType			= "ar2"

SWEP.Damage 		= 45
SWEP.Recoil 		= 0.75
SWEP.NumShots 		= 1
SWEP.Cone 		= 0.001
SWEP.ClipSize 		= 20
SWEP.Rate	 		= 0.2
SWEP.MaxAmmo 	= 90
SWEP.Primary.Automatic 		= true

-- Accuracy
SWEP.CrouchCone				= 0.001 -- Accuracy when we're crouching
SWEP.CrouchWalkCone			= 0.005 -- Accuracy when we're crouching and walking
SWEP.WalkCone				= 0.025 -- Accuracy when we're walking
SWEP.AirCone				= 0.1 -- Accuracy when we're in air
SWEP.StandCone				= 0.001 -- Accuracy when we're standing still


SWEP.Offset = { --Procedural world model animation, defaulted for CS:S purposes.
        Pos = {
        Up = -4.6,
        Right = 0.8,
        Forward = 8,
        },
        Ang = {
        Up = 2,
        Right = 0,
        Forward = 178
        },
		Scale = 1
}