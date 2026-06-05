AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Random entitynpc generator"
ENT.Author = "Lenny"
ENT.Category = "Fluffy's gamemode"
ENT.Spawnable = true
ENT.AdminOnly = false

if SERVER then
    -------------------------------------------------------------------------
    -- INTERNAL BACKEND REGISTER PARSER (Gathers Everything)
    -------------------------------------------------------------------------
    local GeneratorBackupList = {}

    local function PopulateGeneratorPool()
        GeneratorBackupList = {}

        -- Fetch the master blacklist if it exists globally, otherwise keep a safety fallback check
        -- (This ensures logic, triggers, and soundscapes never spawn out of the generator)
        local blocklist = QuestBlacklist or {}

        -- 1. Grab all Scripted Entities (SENTS)
        for class, _ in pairs(scripted_ents.GetList()) do
            if class ~= "base_anim" and class ~= "base_gmodentity" and class ~= "base_ai" and not blocklist[class] and not string.find(class, "logic_") and not string.find(class, "trigger_") then
                table.insert(GeneratorBackupList, { type = "entity", class = class })
            end
        end

        -- 2. Grab Sandbox Spawnable Entities
        local spawnableEntities = list.Get("SpawnableEntities")
        if spawnableEntities then
            for class, _ in pairs(spawnableEntities) do
                if not blocklist[class] then
                    table.insert(GeneratorBackupList, { type = "entity", class = class })
                end
            end
        end

        -- 3. Grab ALL Spawnable NPCs
        local npcList = list.Get("NPC")
        if npcList then
            for class, info in pairs(npcList) do
                if not blocklist[class] then
                    table.insert(GeneratorBackupList, { type = "npc", class = class, model = info.Model })
                end
            end
        end

        -- 4. Grab All Vehicles
        local vehicleList = list.Get("Vehicles")
        if vehicleList then
            for class, info in pairs(vehicleList) do
                if not blocklist[class] then
                    table.insert(GeneratorBackupList, { type = "vehicle", class = class, model = info.Model, keyvalues = info.KeyValues })
                end
            end
        end
    end

    -- Run the scraper right as the map setups load
    hook.Add("Initialize", "FLGM_GeneratorPoolInit", function()
        PopulateGeneratorPool()
    end)

    -------------------------------------------------------------------------
    -- INITIALIZE ENTITY
    -------------------------------------------------------------------------
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
        self.CooldownDuration = 300 -- 5 minutes
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

        -- Check shared master list first, fall back to our local generator registry if empty
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
        
        -- Safe spacing: Give a higher offset to accommodate massive entities/NPCs spawning
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