SWEP.PrintName			="P90"
SWEP.Slot				=1

SWEP.HoldType 			="rpg" // TO FIXED
SWEP.Base				="base_lidi_csgo"

SWEP.isCSGO = true
SWEP.ViewModel			= "models/weapons/tfa_csgo/c_p90.mdl" --Viewmodel path
SWEP.WorldModel			= "models/weapons/tfa_csgo/w_p90.mdl" -- Weapon world model path


SWEP.Sound			= Sound( "TFA_CSGO_P90.1")
SWEP.Recoil			= 0.6
SWEP.Damage			= 36
SWEP.NumShots		= 1
SWEP.Cone			= 0.03
SWEP.ClipSize		= 50
SWEP.Rate			= 0.07
SWEP.MaxAmmo		= 200
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
        Right = 1.5,
        Forward = 3,
        },
        Ang = {
        Up = 3,
        Right = 70,
        Forward = 178
        },
		Scale = 1.3
}