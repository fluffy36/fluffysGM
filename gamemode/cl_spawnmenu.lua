-- Force Garry's Mod to pull the engine's core spawnmenu framework files from sandbox
AddCSLuaFile( "sandbox/gamemode/spawnmenu/spawnmenu.lua" )
include( "sandbox/gamemode/spawnmenu/spawnmenu.lua" )

--[[---------------------------------------------------------
    If false is returned then the spawn menu is never created.
    This saves load times if your mod doesn't actually use the
    spawn menu for any reason.
-----------------------------------------------------------]]
function GM:SpawnMenuEnabled()
    return true
end

--[[---------------------------------------------------------
    Called when spawnmenu is trying to be opened.
    Return false to dissallow it.
-----------------------------------------------------------]]
function GM:SpawnMenuOpen()
    return true
end

function GM:SpawnMenuOpened()
    if self.SuppressHint then self:SuppressHint( "OpeningMenu" ) end
    if self.AddHint then
        self:AddHint( "OpeningContext", 20 )
        self:AddHint( "EditingSpawnlists", 5 )
    end
end

function GM:SpawnMenuClosed()
end

function GM:SpawnMenuCreated(spawnmenu)
end

--[[---------------------------------------------------------
    If false is returned then the context menu is never created.
    This saves load times if your mod doesn't actually use the
    context menu for any reason.
-----------------------------------------------------------]]
function GM:ContextMenuEnabled()
    return true
end

--[[---------------------------------------------------------
    Called when context menu is trying to be opened.
    Return false to dissallow it.
-----------------------------------------------------------]]
function GM:ContextMenuOpen()
    return true
end

function GM:ContextMenuOpened()
    if self.SuppressHint then self:SuppressHint( "OpeningContext" ) end
    if self.AddHint then self:AddHint( "ContextClick", 20 ) end
end

function GM:ContextMenuClosed()
end

function GM:ContextMenuCreated()
end

--[[---------------------------------------------------------
    Backwards compatibility. Do Not Use!!!
-----------------------------------------------------------]]
function GM:GetSpawnmenuTools( name )
    return spawnmenu.GetToolMenu( name )
end

--[[---------------------------------------------------------
    Backwards compatibility. Do Not Use!!!
-----------------------------------------------------------]]
function GM:AddSTOOL( category, itemname, text, command, controls, cpanelfunction )
    self:AddToolMenuOption( "Main", category, itemname, text, command, controls, cpanelfunction )
end

function GM:PreReloadToolsMenu()
end

function GM:AddGamemodeToolMenuTabs()

    -- This is named like this to force it to be the first tab
    spawnmenu.AddToolTab( "Main",      "#spawnmenu.tools_tab", "icon16/wrench.png" )
    spawnmenu.AddToolTab( "Utilities",  "#spawnmenu.utilities_tab", "icon16/page_white_wrench.png" )

end

function GM:AddToolMenuTabs()
    -- Hook me!
end


function GM:AddGamemodeToolMenuCategories()

    spawnmenu.AddToolCategory( "Main", "Constraints",   "#spawnmenu.tools.constraints" )
    spawnmenu.AddToolCategory( "Main", "Construction",  "#spawnmenu.tools.construction" )
    spawnmenu.AddToolCategory( "Main", "Poser",         "#spawnmenu.tools.posing" )
    spawnmenu.AddToolCategory( "Main", "Render",        "#spawnmenu.tools.render" )

end


function GM:AddToolMenuCategories()
    -- Hook this function to add custom stuff
end

function GM:PopulateToolMenu()
end

function GM:PostReloadToolsMenu()
end


function GM:PopulatePropMenu()

    spawnmenu.PopulateFromEngineTextFiles()

end


hook.Add( "SpawnMenuInitialize", "FLGM_ForceSpawnmenuPopulation", function()
    if GAMEMODE then
        GAMEMODE:AddGamemodeToolMenuTabs()
        GAMEMODE:AddToolMenuTabs()
        GAMEMODE:AddGamemodeToolMenuCategories()
        GAMEMODE:AddToolMenuCategories()
    end
end )