AddCSLuaFile()

ENT.PrintName = "Terminal"
ENT.Base = "base_gmodentity"
ENT.Author = "Fluffy"
ENT.Category = "Fluffy's gamemode"
ENT.Spawnable = true
ENT.Editable = true

function ENT:SetupDataTables()
    
    self:NetworkVar("Float", 4, "PropSpawnRate", {KeyName="Prop spawn rate",Edit={type="Float", order=1, min = 0.1, max = 240}})
    

end

function ENT:Initialize()

    if (SERVER) then
        
        self:SetModel("models/props_wasteland/kitchen_fridge001a.mdl")
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        

        self:SetUseType(SIMPLE_USE)

        local flgm_PropSpawnRate = CreateConVar("flgm_PropSpawnRate", 4, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Sets prop spawn rate of props in the air")
        self:SetPropSpawnRate(4)
        self:SetOverlayText("USE ONLY IN GAMEMODE(fluffy's gamemode)\n Go to contect menu to edit!\n you can also use the terminal to play music")
        self.Powered = false
        self.Music = CreateSound(self, "TerminalMusic.wav")
        
    end

end

function ENT:Think()
    if (SERVER) then
        flgm_PropSpawnRate = GetConVar("flgm_PropSpawnRate")
        self:SetPropSpawnRate(flgm_PropSpawnRate:GetFloat())
        flgm_PropSpawnRate:SetFloat(self:GetPropSpawnRate())
    end
end

function ENT:Use(activator, caller, useType, value)
    self.Powered = !self.Powered
    if (self.Powered) then
        self.Music:Play()
    else
        self.Music:Stop()
    end
    
end

function ENT:OnTakeDamage(damage)
    self:EmitSound("physics/metal/metal_canister_impact_hard".. math.random(1, 3) ..".wav")
end

function ENT:PhysicsCollide(colData, collider)
    local Energy = colData.OurOldVelocity:Length() - colData.OurNewVelocity:Length()

    if Energy > 50 then
        self:EmitSound("physics/metal/metal_grate_impact_hard".. math.random(1, 3) ..".wav",75,100,Energy/100)
    end
    if Energy > 500 then
        if colData.HitEntity:IsPlayer() then
            self:EmitSound("physics/body/body_medium_break".. math.random(2, 4) ..".wav",80,85,Energy/80)
        else
            self:EmitSound("physics/metal/metal_sheet_impact_hard".. math.random(6, 8) ..".wav",78,100,Energy/99)
        end
    end
    --print(Energy)
    --print(Energy/100)
end

function ENT:OnRemove()
    
    sound.Play("friends/friend_online.wav", Vector(0, 0, 0), 0)
end