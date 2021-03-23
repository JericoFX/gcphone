
FXCore.Functions.CreateCallback("crew:getBills", function(a, b)
    local c = FXCore.Functions.GetPlayer(a)
    exports['ghmattimysql']:execute("SELECT amount, id, target, label FROM billing WHERE identifier = @identifier", {["@identifier"] = c.PlayerData.citizenid}, function(d)
        b(d)
    end)
end)

RegisterServerEvent("gcPhone:faturapayBill")
AddEventHandler("gcPhone:faturapayBill", function(a)
    local b = FXCore.Functions.GetPlayer(source)
    exports['ghmattimysql']:execute("SELECT * FROM billing WHERE id = @id", {["@id"] = a}, function(c)
        local d = c[1].sender;
        local e = c[1].target_type;
        local f = c[1].target;
        local g = c[1].amount;
        local h = FXCore.Functions.GetPlayerByCitizenId(d)

        if e == "player" then 
            if h.PlayerData.citizenid ~= nil then
            if b.PlayerData.money.bank >= g then
                exports['ghmattimysql']:execute("DELETE from billing WHERE id = @id", {["@id"] = a}, function(i)
                    b.Functions.RemoveMoney("bank", g)
                    local h1 = b.PlayerData.charinfo.firstname .. " " .. b.PlayerData.charinfo.lastname
                  --  h.Functions.AddMoney("bank", g)
                  --  local h2 = ;
                    TriggerClientEvent(Config.CoreNotify, b.PlayerData.source, _U("paying_bill"))
                    TriggerClientEvent(Config.CoreNotify, h.PlayerData.source, _U("payed_bill"))
                    TriggerClientEvent("gcPhone:updateFaturalar", b.PlayerData.source,"JERICO!")


                end)
               -- TriggerClientEvent("crew:crew-phone:bankmoney",source,b.PlayerData.money.bank)
                exports['ghmattimysql']:execute("INSERT INTO crew_phone_bank (type, identifier, price, name) VALUES (@type, @identifier, @price, @name)", {["@type"] = 2, ["@identifier"] = b.PlayerData.citizenid, ["@price"] = g, ["@name"] = h.PlayerData.charinfo.firstname .. " " .. h.PlayerData.charinfo.lastname})
                TriggerClientEvent("crewPhone:updateHistory", h.PlayerData.source,"JERICO2!")
                end
        end
        end
    end)
end)

RegisterServerEvent('gcPhone_billing:sendBill') --# CREDITS TO ESX BILLING
AddEventHandler('gcPhone_billing:sendBill', function(playerId, label, amount,type)
    local xPlayer = FXCore.Functions.GetPlayer(source)
    local xTarget = FXCore.Functions.GetPlayer(playerId)
    if amount > 0 and xTarget  then
        exports['ghmattimysql']:execute('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (@identifier, @sender, @target_type, @target, @label, @amount)', {
                    ['@identifier'] = xTarget.PlayerData.citizenid,
                    ['@sender'] = xPlayer.PlayerData.citizenid,
                    ['@target_type'] = type,
                    ['@target'] = xPlayer.PlayerData.citizenid,
                    ['@label'] = label,
                    ['@amount'] = amount
                }, function(rowsChanged)
                    TriggerClientEvent(Config.CoreNotify,xTarget.PlayerData.source,"INVOICE RECEIVED")
                end)
    end
end)

FXCore.Commands.Add("billmenu", "Factura Menu", {}, false, function(source, args)
    TriggerClientEvent('jerico:factura',source)
end)


FXCore.Functions.CreateCallback("crew:getBillsByPlayer", function(source, b,a)
    local elements = {}
    local c = FXCore.Functions.GetPlayer(a)
    exports['ghmattimysql']:execute("SELECT amount, id, target, label FROM billing WHERE identifier = @identifier", {["@identifier"] = c.PlayerData.citizenid}, function(d)
        if d[1] ~= nil then
            table.insert(elements,{label = d[1].label,amount = d[1].amount})
            b(elements)
        else
            table.insert(elements,{label = "BILLS NOT FOUND",amount = 0})
            b(elements)
        end
    end)
end)