SWEP.PrintName 		= "UMP45"

SWEP.Base				= "base_lidi_csgo"
SWEP.isCSGO = true
SWEP.ViewModel			= "models/weapons/tfa_csgo/c_ump45.mdl" --Viewmodel path
SWEP.WorldModel			= "models/weapons/tfa_csgo/w_ump45.mdl" -- Weapon world model path

SWEP.Sound 			= Sound("TFA_CSGO_UMP45.1")	 -- This is the sound of the weapon, when you shoot.
SWEP.HoldType			= "ar2"

SWEP.Recoil			= 1
SWEP.Damage			= 9
SWEP.NumShots		= 1
SWEP.Cone			= 0.025
SWEP.ClipSize		= 50
SWEP.Rate			= 0.08
SWEP.MaxAmmo		= 150
SWEP.Primary.Automatic		= true

-- Accuracy
SWEP.CrouchCone				= 0.2 -- Accuracy when we're crouching
SWEP.CrouchWalkCone			= 0.3 -- Accuracy when we're crouching and walking
SWEP.WalkCone				= 0.3 -- Accuracy when we're walking
SWEP.AirCone				= 0.1 -- Accuracy when we're in air
SWEP.StandCone				= 0.03 -- Accuracy when we're standing still
SWEP.IronsightsCone			= 0.015


SWEP.Offset = { --Procedural world model animation, defaulted for CS:S purposes.
        Pos = {
        Up = -3.8,
        Right = 0.5,
        Forward = 6,
        },
        Ang = {
        Up = 0,
        Right = 80,
        Forward = 178
        },
		Scale = 1.1
}