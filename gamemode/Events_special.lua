include("lua/entities/weapons/flgm_tool")

concommand.Add("flgm_checkcorruptedpropsamount", function()
    print(_G.CorruptedPropsAmount)
end)