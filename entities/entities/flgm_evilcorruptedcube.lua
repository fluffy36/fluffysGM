AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Corrupted prop"
ENT.Author = "Fluffy"
ENT.Category = "Fluffy's gamemode"
ENT.Spawnable = true

function ENT:Initialize()
    
    if ( SERVER ) then
       
        self:SetModel("models/hunter/blocks/cube075x075x075.mdl")
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        
        
        self:SetMaterial("debug/debugempty.vtf")
        
        
        self:SetColor(Color(255, 0, 0, 255))
        
        
        local phys = self:GetPhysicsObject()
        if IsValid(phys) then
            phys:Wake()
        end
    end
end

if ( SERVER ) then
    
    function ENT:OnRemove()
       
        if GM_REMOVING_ALL or not IsValid(self) then return end
        
        local currentPos = self:GetPos()
        local currentAng = self:GetAngles()
        
        
        local clone1 = ents.Create(self:GetClass())
        if IsValid(clone1) then
            clone1:SetPos(currentPos + Vector(math.random(-15, 15), math.random(-15, 15), 10))
            clone1:SetAngles(currentAng)
            clone1:Spawn()
            
            
            local phys1 = clone1:GetPhysicsObject()
            if IsValid(phys1) then phys1:ApplyForceCenter(Vector(math.random(-200, 200), math.random(-200, 200), 300)) end
        end

       
        local clone2 = ents.Create(self:GetClass())
        if IsValid(clone2) then
            clone2:SetPos(currentPos + Vector(math.random(-15, 15), math.random(-15, 15), 10))
            clone2:SetAngles(currentAng)
            clone2:Spawn()
            
            
            local phys2 = clone2:GetPhysicsObject()
            if IsValid(phys2) then phys2:ApplyForceCenter(Vector(math.random(-200, 200), math.random(-200, 200), 300)) end
        end
        
        
        self:EmitSound("ambient/energy/spark" .. math.random(1, 6) .. ".wav", 75, 150)
    end
end

if ( CLIENT ) then
   
    function ENT:Draw()
        self:DrawModel()
    end
end