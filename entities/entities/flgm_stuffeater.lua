AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Mr Eater"
ENT.Author = "Lenny"
ENT.Category = "Fluffy's gamemode"
ENT.Spawnable = true
ENT.AdminOnly = false 

if SERVER then
   
    hook.Add("CanExitVehicle", "FLGM_LockKidnappedPlayer", function(veh, ply)
        local parent = veh:GetParent()
        if IsValid(parent) and parent:GetClass() == "flgm_stuffstealer" and parent.IsKidnapping then
            return false
        end
    end)

    function ENT:Initialize()
        self:SetModel("models/hunter/blocks/cube1x1x1.mdl")
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMaterial("models/monk/grigori_head")
        self:SetSolid(SOLID_VPHYSICS)
    
        self:SetTrigger(true)
        
        self:SetColor(Color(255, 50, 50, 255))
        
       
        self.MoveSpeed = 180         
        self.BaseChaseSpeed = 450   
        self.ChaseSpeed = 450       
        self.SpinSpeed = 500        

        
        self.TargetPlayer = nil 
        self.KidnapChair = nil
        self.IsKidnapping = false
        self.KidnapEndTime = 0

        
        self.ChaseStartTime = 0
        self.CurrentPhase = 1
        self.IsAlarmPlaying = false

        local phys = self:GetPhysicsObject()
        if IsValid(phys) then 
            phys:Wake() 
            phys:SetMass(150)
            phys:EnableGravity(true) 
        end

        self:StartMotionController()

        --IdleSounds = {}

        REP = math.random(2, 5)
        timer.Create("idleSoundPlay", REP, 0, function()
            if !IsValid(self) then timer.Stop("idelSoundPlay") end 
            self:EmitSound("npc/barnacle/barnacle_pull"..math.random(1, 4)..".wav")
        end)

    end

    function ENT:Touch(ent)
        if not IsValid(ent) or ent == self then return end
        if ent == self.KidnapChair then return end

        if ent == self.TargetPlayer then
            if ent:IsPlayer() then
                if not self.IsKidnapping then
                    self:KidnapVictim(ent)
                end
                return
            else
                self:EmitSound("physics/flesh/flesh_squishy_impact_hard" .. math.random(1, 4) .. ".wav", 85, math.random(70, 90))
                local effect = EffectData()
                effect:SetOrigin(ent:WorldSpaceCenter())
                util.Effect("BloodImpact", effect)
                
                ent:Remove()
                self:ReleaseVictim() 
                return
            end
        end

        local class = ent:GetClass()
        if ent:IsPlayer() or class == "worldspawn" or class == "soundent" or string.find(class, "logic_") or string.find(class, "trigger_") then
            return
        end

        self:EmitSound("physics/flesh/flesh_squishy_impact_hard" .. math.random(1, 4) .. ".wav", 75, math.random(90, 110))
        self:EmitSound("physics/cardboard/cardboard_box_break" .. math.random(1, 3) .. ".wav", 70, 85)

        local effect = EffectData()
        effect:SetOrigin(ent:GetPos())
        util.Effect("GlassImpact", effect)

        ent:Remove()
    end

    function ENT:OnTakeDamage(dmginfo)
        local attacker = dmginfo:GetAttacker()

        if IsValid(attacker) and (attacker:IsPlayer() or attacker:IsNPC() or attacker:IsNextBot()) and not self.IsKidnapping then
            if self.TargetPlayer ~= attacker then
                self.TargetPlayer = attacker
                self.ChaseStartTime = CurTime() 
                self.CurrentPhase = 1
                
                self:SetColor(Color(255, 0, 0, 255))
                self.SpinSpeed = 1400 
                self.ChaseSpeed = self.BaseChaseSpeed
                
                local phys = self:GetPhysicsObject()
                if IsValid(phys) then
                    phys:EnableGravity(false)
                end

                self:EmitSound("npc/scanner/scanner_alert1.wav", 85, 120)
                self:EmitSound("npc/fast_zombie/fz_scream1.wav" ,85, 80 ,2)
                
                self:EmitSound("ambient/machines/combine_shield_touch_loop1.wav", 75, 150)
                self.IsAlarmPlaying = true
            end
        end
    end

    function ENT:Think()
        local frameTime = FrameTime()

        if self.IsKidnapping and IsValid(self.TargetPlayer) then
            if CurTime() > self.KidnapEndTime or not self.TargetPlayer:Alive() then
                self:ReleaseVictim()
                return
            end
            
            self:NextThink(CurTime())
            return true
        end

        if IsValid(self.TargetPlayer) and not self.IsKidnapping then
        
            if not self.TargetPlayer:IsPlayer() and (self.TargetPlayer:Health() <= 0 or not IsValid(self.TargetPlayer)) then
                self:ReleaseVictim()
                return
            end

            local myPos = self:GetPos()
            local playerPos = self.TargetPlayer:WorldSpaceCenter() 
            local timeElapsed = CurTime() - self.ChaseStartTime

            
            if timeElapsed >= 10 and timeElapsed < 20 and self.CurrentPhase < 2 then
                self.CurrentPhase = 2
                self.ChaseSpeed = 650 
                self.SpinSpeed = 2000
                self:SetColor(Color(140, 0, 0, 255)) 
                self:EmitSound("npc/scanner/scanner_siren1.wav", 85, 115)

            elseif timeElapsed >= 20 and self.CurrentPhase < 3 then
                self.CurrentPhase = 3
                self.ChaseSpeed = 900 
                self.SpinSpeed = 3000
                self:SetColor(Color(15, 15, 15, 255)) 
                self:EmitSound("npc/zombie_scrim/zombie_scream1.wav", 95, 140)
            end

            local travelDirection = (playerPos - myPos):GetNormalized()
            local nextPosition = myPos + (travelDirection * self.ChaseSpeed * frameTime)

            self:SetPos(nextPosition)

            local phys = self:GetPhysicsObject()
            if IsValid(phys) then 
                phys:Wake() 
                phys:SetVelocity(Vector(0,0,0)) 
            end

            self:NextThink(CurTime())
            return true
        end
    end

    function ENT:PhysicsSimulate(phys, deltatime)
        phys:Wake()

        local angularVelocity = Vector(0, 0, self.SpinSpeed)

        if IsValid(self.TargetPlayer) then 
            return angularVelocity, Vector(0, 0, 0), SIM_GLOBAL_ACCELERATION 
        end

        if not self.NextWanderTime or CurTime() > self.NextWanderTime then
            self.WanderDirection = Vector(math.random(-1, 1), math.random(-1, 1), 0):GetNormalized()
            self.NextWanderTime = CurTime() + math.random(2.0, 4.0)
        end

        local currentVel = phys:GetVelocity()
        local targetVel = (self.WanderDirection * self.MoveSpeed) + Vector(0, 0, currentVel.z)
        local forceVector = (targetVel - currentVel) * 5 

        return angularVelocity, forceVector, SIM_GLOBAL_ACCELERATION
    end

    function ENT:KidnapVictim(ply)
        if self.IsKidnapping then return end

        self.IsKidnapping = true
        self.KidnapEndTime = CurTime() + 10 

        local chair = ents.Create("prop_vehicle_prisoner_pod")
        chair:SetModel("models/nova/chair_office02.mdl") 
        chair:SetKeyValue("vehiclescript", "scripts/vehicles/prisoner_pod.txt")
        chair:SetPos(self:GetPos()) 
        chair:SetAngles(self:GetAngles())
        chair:Spawn()
        chair:Activate()

        chair:SetRenderMode(RENDERMODE_TRANSALPHA)
        chair:SetColor(Color(0, 0, 0, 0))
        chair:SetSolid(SOLID_NONE)
        
        chair:SetParent(self)
        self.KidnapChair = chair

        ply:EnterVehicle(chair)

        ply:EmitSound("ambient/energy/zap9.wav", 80, 100)
        self:EmitSound("npc/attack_helicopter/helicopter_advertise_start1.wav", 90, 100)
        self:StopSound("ambient/machines/combine_shield_touch_loop1.wav")

        local phys = self:GetPhysicsObject()
        if IsValid(phys) then
            phys:EnableGravity(true) 
            phys:SetVelocity(Vector(math.random(-300, 300), math.random(-300, 300), math.random(-100, 100)))
        end


    end

    function ENT:ReleaseVictim()
        self.IsKidnapping = false
        
        if IsValid(self.TargetPlayer) and self.TargetPlayer:IsPlayer() then
            self.TargetPlayer:ExitVehicle()
            self.TargetPlayer:EmitSound("ambient/energy/spark6.wav", 75, 100)
        end

        if IsValid(self.KidnapChair) then
            self.KidnapChair:Remove()
        end

        if self.IsAlarmPlaying then
            self:StopSound("ambient/machines/combine_shield_touch_loop1.wav")
            self.IsAlarmPlaying = false
        end

        local phys = self:GetPhysicsObject()
        if IsValid(phys) then
            phys:EnableGravity(true)
        end

        self.TargetPlayer = nil
        self.SpinSpeed = 500
        self.ChaseSpeed = self.BaseChaseSpeed
        self.CurrentPhase = 1
        self:SetColor(Color(255, 50, 50, 255))
        self:EmitSound("npc/scanner/scanner_nearmiss2.wav", 75, 90)
    end

    function ENT:OnRemove()
        if IsValid(self.KidnapChair) then
            self.KidnapChair:Remove()
        end
        
        self:StopSound("ambient/machines/combine_shield_touch_loop1.wav")
    end
end

if CLIENT then
    function ENT:Draw()
        self:DrawModel()
        
        local size = 35 + math.sin(CurTime() * 12) * 6
        local serverColor = self:GetColor()
        local glowColor = Color(255, 0, 100, 220)

        local lightRadius = 150
        local lightBrightness = 1

        if serverColor.r <= 20 and serverColor.g <= 20 then
            size = 55 + math.sin(CurTime() * 30) * 12
            glowColor = Color(255, 0, 0, 255) 
            lightRadius = 500
            lightBrightness = 6 + (math.sin(CurTime() * 25) * 2)
        elseif serverColor.r < 200 then
            size = 45 + math.sin(CurTime() * 18) * 6
            glowColor = Color(180, 0, 0, 255)
            lightRadius = 350
            lightBrightness = 4
        elseif serverColor.g == 0 then
            glowColor = Color(255, 0, 0, 255)
            lightRadius = 220
            lightBrightness = 2.5
        end

        render.SetMaterial(Material("sprites/glow04_noz_gmod"))
        render.DrawSprite(self:GetPos() + Vector(0, 0, 2), size, size, glowColor)

        local dlight = DynamicLight(self:EntIndex(), false)
        if dlight then
            dlight.pos = self:GetPos()
            dlight.r = 255
            dlight.g = 0
            dlight.b = 0
            dlight.brightness = lightBrightness
            dlight.decay = lightRadius * 5
            dlight.size = lightRadius
            dlight.dieTime = CurTime() + 0.1
        end
    end
end