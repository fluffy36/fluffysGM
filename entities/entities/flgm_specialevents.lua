-- quest_system.lua
-- Tracks and manages corruption events, handles prop visual modifications, and updates quest states.

if SERVER then
    util.AddNetworkString("FLGM_UpdateQuestUI")

    -- Configuration variables
    local QuestActive = true
    local TargetCorruptionColor = Color(255, 0, 0, 255) -- Crimson Corrupted Red
    local TargetCorruptionMaterial = "models/debug/debugwhite" -- Smooth unshaded texture for neon effect

    ---------------------------------------------------------
    -- CORRUPTION MONITOR & VISUAL PATCHER
    ---------------------------------------------------------
    -- Constantly checks for active event props, transforms them, and prunes stale data
    timer.Create("FLGM_QuestPropProcessor", 0.5, 0, function()
        if not QuestActive then return end

        local currentEventCount = 0
        local allProps = ents.FindByClass("prop_physics")

        for _, prop in ipairs(allProps) do
            if IsValid(prop) and prop.IsEventsLuaProp then
                currentEventCount = currentEventCount + 1

                -- If the prop hasn't been visually corrupted yet, apply the effects
                if not prop.IsCorruptedVisualApplied then
                    prop:SetColor(TargetCorruptionColor)
                    prop:SetMaterial(TargetCorruptionMaterial)
                    prop:DrawShadow(false) -- Makes it look like it's glowing slightly
                    
                    -- Optional: add a slight red dynamic glow around it
                    local glow = ents.Create("env_sprite")
                    if IsValid(glow) then
                        glow:SetKeyValue("model", "sprites/light_glow01.vmt")
                        glow:SetKeyValue("rendercolor", "255 0 0")
                        glow:SetKeyValue("renderamt", "200")
                        glow:SetKeyValue("modelscale", "1.5")
                        glow:SetPos(prop:WorldSpaceCenter())
                        glow:SetParent(prop)
                        glow:Spawn()
                    end

                    prop.IsCorruptedVisualApplied = true
                end
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
    -- Fires whenever an entity takes damage; catches when players destroy event props
    hook.Add("EntityTakeDamage", "FLGM_TrackQuestDestruction", function(target, dmginfo)
        if not QuestActive then return end
        if not IsValid(target) or target:GetClass() ~= "prop_physics" then return end

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