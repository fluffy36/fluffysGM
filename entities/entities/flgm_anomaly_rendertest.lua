AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "Render Cube"
ENT.Author = "ChatGPT"
ENT.Category = "Fluffy's gamemode"
ENT.Spawnable = true


function ENT:Initialize()
    if SERVER then
        self:SetModel("models/hunter/blocks/cube05x05x05.mdl")

        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self.Draw = false
        self:SetUseType(SIMPLE_USE)

        local env_sun = ents.FindByClass("env_sun")
        for i,v in pairs(env_sun) do
            v:SetNoDraw(true)
        end
    end
end

function ENT:Use(Activator, Caller)
    if SERVER then 

    end
end

function ENT:Think()
    Pos = self:GetPos()
    Ang = self:GetAngles()
end

function ENT:Draw(flags)
    if CLIENT and draw then
        render.SetMaterial(Material("models/debug/debugwhite"))
        local Size = 15
        render.DrawWireframeBox(Pos, Ang, Vector(-Size,-Size,-Size), Vector(Size,Size,Size), Color( 255, 255, 255 ), false)
    end
end