if SERVER then
    AddCSLuaFile()

    FLGM_ActiveQuest = {
        Active = false,
        TargetEnt = nil,
        TargetName = "None",
        CorruptedDeleted = 0,
        CurrentPlayer = nil
    }

    local DynamicRewardsList = {}

    local function ScrapeRewardRegistry()
        DynamicRewardsList = {}
        
        for class, _ in pairs(scripted_ents.GetList()) do
            if class ~= "base_anim" and class ~= "base_gmodentity" and class ~= "base_ai" then
                table.insert(DynamicRewardsList, { type = "entity", class = class })
            end
        end

        local spawnableEntities = list.Get("SpawnableEntities")
        if spawnableEntities then
            for class, _ in pairs(spawnableEntities) do
                table.insert(DynamicRewardsList, { type = "entity", class = class })
            end
        end

        local npcList = list.Get("NPC")
        if npcList then
            for class, info in pairs(npcList) do
                table.insert(DynamicRewardsList, { type = "npc", class = class, model = info.Model })
            end
        end

        local vehicleList = list.Get("Vehicles")
        if vehicleList then
            for class, info in pairs(vehicleList) do
                table.insert(DynamicRewardsList, { type = "vehicle", class = class, model = info.Model, keyvalues = info.KeyValues })
            end
        end
    end

    hook.Add("Initialize", "FLGM_ScrapeOnLoad", function()
        ScrapeRewardRegistry()
    end)

    local function StartRandomQuest(ply)
        if #DynamicRewardsList == 0 then ScrapeRewardRegistry() end

        local allMapEntities = ents.GetAll()
        local validTargets = {}

        ---------------------------------------------------------
        -- STRICT EVENT FILTER MATRIX
        ---------------------------------------------------------
        for _, ent in ipairs(allMapEntities) do
            -- Tracks down anything tagged as a falling sky entity from events.lua
            if IsValid(ent) and ent.IsEventsLuaProp == true then
                table.insert(validTargets, ent)
            end
        end

        -- Handle sky timing delays safely
        if #validTargets == 0 then
            ply:ChatPrint("[Quest Engine] No custom props found on the map yet! Wait for the sky events to drop objects...")
            -- Roll back counters so they can try click-triggering again instantly
            FLGM_ActiveQuest.CorruptedDeleted = 9 
            return
        end

        local chosenTarget = validTargets[math.random(1, #validTargets)]
        
        FLGM_ActiveQuest.Active = true
        FLGM_ActiveQuest.TargetEnt = chosenTarget
        FLGM_ActiveQuest.CurrentPlayer = ply
        
        -- FIX: Handle fallback text names smoothly if the entity dropped doesn't use a standard .mdl file string (like weapons/SENTs)
        local displayIdent = "Unknown Object"
        local rawModel = chosenTarget:GetModel()

        if rawModel and rawModel ~= "" then
            displayIdent = string.match(rawModel, ".*/(.*)%.mdl") or rawModel
        else
            displayIdent = chosenTarget:GetClass() -- Fall back to class name (e.g., weapon_muzzle) if model data is hidden
        end

        FLGM_ActiveQuest.TargetName = displayIdent

        ---------------------------------------------------------
        -- VISUAL RED ALERT INDICATOR
        ---------------------------------------------------------
        -- Tint the selected prop bright solid red so it stands out immediately
        chosenTarget:SetColor(Color(255, 0, 0, 255))
        chosenTarget:SetRenderMode(RENDERMODE_TRANSCOLOR) -- Ensures transparency/color channels process cleanly

        ply:PrintMessage(HUD_PRINTTALK, "========================================")
        ply:PrintMessage(HUD_PRINTTALK, "[QUEST STARTED] A sky prop has been corrupted!")
        ply:PrintMessage(HUD_PRINTTALK, "TARGET OBJECT: " .. displayIdent .. " (Look for the one flashing RED!)")
        ply:PrintMessage(HUD_PRINTTALK, "EQUIP: Use your flgm_tool to expunge it!")
        ply:PrintMessage(HUD_PRINTTALK, "========================================")
        
        chosenTarget:EmitSound("ambient/machines/thumper_top.wav", 80, 130)
    end

    local function CompleteQuest(ply)
        ply:PrintMessage(HUD_PRINTTALK, "========================================")
        ply:PrintMessage(HUD_PRINTTALK, "[QUEST COMPLETE] Target successfully deleted!")
        
        local rewardData = DynamicRewardsList[math.random(1, #DynamicRewardsList)]
        
        if rewardData then
            ply:PrintMessage(HUD_PRINTTALK, "REWARD EARNED: " .. rewardData.class .. " has been delivered!")
            
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

        FLGM_ActiveQuest.Active = false
        FLGM_ActiveQuest.TargetEnt = nil
        FLGM_ActiveQuest.TargetName = "None"
        FLGM_ActiveQuest.CorruptedDeleted = 0
        FLGM_ActiveQuest.CurrentPlayer = nil
    end

    hook.Add("EntityRemoved", "FLGM_QuestDeletionTracker", function(ent)
        if FLGM_ActiveQuest.Active and IsValid(FLGM_ActiveQuest.TargetEnt) and ent == FLGM_ActiveQuest.TargetEnt then
            local ply = FLGM_ActiveQuest.CurrentPlayer
            if IsValid(ply) then
                CompleteQuest(ply)
            end
            return
        end

        if ent:GetClass() == "flgm_corruptedprop" then
            for _, ply in ipairs(player.GetAll()) do
                local activeWep = ply:GetActiveWeapon()
                if IsValid(activeWep) and activeWep:GetClass() == "flgm_tool" then
                    
                    if FLGM_ActiveQuest.Active then
                        ply:ChatPrint("[Quest Engine] ERROR: Complete your current tracking objective first! Target: " .. FLGM_ActiveQuest.TargetName)
                        return 
                    end

                    FLGM_ActiveQuest.CorruptedDeleted = FLGM_ActiveQuest.CorruptedDeleted + 1
                    local remaining = 10 - FLGM_ActiveQuest.CorruptedDeleted

                    if remaining > 0 then
                        ply:ChatPrint("[Quest Engine] Corrupted entity neutralized. (" .. FLGM_ActiveQuest.CorruptedDeleted .. "/10) Destroy " .. remaining .. " more.")
                    else
                        ply:ChatPrint("[Quest Engine] Objective calculated. Finding a falling sky prop...")
                        StartRandomQuest(ply)
                    end
                    break
                end
            end
        end
    end)
end

if CLIENT then
    hook.Add("HUDPaint", "FLGM_QuestStatusDisplay", function()
        if FLGM_ActiveQuest and FLGM_ActiveQuest.Active then
            draw.RoundedBox(4, 20, 20, 320, 65, Color(0, 0, 0, 180))
            draw.SimpleText("CURRENT OBJECTIVE:", "DermaDefaultBold", 30, 25, Color(255, 60, 60, 255))
            draw.SimpleText("Find & Remove: " .. FLGM_ActiveQuest.TargetName, "DermaDefault", 30, 45, Color(255, 255, 255, 255))
            draw.SimpleText("Status: Selected model turned RED", "DermaDefault", 30, 65, Color(200, 200, 200, 255))
        end
    end)
end