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
        
        self.KilledByCrowbar = false

        local phys = self:GetPhysicsObject()
        if IsValid(phys) then
            phys:Wake()
        end
    end
end

if ( SERVER ) then
   
    function ENT:OnTakeDamage(dmginfo)
        local attacker = dmginfo:GetAttacker()
        
        if IsValid(attacker) and attacker:IsPlayer() then
            local activeWeapon = attacker:GetActiveWeapon()
            
            -- Checks if the weapon class is specifically the default crowbar
            if IsValid(activeWeapon) and activeWeapon:GetClass() == "weapon_crowbar" then
                self.KilledByCrowbar = true
                self:Remove() -- Forces deletion safely
            end
        end
    end

    function ENT:OnRemove()
        
        if GM_REMOVING_ALL then return end

        local currentPos = self:GetPos()
        local currentAng = self:GetAngles()
        local currentClass = self:GetClass()

       
        local currentVel = Vector(0, 0, 0)
        local physObj = self:GetPhysicsObject()
        if IsValid(physObj) then
            currentVel = physObj:GetVelocity()
        end

        
        if self.KilledByCrowbar then
           
            local effectData = EffectData()
            effectData:SetOrigin(currentPos)
            effectData:SetScale(2) 
            effectData:SetMagnitude(3) 
            util.Effect("Sparks", effectData, true)
            self:EmitSound("ambient/energy/spark" .. math.random(1, 6) .. ".wav", 75, 150)
            return 
        end

        
        timer.Simple(0, function()
            if GM_REMOVING_ALL then return end
            
            local backup = ents.Create(currentClass)
            if IsValid(backup) then
                backup:SetPos(currentPos)
                backup:SetAngles(currentAng)
                backup:Spawn()
                
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
        
        self:EmitSound("ambient/energy/spark" .. math.random(1, 6) .. ".wav", 75, 150)
    end
end

if ( CLIENT ) then
    function ENT:Draw()
        self:DrawModel()
    end
end