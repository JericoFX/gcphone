
RegisterServerEvent("gcPhone:transfer")
AddEventHandler("gcPhone:transfer", function(a, b)
    local c = source;
    local d = FXCore.Functions.GetPlayer(c)
    local z = FXCore.Functions.GetIdentifier(a,"steam")
    local e = FXCore.Functions.GetPlayer(z)
    local f = 0;
    if e ~= nil then
        f = d.PlayerData.money.bank
        zbalance = e.PlayerData.money.bank
        if tonumber(c) == tonumber(a) then
            TriggerClientEvent(Config.CoreNotify, c, _U("send_yourself"))
        else
            if f <= 0 or f < tonumber(b) or tonumber(b) <= 0 then
                TriggerClientEvent(Config.CoreNotify, c, _U("send_yourself"))
            else
                d.Functions.RemoveMoney("bank", tonumber(b))
                e.Functions.AddMoney("bank", tonumber(b))
                TriggerClientEvent(Config.CoreNotify, c, "$" .. b .. _U("bank_sending"))
                TriggerClientEvent(Config.CoreNotify, a, "$" .. b .. _U("bank_incoming"))
                exports['ghmattimysql']:execute("SELECT * FROM players WHERE steam = @identifier", {["@identifier"] = z}, function(g)

                    if g[1] then
                        local jugador2 = FXCore.Functions.GetPlayer(g[1].steam)
                        local h = jugador2.PlayerData.charinfo.firstname .. " " .. jugador2.PlayerData.charinfo.lastname
                        exports['ghmattimysql']:execute("INSERT INTO crew_phone_bank (type, identifier, price, name) VALUES (@type, @identifier, @price, @name)", {["@type"] = 1, ["@identifier"] = d.PlayerData.citizenid, ["@price"] = b, ["@name"] = h})
                        TriggerClientEvent("crewPhone:updateHistory", d.PlayerData.source)
                    end
                end)
                exports['ghmattimysql']:execute("SELECT * FROM players WHERE steam = @identifier", {["@identifier"] = d.PlayerData.citizenid}, function(g)
                    if g[1] then
                        local jugador2 = FXCore.Functions.GetPlayer(g[1].steam)
                        local h = jugador2.PlayerData.charinfo.firstname .. " " .. jugador2.PlayerData.charinfo.lastname
                         exports['ghmattimysql']:execute("INSERT INTO crew_phone_bank (type, identifier, price, name) VALUES (@type, @identifier, @price, @name)", {["@type"] = 2, ["@identifier"] = e.PlayerData.citizenid, ["@price"] = b, ["@name"] = h})
                        TriggerClientEvent("crewPhone:updateHistory", e.PlayerData.source)
                    end
                end)
            end
        end
   else
        TriggerClientEvent(Config.CoreNotify, c, _U("no_player_id"))
    end 
end)
FXCore.Functions.CreateCallback("crew-phone:check-bank", function(a, b)

    local c = a;
    local d = FXCore.Functions.GetPlayer(c)
    local money = d.PlayerData.money.bank
    TriggerClientEvent("crew:getPlayerBank1",d.PlayerData.source,money)
   exports['ghmattimysql']:execute("SELECT * FROM crew_phone_bank WHERE identifier = @identifier ORDER BY time DESC LIMIT 5", {["@identifier"] = d.PlayerData.citizenid}, function(e)
        b(e)

      end)
end)
FXCore.Functions.CreateCallback("crew-phone:check-bank-money", function(a, b)
    local c = a;
    local d = FXCore.Functions.GetPlayer(c)
    exports['ghmattimysql']:execute("SELECT * FROM crew_phone_bank WHERE identifier = @identifier ORDER BY time DESC LIMIT 5", {["@identifier"] = d.PlayerData.citizenid}, function(e)
        b(e)
    end)
end)

