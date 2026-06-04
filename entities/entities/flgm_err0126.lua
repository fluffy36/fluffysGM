AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "err0126"
ENT.Author = "Lenny"
ENT.Category = "Fluffy's gamemode"
ENT.Spawnable = true

function ENT:Initialize()
    
    if ( SERVER ) then
       
        self:SetModel("models/hunter/blocks/cube075x075x075.mdl")
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        
        self:SetMaterial("debug/debugempty.vtf")
        
        local phys = self:GetPhysicsObject()
        if IsValid(phys) then
            phys:Wake()
        end
    end
end

if ( SERVER ) then
    
    function ENT:OnRemove()
    
        
        local currentPos = self:GetPos()
        local currentAng = self:GetAngles()
        local currentMat = self:GetMaterial()
        local currentClass = self:GetClass() 
        
        local currentVel = Vector(0, 0, 0)
        local physObj = self:GetPhysicsObject()
        if IsValid(physObj) then
            currentVel = physObj:GetVelocity()
        end
        
        local effectData = EffectData()
        effectData:SetOrigin(currentPos)
        effectData:SetScale(3) 
        effectData:SetMagnitude(3) 
        util.Effect("Sparks", effectData, true)
        
        
        timer.Simple(0, function()
           
            local backup = ents.Create(currentClass)
            if IsValid(backup) then
                backup:SetPos(currentPos)
                backup:SetAngles(currentAng)
                backup:Spawn()
                if currentMat and currentMat ~= "" then backup:SetMaterial(currentMat) end
                
                local bPhys = backup:GetPhysicsObject()
                if IsValid(bPhys) then
                    bPhys:SetVelocity(currentVel)
                end
            end
        end)
        
        local clone1 = ents.Create(currentClass)
        if IsValid(clone1) then
            clone1:SetPos(currentPos + Vector(math.random(-15, 15), math.random(-15, 15), 10))
            clone1:SetAngles(currentAng)
            clone1:Spawn()
            
            local phys1 = clone1:GetPhysicsObject()
            if IsValid(phys1) then phys1:ApplyForceCenter(Vector(math.random(-200, 200), math.random(-200, 200), 300)) end
        end

       
        local clone2 = ents.Create(currentClass)
        if IsValid(clone2) then
            clone2:SetPos(currentPos + Vector(math.random(-15, 15), math.random(-15, 15), 10))
            clone2:SetAngles(currentAng)
            clone2:Spawn()
            
            local phys2 = clone2:GetPhysicsObject()
            if IsValid(phys2) then phys2:ApplyForceCenter(Vector(math.random(-200, 200), math.random(-200, 200), 300)) end
        end
        
        self:EmitSound("glitch_sound"..math.random(1,3)"...wav", 75, 150)
    end
end

if ( CLIENT ) then
   
    function ENT:Draw()
        local r = math.abs(math.sin(RealTime() * 25) * 255)
        local g = math.abs(math.sin(RealTime() * 40) * 255) 
        local b = math.abs(math.cos(RealTime() * 33) * 255)
        
        render.SetColorModulation(r / 255, g / 255, b / 255)
        self:DrawModel()
        render.SetColorModulation(1, 1, 1)
    end
end