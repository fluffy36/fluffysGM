if SERVER then
    -- Configuration Settings
    local RespawnDelay = 3 -- 3 Seconds
    local DropHeight = 1500 -- Sky height calculation anchor

    -------------------------------------------------------------------------
    -- LOGIC: AIR DROP TRACKER & POSITION CALCULATOR
    -------------------------------------------------------------------------
    local function SpawnGeneratorFromSky()
        local targetPos = Vector(0, 0, 0)
        local players = player.GetAll()
        
        -- 1. Find an active player to drop the box near
        if #players > 0 then
            local randomPly = players[math.random(1, #players)]
            if IsValid(randomPly) then
                -- Drop nearby within a random 300-unit window offset
                targetPos = randomPly:GetPos() + Vector(math.random(-300, 300), math.random(-300, 300), DropHeight)
            end
        else
            -- Map is empty, pick a safe localized cluster spread around center origin
            targetPos = Vector(math.random(-500, 500), math.random(-500, 500), DropHeight)
        end

        -- 2. Trace down from the skybox roof to prevent it from getting stuck outside geometry
        local tr = util.TraceLine({
            start = targetPos,
            endpos = targetPos - Vector(0, 0, DropHeight),
            filter = function(ent) return ent:IsWorld() end
        })
        
        -- If it hits a ceiling sky boundary or structural roof, shift the drop position slightly below it
        if tr.Hit then 
            targetPos = tr.HitPos - Vector(0, 0, 50) 
        end

        -- 3. Manifest the Dumpster Generator
        local generator = ents.Create("flgm_Generator")
        if IsValid(generator) then
            generator:SetPos(targetPos)
            generator:Spawn()
            generator:Activate()

            -- Global alerts (Sound & Text)
            generator:EmitSound("ambient/machines/thumper_top.wav", 100, 90)
            
            for _, ply in ipairs(player.GetAll()) do
                ply:PrintMessage(HUD_PRINTTALK, "mysterious generator is dropping from the sky")
            end
        end
    end

    -------------------------------------------------------------------------
    -- ENGINE HOOK INTERCEPTORS
    -------------------------------------------------------------------------
    -- Event Phase A: Map loaded / server started. Queue first drop after 3 seconds.
    hook.Add("Initialize", "FLGM_StartInitialGeneratorEvent", function()
        timer.Simple(RespawnDelay, function()
            SpawnGeneratorFromSky()
        end)
    end)

    -- Event Phase B: Tracking removal. When deleted, queue a replacement in 3 seconds.
    hook.Add("EntityRemoved", "FLGM_GeneratorEventRespawnTracker", function(ent)
        -- Strict validation check so normal cleanup or map changes don't cause ghost timers
        if ent:GetClass() == "flgm_Generator" and not ent.IsShuttingDown then
            timer.Simple(RespawnDelay, function()
                SpawnGeneratorFromSky()
            end)
        end
    end)
end