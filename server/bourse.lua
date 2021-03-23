
-- FXCore.Functions.CreateCallback("gcPhone:getCrypto",function(a,b,c)
--     local d=FXCore.Functions.Getplayer(a)
--     if not d then 
--         return 
--     end;
--     exports['ghmattimysql']:execute("SELECT crypto FROM users WHERE identifier = @identifier",{["@identifier"]=d.identifier},function(e)
--         b(json.decode(e[1].crypto)[c])
--     end)
-- end)

-- RegisterServerEvent("gcPhone:buyCrypto")
-- AddEventHandler("gcPhone:buyCrypto",function(a,b,c,d)
--     local e=FXCore.Functions.Getplayer(source)
--     local f=ESX.Math.Round(c)
--     if not e then
--          return 
--         end;
--          local g={}
--          exports['ghmattimysql']:execute("SELECT crypto FROM users WHERE identifier = @identifier",{["@identifier"]=e.identifier},function(h)
--             if f<0 then f=f*-1 
--             end;
--             g=json.decode(h[1].crypto)
--             if a==1 then 
--                 if e.getAccount("bank").money>=d*f then 
--                     e.removeAccountMoney("bank",d*f)g[b]=g[b]+f;
--                     TriggerClientEvent("updateCrypto",e.source,b)
--                 else 
--                     e.showNotification(_U("not_enough_money"))
--                 end 
--             elseif a==2 then 
--                 if g[b]>=f then 
--                     e.addAccountMoney("bank",d*f)g[b]=g[b]-f;
--                     TriggerClientEvent("updateCrypto",e.source,b)
--                 else 
--                     e.showNotification(_U("not_enough_coin")..b)
--                 end 
--             else print("phone coin error because SOB LilBecha"..e.identifier)
--                 return 
--             end;
--             exports['ghmattimysql']:execute("UPDATE users SET crypto = @crypto WHERE identifier = @identifier",{["@identifier"]=e.identifier,["@crypto"]=json.encode(g)})
--         end)
--     end)

FXCore.Functions.CreateCallback("gcPhone:getCrypto",function(a,b,c)
    local d=FXCore.Functions.GetPlayer(a)
    if not d then 
        return 
    end;
    exports['ghmattimysql']:execute("SELECT crypto FROM players WHERE citizenid = @identifier",{["@identifier"]=d.PlayerData.citizenid},function(e)
        b(json.decode(e[1].crypto)[c])
    end)
end)

RegisterServerEvent("gcPhone:buyCrypto")
AddEventHandler("gcPhone:buyCrypto",function(a,b,c,d)
    local e=FXCore.Functions.GetPlayer(source)
    local f=Round(c)
    if not e then
         return 
        end;
         local g={}
         exports['ghmattimysql']:execute("SELECT crypto FROM players WHERE citizenid = @identifier",{["@identifier"]=e.PlayerData.citizenid},function(h)
            if f<0 then f=f*-1 
            end;
            g=json.decode(h[1].crypto)
            if a==1 then 
                if e.PlayerData.money.bank>=d*f then 
                    e.Functions.RemoveMoney("bank",d*f)g[b]=g[b]+f;
                    TriggerClientEvent("updateCrypto",e.PlayerData.source,b)
                else 
                    TriggerClientEvent("FXCore:Notify",e.PlayerData.source,_U("not_enough_money"))
                end 
            elseif a==2 then 
                if g[b]>=f then 
                    e.Functions.AddMoney("bank",d*f) g[b]=g[b]-f;
                    TriggerClientEvent("updateCrypto",e.PlayerData.source,b)
                else 
                    TriggerClientEvent("FXCore:Notify",e.PlayerData.source,_U("not_enough_coin")..b)
                end 
            else print("phone coin error because SOB LilBecha"..e.PlayerData.citizenid)
                return 
            end;
            exports['ghmattimysql']:execute("UPDATE players SET crypto = @crypto WHERE citizenid = @identifier",{["@identifier"]=e.PlayerData.citizenid,["@crypto"]=json.encode(g)})
        end)
    end)
    Round = function(value, numDecimalPlaces)
        if numDecimalPlaces then
            local power = 10^numDecimalPlaces
            return math.floor((value * power) + 0.5) / (power)
        else
            return math.floor(value + 0.5)
        end
    end