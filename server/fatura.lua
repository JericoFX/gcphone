--
--  LEAKED BY S3NTEX -- 
--  https://discord.gg/aUDWCvM -- 
--  fivemleak.com -- 
--  fkn crew -- 
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
        else
          --[[   TriggerEvent("esx_addonaccount:getSharedAccount", f, function(j)
                if b.getAccount("bank").money >= g then
                    exports['ghmattimysql']:execute("DELETE from billing WHERE id = @id", {["@id"] = a}, function(i)
                        local k = ESX.Math.Round(g / 100 * 10)
                        local l = ESX.Math.Round(g / 100 * 90)
                        if h ~= nil then h.Functions.AddMoney("bank", k)
                        end;
                        b.Functions.RemoveMoney("bank", g)
                        j.Functions.AddMoney("bank"l)
                        TriggerClientEvent("esx:showNotification", b.source, _U("payed_bill_complete") .. g)
                        TriggerClientEvent("gcPhone:updateFaturalar", b.source)
                        if h ~= nil then
                            TriggerClientEvent("esx:showNotification", h.source, _U("payed_bill_target") .. k)
                        end
                    end)
                else TriggerClientEvent("esx:showNotification", b.source, _U("not_enough_money"))
                end
            end) ]]
        end
    end)
end)
