AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "Giant Barnacle"
ENT.Category = "NPCs"
ENT.Spawnable = true

function ENT:Initialize()
    if CLIENT then return end

    self:SetModel("models/barnacle.mdl")
    self:SetModelScale(5, 0)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:EnableMotion(false)
    end

    self.Pulling = false
    self.Digesting = false
    self.Captured = nil

    self:ResetSequence("idle01")

    print("[Barnacle] Ready for feeding.")
end

function ENT:CreateCaptureSeat(pos)
    local seat = ents.Create("prop_vehicle_prisoner_pod")

    if not IsValid(seat) then return end

    seat:SetModel("models/vehicles/prisoner_pod_inner.mdl")
    seat:SetPos(pos)
    seat:SetAngles(angle_zero)

    seat:SetKeyValue("vehiclescript", "scripts/vehicles/prisoner_pod.txt")

    seat:Spawn()
    seat:Activate()

    seat:SetNoDraw(true)
    seat:SetColor(Color(255,255,255,0))
    seat:SetRenderMode(RENDERMODE_TRANSALPHA)

    local phys = seat:GetPhysicsObject()
    if IsValid(phys) then
        phys:EnableMotion(false)
    end

    self.Seat = seat
end

function ENT:Think()
    if CLIENT then return end

    if not self.Pulling and not self.Digesting then
        self:SearchForVictim()
    end

    if self.Pulling then
        self:PullVictim()
    end

    self:NextThink(CurTime() + 0.05)
    return true
end

function ENT:SearchForVictim()
    for _, ply in ipairs(player.GetAll()) do
        if not IsValid(ply) then continue end
        if not ply:Alive() then continue end

        local barnPos = self:GetPos()

        local detectPos = Vector(
            barnPos.x,
            barnPos.y,
            ply:GetPos().z
        )

        local dist = ply:GetPos():Distance(detectPos)

        if dist < 50 then
            self:CapturePlayer(ply)
            break
        end
    end
end

function ENT:CapturePlayer(ply)
    if self.Captured == ply then return end

    self.Captured = ply

    local seatPos = Vector(
        self:GetPos().x,
        self:GetPos().y,
        ply:GetPos().z
    )

    self:CreateCaptureSeat(seatPos)

    if IsValid(self.Seat) then
        ply:EnterVehicle(self.Seat)
    end

    self.Pulling = true

    self:EmitSound("npc/barnacle/barnacle_tongue_pull1.wav")

    local seq = self:LookupSequence("attack1")
    if seq and seq > 0 then
        self:SetSequence(seq)
    end
end

function ENT:PullVictim()
    if not IsValid(self.Captured) then
        self:ResetBarnacle()
        return
    end

    if not self.Captured:Alive() then
        self:VictimDied()
        return
    end

    if not IsValid(self.Seat) then
        self:ResetBarnacle()
        return
    end

    local targetPos = self:GetPos() + Vector(0, 0, -40)

    local dir = (targetPos - self.Seat:GetPos()):GetNormalized()

    self.Seat:SetPos(self.Seat:GetPos() + dir * 10)

    if self.Seat:GetPos():Distance(self:GetPos()) < 60 then
        self.Pulling = false
        self.Digesting = true

        print(self.Captured:Nick() .. " has been caught!")

        self:StartDigesting()
    end
end

function ENT:StartDigesting()
    timer.Create(
        "BarnacleDigest_" .. self:EntIndex(),
        2,
        0,
        function()
            if not IsValid(self) then return end

            if not self.Digesting then return end

            if not IsValid(self.Captured) then
                self:ResetBarnacle()
                return
            end

            if not self.Captured:Alive() then
                self:VictimDied()
                return
            end

            local sounds = {
                "npc/barnacle/barnacle_digesting1.wav",
                "npc/barnacle/barnacle_digesting2.wav"
            }

            self:EmitSound(table.Random(sounds))

            local dmg = DamageInfo()
            dmg:SetDamage(100)
            dmg:SetAttacker(IsValid(self) and self or game.GetWorld())
            dmg:SetInflictor(self)

            self.Captured:TakeDamageInfo(dmg)
        end
    )
end

function ENT:VictimDied()
    self:EmitSound("npc/barnacle/barnacle_crunch2.wav")

    self.Pulling = false
    self.Digesting = false

    timer.Simple(4, function()
        if IsValid(self) then
            self:ResetBarnacle()
        end
    end)
end

function ENT:ResetBarnacle()
    timer.Remove("BarnacleDigest_" .. self:EntIndex())

    if IsValid(self.Seat) then
        self.Seat:Remove()
    end

    self.Seat = nil
    self.Captured = nil
    self.Pulling = false
    self.Digesting = false

    local seq = self:LookupSequence("idle01")
    if seq and seq > 0 then
        self:SetSequence(seq)
    end

    print("[Barnacle] Ready for another victim.")
end

function ENT:OnRemove()
    timer.Remove("BarnacleDigest_" .. self:EntIndex())

    if IsValid(self.Seat) then
        self.Seat:Remove()
    end
end