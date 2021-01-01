
RSCore.Functions.CreateCallback("gcPhone:getCars", function(a, b)
    local c = RSCore.Functions.GetPlayer(a)
    MySQL.Async.fetchAll("SELECT * FROM player_vehicles WHERE steam = @cid", {["@cid"] = c.PlayerData.steam}, function(d)
        print(d.plate)
        local e = {} for f, g in ipairs(d) do
            table.insert(e, {["garage"] = g["state"], ["plate"] = g["plate"], ["props"] = json.decode(g["mods"])})
        end;
        b(e)
    end)
end)
RegisterServerEvent("gcPhone:finish")
AddEventHandler("gcPhone:finish", function(a)
    local b = source;
    local c = RSCore.Functions.GetPlayer(b)
    TriggerClientEvent("RSCore:Notify", b, Config.valetPrice .. _U("valet_succ"))
    c.Functions.RemoveMoney("bank", Config.valetPrice)
end)
RegisterServerEvent("gcPhone:valet-car-set-outside")
AddEventHandler("gcPhone:valet-car-set-outside", function(a)
    local b = source;
    local c = RSCore.Functions.GetPlayer(b)
    if c then
        MySQL.Async.insert("UPDATE player_vehicles SET state = @stored WHERE plate = @plate", {["@plate"] = a, ["@stored"] = 2})
    end
end)
