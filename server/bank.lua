--
--  LEAKED BY S3NTEX -- 
--  https://discord.gg/aUDWCvM -- 
--  fivemleak.com -- 
--  fkn crew -- 
RegisterServerEvent("gcPhone:transfer")
AddEventHandler("gcPhone:transfer", function(a, b)
    local c = source;
    local d = RSCore.Functions.GetPlayer(c)
    local z = RSCore.Functions.GetIdentifier(a,"steam")
    local e = RSCore.Functions.GetPlayer(z)
    local f = 0;
    if e ~= nil then
        f = d.PlayerData.money.bank
        zbalance = e.PlayerData.money.bank
        if tonumber(c) == tonumber(a) then
            TriggerClientEvent("RSCore:Notify", c, _U("send_yourself"))
        else
            if f <= 0 or f < tonumber(b) or tonumber(b) <= 0 then
                TriggerClientEvent("RSCore:Notify", c, _U("send_yourself"))
            else
                d.Functions.RemoveMoney("bank", tonumber(b))
                e.Functions.AddMoney("bank", tonumber(b))
                TriggerClientEvent("RSCore:Notify", c, "$" .. b .. _U("bank_sending"))
                TriggerClientEvent("RSCore:Notify", a, "$" .. b .. _U("bank_incoming"))
                MySQL.Async.fetchAll("SELECT * FROM players WHERE steam = @identifier", {["@identifier"] = z}, function(g)
                    if g[1] then
                        print(tostring(g[1]))
                        
                        local jugador2 = RSCore.Functions.GetPlayer(g[1].steam)
                        local h = jugador2.PlayerData.charinfo.firstname .. " " .. jugador2.PlayerData.charinfo.lastname; MySQL.Async.fetchAll("INSERT INTO crew_phone_bank (type, identifier, price, name) VALUES (@type, @identifier, @price, @name)", {["@type"] = 1, ["@identifier"] = d.PlayerData.steam, ["@price"] = b, ["@name"] = h}, function(i)TriggerClientEvent("crewPhone:updateHistory", d.PlayerData.source)
                            end)
                    end
                end)
                MySQL.Async.fetchAll("SELECT * FROM players WHERE steam = @identifier", {["@identifier"] = d.PlayerData.steam}, function(g)
                    if g[1] then
                        local jugador2 = RSCore.Functions.GetPlayer(g[1].steam)
                        local h = jugador2.PlayerData.charinfo.firstname .. " " .. jugador2.PlayerData.charinfo.lastname;
                         MySQL.Async.fetchAll("INSERT INTO crew_phone_bank (type, identifier, price, name) VALUES (@type, @identifier, @price, @name)", {["@type"] = 2, ["@identifier"] = e.PlayerData.steam, ["@price"] = b, ["@name"] = h}, function(j)
                            TriggerClientEvent("crewPhone:updateHistory", e.PlayerData.source)
                            end)
                    end
                end)
            end
        end
   else
        TriggerClientEvent("RSCore:Notify", c, _U("no_player_id"))
    end 
end)
RSCore.Functions.CreateCallback("crew-phone:check-bank", function(a, b)
    local c = a;
    local d = RSCore.Functions.GetPlayer(c)
    MySQL.Async.fetchAll("SELECT * FROM crew_phone_bank WHERE identifier = @identifier ORDER BY time DESC LIMIT 5", {["@identifier"] = d.PlayerData.steam}, function(e)
        print("49 E FROM BANK IS ")
        b(e)

        end)
end)
RSCore.Functions.CreateCallback("crew-phone:check-bank-money", function(a, b)
    local c = a;
    local d = RSCore.Functions.GetPlayer(c)
   -- print("58 E FROM BANK IS "..d.PlayerData.money.bank)
    MySQL.Async.fetchAll("SELECT * FROM crew_phone_bank WHERE identifier = @identifier ORDER BY time DESC LIMIT 5", {["@identifier"] = d.PlayerData.steam}, function(e)
        b(e)
        end)
end)

