AddCSLuaFile("fluffysgm/entities/weapons/flgm_tool.lua")


concommand.Add("flgm_checkcorruptedpropsamount", function()
    print(CorruptedPropsAmount)
end)