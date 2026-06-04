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
        
        if not self.purpose or self.purpose == "" then
            self.purpose = "PLEASE SET A VALID PURPOSE"
        end

        local phys = self:GetPhysicsObject()
        if IsValid(phys) then
            phys:Wake()
        end

    end

end