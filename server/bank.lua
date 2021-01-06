--
--  LEAKED BY S3NTEX -- 
--  https://discord.gg/aUDWCvM -- 
--  fivemleak.com -- 
--  fkn crew -- 
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
            TriggerClientEvent("FXCore:Notify", c, _U("send_yourself"))
        else
            if f <= 0 or f < tonumber(b) or tonumber(b) <= 0 then
                TriggerClientEvent("FXCore:Notify", c, _U("send_yourself"))
            else
                d.Functions.RemoveMoney("bank", tonumber(b))
                e.Functions.AddMoney("bank", tonumber(b))
                TriggerClientEvent("FXCore:Notify", c, "$" .. b .. _U("bank_sending"))
                TriggerClientEvent("FXCore:Notify", a, "$" .. b .. _U("bank_incoming"))
                exports['ghmattimysql']:execute("SELECT * FROM players WHERE steam = @identifier", {["@identifier"] = z}, function(g)
                    if g[1] then
                        
                        local jugador2 = FXCore.Functions.GetPlayer(g[1].steam)
                        local h = jugador2.PlayerData.charinfo.firstname .. " " .. jugador2.PlayerData.charinfo.lastname; exports['ghmattimysql']:execute("INSERT INTO crew_phone_bank (type, identifier, price, name) VALUES (@type, @identifier, @price, @name)", {["@type"] = 1, ["@identifier"] = d.PlayerData.steam, ["@price"] = b, ["@name"] = h}, function(i)TriggerClientEvent("crewPhone:updateHistory", d.PlayerData.source)
                            end)
                    end
                end)
                exports['ghmattimysql']:execute("SELECT * FROM players WHERE steam = @identifier", {["@identifier"] = d.PlayerData.steam}, function(g)
                    if g[1] then
                        local jugador2 = FXCore.Functions.GetPlayer(g[1].steam)
                        local h = jugador2.PlayerData.charinfo.firstname .. " " .. jugador2.PlayerData.charinfo.lastname;
                         exports['ghmattimysql']:execute("INSERT INTO crew_phone_bank (type, identifier, price, name) VALUES (@type, @identifier, @price, @name)", {["@type"] = 2, ["@identifier"] = e.PlayerData.steam, ["@price"] = b, ["@name"] = h}, function(j)
                            TriggerClientEvent("crewPhone:updateHistory", e.PlayerData.source)
                            end)
                    end
                end)
            end
        end
   else
        TriggerClientEvent("FXCore:Notify", c, _U("no_player_id"))
    end 
end)
FXCore.Functions.CreateCallback("crew-phone:check-bank", function(a, b)
    local c = a;
    local d = FXCore.Functions.GetPlayer(c)
    exports['ghmattimysql']:execute("SELECT * FROM crew_phone_bank WHERE identifier = @identifier ORDER BY time DESC LIMIT 5", {["@identifier"] = d.PlayerData.steam}, function(e)
        b(e)

        end)
end)
FXCore.Functions.CreateCallback("crew-phone:check-bank-money", function(a, b)
    local c = a;
    local d = FXCore.Functions.GetPlayer(c)
    exports['ghmattimysql']:execute("SELECT * FROM crew_phone_bank WHERE identifier = @identifier ORDER BY time DESC LIMIT 5", {["@identifier"] = d.PlayerData.steam}, function(e)
        b(e)
        end)
end)

