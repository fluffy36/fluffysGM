-- quest_system.lua
-- Tracks and manages corruption events, handles prop visual modifications, and updates quest states.

if SERVER then
    util.AddNetworkString("FLGM_UpdateQuestUI")

    -- Global Quest State Tracker
    FLGM_ActiveQuest = {
        Active = false,
        TargetEnt = nil,
        TargetName = "None",
        CorruptedDeleted = 0,
        CurrentPlayer = nil
    }

    ---------------------------------------------------------
    -- CORRUPTION MONITOR & VISUAL PATCHER
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

        -- Sync the global tracking metric cleanly
        _G.CorruptedPropsAmount = currentEventCount

        -- Broadcast status updates to all active clients for rendering/UI elements
        net.Start("FLGM_UpdateQuestUI")
            net.WriteInt(currentEventCount, 16)
            net.WriteBool(QuestActive)
        net.Broadcast()
    end)

    ---------------------------------------------------------
    -- DESTRUCTION & PROGRESSION HOOK
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

        -- Verify if this was an explicit event item from events.lua
        if target.IsEventsLuaProp then
            local attacker = dmginfo:GetAttacker()

            -- Detect if the damage is fatal
            if (target:Health() > 0 and dmginfo:GetDamage() >= target:Health()) or (dmginfo:GetDamage() >= 100) or (target:GetPhysicsObject():GetMass() < 50 and dmginfo:IsDamageType(DMG_CRUSH)) then
                
                -- Guard against double-triggering before removal frame
                if target.AlreadyDestroyedByQuest then return end
                target.AlreadyDestroyedByQuest = true

                -- Trigger a subtle localized detonation effect to signal completion
                local effectData = EffectData()
                effectData:SetOrigin(target:WorldSpaceCenter())
                effectData:SetScale(1)
                util.Effect("vortigaunt_glow", effectData)
                util.Effect("cball_explode", effectData)

                -- Give the destroyer a notification if it was a valid player
                if IsValid(attacker) and attacker:IsPlayer() then
                    attacker:ChatPrint("[QUEST] You purged a corrupted anomaly object!")
                    -- Hook your economy/XP rewards framework right here if needed
                end

                -- Decrement tracker instantly to keep UI highly responsive
                _G.CorruptedPropsAmount = math.max(0, _G.CorruptedPropsAmount - 1)
            end
        end
    end)

    -- Clean up entries cleanly if they get deleted by cleanup commands or Garry's Mod core mechanics
    hook.Add("EntityRemoved", "FLGM_QuestEntityRemovedCleanup", function(ent)
        if ent.IsEventsLuaProp and not ent.AlreadyDestroyedByQuest then
            _G.CorruptedPropsAmount = math.max(0, _G.CorruptedPropsAmount - 1)
        end
    end)
end

---------------------------------------------------------
-- CLIENT SIDE INTERFACE MANAGEMENT
---------------------------------------------------------
if CLIENT then
    local localCorruptedCount = 0
    local displayQuestHUD = false

    net.Receive("FLGM_UpdateQuestUI", function()
        localCorruptedCount = net.ReadInt(16)
        displayQuestHUD = net.ReadBool()
    end)

    -- Simple modern screen paint loop to showcase active progression status
    hook.Add("HUDPaint", "FLGM_DrawQuestStatus", function()
        if not displayQuestHUD or localCorruptedCount <= 0 then return end

        local padding = 15
        local width, height = 240, 50
        local x = ScrW() - width - padding
        local y = padding + 120 -- Shifted downward slightly to clear default sandbox configurations

        -- Background track container box panel
        draw.RoundedBox(6, x, y, width, height, Color(20, 20, 20, 180))
        draw.RoundedBox(6, x, y, 6, height, Color(220, 40, 40, 255)) -- Left crimson side badge border

        -- Text display updates
        draw.SimpleText("CRISIS: CORRUPTED ANOMALIES", "DermaDefaultBold", x + 16, y + 10, Color(240, 240, 240), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText("Purge remaining targets: " .. localCorruptedCount, "DermaDefault", x + 16, y + 26, Color(200, 200, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end)
end