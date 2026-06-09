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

   --------------------------------------------------------
    -- QUEST TARGET / REWARD BLACKLIST
    ---------------------------------------------------------
    -- Add any class names or model path snippets here to completely ignore them
    local QuestBlacklist = {
        ["light_spot"] = true,
        ["light_dynamic"] = true,
        ["env_projectedtexture"] = true,
        ["light_environment"] = true,
        ["light_directional"] = true,
        ["env_beam"] = true,
        ["manipulate_flex"] = true,
        ["path_track"] = true,
        ["player_loadsaved"] = true,
        ["player_speedmod"] = true,
        ["player_weaponstrip"] = true,
        ["gmod_light"] = true,
        ["hint"] = true,
        ["light"] = true,
        ["phys_constraintsystem"] = true,
-- Miscellaneous World Controls, Sound Players & Ropes
        ["ambient_generic"] = true,
        ["cycler"] = true,
        ["gibshooter"] = true,
        ["keyframe_rope"] = true,
        ["keyframe_track"] = true,
        ["material_modify_control"] = true,
        ["math_colorblend"] = true,
        ["math_counter"] = true,
        ["math_remap"] = true,
        ["momentary_rot_button"] = true,
        ["move_keyframed"] = true,
        ["move_rope"] = true,
        ["move_track"] = true,
        ["script_intro"] = true,
        ["script_tauremoval"] = true,
        ["sky_camera"] = true,
        ["test_sidelist"] = true,
        ["test_traceline"] = true,
        ["vgui_screen"] = true,
        ["water_lod_control"] = true,
    -- Map Flow Data Logic & Event Processors
        ["spotlight_end"] = true,
        ["Door Base"] = true,
        ["beam"] = true, 
        ["manipulate_bone"] = true,
        ["logic_time_relay"] = true,
        ["gm13_npc_hydra"] = true,
        ["ent_welding_tanks"] = true,
        ["prop_dynamic"] = true,
        ["predicted_viewmodel"] = true,
        ["flgm_tool"] = true,
        ["logic_achievement"] = true,
        ["Event goal"] = true,
        ["logic_active_autosave"] = true,
        ["logic_auto"] = true,
        ["logic_autosave"] = true,
        ["logic_branch"] = true,
        ["logic_branch_listener"] = true,
        ["logic_case"] = true,
        ["logic_choreographed_scene"] = true,
        ["logic_collision_pair"] = true,
        ["logic_compare"] = true,
        ["logic_coop_manager"] = true,
        ["logic_director_query"] = true,
        ["logic_eventlistener"] = true,
        ["logic_game_event"] = true,
        ["logic_lineto"] = true,
        ["logic_measure_movement"] = true,
        ["logic_mirror_movement"] = true,
        ["logic_multicompare"] = true,
        ["logic_navigation"] = true,
        ["logic_playerproxy"] = true,
        ["logic_playmovie"] = true,
        ["logic_random_outputs"] = true,
        ["logic_register_activator"] = true,
        ["logic_relay"] = true,
        ["logic_scene_list_manager"] = true,
        ["logic_script"] = true,
        ["logic_timer"] = true,
        ["logic_timescale"] = true,
        ["logic_versus_random"] = true,
        ["path_corner"] = true,
-- Invisible Point Logic, Cameras & Command Triggers
        ["point_anglesensor"] = true,
        ["point_angularvelocitysensor"] = true,
        ["point_antlion_repellant"] = true,
        ["point_apc_controller"] = true,
        ["point_bugbait"] = true,
        ["point_camera"] = true,
        ["point_clientcommand"] = true,
        ["point_commentary_node"] = true,
        ["point_devshot_camera"] = true,
        ["point_enable_motion_fixup"] = true,
        ["point_energy_ball_launcher"] = true,
        ["point_hurt"] = true,
        ["point_message"] = true,
        ["point_playermoveconstraint"] = true,
        ["point_servercommand"] = true,
        ["point_spotlight"] = true,
        ["point_teleport"] = true,
        ["point_template"] = true,
        ["point_tesla"] = true,
        ["point_viewcontrol"] = true,
        ["vehicle_viewcontroller"] = true,
-- Hidden Map Trigger Volumes & Logic Zones
        ["trigger_autosave"] = true,
        ["trigger_brush"] = true,
        ["trigger_changelevel"] = true,
        ["trigger_finale"] = true,
        ["trigger_gravity"] = true,
        ["trigger_hurt"] = true,
        ["trigger_impact"] = true,
        ["trigger_look"] = true,
        ["shadow_control"] = true,
        ["trigger_multiple"] = true,
        ["trigger_once"] = true,
        ["trigger_physics_trap"] = true,
        ["trigger_playermovement"] = true,
        ["trigger_portal_cleanser"] = true,
        ["trigger_proximity"] = true,
        ["trigger_push"] = true,
        ["trigger_remove"] = true,
        ["trigger_rpgfire"] = true,
        ["trigger_soundscape"] = true,
        ["trigger_teleport"] = true,
        ["trigger_transition"] = true,
        ["trigger_vphysics_motion"] = true,
        ["trigger_waterydeath"] = true,
        ["trigger_weapon_dissolve"] = true,
        ["trigger_weapon_strip"] = true,
        ["trigger_wind"] = true,
-- Physics Constraints & Forces
        ["phys_ballsocket"] = true,
        ["phys_constraint"] = true,
        ["phys_constraintsystem"] = true,
        ["phys_convert"] = true,
        ["phys_hinge"] = true,
        ["phys_keepupright"] = true,
        ["phys_lengthconstraint"] = true,
        ["phys_magnet"] = true,
        ["phys_motor"] = true,
        ["phys_pulleyconstraint"] = true,
        ["phys_ragdollconstraint"] = true,
        ["phys_ragdollmagnet"] = true,
        ["phys_slideconstraint"] = true,
        ["phys_spring"] = true,
        ["phys_thruster"] = true,
        ["phys_torque"] = true,
        ["physics_cannister"] = true,
-- Special Actors, Utility Nodes & Invisible Controllers
        ["cycler_actor"] = true,
        ["generic_actor"] = true,
        ["info_npc_spawn_destination"] = true,
        ["monster_generic"] = true,
        ["npc_apcdriver"] = true,
        ["npc_bullseye"] = true,
        ["npc_enemyfinder"] = true,
        ["npc_furniture"] = true,
        ["npc_heli_avoidbox"] = true,
        ["npc_heli_avoidsphere"] = true,
        ["npc_heli_nobomb"] = true,
        ["npc_launcher"] = true,
        ["npc_maker"] = true,
        ["npc_missiledefense"] = true,
        ["npc_newnpc"] = true,
        ["npc_particlestorm"] = true,
        ["npc_puppet"] = true,
        ["npc_spotlight"] = true,
        ["npc_template_maker"] = true,
        ["npc_vehicledriver"] = true,
 -- Map Geometry & Optimization Elements
        ["func_areaportal"] = true,
        ["func_areaportalwindow"] = true,
        ["func_brush"] = true,
        ["func_detail"] = true,
        ["func_lod"] = true,
        ["func_occluder"] = true,
        ["func_viscluster"] = true,
        ["func_wall"] = true,
        ["func_wall_toggle"] = true,
        ["func_reflective_glass"] = true,
        
        -- Interactables, Doors & Buttons
        ["func_button"] = true,
        ["func_rot_button"] = true,
        ["func_door"] = true,
        ["func_door_rotating"] = true,
        ["func_lookdoor"] = true,
        ["func_movelinear"] = true,
        ["func_platrot"] = true,
        ["func_rotating"] = true,
        
        -- Breakables & Physics Boxes
        ["func_breakable"] = true,
        ["func_breakable_surf"] = true,
        ["func_physbox"] = true,
        ["func_physbox_multiplayer"] = true,
        
        -- Ladders & Movement Systems
        ["func_ladder"] = true,
        ["func_ladderendpoint"] = true,
        ["func_useableladder"] = true,
        ["func_conveyor"] = true,
        ["func_trackautochange"] = true,
        ["func_trackchange"] = true,
        ["func_tracktrain"] = true,
        ["func_traincontrols"] = true,
        
        -- Gameplay Zones & Triggers
        ["func_capturezone"] = true,
        ["func_changeclass"] = true,
        ["func_nobuild"] = true,
        ["func_nogrenades"] = true,
        ["func_proprrespawnzone"] = true,
        ["func_regenerate"] = true,
        ["func_respawnroom"] = true,
        ["func_respawnroomvisualizer"] = true,
        
        -- Portals & Portal Volumes
        ["func_liquidportal"] = true,
        ["func_noportal_volume"] = true,
        ["func_portal_bumper"] = true,
        ["func_portal_detector"] = true,
        ["func_portal_orientation"] = true,
        
        -- Environmental Effects (Func)
        ["func_dustcloud"] = true,
        ["func_dustmotes"] = true,
        ["func_precipitation"] = true,
        ["func_smokevolume"] = true,
        ["func_water_analog"] = true,
        
        -- Chargers & Spawners
        ["func_extinguishercharger"] = true,
        ["func_healthcharger"] = true,
        ["func_recharge"] = true,
        ["func_combine_ball_spawner"] = true,
        
        -- Mounted Tanks & Emplacements
        ["func_guntarget"] = true,
        ["func_tank"] = true,
        ["func_tankairboatgun"] = true,
        ["func_tankapcrocket"] = true,
        ["func_tanklaser"] = true,
        ["func_tankmortar"] = true,
        ["func_tankphyscannister"] = true,
        ["func_tankpulselaser"] = true,
        ["func_tankrocket"] = true,
        ["func_tanktrain"] = true,
        
        -- Clip Brushes
        ["func_clip_vphysics"] = true,
        ["func_vehicleclip"] = true,
        ["func_monitor"] = true,

        -- Map Logic, Anchors & Target Points
        ["info_camera_link"] = true,
        ["info_constraint_anchor"] = true,
        ["info_hint"] = true,
        ["info_intermission"] = true,
        ["info_ladder_dismount"] = true,
        ["info_landmark"] = true,
        ["info_lighting"] = true,
        ["info_lighting_relative"] = true,
        ["info_mass_center"] = true,
        ["info_no_dynamic_shadow"] = true,
        ["info_null"] = true,
        ["info_observer_point"] = true,
        ["info_target"] = true,
        ["info_target_gunshipcrash"] = true,
        ["info_teleporter_countdown"] = true,
        ["info_teleport_destination"] = true,
        ["info_snipertarget"] = true,
        ["info_radar_target"] = true,
        ["info_player_start"] = true,

        -- Decals & Overlays
        ["info_overlay"] = true,
        ["info_projecteddecal"] = true,
        ["infodecal"] = true,

        -- Particle Systems & FX
        ["info_particle_system"] = true,

        -- AI Navigation Nodes
        ["info_node"] = true,
        ["info_node_air"] = true,
        ["info_node_air_hint"] = true,
        ["info_node_climb"] = true,
        ["info_node_hint"] = true,
        ["info_node_link"] = true,
        ["info_node_link_controller"] = true,

        -- Player & NPC Spawn Markers
        ["info_npc_spawn_destination"] = true,
        ["info_player_combine"] = true,
        ["info_player_deathmatch"] = true,
        ["info_player_logo"] = true,
        ["info_player_rebel"] = true,
        ["info_player_start"] = true,

        -- Environmental Emitters, Screens & Post-Processing
        ["env_ar2explosion"] = true,
        ["env_beam"] = true,
        ["env_beverage"] = true,
        ["env_blood"] = true,
        ["env_bubbles"] = true,
        ["env_citadel_energy_core"] = true,
        ["env_credits"] = true,
        ["env_cubemap"] = true,
        ["env_dustpuff"] = true,
        ["env_effectscript"] = true,
        ["env_embers"] = true,
        ["env_entity_dissolver"] = true,
        ["env_entity_igniter"] = true,
        ["env_entity_maker"] = true,
        ["env_explosion"] = true,
        ["env_extinguisherjet"] = true,
        ["env_fade"] = true,
        ["env_fire"] = true,
        ["env_firesensor"] = true,
        ["env_firesource"] = true,
        ["env_flare"] = true,
        ["env_fog_controller"] = true,
        ["env_funnel"] = true,
        ["env_global"] = true,
        ["env_gunfire"] = true,
        ["env_headcrabcanister"] = true,
        ["env_hudhint"] = true,
        ["env_laser"] = true,
        ["env_lightglow"] = true,
        ["env_lightrail_endpoint"] = true,
        ["env_message"] = true,
        ["env_microphone"] = true,
        ["env_muzzleflash"] = true,
        ["env_particlelight"] = true,
        ["env_particlescript"] = true,
        ["env_physexplosion"] = true,
        ["env_physimpact"] = true,
        ["env_player_surface_trigger"] = true,
        ["env_portal_credits"] = true,
        ["env_portal_laser"] = true,
        ["env_portal_path_track"] = true,
        ["env_rotorshooter"] = true,
        ["env_rotorwash"] = true,
        ["hint"] = true,
        ["func_useableladder"] = true,
        ["env_screenoverlay"] = true,
        ["env_screenoverlay"] = true,
        ["env_screenoverlay"] = true,
        ["env_screenoverlay"] = true,
        ["env_screenoverlay"] = true,
        ["path_track"] = true,
        ["env_shake"] = true,
        ["env_shooter"] = true,
        ["env_smokestack"] = true,
        ["env_smoketrail"] = true,
        ["env_spark"] = true,
        ["env_speaker"] = true,
        ["env_splash"] = true,
        ["env_sprite"] = true,
        ["env_spritetrail"] = true,
        ["env_starfield"] = true,
        ["env_steam"] = true,
        ["env_sun"] = true,
        ["env_terrainmorph"] = true,
        ["env_texturetoggle"] = true,
        ["env_tonemap_controller"] = true,
        ["env_wind"] = true,
        ["env_zoom"] = true,

        -- Soundscapes
        ["env_soundscape"] = true,
        ["env_soundscape_proxy"] = true,
        ["env_soundscape_triggerable"] = true,

        -- Example of blacklisting specific utility types or entities:
        ["edit_sun"] = true,
        ["shadow_control"] = true,
    }

    ---------------------------------------------------------
    -- AUTOMATED GLOBAL SPAWNMENU REGISTRY SCRAPER (No Props)
    ---------------------------------------------------------
    local DynamicRewardsList = {}

    local function ScrapeRewardRegistry()
        DynamicRewardsList = {} -- Reset

        -- 1. Grab all Scripted Entities (SENTS)
        for class, ent in pairs(scripted_ents.GetList()) do
            if class ~= "base_anim" and class ~= "base_gmodentity" and class ~= "base_ai" and not QuestBlacklist[class] then
                table.insert(DynamicRewardsList, { type = "entity", class = class })
            end
        end

        -- 2. Grab Sandbox Entities List
        local spawnableEntities = list.Get("SpawnableEntities")
        if spawnableEntities then
            for class, _ in pairs(spawnableEntities) do
                if not QuestBlacklist[class] then
                    table.insert(DynamicRewardsList, { type = "entity", class = class })
                end
            end
        end

        -- 3. Grab NPCs
        local npcList = list.Get("NPC")
        if npcList then
            for class, info in pairs(npcList) do
                if not QuestBlacklist[class] then
                    table.insert(DynamicRewardsList, { type = "npc", class = class, model = info.Model })
                end
            end
        end

        -- 4. Grab Vehicles
        local vehicleList = list.Get("Vehicles")
        if vehicleList then
            for class, info in pairs(vehicleList) do
                if not QuestBlacklist[class] then
                    table.insert(DynamicRewardsList, { type = "vehicle", class = class, model = info.Model, keyvalues = info.KeyValues })
                end
            end
        end

        -- Fallback defaults if tables aren't fully populated on instant frame load
        if #DynamicRewardsList == 0 then
            table.insert(DynamicRewardsList, { type = "npc", class = "npc_helicopter" })
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
            if IsValid(ent) and not ent:IsPlayer() and not QuestBlacklist[class] and not ent:IsWeapon() and not ent.QuestBlackListed then
                local class = ent:GetClass()
                local model = ent:GetModel() or ""

                table.insert(validTargets, ent)
            end
        end

        -- Safety fallback: if the map is completely empty, spawn a random object into the sky to hunt
        if #validTargets == 0 then
            for i,ply in pairs(player.GetAll()) do
                ply:ChatPrint("No valid alternative target entities found on the map")
            end
            return
        end

        -- Pick a completely random target entity from the map
        local chosenTarget = validTargets[math.random(1, #validTargets)]
        
        FLGM_ActiveQuest.Active = true
        FLGM_ActiveQuest.TargetEnt = chosenTarget
        FLGM_ActiveQuest.CurrentPlayer = ply
        
        -- Clean up print names for the chat prompt
        local readableName = chosenTarget.PrintName or chosenTarget:GetClass()
        local chosenClass = chosenTarget:GetClass()
        FLGM_ActiveQuest.TargetName = readableName

        ---------------------------------------------------------
        -- VISUAL RED ALERT TARGET PAINT
        ---------------------------------------------------------
        -- Explicitly turns the target crimson red and alters render mode so it flashes perfectly
        chosenTarget:SetColor(Color(255, 0, 0, 255))
        chosenTarget:SetRenderMode(RENDERMODE_TRANSCOLOR)

        -- Notify the target player
        for i,ply in pairs(player.GetAll()) do
            ply:PrintMessage(HUD_PRINTTALK, "Find and eliminate the glitched target")
            ply:PrintMessage(HUD_PRINTTALK, "TARGET: " .. readableName .. "(CLASS): ".. chosenClass .. " (ID: #" .. chosenTarget:EntIndex() .. ")")
            ply:PrintMessage(HUD_PRINTTALK, "status: target turned red")
            ply:PrintMessage(HUD_PRINTTALK, "Use your flgm_tool to delete it")
        end
        
        chosenTarget:EmitSound("ambient/machines/thumper_top.wav", 80, 130)
    end

    local function CompleteQuest(ply)
        for i,ply in pairs(player.GetAll()) do
            ply:PrintMessage(HUD_PRINTTALK, "Target successfully removed")
        end
        
        -- Pick a random dynamic reward (strictly NPCs or SENTS, no pure prop models)
        local rewardData = DynamicRewardsList[math.random(1, #DynamicRewardsList)]
        
        if rewardData then
            for i,ply in pairs(player.GetAll()) do
                ply:PrintMessage(HUD_PRINTTALK, "You got: " .. rewardData.class .. "yay")
            end
            
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
                        for i,ply in pairs(player.GetAll()) do
                            ply:ChatPrint("You must complete the current quest first Target: " .. FLGM_ActiveQuest.TargetName)
                        end
                        return 
                    end

                    FLGM_ActiveQuest.CorruptedDeleted = FLGM_ActiveQuest.CorruptedDeleted + 1
                    local remaining = 5 - FLGM_ActiveQuest.CorruptedDeleted

                    if remaining > 0 then
                        for i,ply in pairs(player.GetAll()) do
                            ply:ChatPrint("Targetted entity removed. (" .. FLGM_ActiveQuest.CorruptedDeleted .. "/5) Destroy " .. remaining .. " more to activate quest.")
                        end
                    else
                        for i,ply in pairs(player.GetAll()) do
                            ply:ChatPrint("Critical threshold met! Initializing world tracking matrix...")
                        end
                        StartRandomQuest(ply)
                    end
                    break
                end
            end
        end
    end)

    ---------------------------------------------------------
    -- CHAT SKIP COMMAND INTERCEPTOR
    ---------------------------------------------------------
    hook.Add("PlayerSay", "FLGM_QuestSkipCommand", function(ply, text)
        if string.lower(text) == "/skipquest" then
            if not FLGM_ActiveQuest.Active then
                for i,ply in pairs(player.GetAll()) do
                    ply:ChatPrint("There is no active quest to skip!")
                end
                return ""
            end
            for i,ply in pairs(player.GetAll()) do
                ply:ChatPrint("Rerolling target... Skipping active target: " .. FLGM_ActiveQuest.TargetName)
            end
            
            -- Revert the old target back to standard look so it doesn't stay red forever
            if IsValid(FLGM_ActiveQuest.TargetEnt) then
                FLGM_ActiveQuest.TargetEnt:SetColor(Color(255, 255, 255, 255))
            end

            -- Pick a fresh entity target
            StartRandomQuest(ply)
            return "" -- Suppress from appearing globally in chat text box
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
            draw.SimpleText("Status: Selected target is painted RED", "DermaDefault", 30, 65, Color(200, 200, 200, 255))
        end
    end)
end