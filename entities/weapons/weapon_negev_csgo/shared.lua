SWEP.PrintName 		= "Negev"

SWEP.Base				= "base_lidi_csgo"
SWEP.isCSGO = true
SWEP.ViewModel				= "models/weapons/tfa_csgo/c_negev.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/tfa_csgo/w_negev.mdl"	-- Weapon world model

SWEP.Sound 			= Sound("TFA_CSGO_NEGEV.1")	-- This is the sound of the weapon, when you shoot.
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


SWEP.Offset = {
        Pos = {
        Up = -1.6,
        Right = 1,
        Forward = 6.3,
        },
        Ang = {
        Up = 0,
        Right = -9,
        Forward = 180,
        },
		Scale = 1.55
}