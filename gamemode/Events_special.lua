local CorruptedPropsAmount = GetConVar("flgm_CorruptedPropsAmount")

concommand.Add("flgm_checkcorruptedpropsamount", function()
    print(CorruptedPropsAmount)
end)