--flgm_event_generatorsummoner.lua
hook.Add("PlayerInitialSpawn", "KillFirstJoinOnce", function(Ply)
    if SERVER then
        -- Configuration Settings
        local RespawnDelay = 300 -- 5 Minutes (300 seconds)
        local DropHeight = 1500  -- Sky height calculation anchor

        
        local function SpawnGeneratorFromSky()
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
            
            
            if tr.Hit then 
                targetPos = tr.HitPos - Vector(0, 0, 50) 
            end

            
            local generator = ents.Create("flgm_entitynpc_generator")
            if IsValid(generator) then
                generator:SetPos(targetPos)
                generator:Spawn()
                generator:Activate()

                
                generator:EmitSound("ambient/machines/thumper_top.wav", 100, 90)
                
                for _, ply in ipairs(player.GetAll()) do
                    ply:PrintMessage(HUD_PRINTTALK, "mysterious generator is dropping from the sky")
                end
            end
        end

        
        hook.Add("Initialize", "FLGM_StartInitialGeneratorEvent", function()
            timer.Simple(RespawnDelay, function()
                SpawnGeneratorFromSky()
            end)
        end)

        
        hook.Add("EntityRemoved", "FLGM_GeneratorEventRespawnTracker", function(ent)
            if ent:GetClass() == "flgm_Generator" and not ent.IsShuttingDown then
                timer.Simple(RespawnDelay, function()
                    SpawnGeneratorFromSky()
                end)
            end
        end)
    end
end)