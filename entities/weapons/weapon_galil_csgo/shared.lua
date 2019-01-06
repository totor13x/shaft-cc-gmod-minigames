SWEP.PrintName			= "Galil"

SWEP.Base				= "base_lidi_csgo"
SWEP.isCSGO = true
SWEP.ViewModel			= "models/weapons/tfa_csgo/c_galil.mdl" --Viewmodel path
SWEP.WorldModel			= "models/weapons/tfa_csgo/w_galil.mdl" -- Weapon world model path

SWEP.Sound 			= Sound("TFA_CSGO_GALIL.1")				-- This is the sound of the weapon, when you shoot.

SWEP.HoldType			= "ar2"
SWEP.Recoil			= 0.5
SWEP.Damage			= 36
SWEP.NumShots		= 1
SWEP.Cone			= 0.017
SWEP.ClipSize		= 30
SWEP.Rate			= 0.08
SWEP.MaxAmmo	= 120
SWEP.Primary.Automatic		= true

-- Accuracy
SWEP.CrouchCone				= 0.01 -- Accuracy when we're crouching
SWEP.CrouchWalkCone			= 0.02 -- Accuracy when we're crouching and walking
SWEP.WalkCone				= 0.025 -- Accuracy when we're walking
SWEP.AirCone				= 0.1 -- Accuracy when we're in air
SWEP.StandCone				= 0.015 -- Accuracy when we're standing still
SWEP.IronsightsCone			= 0.015

SWEP.Offset = { --Procedural world model animation, defaulted for CS:S purposes.
        Pos = {
        Up = -3.5,
        Right = 0.8,
        Forward = 6,
        },
        Ang = {
        Up = 3,
        Right = 84,
        Forward = 178
        },
		Scale = 1
}