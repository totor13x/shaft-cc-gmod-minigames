AddCSLuaFile()

SWEP.PrintName			="Glock"
SWEP.Slot				=1

SWEP.Hold				="pistol"
SWEP.Base				="base_lidi_csgo"

SWEP.isCSGO = true
SWEP.ViewModel			= "models/weapons/tfa_csgo/c_glock18.mdl" --Viewmodel path
SWEP.WorldModel			= "models/weapons/tfa_csgo/w_glock18.mdl" -- Weapon world model path

SWEP.Sound			= Sound( "TFA_CSGO_GLOCK18.1" )
SWEP.Recoil			= 0.3
SWEP.Damage			= 24
SWEP.NumShots		= 1
SWEP.ClipSize		= 18
SWEP.MaxAmmo		= 120
SWEP.Rate			= 0.1
SWEP.Primary.Automatic		= false


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