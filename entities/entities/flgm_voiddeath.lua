if SERVER then
    -- Master Toggle States
    local IsPurgingNonStop = false
    local PurgeHookName = "FLGM_ConstantForcePurgeLoop"

    -------------------------------------------------------------------------
    -- BLACKLIST CONTROL: What gets spared?
    -------------------------------------------------------------------------
    local function ShouldBePurged(ent)
        if not IsValid(ent) then return false end
        
        local class = ent:GetClass()

        -- Absolutely protect critical engine entities and active players
        if ent:IsPlayer() or class == "worldspawn" or class == "soundent" or string.find(class, "viewmodel") then
            return false
        end

        -- Keep core map design, lighting, and basic networking intact so the server doesn't crash
        if string.find(class, "player_manager") or string.find(class, "predicted_viewmodel") or class == "gmod_hands" then
            return false
        end

        -- If it's a prop, NPC, vehicle, weapon, or custom scripted entity, wipe it out
        return true
    end

    -------------------------------------------------------------------------
    -- THE CONSTANT DELETION MATRIX
    -------------------------------------------------------------------------
    local function ExecuteConstantPurge()
        local count = 0
        local allEntities = ents.GetAll()

        for _, ent in ipairs(allEntities) do
            if ShouldBePurged(ent) then
                -- Bypass normal deletion safety hooks so it forces instant removal
                ent:Remove()
                count = count + 1
            end
        end
    end

    -------------------------------------------------------------------------
    -- CHAT INTERCEPT COMMANDS
    -------------------------------------------------------------------------
    hook.Add("PlayerSay", "FLGM_PurgeChatCommands", function(ply, text)
        local command = string.lower(string.trim(text))

        -- COMMAND 1: START THE NONSTOP WIPEOUT
        if command == "!ent_remove_everything" then
            if IsPurgingNonStop then
                return ""
            end

            IsPurgingNonStop = true
            
            -- Hook into 'Think' so it executes every single server frame nonstop
            hook.Add("Think", PurgeHookName, function()
                ExecuteConstantPurge()
            end)

            -- Send a bold system alert to everyone on the server
 
            PrintMessage(HUD_PRINTTALK, "started")
            
            return "" -- Hide typing from chatbox
        end

        -- COMMAND 2: STOP THE PURGE
        if command == "!stop" then
            if not IsPurgingNonStop then

                return ""
            end

            IsPurgingNonStop = false
            hook.Remove("Think", PurgeHookName)

            
            PrintMessage(HUD_PRINTTALK, "stopped")
            return "" -- Hide typing from chatbox
        end
    end)
end