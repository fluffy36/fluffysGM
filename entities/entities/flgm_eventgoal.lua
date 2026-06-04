
ENT.PrintName = "Event goal"
ENT.Author = "Fluffy"
ENT.Base = "base_gmodentity"
ENT.Category = "Fluffy's gamemode"
ENT.Spawnable = true



function ENT:Initialize()

    if ( SERVER ) then

        -- Set a default model if none is provided before Spawn()
        if not self:GetModel() or self:GetModel() == "" then
            self:SetModel("models/props_phx/misc/egg.mdl")
        end
        
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        
        if not self.purpose or self.purpose == "" then
            self.purpose = "PLEASE SET A VALID PURPOSE"
        end

        local phys = self:GetPhysicsObject()
        if IsValid(phys) then
            phys:Wake()
        end

    end

end

function ENT:Use(activator, caller, useType, value)
    if activator:IsPlayer() then

        self:Remove()

        local effectData = EffectData()

        effectData:SetOrigin(self:GetPos())
        effectData:SetScale(1)
        util.Effect("balloon_pop", effectData, true, nil)

        local ply = activator
        local purpose = self.purpose
        local pos = self:GetPos()
        hook.Call("flgm_GoalReached", nil, ply , purpose, pos)

    end
end