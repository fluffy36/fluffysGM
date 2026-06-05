AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Random entitynpc generator"
ENT.Author = "Lenny"
ENT.Category = "Fluffy's gamemode"
ENT.Spawnable = true
ENT.AdminOnly = false

if SERVER then
    local RespawnDelay = 600 
    local DropHeight = 1500  


    local GeneratorBackupList = {}

    local function PopulateGeneratorPool()
        GeneratorBackupList = {}

        
        local blocklist = QuestBlacklist or {}

       
        for class, _ in pairs(scripted_ents.GetList()) do
            if class ~= "base_anim" and class ~= "base_gmodentity" and class ~= "base_ai" and not blocklist[class] and not string.find(class, "logic_") and not string.find(class, "trigger_") then
                table.insert(GeneratorBackupList, { type = "entity", class = class })
            end
        end

        
        local spawnableEntities = list.Get("SpawnableEntities")
        if spawnableEntities then
            for class, _ in pairs(spawnableEntities) do
                if not blocklist[class] then
                    table.insert(GeneratorBackupList, { type = "entity", class = class })
                end
            end
        end

        
        local npcList = list.Get("NPC")
        if npcList then
            for class, info in pairs(npcList) do
                if not blocklist[class] then
                    table.insert(GeneratorBackupList, { type = "npc", class = class, model = info.Model })
                end
            end
        end

        local vehicleList = list.Get("Vehicles")
        if vehicleList then
            for class, info in pairs(vehicleList) do
                if not blocklist[class] then
                    table.insert(GeneratorBackupList, { type = "vehicle", class = class, model = info.Model, keyvalues = info.KeyValues })
                end
            end
        end
    end

    
    hook.Add("Initialize", "FLGM_GeneratorPoolInit", function()
        PopulateGeneratorPool()
    end)

    local function SpawnBarrelFromSky()
        local targetPos = Vector(0, 0, 0)
        local players = player.GetAll()
        
        if #players > 0 then
            local randomPly = players[math.random(1, #players)]
            if IsValid(randomPly) then
                targetPos = randomPly:GetPos() + Vector(math.random(-300, 300), math.random(-300, 300), DropHeight)
            end
        else
            targetPos = Vector(math.random(-500, 500), math.random(-500, 500), DropHeight)
        end

        local tr = util.TraceLine({
            start = targetPos,
            endpos = targetPos - Vector(0, 0, DropHeight),
            filter = function(ent) return ent:IsWorld() end
        })
        
        if tr.Hit then targetPos = tr.HitPos - Vector(0, 0, 50) end

        local barrel = ents.Create("flgm_Generator")
        if IsValid(barrel) then
            barrel:SetPos(targetPos)
            barrel:Spawn()
            barrel:Activate()

            barrel:EmitSound("ambient/machines/thumper_top.wav", 100, 90)
            for _, ply in ipairs(player.GetAll()) do
                ply:ChatPrint("mysterious generator is dropping from the sky")
            end
        end
    end

    hook.Add("Initialize", "FLGM_InitialGeneratorDrop", function()
        timer.Simple(RespawnDelay, function()
            SpawnBarrelFromSky()
        end)
    end)

    hook.Add("EntityRemoved", "FLGM_GeneratorRespawnTracker", function(ent)
        if ent:GetClass() == "flgm_Generator" and not ent.IsShuttingDown then
            timer.Simple(RespawnDelay, function()
                SpawnBarrelFromSky()
            end)
        end
    end)

    function ENT:Initialize()
        self:SetModel("models/props_junk/TrashDumpster02.mdl") 
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        
        if CLIENT then return end
        
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE) 

        local phys = self:GetPhysicsObject()
        if IsValid(phys) then
            phys:Wake()
            phys:SetMass(150) 
        end

        self.NextUseTime = 0
        self.CooldownDuration = 300 
    end

    function ENT:Use(activator, caller)
        if not IsValid(activator) or not activator:IsPlayer() then return end

        local curTime = CurTime()

        if curTime < self.NextUseTime then
            local timeLeft = math.ceil(self.NextUseTime - curTime)
            local minutes = math.floor(timeLeft / 60)
            local seconds = timeLeft % 60
            activator:ChatPrint(string.format("Generator delayed wait 5 minutes"))
            self:EmitSound("common/wpn_denyselect.wav", 70, 100)
            return
        end

        
        local rewardsPool = DynamicRewardsList
        if not rewardsPool or #rewardsPool == 0 then
            if #GeneratorBackupList == 0 then PopulateGeneratorPool() end
            rewardsPool = GeneratorBackupList
        end

        if #rewardsPool == 0 then
            activator:ChatPrint("error spawner registry is empty.")
            return
        end

        self.NextUseTime = curTime + self.CooldownDuration

        local choice = rewardsPool[math.random(1, #rewardsPool)]
        
        
        local spawnPos = self:GetPos() + Vector(0, 0, 75) 

        local spawnedEnt = ents.Create(choice.class)
        if IsValid(spawnedEnt) then
            spawnedEnt:SetPos(spawnPos)
            spawnedEnt:SetAngles(Angle(0, math.random(0, 360), 0))

            if choice.model then spawnedEnt:SetModel(choice.model) end
            
            if choice.keyvalues then
                for k, v in pairs(choice.keyvalues) do
                    spawnedEnt:SetKeyValue(k, v)
                end
            end

            spawnedEnt:Spawn()
            spawnedEnt:Activate()

            self:EmitSound("ambient/levels/citadel/weapon_disintegrate2.wav", 80, 120)
            
            local effect = EffectData()
            effect:SetOrigin(spawnPos)
            effect:SetScale(2)
            util.Effect("cball_explode", effect)

            activator:ChatPrint("Generated: " .. choice.class)
        else
            activator:ChatPrint("Generator: Failed to manifest entity format. Cooldown refunded.")
            self.NextUseTime = curTime 
        end
    end

    function ENT:OnRemove()
        self.IsShuttingDown = true
    end
end

if CLIENT then
    function ENT:Draw()
        self:DrawModel()

        if self:GetPos():DistToSqr(LocalPlayer():GetPos()) < 250000 then 
            local size = 30 + math.sin(CurTime() * 4) * 5
            render.SetMaterial(Material("sprites/glow04_gmod"))
            render.DrawSprite(self:GetPos() + Vector(0, 0, 20), size, size, Color(0, 128, 255, 150))
        end
    end
end