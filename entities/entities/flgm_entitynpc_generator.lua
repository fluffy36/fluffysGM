AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Random entitynpc generator"
ENT.Author = "Lenny"
ENT.Category = "Fluffy's gamemode"
ENT.Spawnable = true
ENT.AdminOnly = false

if SERVER then

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
        ["env_screenoverlay"] = true,
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

    -------------------------------------------------------------------------
    -- INTERNAL BACKEND REGISTER PARSER (Gathers Everything)
    -------------------------------------------------------------------------
    local GeneratorBackupList = {}

    local function PopulateGeneratorPool()
        GeneratorBackupList = {}

        -- Fetch the master blacklist if it exists globally, otherwise keep a safety fallback check
        -- (This ensures logic, triggers, and soundscapes never spawn out of the generator)
        local blocklist = QuestBlacklist

        -- 1. Grab all Scripted Entities (SENTS)
        for class, _ in pairs(scripted_ents.GetList()) do
            if class ~= "base_anim" and class ~= "base_gmodentity" and class ~= "base_ai" and not blocklist[class] and not string.find(class, "logic_") and not string.find(class, "trigger_") then
                table.insert(GeneratorBackupList, { type = "entity", class = class })
            end
        end

        -- 2. Grab Sandbox Spawnable Entities
        local spawnableEntities = list.Get("SpawnableEntities")
        if spawnableEntities then
            for class, _ in pairs(spawnableEntities) do
                if not blocklist[class] then
                    table.insert(GeneratorBackupList, { type = "entity", class = class })
                end
            end
        end

        -- 3. Grab ALL Spawnable NPCs
        local npcList = list.Get("NPC")
        if npcList then
            for class, info in pairs(npcList) do
                if not blocklist[class] then
                    table.insert(GeneratorBackupList, { type = "npc", class = class, model = info.Model })
                end
            end
        end

        -- 4. Grab All Vehicles
        local vehicleList = list.Get("Vehicles")
        if vehicleList then
            for class, info in pairs(vehicleList) do
                if not blocklist[class] then
                    table.insert(GeneratorBackupList, { type = "vehicle", class = class, model = info.Model, keyvalues = info.KeyValues })
                end
            end
        end
    end

    -- Run the scraper right as the map setups load
    hook.Add("Initialize", "FLGM_GeneratorPoolInit", function()
        PopulateGeneratorPool()
    end)

    -------------------------------------------------------------------------
    -- INITIALIZE ENTITY
    -------------------------------------------------------------------------
    function ENT:Initialize()
        self:SetModel("models/props_junk/TrashDumpster02.mdl") 
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        
        if CLIENT then return end
        
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE) 

        local phys = self:GetPhysicsObject()
        if IsValid(phys) then
            phys:Wake()
            phys:SetMass(150) 
        end

        self.NextUseTime = 0
        self.CooldownDuration = 5 
    end

    
    function ENT:Use(activator, caller)
        if not IsValid(activator) or not activator:IsPlayer() then return end

        local curTime = CurTime()

        if curTime < self.NextUseTime then
            local timeLeft = math.ceil(self.NextUseTime - curTime)
            activator:ChatPrint(string.format("Generator delayed Please wait %d more seconds.", timeLeft))
            self:EmitSound("common/wpn_denyselect.wav", 70, 100)
            return
        end

        -- Check shared master list first, fall back to our local generator registry if empty
        local rewardsPool = DynamicRewardsList
        if not rewardsPool or #rewardsPool == 0 then
            if #GeneratorBackupList == 0 then PopulateGeneratorPool() end
            rewardsPool = GeneratorBackupList
        end

        if #rewardsPool == 0 then
            activator:ChatPrint("error spawner registry is empty.")
            return
        end

        self.NextUseTime = curTime + self.CooldownDuration

        local choice = rewardsPool[math.random(1, #rewardsPool)]
        
        -- Safe spacing: Give a higher offset to accommodate massive entities/NPCs spawning
        local spawnPos = self:GetPos() + Vector(0, 0, 75) 

        local spawnedEnt = ents.Create(choice.class)
        if IsValid(spawnedEnt) then
            spawnedEnt:SetPos(spawnPos)
            spawnedEnt:SetAngles(Angle(0, math.random(0, 360), 0))

            if choice.model then spawnedEnt:SetModel(choice.model) end
            
            if choice.keyvalues then
                for k, v in pairs(choice.keyvalues) do
                    spawnedEnt:SetKeyValue(k, v)
                end
            end

            spawnedEnt:Spawn()
            spawnedEnt:Activate()

            self:EmitSound("ambient/levels/citadel/weapon_disintegrate2.wav", 80, 120)
            
            local effect = EffectData()
            effect:SetOrigin(spawnPos)
            effect:SetScale(2)
            util.Effect("cball_explode", effect)

            activator:ChatPrint("Generated: " .. choice.class)
        else
            activator:ChatPrint("Generator: Failed to manifest entity format. Cooldown refunded.")
            self.NextUseTime = curTime 
        end
    end
end

if CLIENT then
    function ENT:Draw()
        self:DrawModel()

        if self:GetPos():DistToSqr(LocalPlayer():GetPos()) < 250000 then 
            local size = 30 + math.sin(CurTime() * 4) * 5
            render.SetMaterial(Material("sprites/glow04_noz_gmod"))
            render.DrawSprite(self:GetPos() + Vector(0, 0, 20), size, size, Color(0, 128, 255, 150))
        end
    end
end