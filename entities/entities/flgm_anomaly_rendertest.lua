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
        self:SetUseType(SIMPLE_USE)

        self.HoldingArtifact = false
    end
end
if SERVER then

function ENT:Use(Activator, Caller)
    if SERVER then 
        if !self:IsPlayerHolding() then
            Activator:PickupObject(self)
            self:SetNWEntity("Holder", Activator)
        else
            self:SetNWEntity("Holder", nil)
        end
    end
end

end

function ENT:Think()
    Pos = self:GetPos()
    Ang = self:GetAngles()
    Self = self
    if SERVER then
        if self:IsPlayerHolding() then
            self:SetNWBool("HoldingArtifact", true)
            
        else
            self:SetNWBool("HoldingArtifact", false)
        end
    end
end

function ENT:Draw(flags)
    if CLIENT then
        for _, ent in ipairs(ents.FindByClass("flgm_anomaly_rendertest")) do
            local ply = LocalPlayer()
            render.SetMaterial(Material("models/debug/debugwhite"))
            local Size = 11
            local Size2 = 7
            local Size3 = 5
            render.DrawWireframeSphere(ent:GetPos(), 3, 35, 35, Color( 255, 255, 255 ), false)
            render.DrawWireframeBox(ent:GetPos(), ent:GetAngles()+Angle(0+math.sin(CurTime()*10), 0, 0+math.cos(CurTime()*10)), Vector(-Size,-Size,-Size), Vector(Size,Size,Size), Color( 255/4, 255/4, 255 ), false)
            render.DrawWireframeBox(ent:GetPos(), ent:GetAngles()+Angle(45,0+CurTime()*60,45), Vector(-Size2,-Size2,-Size2), Vector(Size2,Size2,Size2), Color( 255, 255, 255/2 ), false)
            render.DrawWireframeBox(ent:GetPos(), ent:GetAngles()+Angle(0,0+CurTime()*30,0), Vector(-Size3,-Size3,-Size3), Vector(Size3,Size3,Size3), Color( 255, 255/2, 255/2 ), false)
        end
    end
end

if CLIENT then
    hook.Add("HUDPaint", "ShowArtifactMessage", function()

        for _, ent in ipairs(ents.FindByClass("flgm_anomaly_rendertest")) do

            if not ent:GetNWBool("HoldingArtifact") then continue end
            local ply = ent:GetNWEntity("Holder")
            if not IsValid(ply) then return end
            if LocalPlayer() ~= ply then return end
            draw.RoundedBox(
                4,
                ScrW()/2 - 150,
                ScrH() - 120,
                300,
                40,
                Color(0,0,0,200)
            )

            draw.SimpleText(
                "Ancient Artifact Acquired",
                "DermaLarge",
                ScrW()/2,
                ScrH() - 115,
                Color(255,255,0),
                TEXT_ALIGN_CENTER
            )

            break
        end

    end)
end