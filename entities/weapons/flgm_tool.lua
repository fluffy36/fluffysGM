
AddCSLuaFile()

SWEP.PrintName = "Tool gun?"
SWEP.Author = "Fluffy"
SWEP.Purpose = "I cant tell if this is the real one..."

SWEP.Slot = 5
SWEP.SlotPos = 4

SWEP.Spawnable = true

SWEP.ShootSound = Sound( "Toolgun.Single" )

SWEP.ViewModel		= "models/weapons/c_toolgun.mdl"
SWEP.WorldModel		= "models/weapons/w_toolgun.mdl"

SWEP.UseHands = true

util.PrecacheModel( SWEP.ViewModel )
util.PrecacheModel( SWEP.WorldModel )

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.HoldType = "revolver"



function SWEP:Initialize()
    self:SetHoldType( self.HoldType )

	
end


function SWEP:Deploy()
    
end

-- The shoot effect
function SWEP:DoShootEffect( hitpos, hitnormal, entity, physbone, bFirstTimePredicted )

	local owner = self:GetOwner()

	self:EmitSound( self.ShootSound )
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) -- View model animation

	-- There's a bug with the model that's causing a muzzle to
	-- appear on everyone's screen when we fire this animation.
	owner:SetAnimation( PLAYER_ATTACK1 ) -- 3rd Person Animation

	if ( !bFirstTimePredicted ) then return end
	if ( GetConVarNumber( "gmod_drawtooleffects" ) == 0 ) then return end

	local effectdata = EffectData()
	effectdata:SetOrigin( hitpos )
	effectdata:SetNormal( hitnormal )
	effectdata:SetEntity( entity )
	effectdata:SetAttachment( physbone )
	util.Effect( "selection_indicator", effectdata )

	local effect_tr = EffectData()
	effect_tr:SetOrigin( hitpos )
	effect_tr:SetStart( owner:GetShootPos() )
	effect_tr:SetAttachment( 1 )
	effect_tr:SetEntity( self )
	util.Effect( "ToolTracer", effect_tr )

end

local toolMask = bit.bor( CONTENTS_SOLID, CONTENTS_MOVEABLE, CONTENTS_MONSTER, CONTENTS_WINDOW, CONTENTS_DEBRIS, CONTENTS_GRATE, CONTENTS_AUX )
function SWEP:DoToolTrace()
	local owner = self:GetOwner()

	local tr = util.GetPlayerTrace( owner )
	tr.mask = toolMask
	tr.mins = vector_origin
	tr.maxs = tr.mins
	tr.filter = { owner, owner:GetVehicle() }

	local trace = util.TraceLine( tr )
	if ( !trace.Hit || !IsValid( trace.Entity ) ) then
		local hulltrace = util.TraceHull( tr )

		if ( IsValid( hulltrace.Entity ) ) then
			trace = hulltrace
			trace.HullTrace = true
		end
	end
	if ( !trace.Hit ) then return end

	return trace
end
local CorruptedPropsAmount = 0
function SWEP:PrimaryAttack()

    local trace = self:DoToolTrace()
	if ( !trace ) then return end

	local tool = self
	if ( !tool ) then return end

	self:DoShootEffect( trace.HitPos, trace.HitNormal, trace.Entity, trace.PhysicsBone, IsFirstTimePredicted() )
    local Str = string.Split(trace.Entity:GetClass(), "_")
    --PrintTable(Str)
    if Str[1]=="flgm" then
		if Str[1]~="flgm" and Str[2]~="corruptedprop" then
        	trace.Entity:EmitSound("friends/friend_online.wav")
		end
		if Str[2]=="corruptedprop" then
			self:EmitSound("resource/warning.wav",0)
			CorruptedPropsAmount = CorruptedPropsAmount + 1
			if ( SERVER ) then
				trace.Entity:Remove()
				self:GetOwner():SetHealth(self:GetOwner():Health()+20)
				local Nav = navmesh.GetNearestNavArea(self:GetOwner():GetPos(), false, 10000, true, true)
				--print(Nav)
				if IsValid(Nav) or Nav ~= nil then
					local RandPoint = Nav:GetRandomPoint()
					Weapons = {"weapon_crowbar","weapon_physcannon","weapon_pistol","weapon_smg1","weapon_357","weapon_shotgun","weapon_crossbow","weapon_rpg"}

					local wpn =  ents.Create(Weapons[math.random(1, table.Count(Weapons))])
					wpn:SetPos(RandPoint+Vector(0,0,500))
					wpn:Spawn()
				end
			end
		end
    elseif trace.Entity:IsValidProp() then
		trace.Entity:EmitSound("friends/message.wav",0)
		if ( SERVER ) then
			trace.Entity:Remove()
			self:GetOwner():SetHealth(self:GetOwner():Health()+20)
		end
	end

end

function SWEP:SecondaryAttack()
    
    local trace = self:DoToolTrace()
	if ( !trace ) then return end

	local tool = self
	if ( !tool ) then return end

	self:DoShootEffect( trace.HitPos, trace.HitNormal, trace.Entity, trace.PhysicsBone, IsFirstTimePredicted() )

	local Str = string.Split(trace.Entity:GetClass(), "_")
    --PrintTable(Str)
    if Str[1]=="flgm" or Str[1]=="prop" then
        trace.Entity:EmitSound("friends/friend_online.wav")
		if Str[1]=="prop"then
			local phys = trace.Entity:GetPhysicsObject()
			phys:EnableMotion(!phys:IsMotionEnabled())
		end
    end
end
