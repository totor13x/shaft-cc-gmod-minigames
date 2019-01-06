SWEP.PrintName 		= "AUG"

SWEP.Base				= "base_lidi_csgo"
SWEP.isCSGO = true
SWEP.ViewModel				= "models/weapons/tfa_csgo/c_aug.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/tfa_csgo/w_aug.mdl"	-- Weapon world model

SWEP.Sound			= Sound("TFA_CSGO_AUG.1")		-- Script that calls the primary fire sound

SWEP.HoldType			= "ar2"
SWEP.Recoil			= 0.6
SWEP.Damage			= 36
SWEP.Rate				=.1
SWEP.ClipSize			=30
SWEP.MaxAmmo			=120
SWEP.Primary.Automatic	=true

SWEP.CrouchCone				= 0.01 -- Accuracy when we're crouching
SWEP.CrouchWalkCone			= 0.02 -- Accuracy when we're crouching and walking
SWEP.WalkCone				= 0.025 -- Accuracy when we're walking
SWEP.AirCone				= 0.1 -- Accuracy when we're in air
SWEP.StandCone				= 0.015 -- Accuracy when we're standing still
SWEP.IronsightsCone			= 0.015
SWEP.Recoil				= 1.1	-- Recoil For not Aimed
SWEP.RecoilZoom				= 0.8	-- Recoil For Zoom
SWEP.Delay				= 0.1	-- Delay For Not Zoom
SWEP.DelayZoom				= 0.15	-- Delay For Zoom

SWEP.Offset = { --Procedural world model animation, defaulted for CS:S purposes.
        Pos = {
        Up = -4.5,
        Right = 0.9,
        Forward = 3.5,
        },
        Ang = {
        Up = 2,
        Right = 80,
        Forward = 178
        },
		Scale = 1.2
}