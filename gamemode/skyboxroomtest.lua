if CLIENT then return end

local ROOM_ORIGIN = Vector(0, 0, 12692)

local function CreateWall(pos, ang, scale)
    local ent = ents.Create("prop_physics")
    if not IsValid(ent) then return end

    ent:SetModel("models/hunter/plates/plate8x8.mdl")
    ent:SetPos(pos)
    ent:SetAngles(ang)
    ent:SetModelScale(scale, 0)

    ent:Spawn()

    local phys = ent:GetPhysicsObject()
    if IsValid(phys) then
        phys:EnableMotion(false)
    end

    return ent
end

local function BuildPocketRoom()
    local size = 512

    CreateWall(
        ROOM_ORIGIN + Vector(0, 0, -size),
        Angle(0, 0, 0),
        1
    )

    CreateWall(
        ROOM_ORIGIN + Vector(0, 0, size),
        Angle(180, 0, 0),
        1
    )

    CreateWall(
        ROOM_ORIGIN + Vector(size, 0, 0),
        Angle(0, 90, 90),
        1
    )

    CreateWall(
        ROOM_ORIGIN + Vector(-size, 0, 0),
        Angle(0, -90, 90),
        1
    )

    CreateWall(
        ROOM_ORIGIN + Vector(0, size, 0),
        Angle(90, 0, 90),
        1
    )

    CreateWall(
        ROOM_ORIGIN + Vector(0, -size, 0),
        Angle(-90, 0, 90),
        1
    )

    local light = ents.Create("light_dynamic")
    if IsValid(light) then
        light:SetPos(ROOM_ORIGIN)
        light:SetKeyValue("brightness", "6")
        light:SetKeyValue("distance", "1000")
        light:SetKeyValue("_light", "255 255 255 255")
        light:Spawn()
        light:Fire("TurnOn")
    end

    print("[Pocket Room] Created at " .. tostring(ROOM_ORIGIN))
end

hook.Add("InitPostEntity", "CreatePocketRoom", function()
    timer.Simple(1, BuildPocketRoom)
end)

hook.Add("PlayerSay", "PocketRoomCommands", function(ply, text)
    text = string.lower(text)

    if text == "!tardis" then
        ply:SetPos(ROOM_ORIGIN + Vector(0, 0, 20))
        return ""
    end

    if text == "!exit_tardis" then
        ply:SetPos(Vector(0, 0, 100))
        return ""
    end
end)