SWEP.PrintName				= "Five-SeveN"		-- Weapon name (Shown on HUD)

SWEP.Base				= "base_lidi_csgo"
SWEP.isCSGO = true
SWEP.ViewModel			= "models/weapons/tfa_csgo/c_fiveseven.mdl" --Viewmodel path
SWEP.WorldModel			= "models/weapons/tfa_csgo/w_fiveseven.mdl" -- Weapon world model path

SWEP.Sound 			= Sound("TFA_CSGO_FIVESEVEN.1")				-- This is the sound of the weapon, when you shoot.

SWEP.HoldType			= "pistol"

SWEP.ClipSize			=21
SWEP.MaxAmmo			=84
SWEP.Recoil				=0.5
SWEP.Damage				=35
SWEP.Rate				=0.08
SWEP.Recoil			= 0.5
SWEP.Automatic			=false

-- Accuracy
SWEP.CrouchCone				= 0.02 -- Accuracy when we're crouching
SWEP.CrouchWalkCone			= 0.025 -- Accuracy when we're crouching and walking
SWEP.WalkCone				= 0.03 -- Accuracy when we're walking
SWEP.AirCone				= 0.1 -- Accuracy when we're in air
SWEP.StandCone				= 0.02 -- Accuracy when we're standing still
SWEP.IronsightsCone			= 0.015


SWEP.Offset = { --Procedural world model animation, defaulted for CS:S purposes.
        Pos = {
        Up = -2,
        Right = 0.8,
        Forward = 4.5,
        },
        Ang = {
        Up = 3,
        Right = 90,
        Forward = 178
        },
		Scale = 0.9
}