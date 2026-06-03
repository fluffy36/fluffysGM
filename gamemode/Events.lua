local EventStart = false
local flgm_PropSpawnRate = CreateConVar("flgm_PropSpawnRate", 4, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Sets prop spawn rate of props in the air")
local TimerStart = false

concommand.Add("flgm_restart_events", function(ply)
    hook.Run("PlayerInitialSpawn", ply)
end)

concommand.Add("flgm_find_sun", function(ply)
    local sun = ents.FindByClass("env_sun")
    sun[1]:Fire("LightOn")
end)

hook.Add("PlayerInitialSpawn", "KillFirstJoinOnce", function(Ply)
    if EventStart then return end
    EventStart = true
    
    local sun = ents.FindByClass("sun_light")
    


    local owner = Ply

    local Models = {}
    local Ents = {}

    -- 1. Scrape every registered SENT (Scripted Entity) b
    for class, _ in pairs(scripted_ents.GetList()) do
        if class ~= "base_anim" and class ~= "base_gmodentity" and class ~= "base_ai" then
            table.insert(Ents, { type = "entity", class = class })
        end
    end

    -- 2. Scrape Sandbox Spawnlists (Entities, NPCs, Vehicles, Weapons)
    local spawnableEntities = list.Get("SpawnableEntities")
    if spawnableEntities then
        for class, info in pairs(spawnableEntities) do
            table.insert(Ents, { type = "entity", class = class })
        end
    end

    local npcList = list.Get("NPC")
    if npcList then
        for class, info in pairs(npcList) do
            table.insert(Ents, { type = "npc", class = class, model = info.Model })
        end
    end

    local vehicleList = list.Get("Vehicles")
    if vehicleList then
        for class, info in pairs(vehicleList) do
            table.insert(Ents, { type = "vehicle", class = class, model = info.Model, keyvalues = info.KeyValues })
        end
    end

    local weaponList = weapons.GetList()
    if weaponList then
        for _, swep in pairs(weaponList) do
            if swep.ClassName then
                table.insert(Ents, { type = "weapon", class = swep.ClassName })
            end
        end
    end

    -- 3. Extract models from the visual spawnlists to mix with your base props
    local spawnLists = list.Get("SpawnmenuContent")
    if spawnLists then
        for _, content in pairs(spawnLists) do
            if content.model then
                table.insert(Models, content.model)
            end
        end
    end

    -- fallback legacy defaults in case table scraping triggers ahead of early frames
    table.insert(Ents, { type = "npc", class = "npc_helicopter" })
    table.insert(Ents, { type = "entity", class = "gmod_light" })

    -- Fallback safety array for pure physics debris loops
    local BasePropsFallback = {
        "models/props_c17/oildrum001_explosive.mdl", "models/props_c17/concrete_barrier001a.mdl",
        "models/props_vehicles/car001a_hatchback.mdl", "models/props_junk/watermelon01.mdl",
        "models/props_c17/furniturecouch001a.mdl", "models/props_vehicles/apc001.mdl"
    }

    -- Merge scraped models with fallback array
    for _, fallbackModel in ipairs(BasePropsFallback) do
        table.insert(Models, fallbackModel)
    end

    local PropSpawnRate = 10
    concommand.Add("flgm_PropSpawnRate", function(ply)
        
    end)

    timer.Simple(10, function()
        for i,v in pairs(player.GetAll()) do
            v:Kill()
        end
    end)

    timer.Create("PropSpawn", PropSpawnRate, 0, function()
        if !TimerStart then 
            print("############################\n### (Fluffy's gamemode)  ###\n###   Events started!    ###\n###                      ###\n############################")
            TimerStart = true
        end
        


        PropSpawnRate = flgm_PropSpawnRate:GetFloat()

        local Nav = navmesh.GetNearestNavArea(owner:GetPos(), false, 10000, true, true)
        --print(Nav)
        if IsValid(Nav) or Nav ~= nil then
            local RandInt = math.random(1, 4)
            if RandInt == 1 then
                local RandPoint = Nav:GetRandomPoint()
                local model = Models[math.random(1, table.Count(Models))]
                --print(model)

                local prop = ents.Create("prop_physics")
                prop:SetModel(model)
                prop:SetPos(RandPoint+Vector(0,0,2000))
                prop:Spawn()
            elseif RandInt == 2 then
                local RandPoint = Nav:GetRandomPoint()
                local ent = Ents[math.random(1, table.Count(Ents))]
                print(ent)

                if ent == "prop_vehicle_airboat" then
                    local prop = ents.Create("prop_vehicle_airboat")
                    prop:SetModel("models/airboat.mdl")
                    prop:SetPos(RandPoint+Vector(0,0,20))
                    prop:Spawn()
                elseif ent == "prop_vehicle_prisoner_pod" then
                    local prop = ents.Create("prop_vehicle_prisoner_pod")
                    prop:SetModel("models/vehicles/prisoner_pod.mdl")
                    prop:SetPos(RandPoint+Vector(0,0,20))
                    prop:Spawn()
                elseif ent == "flgm_corruptedprop" then
                    local prop = ents.Create("flgm_corruptedprop")
                    prop:SetModel("models/vehicles/prisoner_pod.mdl")
                    prop:SetPos(RandPoint+Vector(0,0,20))
                    prop:Spawn()
                elseif ent == "npc_helicopter" then
                    local prop = ents.Create("npc_helicopter")
                    prop:SetPos(RandPoint+Vector(0,0,2000))
                    prop:Spawn()
                    prop:Activate()
                else
                    local prop = ents.Create(ent)
                    prop:SetPos(RandPoint+Vector(0,0,20))
                    prop:Spawn()
                end
            end
            
        else
            print("let us in...")
        end
    end)

end)

hook.Add("ShutDown", "ServerStop", function()
    EventStart = false
end)