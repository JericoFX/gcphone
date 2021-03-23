FXCore.Functions.CreateCallback("Jerico:GetCarByPLate", function(a, b,plate)
    local c = FXCore.Functions.GetPlayer(a)
   -- print(plate)
    exports['ghmattimysql']:execute("SELECT vehicle FROM player_vehicles WHERE plate = @cid", {["@cid"] = plate}, function(d)
        if d[1] ~= nil then
             b(d[1].vehicle)
        end
    end)
end)

function tprint (tbl, indent)
    if not indent then indent = 0 end
    for k, v in pairs(tbl) do
      formatting = string.rep("  ", indent) .. k .. ": "
      if type(v) == "table" then
        print(formatting)
        tprint(v, indent+1)
      elseif type(v) == 'boolean' then
        print(formatting .. tostring(v))      
      else
        print(formatting .. v)
      end
    end
  end
  
FXCore.Functions.CreateCallback("gcPhone:getCars", function(a, b)
    local c = FXCore.Functions.GetPlayer(a)
    exports['ghmattimysql']:execute("SELECT * FROM player_vehicles WHERE citizenid = '"..c.PlayerData.citizenid.."'", function(d)
        print(d.plate)
        local e = {} for f, g in ipairs(d) do
            table.insert(e, {["garage"] = g["state"], ["plate"] = g["plate"], ["props"] = json.decode(g["mods"]),["vehicle"]= g["vehicle"]})
        end;
        b(e)
    end)
end)

RegisterServerEvent("gcPhone:finish")
AddEventHandler("gcPhone:finish", function(a)
    local b = source;
    local c = FXCore.Functions.GetPlayer(b)
    TriggerClientEvent(Config.CoreNotify, b, Config.valetPrice .. _U("valet_succ"))
    c.Functions.RemoveMoney("bank", Config.valetPrice)
end)
print("BY JERICOFX THIS RESOURCE IS FREE https://github.com/JericoFX ")
RegisterServerEvent("gcPhone:valet-car-set-outside")
AddEventHandler("gcPhone:valet-car-set-outside", function(a)
    local b = source;
    local c = FXCore.Functions.GetPlayer(b)
    if c then
        exports['ghmattimysql']:execute("UPDATE player_vehicles SET state = @stored WHERE plate = @plate", {["@plate"] = a, ["@stored"] = 0})
    end
end)
