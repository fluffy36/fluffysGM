net.Receive("CorruptedPropsAmount", function()
    local CorruptedPropsAmount = net.ReadFloat()
end)

concommand.Add("flgm_checkcorruptedpropsamount", function()
    print(CorruptedPropsAmount)
end)