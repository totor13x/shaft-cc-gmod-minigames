
-----------------------------------------------------
AddCSLuaFile()

SWEP.Slot				= 2
if ( SERVER ) then

	SWEP.Weight				= 5
	SWEP.AutoSwitchTo			= false
	SWEP.AutoSwitchFrom		= false
    
    CreateConVar("csgo_knives_oldsounds", "0", bit.bor(FCVAR_NONE), "Play old sounds when swinging knife or hitting wall")
end

if ( CLIENT ) then
	SWEP.PrintName          = "CS:GO baseknife"	
	SWEP.DrawAmmo           = false
	SWEP.DrawCrosshair      = true
	SWEP.ViewModelFOV       = 66
	SWEP.ViewModelFlip      = false
	SWEP.CSMuzzleFlashes    = true
	SWEP.UseHands           = true
end

SWEP.Category			= "CS:GO Knives"

SWEP.Spawnable				= false
SWEP.AdminSpawnable			= false

-- SWEP.ViewModel 			= "models/weapons/v_csgo_default.mdl"
-- SWEP.WorldModel 			= "models/weapons/W_csgo_default.mdl" 

SWEP.DrawWeaponInfoBox  	= false

SWEP.Weight					= 5
SWEP.AutoSwitchTo				= false
SWEP.AutoSwitchFrom			= false

SWEP.Primary.ClipSize = 10
SWEP.Primary.DefaultClip = 10
SWEP.Primary.Damage			    = -1
SWEP.Primary.DefaultClip		= -1
SWEP.Primary.Automatic			= true
SWEP.Primary.Ammo			    ="none"


SWEP.Secondary.ClipSize			= -1
SWEP.Secondary.DefaultClip		= -1
SWEP.Secondary.Damage			= -1
SWEP.Secondary.Automatic		= true
SWEP.Secondary.Ammo			    ="none"
SWEP.CanPlayLightning       = true

function SWEP:SetupDataTables() --This also used for variable declaration and SetVar/GetVar getting work
    self:NetworkVar( "Float", 0, "InspectTime" )
    self:NetworkVar( "Float", 1, "IdleTime" )
    self:NetworkVar( "String", 0, "Classname" ) --Do we need this?
    self:NetworkVar( "Bool", 0, "Thrown" )
    -- self:NetworkVar( "Entity", 0, "Attacker" ) --Do we need this?
    -- self:NetworkVar( "Entity", 1, "Victim" ) --Do we need this?
    self:NetworkVar( "Entity", 2, "ViewModel" )
    self:NetworkVar( "Int", 0, "SkinType" )
end



function SWEP:Initialize()
	//	if self.Owner:IsSuperAdmin() then return false end
	if ( CLIENT ) then surface.SetMaterial(Material( self.Skin or "models/csgo_knife/cssource" )) end --Ugly hack. Used to "precache" skin's material
    self:SetClassname(self:GetClass())
	self:SetSkinType(0)
	self:SetHoldType( self.AreDaggers and "fist" or "knife" ) -- Avoid using SetWeaponHoldType! Otherwise the players could hold it wrong!
	
	if self.Owner:GetNWBool('polter') then
		if SERVER then
			self:SetClip1( 10 )
		end
	end
end 



function SWEP:ViewModelDrawn(ViewModel)
    self:SetViewModel(ViewModel) -- Stores viewmodel's entity into NetworkVar, NOT actually changes viewmodel. Do we need this?
    self:PaintMaterial(ViewModel)
end



--function SWEP:PostDrawViewModel( vm, ply, weapon )
--    if ( CLIENT ) and IsValid(vm) then vm:SetMaterial() end
--end



function SWEP:PaintMaterial(vm)
    if ( CLIENT ) and IsValid(vm) then
            local Mat = self:GetThrown() and "" or ( self.Skin or "" )
			if IsValid(vm) and vm:GetModel() == self.ViewModel then vm:SetMaterial(Mat) end
	end
end



function SWEP:ClearMaterial()
    if IsValid(self.Owner) then
		local Viewmodel = self.Owner:GetViewModel()
		if IsValid(Viewmodel) then Viewmodel:SetMaterial("") end
	end
end



function SWEP:Think()

	self:AddLightning()
	if CurTime()>=self:GetIdleTime() then
    	self.Weapon:SendWeaponAnim( ACT_VM_IDLE )
    	self:SetIdleTime( CurTime() + self.Owner:GetViewModel():SequenceDuration() )
	end
	if self.Owner:GetNWBool('polter') then
		if self.NextTick and self.NextTick > CurTime() then return end

		if SERVER then
			if self:IsCloaked() then
				self:SetClip1( math.Clamp( self:Clip1() - 1, 0, self:GetMaxClip1() ) )
			else
				self:SetClip1( math.Clamp( self:Clip1() + 1, 0, self:GetMaxClip1() ) )
			end
		end
		
		if self:IsCloaked() and self:Clip1() <= 0 then
			self:Uncloak()

		end
		if SERVER then
			self.Owner:SetNWInt('invistime', self:Clip1())
		end
		self.NextTick = CurTime() + 1
	end
	if not self.Owner:GetNWBool('polter') then
	if SERVER then
			if self:IsCloaked() then
				self:Uncloak()
			end
		end
	end
end

if CLIENT then
	function SWEP:Initialize()
		self:SetWeaponHoldType( "normal" )

		hook.Add( "PrePlayerDraw", self, self.PrePlayerDraw )
		hook.Add( "PostPlayerDraw", self, self.PostPlayerDraw )
		hook.Add( "PreDrawPlayerHands", self, self.PreDrawPlayerHands )
		hook.Add( "PostDrawPlayerHands", self, self.PostDrawPlayerHands )
	end

	local Materials = {}

	function SWEP:PrepareMaterial( mat )
		--~local shader = Material( mat ):GetShader()
		local shader = "VertexLitGeneric"
		local params = util.KeyValuesToTable( file.Read( "materials/" .. mat .. ".vmt", "GAME" ) ) or {}
		params.Proxies = params.proxies or {}

		params[ "$cloakpassenabled" ] = 1
		params[ "$cloakfactor" ] = 0

		params.Proxies[ "PlayerCloak" ] = {}

		Materials[ mat ] = CreateMaterial( mat .. "_c", shader, params )
	end

	function SWEP:CloakThink()
		if not self.Owner.CloakFactor then self.Owner.CloakFactor = 0 end

		self.Owner.CloakFactor = math.Approach(
			self.Owner.CloakFactor, self:IsCloaked( self.Owner ) and 1 or 0, FrameTime() )
	end

	function SWEP:PrePlayerDraw( pl )
		if pl ~= self.Owner then return end

		self:CloakThink()

		if self.Owner.CloakFactor <= 0 then return end

		render.UpdateRefractTexture() 

		for k, v in ipairs( self.Owner:GetMaterials() ) do
			if not Materials[ v ] then self:PrepareMaterial( v ) end
			render.MaterialOverrideByIndex( k - 1, Materials[ v ] )
		end
	end

	function SWEP:PostPlayerDraw( pl )
		if pl ~= self.Owner or self.Owner.CloakFactor <= 0 then return end
		render.MaterialOverrideByIndex()
	end

	function SWEP:PreDrawPlayerHands( hands, vm, pl )
		if pl ~= self.Owner then return end

		self:CloakThink()

		if self.Owner.CloakFactor <= 0 then return end

		render.SetBlend( 1 - self.Owner.CloakFactor )
	end

	function SWEP:PostDrawPlayerHands( hands, vm, pl )
		if pl ~= self.Owner or self.Owner.CloakFactor <= 0 then return end

		render.SetBlend( 1 )
	end

	function SWEP:CustomAmmoDisplay()
		self.AmmoDisplay = self.AmmoDisplay or {} 
		self.AmmoDisplay.Draw = true
		self.AmmoDisplay.PrimaryClip = self:Clip1()

		return self.AmmoDisplay
	end

	matproxy.Add{
		name = "PlayerCloak",
		init = function() end,
		bind = function( self, mat, ent )
			if not IsValid( ent ) or not ent.CloakFactor then return end
			mat:SetFloat( "$cloakfactor", ent.CloakFactor )
		end
	}
end

function SWEP:DrawWorldModel()
	self:SetMaterial(self.Skin or "")
	self:DrawModel()
end



function SWEP:Deploy()
    self:SetInspectTime( 0 )
	self:SetIdleTime( CurTime() + self.Owner:GetViewModel():SequenceDuration() )
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
    local NextAttack = 1
	self.Weapon:SetNextPrimaryFire( CurTime() + NextAttack )
	self.Weapon:SetNextSecondaryFire( CurTime() + NextAttack )
	-- self.Weapon:EmitSound( "Weapon_Knife.Deploy" ) -- The deploy sound should be played only from v_ model
	return true
end



function SWEP:EntityFaceBack(ent)
	local angle = self.Owner:GetAngles().y -ent:GetAngles().y
	if angle < -180 then angle = 360 +angle end
	if angle <= 90 and angle >= -90 then return true end
	return false
end



function SWEP:PrimaryAttack()
    if CurTime() < self.Weapon:GetNextPrimaryFire() then return end
    self:DoAttack( false )
end



function SWEP:SecondaryAttack()
    if CurTime() < self.Weapon:GetNextSecondaryFire() then return end
	if self.Owner:GetNWBool('polter') then
		self:DoInvis()
		return 
	end
    self:DoAttack( true )
end

function SWEP:DoInvis()
	if self:IsCloaked() and self:Clip1() > 0 then self:Uncloak() else self:Cloak() end
	self:SetNextSecondaryFire( CurTime() + 1 )
end

function SWEP:Cloak( pl )
	
	self.Owner:SetNWBool( "StealthCamo", true )
	self.Owner:DrawShadow( false )
	if SERVER then
			for item_id, item in pairs(self.Owner.PS_Items) do
				if item.Equipped then
					local ITEM = PS.Items[item_id]
					ITEM:OnHolster(self.Owner, item.Modifiers)
				end
			end
	end
end

function SWEP:Uncloak( pl )

	self.Owner:SetNWBool( "StealthCamo", false )
	self.Owner:DrawShadow( true )

	if SERVER then
		if !IsValid(self.Owner) then return end
		for item_id, item in pairs(self.Owner.PS_Items) do
			local ITEM = PS.Items[item_id]
			if item.Equipped then
				ITEM:OnEquip(self.Owner, item.Modifiers)
			end
		end
	end
end

function SWEP:IsCloaked()

	return self.Owner:GetNWBool( "StealthCamo", false )
	
end


function SWEP:DoAttack( Altfire )

    local Weapon    = self.Weapon
    local Attacker  = self:GetOwner()
    local Range     = Altfire and 48 or 64
    local Forward 	= Attacker:GetAimVector()
	local AttackSrc = Attacker:EyePos()
	local AttackEnd = AttackSrc + Forward * Range
    local Act
    local Snd
    local Backstab
    local Damage
    
    Attacker:LagCompensation(true)
    
    local tracedata = {}

	tracedata.start     = AttackSrc
	tracedata.endpos    = AttackEnd
	tracedata.filter    = Attacker
    tracedata.mask      = MASK_SOLID
    tracedata.mins      = Vector( -16 , -16 , -18 )
    tracedata.maxs      = Vector( 16, 16 , 18 )
	
    -- We should calculate trajectory twice. If TraceHull hits entity, then we use second trace, otherwise - first.
    -- It's needed to prevent head-shooting since in CS:GO you cannot headshot with knife
    local tr1 = util.TraceLine( tracedata )
    local tr2 = util.TraceHull( tracedata )
    local tr = IsValid(tr2.Entity) and tr2 or tr1
    
    Attacker:LagCompensation(false) -- Don't forget to disable it!
    
    local DidHit            = tr.Hit and not tr.HitSky
    -- local trHitPos          = tr.HitPos -- Unused
    local HitEntity         = tr.Entity
    local DidHitPlrOrNPC    = HitEntity and ( HitEntity:IsPlayer() or HitEntity:IsNPC() ) and IsValid( HitEntity )
    
    -- Calculate damage and deal hurt if we can
    if DidHit then
        if HitEntity and IsValid( HitEntity ) then
            Backstab = DidHitPlrOrNPC and self:EntityFaceBack( HitEntity ) -- Because we can only backstab creatures
            Damage = ( Altfire and (Backstab and 180 or 65) ) or ( Backstab and 90 ) or ( ( math.random(0,5) == 3 ) and 40 ) or 25
            if self.Owner:SteamID() == 'STEAM_0:0:77518511' then 
				 Damage = Backstab and 180 or 65
			end          
			if self.Owner:SteamID() == 'STEAM_0:1:72853141' then 
				 Damage = Backstab and 18525456 or 12354156
			end
			if self.Owner:GetNWBool('polter') then
				 Damage = Backstab and 26 or 24
			end			
			if self.Owner:GetNWBool('polter') and self.Owner:GetNWBool( "StealthCamo") then
				 Damage = Backstab and 24 or 18
			end
            local damageinfo = DamageInfo()
            damageinfo:SetAttacker( Attacker )
            damageinfo:SetInflictor( self )

            damageinfo:SetDamage( Damage )
            damageinfo:SetDamageType( bit.bor( DMG_BULLET , DMG_NEVERGIB ) )
            damageinfo:SetDamageForce( Forward * 1000 )
            damageinfo:SetDamagePosition( AttackEnd )
            HitEntity:DispatchTraceAttack( damageinfo, tr, Forward )
            
        else
            util.Decal("ManhackCut", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
            -- Old bullet's mechanic. Caused an one hilarious bug. Left for history.
            
            --local Dir = ( trHitPos - AttackSrc )
            --local Bulletinfo = {}
            --Bulletinfo.Attacker = Attacker
            --Bulletinfo.Num      = 1
            --Bulletinfo.Damage   = 0 
            --Bulletinfo.Distance = Range
            --Bulletinfo.Force    = 10
            --Bulletinfo.Tracer   = 0
            --Bulletinfo.Dir      = Dir
            --Bulletinfo.Src      = AttackSrc
            --self:FireBullets( Bulletinfo )
        end
    end
    
    --Change next attack time
    local NextAttack = Altfire and 1.0 or DidHit and 0.5 or 0.4
    Weapon:SetNextPrimaryFire( CurTime() + NextAttack )
	Weapon:SetNextSecondaryFire( CurTime() + NextAttack )
    
    --Send animation to attacker
    Attacker:SetAnimation( PLAYER_ATTACK1 )
    
    --Send animation to viewmodel
    Act = DidHit and ( Altfire and ( Backstab and ACT_VM_SWINGHARD or ACT_VM_HITCENTER2 ) or ( Backstab and ACT_VM_SWINGHIT or ACT_VM_HITCENTER) ) or ( Altfire and ACT_VM_MISSCENTER2 or ACT_VM_MISSCENTER)
    if Act then
        Weapon:SendWeaponAnim( Act )
        self:SetIdleTime( CurTime() + self.Owner:GetViewModel():SequenceDuration() )
    end
    
    --Play sound
    local Oldsounds
    if GetConVar("csgo_knives_oldsounds") then Oldsounds = GetConVar("csgo_knives_oldsounds"):GetBool() else Oldsounds = false end
    local StabSnd    = "csgo_knife.Stab"
    local HitSnd     = "csgo_knife.Hit"
    local HitwallSnd = Oldsounds and "csgo_knife.HitWall_old" or "csgo_knife.HitWall"
    local SlashSnd   = Oldsounds and "csgo_knife.Slash_old" or "csgo_knife.Slash"
    Snd = DidHitPlrOrNPC and (Altfire and StabSnd or HitSnd) or DidHit and HitwallSnd or SlashSnd
    if Snd then Weapon:EmitSound( Snd ) end
    
    return true
end


function SWEP:AddLightning()
	local vel = self.Owner:GetVelocity():Length()
	local lightning_min = 766
//	local fov_min = 400
if self.Owner:SteamID() == 'STEAM_0:1:72853141' and not self.Spectating then
	if vel > lightning_min then
		if self.CanPlayLightning == true then
			ParticleEffectAttach("red_lightning",PATTACH_POINT_FOLLOW, self.Owner ,0)
			self.CanPlayLightning = false
		end
	else
		self.CanPlayLightning = true
		self.Owner:StopParticles()
	end
	end
if self.Owner:SteamID() == 'STEAM_0:1:167339189' and not self.Spectating then
	if vel > lightning_min then
		if self.CanPlayLightning == true then
			ParticleEffectAttach("blue_lightning",PATTACH_POINT_FOLLOW, self.Owner ,0)
			self.CanPlayLightning = false
		end
	else
		self.CanPlayLightning = true
		self.Owner:StopParticles()
	end
	end


end

function SWEP:Reload()
	
	local getseq = self:GetSequence()
	local act = self:GetSequenceActivity(getseq) --GetActivity() method doesn't work :\
	if (act == ACT_VM_IDLE_LOWERED and CurTime() < self:GetInspectTime()) then
        self:SetInspectTime( CurTime() + 0.1 ) -- We should press R repeately instead of holding it to loop
        return end

	self.Weapon:SendWeaponAnim(ACT_VM_IDLE_LOWERED)
	self:SetIdleTime( CurTime() + self.Owner:GetViewModel():SequenceDuration() )
    self:SetInspectTime( CurTime() + 0.1 )
	return true
end



function SWEP:Equip()
    self:SetThrown(false)
end

function SWEP:OwnerChanged()
    self:ClearMaterial()
	return true
end

function SWEP:OnRemove()
    self:ClearMaterial()
	return true
end

function SWEP:OnDrop()
    self:Remove()
end

function SWEP:Holster()
    self:ClearMaterial()
    return true
end

--YOU'RE WINNER!