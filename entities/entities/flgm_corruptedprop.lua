AddCSLuaFile()

ENT.PrintName = "Corrupted prop"
ENT.Author = "Fluffy"
ENT.Base = "base_gmodentity"
ENT.Category = "Fluffy's gamemode"
ENT.Spawnable = true

function ENT:Initialize()
    
    if ( SERVER ) then

        self:SetModel("models/hunter/blocks/cube075x075x075.mdl")
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetMaterial("debug/debugempty.vtf")

    end

end
