AddCSLuaFile()

ENT.PrintName = "corrupted prop infection"
ENT.Author = "Lenny"
ENT.Base = "base_gmodentity"
ENT.Category = "Fluffy's gamemode"
ENT.Spawnable = true

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/hunter/blocks/cube2x2x2.mdl")
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        
        self:SetMaterial("debug/debugempty")
        self.InfectionRadius = 150       
        self.MaxInfectionRadius = 2000   
        self.RadiusGrowthRate = 15      
        self.InfectedRegistry = {}      
        self.CureHitsLeft = self.CureHitsLeft or 5

        local phys = self:GetPhysicsObject()
        if IsValid(phys) then phys:Wake() end

        timer.Create("FLGM_InfectionLoop_" .. self:EntIndex(), 1.5, 0, function()
            if IsValid(self) then
                self:SpreadTheCorruption()
            end
        end)
    end

    function ENT:SpreadTheCorruption()
        if self.InfectionRadius < self.MaxInfectionRadius then
            self.InfectionRadius = self.InfectionRadius + self.RadiusGrowthRate
        end

        local nearbyTargets = ents.FindInSphere(self:GetPos(), self.InfectionRadius)

        for _, ent in ipairs(nearbyTargets) do
            if IsValid(ent) and ent ~= self and not ent:IsPlayer() and ent:GetClass() ~= "worldspawn" then
               
                if ent.FLGM_IsInfected then continue end

                local class = ent:GetClass()
                
                if string.find(class, "logic_") or string.find(class, "trigger_") or string.find(class, "point_") then 
                    continue 
                end

                ent.FLGM_IsInfected = true
                ent.FLGM_CureHitsLeft = 5 -- Needs 5 hits to get removed
                ent.FLGM_OriginalMaterial = ent:GetMaterial() or ""
                ent.FLGM_SourceInfectionRoot = self 

                ent:SetMaterial("debug/debugempty")
                ent:EmitSound("ambient/energy/spark1.wav", 65, 85)

                table.insert(self.InfectedRegistry, ent)
            end
        end
    end

    function ENT:OnRemove()
        timer.Destroy("FLGM_InfectionLoop_" .. self:EntIndex())
        if self.CureHitsLeft < 1 then

            if self.InfectedRegistry then

                for _, ent in ipairs(self.InfectedRegistry) do

                    if IsValid(ent) and ent.FLGM_IsInfected then

                        ent:SetMaterial(ent.FLGM_OriginalMaterial or "")
                        ent.FLGM_IsInfected = nil
                        ent.FLGM_CureHitsLeft = nil
                        ent.FLGM_SourceInfectionRoot = nil
                        
                        ent:EmitSound("buttons/button14.wav", 65, 120)
                    end

                end

            end

        else
            local Clone = ents.Create("flgm_corruptedprop_infection")
            Clone:SetPos(self:GetPos())
            Clone:SetAngles(self:GetAngles())
            Clone.InfectedRegistry = self.InfectedRegistry
            Clone.CureHitsLeft = self.CureHitsLeft-1
            Clone:Spawn()
        end
    end
end

if CLIENT then
    function ENT:Draw()
        self:DrawModel()

        local size = 40 + math.sin(CurTime() * 6) * 8
        render.SetMaterial(Material("sprites/glow04_gmod"))
        render.DrawSprite(self:GetPos(), size, size, Color(255, 0, 255, 200))
    end
end