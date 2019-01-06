SWEP.PrintName 		= "Famas"

SWEP.Base				= "base_lidi_csgo"
SWEP.isCSGO = true
SWEP.ViewModel			= "models/weapons/tfa_csgo/c_famas.mdl" --Viewmodel path
SWEP.WorldModel			= "models/weapons/tfa_csgo/w_famas.mdl" -- Weapon world model path
SWEP.WorldModelSilencer		= "models/marquis/wep/w_m4a1.mdl"	-- Weapon world model

SWEP.Sound 			= Sound("TFA_CSGO_FAMAS.1")				-- This is the sound of the weapon, when you shoot.

SWEP.HoldType			= "ar2"

SWEP.Recoil			= 0.5
SWEP.Damage			= 36
SWEP.Rate				=0.08
SWEP.ClipSize			=30
SWEP.MaxAmmo			=120
SWEP.Primary.Automatic	=true


SWEP.CrouchCone				= 0.01 -- Accuracy when we're crouching
SWEP.CrouchWalkCone			= 0.02 -- Accuracy when we're crouching and walking
SWEP.WalkCone				= 0.025 -- Accuracy when we're walking
SWEP.AirCone				= 0.1 -- Accuracy when we're in air
SWEP.StandCone				= 0.015 -- Accuracy when we're standing still
SWEP.IronsightsCone			= 0.015

SWEP.Offset = { --Procedural world model animation, defaulted for CS:S purposes.
        Pos = {
        Up = -3.75,
        Right = 0.8,
        Forward = 3,
        },
        Ang = {
        Up = 3,
        Right = 86,
        Forward = 178
        },
		Scale = 1
}