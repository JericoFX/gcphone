--
--  LEAKED BY S3NTEX -- 
--  https://discord.gg/aUDWCvM -- 
--  fivemleak.com -- 
--  fkn crew -- 
RSCore.Functions.CreateCallback("gcPhone:getCrypto",function(a,b,c)
    local d=RSCore.Functions.Getplayer(a)
    if not d then 
        return 
    end;
    exports['ghmattimysql']:execute("SELECT crypto FROM users WHERE identifier = @identifier",{["@identifier"]=d.identifier},function(e)
        b(json.decode(e[1].crypto)[c])
    end)
end)

RegisterServerEvent("gcPhone:buyCrypto")
AddEventHandler("gcPhone:buyCrypto",function(a,b,c,d)
    local e=RSCore.Functions.Getplayer(source)
    local f=ESX.Math.Round(c)
    if not e then
         return 
        end;
         local g={}
         exports['ghmattimysql']:execute("SELECT crypto FROM users WHERE identifier = @identifier",{["@identifier"]=e.identifier},function(h)
            if f<0 then f=f*-1 
            end;
            g=json.decode(h[1].crypto)
            if a==1 then 
                if e.getAccount("bank").money>=d*f then 
                    e.removeAccountMoney("bank",d*f)g[b]=g[b]+f;
                    TriggerClientEvent("updateCrypto",e.source,b)
                else 
                    e.showNotification(_U("not_enough_money"))
                end 
            elseif a==2 then 
                if g[b]>=f then 
                    e.addAccountMoney("bank",d*f)g[b]=g[b]-f;
                    TriggerClientEvent("updateCrypto",e.source,b)
                else 
                    e.showNotification(_U("not_enough_coin")..b)
                end 
            else print("phone coin error because SOB LilBecha"..e.identifier)
                return 
            end;
            exports['ghmattimysql']:execute("UPDATE users SET crypto = @crypto WHERE identifier = @identifier",{["@identifier"]=e.identifier,["@crypto"]=json.encode(g)})
        end)
    end)
