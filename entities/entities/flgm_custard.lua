ENT.PrintName = "Custard"
ENT.Author = "Fluffy"
ENT.Base = "base_gmodentity"
ENT.Category = "Fluffy's gamemode"
ENT.Spawnable = true



function ENT:Initialize()

    if ( SERVER ) then

        self:SetModel("models/props_phx/misc/egg.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)

        local phys = self:GetPhysicsObject()
        if IsValid(phys) then
            phys:Wake()
        end

    end

end
if ( SERVER ) then
    function ENT:Use(activator, caller, useType, value)

        local EffectData = EffectData()
        EffectData:SetOrigin(self:GetPos())
        EffectData:SetScale(2)
        EffectData:SetMagnitude(5)
        util.Effect("Sparks", EffectData, true)
        self:EmitSound("button/blip1.wav")
    end

    hook.Add("Tick", "", function()
        
    end)
end