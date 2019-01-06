SWEP.PrintName 		= "M249"

SWEP.Base				= "base_lidi_csgo"
SWEP.isCSGO = true
SWEP.ViewModel				= "models/weapons/tfa_csgo/c_m249.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/tfa_csgo/w_m249.mdl"	-- Weapon world model

SWEP.Sound 			= Sound("TFA_CSGO_M249.1")				-- This is the sound of the weapon, when you shoot.
SWEP.HoldType			= "ar2"

SWEP.Recoil			= 1
SWEP.Damage			= 60
SWEP.NumShots		= 1
SWEP.Cone			= 0.05
SWEP.ClipSize		= 100
SWEP.Rate			= 0.09
SWEP.MaxAmmo	= 300
SWEP.Primary.Automatic	= true

-- Accuracy
SWEP.CrouchCone				= 0.02 -- Accuracy when we're crouching
SWEP.CrouchWalkCone			= 0.05 -- Accuracy when we're crouching and walking
SWEP.WalkCone				= 0.09 -- Accuracy when we're walking
SWEP.AirCone				= 0.1 -- Accuracy when we're in air
SWEP.StandCone				= 0.07 -- Accuracy when we're standing still
SWEP.IronsightsCone			= 0.015



SWEP.Offset = { --Procedural world model animation, defaulted for CS:S purposes.
        Pos = {
        Up = -4.75,
        Right = 0.5,
        Forward = 9,
        },
        Ang = {
        Up = 3,
        Right = 80,
        Forward = 178
        },
		Scale = 0.9
}