
FXCore.Functions.CreateCallback("crew:getBills", function(a, b)
    local c = FXCore.Functions.GetPlayer(a)
    exports['ghmattimysql']:execute("SELECT amount, id, target, label FROM billing WHERE identifier = @identifier", {["@identifier"] = c.PlayerData.steam}, function(d)
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
        local h = FXCore.Functions.GetPlayer(d)

        if e == "player" then if h.PlayerData.steam ~= nil then
            if b.PlayerData.money.bank >= g then
                exports['ghmattimysql']:execute("DELETE from billing WHERE id = @id", {["@id"] = a}, function(i)
                    b.Functions.RemoveMoney("bank", g)
                    h.Functions.AddMoney("bank", g)
                    TriggerClientEvent(Config.CoreNotify, b.PlayerData.source, _U("paying_bill"))
                    TriggerClientEvent(Config.CoreNotify, h.PlayerData.source, _U("payed_bill"))
                    TriggerClientEvent("gcPhone:updateFaturalar", b.source) end)
            end
        end
        end
    end)
end)

RegisterServerEvent('gcPhone_billing:sendBill')
AddEventHandler('gcPhone_billing:sendBill', function(playerId, label, amount)
    local xPlayer = FXCore.Functions.GetPlayer(source)
    local xTarget = FXCore.Functions.GetPlayer(playerId)
    if amount > 0 and xTarget then
        exports['ghmattimysql']:execute('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (@identifier, @sender, @target_type, @target, @label, @amount)', {
                    ['@identifier'] = xTarget.PlayerData.steam,
                    ['@sender'] = xPlayer.PlayerData.steam,
                    ['@target_type'] = 'player',
                    ['@target'] = xPlayer.PlayerData.steam,
                    ['@label'] = label,
                    ['@amount'] = amount
                }, function(rowsChanged)
                    TriggerClientEvent(Core.Notify,xTarget.PlayerData.source,"ENVOICE RECIVED")
                end)
    end
end)