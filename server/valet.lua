RSCore.Functions.CreateCallback("gcPhone:getCarsByPlate", function(a, b,plate)
    local c = RSCore.Functions.GetPlayer(a)
   -- print(plate)
    exports['ghmattimysql']:execute("SELECT hash FROM player_vehicles WHERE plate = @cid", {["@cid"] = plate}, function(d)
        --print(d.plate)
       -- print(plate)
       -- tprint(d[1])
        if d[1] ~= nil then
           -- print("PLATE FROM CAR "..d[1].vehicle)

        b(d[1].hash)
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
RSCore.Functions.CreateCallback("gcPhone:getCars", function(a, b)
    local c = RSCore.Functions.GetPlayer(a)
    exports['ghmattimysql']:execute("SELECT * FROM player_vehicles WHERE steam = @cid", {["@cid"] = c.PlayerData.steam}, function(d)
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
    local c = RSCore.Functions.GetPlayer(b)
    TriggerClientEvent("RSCore:Notify", b, Config.valetPrice .. _U("valet_succ"))
    c.Functions.RemoveMoney("bank", Config.valetPrice)
end)
RegisterServerEvent("gcPhone:valet-car-set-outside")
AddEventHandler("gcPhone:valet-car-set-outside", function(a)
    local b = source;
    local c = RSCore.Functions.GetPlayer(b)
    if c then
        exports['ghmattimysql']:execute("UPDATE player_vehicles SET state = @stored WHERE plate = @plate", {["@plate"] = a, ["@stored"] = 2})
    end
end)
