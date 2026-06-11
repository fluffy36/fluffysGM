AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Inbox Car"
ENT.Category = "Fluffy's gamemode"
ENT.Spawnable = true
if CLIENT then
    killicon.Add("inbox_car", "HUD/killicons/default", Color(255, 0, 0, 255))
    -- too lazy to add
end
function ENT:Initialize()
    
    self:SetModel("models/props_vehicles/car004a_physics.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
        phys:SetMass(5000000) 
        self.mass = phys:GetMass()
    end
    
    self.Seat = ents.Create("prop_vehicle_prisoner_pod")
    self.Seat:SetModel("models/nova/airboat_seat.mdl")
    self.Seat:SetPos(self:LocalToWorld(Vector(5,15,-10)))
    self.Seat:SetAngles(self:LocalToWorldAngles(Angle(0,-90,0)))
    self.Seat:Spawn()
    self.Seat:SetParent(self)

    self.Seat2 = ents.Create("prop_vehicle_prisoner_pod")
    self.Seat2:SetModel("models/nova/airboat_seat.mdl")
    self.Seat2:SetPos(self:LocalToWorld(Vector(5,-15,-10)))
    self.Seat2:SetAngles(self:LocalToWorldAngles(Angle(0,-90,0)))
    self.Seat2:Spawn()
    self.Seat2:SetParent(self)

    self.EngineSound = CreateSound(self, "vehicles/v8/first.wav")
    self.EngineSound:PlayEx(1, 50)
    self.PassengerisAvailable = false
end

function ENT:Use(activator, caller)
    if not self.PassengerisAvailable then
        activator:EnterVehicle(self.Seat)
        self.PassengerisAvailable = true
    elseif self.PassengerisAvailable and IsValid(self.Seat2) and not IsValid(self.Seat2:GetDriver()) then
        activator:EnterVehicle(self.Seat2)
    end
end

function ENT:Think()
    local phys = self:GetPhysicsObject()
    if not IsValid(phys) then return end
    local driver = IsValid(self.Seat) and self.Seat:GetDriver()

    if IsValid(driver) then
        -- stability
        local ang = self:GetAngles()
        local angVel = phys:GetAngleVelocity()
        phys:AddAngleVelocity(Vector(-ang.p * 0.5 - angVel.x * 0.1, -ang.r * 0.5 - angVel.y * 0.1, 0))

        local turbo = driver:KeyDown(IN_SPEED) and 2 or 1
        local moveForce = 500000 * turbo

        if driver:KeyDown(IN_FORWARD) then
            phys:ApplyForceCenter(self:GetForward() * moveForce)
        elseif driver:KeyDown(IN_BACK) then
            phys:ApplyForceCenter(-self:GetForward() * moveForce)
        end

        if driver:KeyDown(IN_MOVELEFT) then
            phys:AddAngleVelocity(Vector(0,0,10))
        elseif driver:KeyDown(IN_MOVERIGHT) then
            phys:AddAngleVelocity(Vector(0,0,-10))
        end

        if driver:KeyPressed(IN_JUMP) then
            phys:ApplyForceCenter(Vector(0, 0, 9990000))
            self:EmitSound("physics/metal/metal_barrel_impact_hard1.wav")
        end
    else
        if IsValid(self.Seat2) and IsValid(self.Seat2:GetDriver()) then
            self.Seat2:GetDriver():EnterVehicle(self.Seat)
            self.PassengerisAvailable = true
        else
            self.PassengerisAvailable = false
        end
    end

    local speed = phys:GetVelocity():Length()
    if self.EngineSound then
        self.EngineSound:ChangePitch(math.Clamp(speed / 6, 30, 140), 0.1)
    end
    self:NextThink(CurTime())
    return true
end

function ENT:PhysicsCollide(data, phys)
    local energy = data.Speed

    -- mr booger known as fluffy can fix this i fail
    if energy > 600 then
        local sparkScale = math.Clamp(energy / 400, 2, 10)
        local effectdata = EffectData()
        effectdata:SetOrigin(data.HitPos)
        effectdata:SetNormal(data.HitNormal)
        effectdata:SetMagnitude(sparkScale)
        effectdata:SetScale(sparkScale)
        util.Effect("Sparks", effectdata, true)

    elseif energy > 200 then
        local effectdata = EffectData()
        effectdata:SetOrigin(data.HitPos)
        util.Effect("cball_explode", effectdata, true)
    end
end

function ENT:PhysicsCollide(data, phys)

    local energy = data.Speed

    if energy > 400 then
        self:EmitSound(
            "physics/metal/metal_large_debris" ..
            math.random(1,2) ..
            ".wav"
        )
    end

    if energy > 200 then
        self:EmitSound(
            "physics/metal/metal_barrel_impact_hard" ..
            math.random(1,7) ..
            ".wav"
        )
    end
end

function ENT:OnRemove()
    if self.EngineSound then self.EngineSound:Stop() end
    if IsValid(self.Seat) then self.Seat:Remove() end
    if IsValid(self.Seat2) then self.Seat2:Remove() end
end