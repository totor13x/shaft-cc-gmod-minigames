SWEP.PrintName 		= "Mac10"

SWEP.Base				= "base_lidi_csgo"
SWEP.isCSGO = true
SWEP.ViewModel			= "models/weapons/tfa_csgo/c_mac10.mdl" --Viewmodel path
SWEP.WorldModel			= "models/weapons/tfa_csgo/w_mac10.mdl" -- Weapon world model path

SWEP.Sound 			= Sound("TFA_CSGO_MAC10.1")	-- This is the sound of the weapon, when you shoot.
SWEP.HoldType			= "ar2"

SWEP.Recoil			= 0.7
SWEP.Damage			= 24
SWEP.NumShots		= 1
SWEP.Cone			= 0.03
SWEP.ClipSize		= 25
SWEP.Rate			= 0.07
SWEP.MaxAmmo	= 100
SWEP.Primary.Automatic		= true


-- Accuracy
SWEP.CrouchCone				= 0.025 -- Accuracy when we're crouching
SWEP.CrouchWalkCone			= 0.03 -- Accuracy when we're crouching and walking
SWEP.WalkCone				= 0.04 -- Accuracy when we're walking
SWEP.AirCone				= 0.1 -- Accuracy when we're in air
SWEP.StandCone				= 0.04 -- Accuracy when we're standing still
SWEP.IronsightsCone			= 0.015





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