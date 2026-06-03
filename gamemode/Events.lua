local EventStart = false
local flgm_PropSpawnRate = CreateConVar("flgm_PropSpawnRate", 4, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Sets prop spawn rate of items in the air")
local TimerStart = false

concommand.Add("flgm_restart_events", function(ply)
    hook.Run("PlayerInitialSpawn", ply)
end)

concommand.Add("flgm_find_sun", function(ply)
    local sun = ents.FindByClass("env_sun")
    if IsValid(sun[1]) then
        sun[1]:Fire("LightOn")
    end
end)

hook.Add("PlayerInitialSpawn", "KillFirstJoinOnce", function(Ply)
    if EventStart then return end
    EventStart = true
    
    local owner = Ply

    
    local Models = {}
    local Ents = {}

    -- 1. Scrape every registered SENT (Scripted Entity)
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

    timer.Simple(10, function()
        for _, v in pairs(player.GetAll()) do
            v:Kill()
        end
    end)

    timer.Create("PropSpawn", PropSpawnRate, 0, function()
        if not TimerStart then 
            print("############################\n### (Fluffy's gamemode)  ###\n###   Events started!    ###\n###                      ###\n############################")
            TimerStart = true
        end

        PropSpawnRate = flgm_PropSpawnRate:GetFloat()

        if not IsValid(owner) then return end
        local Nav = navmesh.GetNearestNavArea(owner:GetPos(), false, 10000, true, true)
        
        if IsValid(Nav) then
            local RandInt = math.random(1, 2)
            local RandPoint = Nav:GetRandomPoint()
            
            -- ACTION 1: Spawn a Random Model/Prop from the client spawnlists
            if RandInt == 1 then
                local chosenModel = Models[math.random(1, #Models)]
                local prop = ents.Create("prop_physics")
                if IsValid(prop) then
                    prop:SetModel(chosenModel)
                    prop:SetPos(RandPoint + Vector(0, 0, 2000)) -- Drop from the sky
                    prop:Spawn()
                end
                
            -- ACTION 2: Spawn a Spawner Registry Class Item (NPC, SENT, Weapon, Vehicle)
            elseif RandInt == 2 then
                local spawnData = Ents[math.random(1, #Ents)]
                if not spawnData then return end

                print("Spawning Global Chaos Object: " .. spawnData.class)

                local spawnClass = spawnData.class
                local objType = spawnData.type
                local item

                if objType == "npc" then
                    item = ents.Create(spawnClass)
                    if IsValid(item) then
                        item:SetPos(RandPoint + Vector(0, 0, 40))
                        item:Spawn()
                        -- Give flyers a massive vertical boost
                        if spawnClass == "npc_helicopter" or spawnClass == "npc_combinegunship" then
                            item:SetPos(RandPoint + Vector(0, 0, 1800))
                        end
                    end

                elseif objType == "vehicle" then
                    -- Detect if it's a structural airboat style or wheeled platform
                    item = ents.Create(spawnClass)
                    if IsValid(item) then
                        if spawnData.model then item:SetModel(spawnData.model) end
                        if spawnData.keyvalues then
                            for k, v in pairs(spawnData.keyvalues) do
                                item:SetKeyValue(k, v)
                            end
                        end
                        item:SetPos(RandPoint + Vector(0, 0, 100))
                        item:Spawn()
                        item:Activate()
                    end

                elseif objType == "weapon" then
                    -- Drop actual standalone grabable weapon scripts out of the sky
                    item = ents.Create(spawnClass)
                    if IsValid(item) then
                        item:SetPos(RandPoint + Vector(0, 0, 1500))
                        item:Spawn()
                    end

                else -- Default dynamic handling for typical SENTS/Entities
                    item = ents.Create(spawnClass)
                    if IsValid(item) then
                        if spawnData.model then item:SetModel(spawnData.model) end
                        item:SetPos(RandPoint + Vector(0, 0, 500))
                        item:Spawn()
                    end
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