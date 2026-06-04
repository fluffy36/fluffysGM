if SERVER then
    AddCSLuaFile()

    -- Global Quest State Tracker
    FLGM_ActiveQuest = {
        Active = false,
        TargetEnt = nil,
        TargetName = "None",
        CorruptedDeleted = 0,
        CurrentPlayer = nil
    }

    ---------------------------------------------------------
    -- AUTOMATED GLOBAL SPAWNMENU REGISTRY SCRAPER (No Props)
    ---------------------------------------------------------
    local DynamicRewardsList = {}

    local function ScrapeRewardRegistry()
        DynamicRewardsList = {} -- Reset

        -- 1. Grab all Scripted Entities (SENTS)
        for class, _ in pairs(scripted_ents.GetList()) do
            if class ~= "base_anim" and class ~= "base_gmodentity" and class ~= "base_ai" then
                table.insert(DynamicRewardsList, { type = "entity", class = class })
            end
        end

        -- 2. Grab Sandbox Entities List
        local spawnableEntities = list.Get("SpawnableEntities")
        if spawnableEntities then
            for class, _ in pairs(spawnableEntities) do
                table.insert(DynamicRewardsList, { type = "entity", class = class })
            end
        end

        -- 3. Grab NPCs
        local npcList = list.Get("NPC")
        if npcList then
            for class, info in pairs(npcList) do
                table.insert(DynamicRewardsList, { type = "npc", class = class, model = info.Model })
            end
        end

        -- 4. Grab Vehicles
        local vehicleList = list.Get("Vehicles")
        if vehicleList then
            for class, info in pairs(vehicleList) do
                table.insert(DynamicRewardsList, { type = "vehicle", class = class, model = info.Model, keyvalues = info.KeyValues })
            end
        end

        -- Fallback defaults if tables aren't fully populated on instant frame load
        if #DynamicRewardsList == 0 then
            table.insert(DynamicRewardsList, { type = "npc", class = "npc_helicopter" })
            table.insert(DynamicRewardsList, { type = "entity", class = "gmod_light" })
        end
    end

    -- Run the scraper once components initialize
    hook.Add("Initialize", "FLGM_ScrapeOnLoad", function()
        ScrapeRewardRegistry()
    end)

    ---------------------------------------------------------
    -- QUEST LOGIC CONTROLLER
    ---------------------------------------------------------
    local function StartRandomQuest(ply)
        if #DynamicRewardsList == 0 then ScrapeRewardRegistry() end

        -- Gather every single physical entity, npc, or prop currently alive in the world
        local allMapEntities = ents.GetAll()
        local validTargets = {}

        for _, ent in ipairs(allMapEntities) do
            -- Filter out world geometry, players, and the quest-starting props themselves
            if IsValid(ent) and not ent:IsPlayer() and ent:GetClass() ~= "worldspawn" and ent:GetClass() ~= "flgm_corruptedprop" then
                table.insert(validTargets, ent)
            end
        end

        -- Safety fallback: if the map is completely empty, spawn a random object into the sky to hunt
        if #validTargets == 0 then
            ply:ChatPrint("[Quest Engine] The map is empty! Spawning a target entity automatically...")
            return
        end

        -- Pick a completely random target entity from the map
        local chosenTarget = validTargets[math.random(1, #validTargets)]
        
        FLGM_ActiveQuest.Active = true
        FLGM_ActiveQuest.TargetEnt = chosenTarget
        FLGM_ActiveQuest.CurrentPlayer = ply
        
        -- Clean up print names for the chat prompt
        local readableName = chosenTarget.PrintName or chosenTarget:GetClass()
        FLGM_ActiveQuest.TargetName = readableName

        -- Notify the target player
        ply:PrintMessage(HUD_PRINTTALK, "========================================")
        ply:PrintMessage(HUD_PRINTTALK, "[QUEST STARTED] Find and eliminate the glitched target!")
        ply:PrintMessage(HUD_PRINTTALK, "TARGET OBJECT: " .. readableName .. " (ID: #" .. chosenTarget:EntIndex() .. ")")
        ply:PrintMessage(HUD_PRINTTALK, "EQUIP: Use your flgm_tool to delete it!")
        ply:PrintMessage(HUD_PRINTTALK, "========================================")
        
        -- Halo or spark highlight the target entity briefly so the player knows where it dropped
        chosenTarget:EmitSound("ambient/machines/thumper_top.wav", 80, 130)
    end

    local function CompleteQuest(ply)
        ply:PrintMessage(HUD_PRINTTALK, "========================================")
        ply:PrintMessage(HUD_PRINTTALK, "[QUEST COMPLETE] Target successfully expunged from memory!")
        
        -- Pick a random dynamic reward (strictly NPCs or SENTS, no pure prop models)
        local rewardData = DynamicRewardsList[math.random(1, #DynamicRewardsList)]
        
        if rewardData then
            ply:PrintMessage(HUD_PRINTTALK, "REWARD EARNED: A custom " .. rewardData.class .. " has been granted!")
            
            -- Spawn the reward right above the winning player's head
            local spawnPos = ply:GetPos() + Vector(0, 0, 150)
            local rewardEnt = ents.Create(rewardData.class)
            
            if IsValid(rewardEnt) then
                rewardEnt:SetPos(spawnPos)
                if rewardData.model then rewardEnt:SetModel(rewardData.model) end
                if rewardData.keyvalues then
                    for k, v in pairs(rewardData.keyvalues) do
                        rewardEnt:SetKeyValue(k, v)
                    end
                end
                rewardEnt:Spawn()
                rewardEnt:Activate()
            end
        end
        ply:PrintMessage(HUD_PRINTTALK, "========================================")

        -- Reset states completely so the player can restart it by mining corrupted props again
        FLGM_ActiveQuest.Active = false
        FLGM_ActiveQuest.TargetEnt = nil
        FLGM_ActiveQuest.TargetName = "None"
        FLGM_ActiveQuest.CorruptedDeleted = 0
        FLGM_ActiveQuest.CurrentPlayer = nil
    end

    ---------------------------------------------------------
    -- ENGINE TOOL DETECTION INTERCEPTORS
    ---------------------------------------------------------
    -- This hook catches whenever an entity is deleted on the server
    hook.Add("EntityRemoved", "FLGM_QuestDeletionTracker", function(ent)
        -- 1. TRACK THE TARGET HUNT DETECTION:
        if FLGM_ActiveQuest.Active and IsValid(FLGM_ActiveQuest.TargetEnt) and ent == FLGM_ActiveQuest.TargetEnt then
            local ply = FLGM_ActiveQuest.CurrentPlayer
            if IsValid(ply) then
                CompleteQuest(ply)
            end
            return
        end

        -- 2. TRACK CORRUPTED PROP MINING TO UNLOCK THE QUEST:
        if ent:GetClass() == "flgm_corruptedprop" then
            -- Find the player holding your custom tool gun
            for _, ply in ipairs(player.GetAll()) do
                local activeWep = ply:GetActiveWeapon()
                if IsValid(activeWep) and activeWep:GetClass() == "flgm_tool" then
                    
                    ---------------------------------------------------------
                    -- INTERCEPT: ACTIVE QUEST BLOCKER
                    ---------------------------------------------------------
                    -- If a quest is already active, refuse to count or progress toward a new one
                    if FLGM_ActiveQuest.Active then
                        ply:ChatPrint("[Quest Engine] ERROR: You must complete the current quest first! Target: " .. FLGM_ActiveQuest.TargetName)
                        return 
                    end

                    FLGM_ActiveQuest.CorruptedDeleted = FLGM_ActiveQuest.CorruptedDeleted + 1
                    local remaining = 10 - FLGM_ActiveQuest.CorruptedDeleted

                    if remaining > 0 then
                        ply:ChatPrint("[Quest Engine] Corrupted entity neutralized. (" .. FLGM_ActiveQuest.CorruptedDeleted .. "/10) Destroy " .. remaining .. " more to activate quest.")
                    else
                        ply:ChatPrint("[Quest Engine] Critical threshold met! Initializing world tracking matrix...")
                        StartRandomQuest(ply)
                    end
                    break
                end
            end
        end
    end)
end

---------------------------------------------------------
-- OPTIONAL HUD SYNC DISPLAY (Client-Side)
---------------------------------------------------------
if CLIENT then
    hook.Add("HUDPaint", "FLGM_QuestStatusDisplay", function()
        if FLGM_ActiveQuest and FLGM_ActiveQuest.Active then
            draw.RoundedBox(4, 20, 20, 300, 65, Color(0, 0, 0, 180))
            draw.SimpleText("CURRENT OBJECTIVE:", "DermaDefaultBold", 30, 25, Color(255, 60, 60, 255))
            draw.SimpleText("Find & Remove: " .. FLGM_ActiveQuest.TargetName, "DermaDefault", 30, 45, Color(255, 255, 255, 255))
            draw.SimpleText("Weapon Required: flgm_tool", "DermaDefault", 30, 65, Color(200, 200, 200, 255))
        end
    end)
end