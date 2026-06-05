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
    
    local Props_c17 = {"models/props_c17/awning001a.mdl", "models/props_c17/awning002a.mdl", "models/props_c17/bench01a.mdl", "models/props_c17/briefcase001a.mdl", "models/props_c17/canister01a.mdl", "models/props_c17/canister02a.mdl", "models/props_c17/canisterchunk01a.mdl", "models/props_c17/canisterchunk01b.mdl", "models/props_c17/canisterchunk01c.mdl", "models/props_c17/canisterchunk01d.mdl", "models/props_c17/canisterchunk01f.mdl", "models/props_c17/canisterchunk01g.mdl", "models/props_c17/canisterchunk01h.mdl", "models/props_c17/canisterchunk01i.mdl", "models/props_c17/canisterchunk01k.mdl", "models/props_c17/canisterchunk01l.mdl", "models/props_c17/canisterchunk01m.mdl", "models/props_c17/canisterchunk02a.mdl", "models/props_c17/canisterchunk02b.mdl", "models/props_c17/canisterchunk02c.mdl", "models/props_c17/canisterchunk02d.mdl", "models/props_c17/canisterchunk02e.mdl", "models/props_c17/canisterchunk02f.mdl", "models/props_c17/canisterchunk02g.mdl", "models/props_c17/canisterchunk02h.mdl", "models/props_c17/canisterchunk02i.mdl", "models/props_c17/canisterchunk02j.mdl", "models/props_c17/canisterchunk02k.mdl", "models/props_c17/canisterchunk02l.mdl", "models/props_c17/canisterchunk02m.mdl", "models/props_c17/canister_propane01a.mdl", "models/props_c17/cashregister01a.mdl", "models/props_c17/chair02a.mdl", "models/props_c17/chair_kleiner03a.mdl", "models/props_c17/chair_office01a.mdl", "models/props_c17/chair_stool01a.mdl", "models/props_c17/clock01.mdl", "models/props_c17/column02a.mdl", "models/props_c17/computer01_keyboard.mdl", "models/props_c17/concrete_barrier001a.mdl", "models/props_c17/consolebox01a.mdl", "models/props_c17/consolebox03a.mdl", "models/props_c17/consolebox05a.mdl", "models/props_c17/display_cooler01a.mdl", "models/props_c17/doll01.mdl", "models/props_c17/door01_left.mdl", "models/props_c17/door02_double.mdl", "models/props_c17/fence01a.mdl", "models/props_c17/fence01b.mdl", "models/props_c17/fence02a.mdl", "models/props_c17/fence02b.mdl", "models/props_c17/fence03a.mdl", "models/props_c17/fence04a.mdl", "models/props_c17/fountain_01.mdl", "models/props_c17/frame002a.mdl", "models/props_c17/furniturearmchair001a.mdl", "models/props_c17/furniturebathtub001a.mdl", "models/props_c17/furniturebed001a.mdl", "models/props_c17/furnitureboiler001a.mdl", "models/props_c17/furniturechair001a.mdl", "models/props_c17/furniturechair001a_chunk01.mdl", "models/props_c17/furniturechair001a_chunk02.mdl", "models/props_c17/furniturechair001a_chunk03.mdl", "models/props_c17/furniturecouch001a.mdl", "models/props_c17/furniturecouch002a.mdl", "models/props_c17/furniturecupboard001a.mdl", "models/props_c17/furnituredrawer001a.mdl", "models/props_c17/furnituredrawer001a_chunk01.mdl", "models/props_c17/furnituredrawer001a_chunk02.mdl", "models/props_c17/furnituredrawer001a_chunk03.mdl", "models/props_c17/furnituredrawer001a_chunk04.mdl", "models/props_c17/furnituredrawer001a_chunk05.mdl", "models/props_c17/furnituredrawer001a_chunk06.mdl", "models/props_c17/furnituredrawer001a_shard01.mdl", "models/props_c17/furnituredrawer002a.mdl", "models/props_c17/furnituredrawer003a.mdl", "models/props_c17/furnituredresser001a.mdl", "models/props_c17/furniturefireplace001a.mdl", "models/props_c17/furniturefridge001a.mdl", "models/props_c17/furnituremattress001a.mdl", "models/props_c17/furniturepipecluster001a.mdl", "models/props_c17/furnitureradiator001a.mdl", "models/props_c17/furnitureshelf001a.mdl", "models/props_c17/furnitureshelf001b.mdl", "models/props_c17/furnitureshelf002a.mdl", "models/props_c17/furnituresink001a.mdl", "models/props_c17/furniturestove001a.mdl", "models/props_c17/furnituretable001a.mdl", "models/props_c17/furnituretable002a.mdl", "models/props_c17/furnituretable003a.mdl", "models/props_c17/furnituretoilet001a.mdl", "models/props_c17/furniturewashingmachine001a.mdl", "models/props_c17/gasmeter001a.mdl", "models/props_c17/gasmeter002a.mdl", "models/props_c17/gasmeter003a.mdl", "models/props_c17/gasmeterpipes001a.mdl", "models/props_c17/gasmeterpipes002a.mdl", "models/props_c17/gaspipes001a.mdl", "models/props_c17/gaspipes002a.mdl", "models/props_c17/gaspipes003a.mdl", "models/props_c17/gaspipes004a.mdl", "models/props_c17/gaspipes005a.mdl", "models/props_c17/gaspipes006a.mdl", "models/props_c17/gate_door01a.mdl", "models/props_c17/gate_door02a.mdl", "models/props_c17/gravestone001a.mdl", "models/props_c17/gravestone002a.mdl", "models/props_c17/gravestone003a.mdl", "models/props_c17/gravestone004a.mdl", "models/props_c17/gravestone_coffinpiece001a.mdl", "models/props_c17/gravestone_coffinpiece002a.mdl", "models/props_c17/gravestone_cross001a.mdl", "models/props_c17/gravestone_cross001b.mdl", "models/props_c17/gravestone_statue001a.mdl", "models/props_c17/grinderclamp01a.mdl", "models/props_c17/handrail04_brokencorner.mdl", "models/props_c17/handrail04_brokenlong.mdl", "models/props_c17/handrail04_brokensinglerise.mdl", "models/props_c17/handrail04_cap.mdl", "models/props_c17/handrail04_corner.mdl", "models/props_c17/handrail04_doublerise.mdl", "models/props_c17/handrail04_end.mdl", "models/props_c17/handrail04_long.mdl", "models/props_c17/handrail04_medium.mdl", "models/props_c17/handrail04_short.mdl", "models/props_c17/handrail04_singlerise.mdl", "models/props_c17/lamp001a.mdl", "models/props_c17/lampfixture01a.mdl", "models/props_c17/lamppost03a_off.mdl", "models/props_c17/lamppost03a_off_dynamic.mdl", "models/props_c17/lamppost03a_on.mdl", "models/props_c17/lampshade001a.mdl", "models/props_c17/lamp_bell_on.mdl", "models/props_c17/lamp_standard_off01.mdl", "models/props_c17/light_cagelight01_off.mdl", "models/props_c17/light_cagelight01_on.mdl", "models/props_c17/light_cagelight02_off.mdl", "models/props_c17/light_cagelight02_on.mdl", "models/props_c17/light_decklight01_off.mdl", "models/props_c17/light_decklight01_on.mdl", "models/props_c17/light_domelight01_off.mdl", "models/props_c17/light_domelight02_off.mdl", "models/props_c17/light_domelight02_on.mdl", "models/props_c17/light_floodlight02_off.mdl", "models/props_c17/light_industrialbell01_on.mdl", "models/props_c17/light_magnifyinglamp02.mdl", "models/props_c17/lockers001a.mdl", "models/props_c17/metalladder001.mdl", "models/props_c17/metalladder002.mdl", "models/props_c17/metalladder002b.mdl", "models/props_c17/metalladder003.mdl", "models/props_c17/metalpot001a.mdl", "models/props_c17/metalpot002a.mdl", "models/props_c17/oildrum001.mdl", "models/props_c17/oildrum001_explosive.mdl", "models/props_c17/oildrumchunk01a.mdl", "models/props_c17/oildrumchunk01b.mdl", "models/props_c17/oildrumchunk01c.mdl", "models/props_c17/oildrumchunk01d.mdl", "models/props_c17/oildrumchunk01e.mdl", "models/props_c17/overhaingcluster_001a.mdl", "models/props_c17/overpass_001a.mdl", "models/props_c17/overpass_001b.mdl", "models/props_c17/paper01.mdl", "models/props_c17/pillarcluster_001a.mdl", "models/props_c17/pillarcluster_001b.mdl", "models/props_c17/pillarcluster_001c.mdl", "models/props_c17/pillarcluster_001d.mdl", "models/props_c17/pillarcluster_001f.mdl", "models/props_c17/pipe_cap003.mdl", "models/props_c17/pipe_cap005.mdl", "models/props_c17/pipe_cap005c.mdl", "models/props_c17/playgroundslide01.mdl", "models/props_c17/playgroundtick-tack-toe_block01a.mdl", "models/props_c17/playgroundtick-tack-toe_post01.mdl", "models/props_c17/playground_carousel01.mdl", "models/props_c17/playground_jungle_gym01a.mdl", "models/props_c17/playground_jungle_gym01b.mdl", "models/props_c17/playground_swingset01.mdl", "models/props_c17/playground_swingset_seat01a.mdl", "models/props_c17/playground_teetertoter_seat.mdl", "models/props_c17/playground_teetertoter_stan.mdl", "models/props_c17/pulleyhook01.mdl", "models/props_c17/pulleywheels_large01.mdl", "models/props_c17/pulleywheels_small01.mdl", "models/props_c17/pushbroom.mdl", "models/props_c17/shelfunit01a.mdl", "models/props_c17/signpole001.mdl", "models/props_c17/statue_horse.mdl", "models/props_c17/streetsign001c.mdl", "models/props_c17/streetsign002b.mdl", "models/props_c17/streetsign003b.mdl", "models/props_c17/streetsign004e.mdl", "models/props_c17/streetsign004f.mdl", "models/props_c17/streetsign005b.mdl", "models/props_c17/streetsign005c.mdl", "models/props_c17/streetsign005d.mdl", "models/props_c17/substation_circuitbreaker01a.mdl", "models/props_c17/substation_stripebox01a.mdl", "models/props_c17/substation_transformer01a.mdl", "models/props_c17/substation_transformer01b.mdl", "models/props_c17/substation_transformer01c.mdl", "models/props_c17/substation_transformer01d.mdl", "models/props_c17/substation_transformer01e.mdl", "models/props_c17/suitcase001a.mdl", "models/props_c17/suitcase_passenger_physics.mdl", "models/props_c17/support01.mdl", "models/props_c17/tools_pliers01a.mdl", "models/props_c17/tools_wrench01a.mdl", "models/props_c17/traffic_light001a.mdl", "models/props_c17/trappropeller_blade.mdl", "models/props_c17/trappropeller_engine.mdl", "models/props_c17/trappropeller_lever.mdl", "models/props_c17/trap_crush01a.mdl", "models/props_c17/truss02a.mdl", "models/props_c17/truss02c.mdl", "models/props_c17/truss02d.mdl", "models/props_c17/truss02e.mdl", "models/props_c17/truss02f.mdl", "models/props_c17/truss02g.mdl", "models/props_c17/truss02h.mdl", "models/props_c17/truss03a.mdl", "models/props_c17/truss03b.mdl", "models/props_c17/tv_monitor01.mdl", "models/props_c17/tv_monitor01_screen.mdl", "models/props_c17/utilityconducter001.mdl", "models/props_c17/utilityconnecter002.mdl", "models/props_c17/utilityconnecter003.mdl", "models/props_c17/utilityconnecter005.mdl", "models/props_c17/utilityconnecter006.mdl", "models/props_c17/utilityconnecter006b.mdl", "models/props_c17/utilityconnecter006c.mdl", "models/props_c17/utilityconnecter006d.mdl", "models/props_c17/utilitypole01a.mdl", "models/props_c17/utilitypole01b.mdl", "models/props_c17/utilitypole01d.mdl", "models/props_c17/utilitypole02b.mdl", "models/props_c17/utilitypole03a.mdl", "models/props_c17/utilitypolemount01a.mdl"}
    local Props_WasteLand = {"models/props_wasteland/antlionhill.mdl", "models/props_wasteland/barricade001a.mdl", "models/props_wasteland/barricade001a_chunk01.mdl", "models/props_wasteland/barricade001a_chunk02.mdl", "models/props_wasteland/barricade001a_chunk03.mdl", "models/props_wasteland/barricade001a_chunk04.mdl", "models/props_wasteland/barricade001a_chunk05.mdl", "models/props_wasteland/barricade002a.mdl", "models/props_wasteland/barricade002a_chunk01.mdl", "models/props_wasteland/barricade002a_chunk02.mdl", "models/props_wasteland/barricade002a_chunk03.mdl", "models/props_wasteland/barricade002a_chunk04.mdl", "models/props_wasteland/barricade002a_chunk05.mdl", "models/props_wasteland/barricade002a_chunk06.mdl", "models/props_wasteland/boat_01.mdl", "models/props_wasteland/boat_fishing01a.mdl", "models/props_wasteland/boat_fishing02a.mdl", "models/props_wasteland/bridge_internals01.mdl", "models/props_wasteland/bridge_internals02.mdl", "models/props_wasteland/bridge_internals03.mdl", "models/props_wasteland/bridge_low_res.mdl", "models/props_wasteland/bridge_middle.mdl", "models/props_wasteland/bridge_railing.mdl", "models/props_wasteland/bridge_side01-other.mdl", "models/props_wasteland/bridge_side01.mdl", "models/props_wasteland/bridge_side02-other.mdl", "models/props_wasteland/bridge_side02.mdl", "models/props_wasteland/bridge_side03-other.mdl", "models/props_wasteland/bridge_side03.mdl", "models/props_wasteland/buoy01.mdl", "models/props_wasteland/cafeteria_bench001a.mdl", "models/props_wasteland/cafeteria_bench001a_chunk01.mdl", "models/props_wasteland/cafeteria_bench001a_chunk02.mdl", "models/props_wasteland/cafeteria_bench001a_chunk03.mdl", "models/props_wasteland/cafeteria_bench001a_chunk04.mdl", "models/props_wasteland/cafeteria_bench001a_chunk05.mdl", "models/props_wasteland/cafeteria_table001a.mdl", "models/props_wasteland/cafeteria_table001a_chunk01.mdl", "models/props_wasteland/cafeteria_table001a_chunk02.mdl", "models/props_wasteland/cafeteria_table001a_chunk03.mdl", "models/props_wasteland/cafeteria_table001a_chunk04.mdl", "models/props_wasteland/cafeteria_table001a_chunk05.mdl", "models/props_wasteland/cafeteria_table001a_chunk06.mdl", "models/props_wasteland/cafeteria_table001a_chunk07.mdl", "models/props_wasteland/cafeteria_table001a_chunk08.mdl", "models/props_wasteland/cargo_container01.mdl", "models/props_wasteland/cargo_container01b.mdl", "models/props_wasteland/cargo_container01c.mdl", "models/props_wasteland/chimneypipe01a.mdl", "models/props_wasteland/chimneypipe01b.mdl", "models/props_wasteland/chimneypipe02a.mdl", "models/props_wasteland/chimneypipe02b.mdl", "models/props_wasteland/controlroom_chair001a.mdl", "models/props_wasteland/controlroom_desk001a.mdl", "models/props_wasteland/controlroom_desk001b.mdl", "models/props_wasteland/controlroom_filecabinet001a.mdl", "models/props_wasteland/controlroom_filecabinet002a.mdl", "models/props_wasteland/controlroom_monitor001a.mdl", "models/props_wasteland/controlroom_monitor001b.mdl", "models/props_wasteland/controlroom_storagecloset001a.mdl", "models/props_wasteland/controlroom_storagecloset001b.mdl", "models/props_wasteland/coolingtank01.mdl", "models/props_wasteland/coolingtank02.mdl", "models/props_wasteland/cranemagnet01a.mdl", "models/props_wasteland/depot.mdl", "models/props_wasteland/depot_skybox.mdl", "models/props_wasteland/dockplank01a.mdl", "models/props_wasteland/dockplank01b.mdl", "models/props_wasteland/dockplank_chunk01a.mdl", "models/props_wasteland/dockplank_chunk01b.mdl", "models/props_wasteland/dockplank_chunk01c.mdl", "models/props_wasteland/dockplank_chunk01d.mdl", "models/props_wasteland/dockplank_chunk01e.mdl", "models/props_wasteland/dockplank_chunk01f.mdl", "models/props_wasteland/exterior_fence001a.mdl", "models/props_wasteland/exterior_fence001b.mdl", "models/props_wasteland/exterior_fence002a.mdl", "models/props_wasteland/exterior_fence002b.mdl", "models/props_wasteland/exterior_fence002c.mdl", "models/props_wasteland/exterior_fence002d.mdl", "models/props_wasteland/exterior_fence002e.mdl", "models/props_wasteland/exterior_fence003a.mdl", "models/props_wasteland/exterior_fence003b.mdl", "models/props_wasteland/gaspump001a.mdl", "models/props_wasteland/gear01.mdl", "models/props_wasteland/gear02.mdl", "models/props_wasteland/grainelevator01.mdl", "models/props_wasteland/horizontalcoolingtank04.mdl", "models/props_wasteland/interior_fence001a.mdl", "models/props_wasteland/interior_fence001b.mdl", "models/props_wasteland/interior_fence001c.mdl", "models/props_wasteland/interior_fence001d.mdl", "models/props_wasteland/interior_fence001e.mdl", "models/props_wasteland/interior_fence001g.mdl", "models/props_wasteland/interior_fence002a.mdl", "models/props_wasteland/interior_fence002b.mdl", "models/props_wasteland/interior_fence002c.mdl", "models/props_wasteland/interior_fence002d.mdl", "models/props_wasteland/interior_fence002e.mdl", "models/props_wasteland/interior_fence002f.mdl", "models/props_wasteland/interior_fence003a.mdl", "models/props_wasteland/interior_fence003b.mdl", "models/props_wasteland/interior_fence003d.mdl", "models/props_wasteland/interior_fence003e.mdl", "models/props_wasteland/interior_fence003f.mdl", "models/props_wasteland/interior_fence004a.mdl", "models/props_wasteland/interior_fence004b.mdl", "models/props_wasteland/kitchen_counter001a.mdl", "models/props_wasteland/kitchen_counter001b.mdl", "models/props_wasteland/kitchen_counter001c.mdl", "models/props_wasteland/kitchen_counter001d.mdl", "models/props_wasteland/kitchen_fridge001a.mdl", "models/props_wasteland/kitchen_shelf001a.mdl", "models/props_wasteland/kitchen_shelf002a.mdl", "models/props_wasteland/kitchen_stove001a.mdl", "models/props_wasteland/kitchen_stove002a.mdl", "models/props_wasteland/laundry_basket001.mdl", "models/props_wasteland/laundry_basket002.mdl", "models/props_wasteland/laundry_cart001.mdl", "models/props_wasteland/laundry_cart002.mdl", "models/props_wasteland/laundry_dryer001.mdl", "models/props_wasteland/laundry_dryer002.mdl", "models/props_wasteland/laundry_washer001a.mdl", "models/props_wasteland/laundry_washer003.mdl", "models/props_wasteland/lighthouse_fresnel_light.mdl", "models/props_wasteland/lighthouse_fresnel_light_base.mdl", "models/props_wasteland/lighthouse_stairs.mdl", "models/props_wasteland/lighthouse_stairs0b.mdl", "models/props_wasteland/lights_industrialcluster01a.mdl", "models/props_wasteland/light_spotlight01_base.mdl", "models/props_wasteland/light_spotlight01_lamp.mdl", "models/props_wasteland/light_spotlight02_base.mdl", "models/props_wasteland/light_spotlight02_lamp.mdl", "models/props_wasteland/medbridge_arch01.mdl", "models/props_wasteland/medbridge_base01.mdl", "models/props_wasteland/medbridge_post01.mdl", "models/props_wasteland/medbridge_strut01.mdl", "models/props_wasteland/panel_leverbase001a.mdl", "models/props_wasteland/panel_leverhandle001a.mdl", "models/props_wasteland/pipecluster001a.mdl", "models/props_wasteland/pipecluster001c.mdl", "models/props_wasteland/pipecluster002a.mdl", "models/props_wasteland/pipecluster003a_small.mdl", "models/props_wasteland/plasterwall029c_window01a.mdl", "models/props_wasteland/plasterwall029c_window01a_bars.mdl", "models/props_wasteland/plasterwall029g_window01a.mdl", "models/props_wasteland/plasterwall029g_window01a_bars.mdl", "models/props_wasteland/powertower01.mdl", "models/props_wasteland/prison_archgate001.mdl", "models/props_wasteland/prison_archgate002a.mdl", "models/props_wasteland/prison_archgate002b.mdl", "models/props_wasteland/prison_archgate002c.mdl", "models/props_wasteland/prison_archwindow001.mdl", "models/props_wasteland/prison_bedframe001a.mdl", "models/props_wasteland/prison_bedframe001b.mdl", "models/props_wasteland/prison_bracket001a.mdl", "models/props_wasteland/prison_cagedlight001a.mdl", "models/props_wasteland/prison_celldoor001a.mdl", "models/props_wasteland/prison_celldoor001b.mdl", "models/props_wasteland/prison_cellwindow002a.mdl", "models/props_wasteland/prison_conduit001a.mdl", "models/props_wasteland/prison_doortrack001a.mdl", "models/props_wasteland/prison_flourescentlight001a.mdl", "models/props_wasteland/prison_flourescentlight001b.mdl", "models/props_wasteland/prison_flourescentlight001c.mdl", "models/props_wasteland/prison_flourescentlight002b.mdl", "models/props_wasteland/prison_gate001a.mdl", "models/props_wasteland/prison_gate001b.mdl", "models/props_wasteland/prison_gate001c.mdl", "models/props_wasteland/prison_heater001a.mdl", "models/props_wasteland/prison_heater002a.mdl", "models/props_wasteland/prison_heavydoor001a.mdl", "models/props_wasteland/prison_lamp001a.mdl", "models/props_wasteland/prison_lamp001b.mdl", "models/props_wasteland/prison_lamp001c.mdl", "models/props_wasteland/prison_metalbed001a.mdl", "models/props_wasteland/prison_padlock001a.mdl", "models/props_wasteland/prison_padlock001b.mdl", "models/props_wasteland/prison_pipefaucet001a.mdl", "models/props_wasteland/prison_pipes001a.mdl", "models/props_wasteland/prison_pipes002a.mdl", "models/props_wasteland/prison_shelf001a.mdl", "models/props_wasteland/prison_shelf002a.mdl", "models/props_wasteland/prison_sink001a.mdl", "models/props_wasteland/prison_sink001b.mdl", "models/props_wasteland/prison_sinkchunk001b.mdl", "models/props_wasteland/prison_sinkchunk001c.mdl", "models/props_wasteland/prison_sinkchunk001d.mdl", "models/props_wasteland/prison_sinkchunk001e.mdl", "models/props_wasteland/prison_sinkchunk001f.mdl", "models/props_wasteland/prison_sinkchunk001g.mdl", "models/props_wasteland/prison_sinkchunk001h.mdl", "models/props_wasteland/prison_slidingdoor001a.mdl", "models/props_wasteland/prison_sprinkler001a.mdl", "models/props_wasteland/prison_sprinkler001b.mdl", "models/props_wasteland/prison_switchbox001a.mdl", "models/props_wasteland/prison_throwswitchbase001.mdl", "models/props_wasteland/prison_throwswitchlever001.mdl", "models/props_wasteland/prison_toilet01.mdl", "models/props_wasteland/prison_toiletchunk01a.mdl", "models/props_wasteland/prison_toiletchunk01b.mdl", "models/props_wasteland/prison_toiletchunk01c.mdl", "models/props_wasteland/prison_toiletchunk01d.mdl", "models/props_wasteland/prison_toiletchunk01e.mdl", "models/props_wasteland/prison_toiletchunk01f.mdl", "models/props_wasteland/prison_toiletchunk01g.mdl", "models/props_wasteland/prison_toiletchunk01h.mdl", "models/props_wasteland/prison_toiletchunk01i.mdl", "models/props_wasteland/prison_toiletchunk01j.mdl", "models/props_wasteland/prison_toiletchunk01k.mdl", "models/props_wasteland/prison_toiletchunk01l.mdl", "models/props_wasteland/prison_toiletchunk01m.mdl", "models/props_wasteland/prison_wallpile002a.mdl", "models/props_wasteland/rockcliff01b.mdl", "models/props_wasteland/rockcliff01c.mdl", "models/props_wasteland/rockcliff01e.mdl", "models/props_wasteland/rockcliff01f.mdl", "models/props_wasteland/rockcliff01g.mdl", "models/props_wasteland/rockcliff01j.mdl", "models/props_wasteland/rockcliff01k.mdl", "models/props_wasteland/rockcliff05a.mdl", "models/props_wasteland/rockcliff05b.mdl", "models/props_wasteland/rockcliff05e.mdl", "models/props_wasteland/rockcliff05f.mdl", "models/props_wasteland/rockcliff06d.mdl", "models/props_wasteland/rockcliff06i.mdl", "models/props_wasteland/rockcliff07b.mdl", "models/props_wasteland/rockcliff_cluster01b.mdl", "models/props_wasteland/rockcliff_cluster02a.mdl", "models/props_wasteland/rockcliff_cluster02b.mdl", "models/props_wasteland/rockcliff_cluster02c.mdl", "models/props_wasteland/rockcliff_cluster03a.mdl", "models/props_wasteland/rockcliff_cluster03b.mdl", "models/props_wasteland/rockcliff_cluster03c.mdl", "models/props_wasteland/rockgranite01a.mdl", "models/props_wasteland/rockgranite01b.mdl", "models/props_wasteland/rockgranite01c.mdl", "models/props_wasteland/rockgranite02a.mdl", "models/props_wasteland/rockgranite02b.mdl", "models/props_wasteland/rockgranite02c.mdl", "models/props_wasteland/rockgranite03a.mdl", "models/props_wasteland/rockgranite03b.mdl", "models/props_wasteland/rockgranite03c.mdl", "models/props_wasteland/rockgranite04a.mdl", "models/props_wasteland/rockgranite04b.mdl", "models/props_wasteland/rockgranite04c.mdl", "models/props_wasteland/shower_system001a.mdl", "models/props_wasteland/speakercluster01a.mdl", "models/props_wasteland/tram_bracket01.mdl", "models/props_wasteland/tram_lever01.mdl", "models/props_wasteland/tram_leverbase01.mdl", "models/props_wasteland/tugtop001.mdl", "models/props_wasteland/tugtop002.mdl", "models/props_wasteland/wheel01.mdl", "models/props_wasteland/wheel01a.mdl", "models/props_wasteland/wheel02a.mdl", "models/props_wasteland/wheel02b.mdl", "models/props_wasteland/wheel03a.mdl", "models/props_wasteland/wheel03b.mdl", "models/props_wasteland/woodwall030b_window01a.mdl", "models/props_wasteland/woodwall030b_window01a_bars.mdl", "models/props_wasteland/woodwall030b_window02a.mdl", "models/props_wasteland/woodwall030b_window02a_bars.mdl", "models/props_wasteland/woodwall030b_window03a.mdl", "models/props_wasteland/woodwall030b_window03a_bars.mdl", "models/props_wasteland/wood_fence01a.mdl", "models/props_wasteland/wood_fence01b.mdl", "models/props_wasteland/wood_fence01c.mdl", "models/props_wasteland/wood_fence02a.mdl", "models/props_wasteland/wood_fence02a_board01a.mdl", "models/props_wasteland/wood_fence02a_board03a.mdl", "models/props_wasteland/wood_fence02a_board04a.mdl", "models/props_wasteland/wood_fence02a_board05a.mdl", "models/props_wasteland/wood_fence02a_board07a.mdl", "models/props_wasteland/wood_fence02a_board08a.mdl", "models/props_wasteland/wood_fence02a_board09a.mdl", "models/props_wasteland/wood_fence02a_board10a.mdl", "models/props_wasteland/wood_fence02a_shard01a.mdl"}
    local Props_vehicles = {"models/props_vehicles/apc001.mdl", "models/props_vehicles/apc_tire001.mdl", "models/props_vehicles/car001a_hatchback.mdl", "models/props_vehicles/car001a_phy.mdl", "models/props_vehicles/car001b_hatchback.mdl", "models/props_vehicles/car001b_phy.mdl", "models/props_vehicles/car002a.mdl", "models/props_vehicles/car002a_physics.mdl", "models/props_vehicles/car002b.mdl", "models/props_vehicles/car002b_physics.mdl", "models/props_vehicles/car003a.mdl", "models/props_vehicles/car003a_physics.mdl", "models/props_vehicles/car003b.mdl", "models/props_vehicles/car003b_physics.mdl", "models/props_vehicles/car004a.mdl", "models/props_vehicles/car004a_physics.mdl", "models/props_vehicles/car004b.mdl", "models/props_vehicles/car004b_physics.mdl", "models/props_vehicles/car005a.mdl", "models/props_vehicles/car005a_physics.mdl", "models/props_vehicles/car005b.mdl", "models/props_vehicles/car005b_physics.mdl", "models/props_vehicles/carparts_axel01a.mdl", "models/props_vehicles/carparts_door01a.mdl", "models/props_vehicles/carparts_muffler01a.mdl", "models/props_vehicles/carparts_tire01a.mdl", "models/props_vehicles/carparts_wheel01a.mdl", "models/props_vehicles/generatortrailer01.mdl", "models/props_vehicles/tanker001a.mdl", "models/props_vehicles/tire001a_tractor.mdl", "models/props_vehicles/tire001b_truck.mdl", "models/props_vehicles/tire001c_car.mdl", "models/props_vehicles/trailer001a.mdl", "models/props_vehicles/trailer002a.mdl", "models/props_vehicles/truck001a.mdl", "models/props_vehicles/truck002a_cab.mdl", "models/props_vehicles/truck003a.mdl", "models/props_vehicles/van001a.mdl", "models/props_vehicles/van001a_physics.mdl", "models/props_vehicles/wagon001a.mdl", "models/props_vehicles/wagon001a_phy.mdl"}
    local Props_canal = {"models/props_canal/boat001a.mdl", "models/props_canal/boat001a_chunk01.mdl", "models/props_canal/boat001a_chunk010.mdl", "models/props_canal/boat001a_chunk02.mdl", "models/props_canal/boat001a_chunk03.mdl", "models/props_canal/boat001a_chunk04.mdl", "models/props_canal/boat001a_chunk05.mdl", "models/props_canal/boat001a_chunk06.mdl", "models/props_canal/boat001a_chunk07.mdl", "models/props_canal/boat001a_chunk08.mdl", "models/props_canal/boat001a_chunk09.mdl", "models/props_canal/boat001b.mdl", "models/props_canal/boat001b_chunk01.mdl", "models/props_canal/boat001b_chunk02.mdl", "models/props_canal/boat001b_chunk03.mdl", "models/props_canal/boat001b_chunk04.mdl", "models/props_canal/boat001b_chunk05.mdl", "models/props_canal/boat001b_chunk06.mdl", "models/props_canal/boat001b_chunk07.mdl", "models/props_canal/boat001b_chunk08.mdl", "models/props_canal/boat002b.mdl", "models/props_canal/boxcar_door.mdl", "models/props_canal/bridge_pillar02.mdl", "models/props_canal/canalmap001.mdl", "models/props_canal/canal_bars001.mdl", "models/props_canal/canal_bars001b.mdl", "models/props_canal/canal_bars001c.mdl", "models/props_canal/canal_bars002.mdl", "models/props_canal/canal_bars002b.mdl", "models/props_canal/canal_bars003.mdl", "models/props_canal/canal_bars004.mdl", "models/props_canal/canal_bridge01.mdl", "models/props_canal/canal_bridge01b.mdl", "models/props_canal/canal_bridge02.mdl", "models/props_canal/canal_bridge03a.mdl", "models/props_canal/canal_bridge03b.mdl", "models/props_canal/canal_bridge03c.mdl", "models/props_canal/canal_bridge04.mdl", "models/props_canal/canal_bridge_railing01.mdl", "models/props_canal/canal_bridge_railing02.mdl", "models/props_canal/canal_bridge_railing_lamps.mdl", "models/props_canal/canal_cap001.mdl", "models/props_canal/generator01.mdl", "models/props_canal/generator02.mdl", "models/props_canal/locks_large.mdl", "models/props_canal/locks_large_b.mdl", "models/props_canal/locks_small.mdl", "models/props_canal/locks_small_b.mdl", "models/props_canal/manhackmatt_doorslider.mdl", "models/props_canal/mattpipe.mdl", "models/props_canal/pipe_bracket001.mdl", "models/props_canal/refinery_01_skybox.mdl", "models/props_canal/refinery_02_skybox.mdl", "models/props_canal/refinery_03.mdl", "models/props_canal/refinery_03_skybox.mdl", "models/props_canal/refinery_04.mdl", "models/props_canal/refinery_05.mdl", "models/props_canal/refinery_05_skybox.mdl", "models/props_canal/rock_riverbed01a.mdl", "models/props_canal/rock_riverbed01b.mdl", "models/props_canal/rock_riverbed01c.mdl", "models/props_canal/rock_riverbed01d.mdl", "models/props_canal/rock_riverbed02a.mdl", "models/props_canal/rock_riverbed02b.mdl", "models/props_canal/rock_riverbed02c.mdl", "models/props_canal/winch01.mdl", "models/props_canal/winch01b.mdl", "models/props_canal/winch02.mdl", "models/props_canal/winch02b.mdl", "models/props_canal/winch02c.mdl", "models/props_canal/winch02d.mdl"}

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