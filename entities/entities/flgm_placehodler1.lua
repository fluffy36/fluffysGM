
ENT.PrintName = "PLACEHOLDER"
ENT.Author = "Fluffy/Lenny"
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