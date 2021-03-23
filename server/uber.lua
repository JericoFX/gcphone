RegisterServerEvent("esx_uber:pay")
AddEventHandler("esx_uber:pay",function(a)
    local b=source;
    local c=FXCore.Functions.GetPlayer(b)
    c.Functions.AddMoney("cash",tonumber(a))
end)


RegisterServerEvent("uber:esyaSil")
AddEventHandler("uber:esyaSil",function(a)
    local b=source;
    local c=FXCore.Functions.GetPlayer(b)
    c.Functions.RemoveItem(a,1)
end)