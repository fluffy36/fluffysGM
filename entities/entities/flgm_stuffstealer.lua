AddCSLuaFile()

ENT.PrintName = "Prop Kidnapper"
ENT.Author = "Lenny"
ENT.Base = "base_gmodentity"
ENT.Category = "Fluffy's gamemode"
ENT.Spawnable = true

if SERVER then
    function ENT:Initialize()
        -- Setting up a visual form for the thief (using a Kleiner model as a placeholder)
        self:SetModel("models/hunter/blocks/cube1x1x1.mdl")
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMaterial("models/monk/grigori_head")
        self:SetSolid(SOLID_VPHYSICS)
        
        -- Give it a distinct red profile color so you know it's aggressive
        self:SetColor(Color(255, 50, 50, 255))

        -- Tracking States
        self.Victim = nil
        self.IsHoldingVictim = false
        self.AbductionLifetime = 30 -- Dissolve timer duration
        self.MoveSpeed = 220        -- Slightly faster speed to accommodate flight drift
        self.HoverHeight = 100      -- Target height to stay off the ground floor

        -- Wake up physics and disable normal gravity profiles so it behaves as a flyer
        local phys = self:GetPhysicsObject()
        if IsValid(phys) then 
            phys:Wake() 
            phys:SetMass(150)
            phys:EnableGravity(false)
        end

        -- CRITICAL FIX: Tells the Source Engine to actively listen to the PhysicsSimulate hook below
        self:StartMotionController()

        -- Step 1: Scan and grab a target immediately upon spawning
        self:SelectAndKidnapTarget()

        -- Step 2: Begin running a lifetime breakdown clock
        timer.Simple(self.AbductionLifetime, function()
            if IsValid(self) then
                self:EscapeWithVictim()
            end
        end)
    end

    function ENT:SelectAndKidnapTarget()
        -- Scan out up to a massive 3000 unit sphere radius for a target
        local entities = ents.FindInSphere(self:GetPos(), 3000)
        
        for _, ent in ipairs(entities) do
            if IsValid(ent) and ent ~= self and not ent:IsPlayer() then
                local class = ent:GetClass()
                
                -- Skip structural nodes, world brush layouts, and components that can't be grabbed
                if class == "worldspawn" or class == "soundent" or string.find(class, "logic_") then continue end

                -- THE SPAWNMENU SAFETY GATEWAY:
                -- Check if it's an engine NPC, a physics prop, or has a player creator footprint attached to it.
                -- This specifically prevents it from ever grabbing structural map walls, doors, or static world trees.
                local isSpawnedProp = (class == "prop_physics" or ent:IsNPC() or class == "prop_ragdoll")
                local hasCreator = IsValid(ent:GetCreator()) or ent.CPPIDowner ~= nil or ent:GetNWString("Creator", "") ~= ""

                if isSpawnedProp or hasCreator then
                    self.Victim = ent
                    break
                end
            end
        end

        -- If a victim was selected, physically anchor them
        if IsValid(self.Victim) then
            self.IsHoldingVictim = true

            -- Strip physics control from the victim while they are trapped
            local vPhys = self.Victim:GetPhysicsObject()
            if IsValid(vPhys) then
                vPhys:EnableMotion(false)
            end

            -- Snap the victim right over the kidnapper's head
            self.Victim:SetPos(self:GetPos() + Vector(0, 0, 75))
            self.Victim:SetParent(self)

            -- Alarm indicator sounds
            self:EmitSound("ambient/machines/combine_shield_touch_loop1.wav", 75, 140)
            self.Victim:EmitSound("vo/npc/male01/help01.wav", 80, 100)
        else
            -- If the area is completely empty, it drops an audio cue and deletes its own idle profile
            self:EmitSound("ambient/voices/cough4.wav", 70, 90)
            self:Remove()
        end
    end

    -------------------------------------------------------------------------
    -- ENHANCED PHYSICS FLYING LOCOMOTION
    -------------------------------------------------------------------------
    function ENT:PhysicsSimulate(phys, deltatime)
        if not self.IsHoldingVictim then return end

        phys:Wake()

        -- 1. Unpredictable Random 3D Wandering Angles
        if not self.NextWanderTime or CurTime() > self.NextWanderTime then
            -- Blends X, Y, and slight Z variance to make it dynamically bob up and down while zooming
            self.WanderDirection = Vector(math.random(-1, 1), math.random(-1, 1), math.random(-0.2, 0.4)):GetNormalized()
            self.NextWanderTime = CurTime() + math.random(1.2, 2.8)
            
            -- Keep playing struggle noise profiles
            self:EmitSound("npc/combine_soldier/gear" .. math.random(1, 2) .. ".wav", 65, 100)
        end

        -- 2. Anti-Ground Crash Radar Raycast
        local tr = util.TraceLine({
            start = self:GetPos(),
            endpos = self:GetPos() - Vector(0, 0, self.HoverHeight * 2),
            filter = { self, self.Victim }
        })

        local upwardThrust = 0
        if tr.Hit then
            local dist = self:GetPos():Distance(tr.HitPos)
            if dist < self.HoverHeight then
                -- The closer it gets to hitting the ground floor, the more powerful the vertical thrust becomes
                local antiGravityScale = (self.HoverHeight - dist) / self.HoverHeight
                upwardThrust = antiGravityScale * 400
            end
        else
            -- If it's falling past our radar trace threshold, apply a safe cushion baseline force
            upwardThrust = 80
        end

        -- 3. Calculate Final Physical Vector Acceleration Forces
        local currentVel = phys:GetVelocity()
        local targetVel = (self.WanderDirection * self.FlySpeed) + Vector(0, 0, upwardThrust)
        
        -- Smooth out dampening translation matrix forces so it glides like a drone
        local forceVector = (targetVel - currentVel) * 4.5

        -- Return forces to the controller (Linear force vector, Angular torque vector, System flag)
        return forceVector, Vector(0, 0, 0), SIM_GLOBAL_ACCELERATION
    end

    -- Run basic damage tracking interceptor
    function ENT:OnTakeDamage(dmginfo)
        -- Any bullet impact, blast, or melee strike triggers a clean release drop
        local attacker = dmginfo:GetAttacker()
        if IsValid(attacker) and attacker:IsPlayer() then
            self:DropVictimSafely()
        end
    end

    function ENT:DropVictimSafely()
        if IsValid(self.Victim) then
            -- Unparent completely and wake the item physics engine back up
            self.Victim:SetParent(nil)
            
            local vPhys = self.Victim:GetPhysicsObject()
            if IsValid(vPhys) then
                vPhys:EnableMotion(true)
                vPhys:Wake()
            end

            self.Victim:EmitSound("ammobox_pickup")
        end

        -- Play defeat effect and disappear completely
        self:EmitSound("physics/cardboard/cardboard_box_break3.wav", 75, 120)
        
        local effect = EffectData()
        effect:SetOrigin(self:GetPos())
        util.Effect("RagdollImpact", effect)

        self:Remove()
    end

    function ENT:EscapeWithVictim()
        -- The 30 seconds expired! Both entities are permanently deleted out of the server grid
        if IsValid(self.Victim) then
            self.Victim:Remove()
        end

        self:EmitSound("ambient/levels/citadel/weapon_disintegrate3.wav", 75, 70)
        
        local effect = EffectData()
        effect:SetOrigin(self:GetPos())
        util.Effect("EntityDissolve", effect)

        self:Remove()
    end
end

if CLIENT then
    function ENT:Draw()
        self:DrawModel()
        
        -- Draw an aggressive pulsing red warning indicator orb beneath its core matrix
        local size = 35 + math.sin(CurTime() * 12) * 6
        render.SetMaterial(Material("sprites/glow04_gmod"))
        render.DrawSprite(self:GetPos() + Vector(0, 0, 5), size, size, Color(255, 0, 50, 220))
    end
end