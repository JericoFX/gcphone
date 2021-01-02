--[[


     ██╗███████╗██████╗ ██╗ ██████╗ ██████╗ ███████╗██╗  ██╗ ██╗ ██╗ ██████╗ ███████╗ ██╗██████╗ 
     ██║██╔════╝██╔══██╗██║██╔════╝██╔═══██╗██╔════╝╚██╗██╔╝████████╗╚════██╗██╔════╝███║╚════██╗
     ██║█████╗  ██████╔╝██║██║     ██║   ██║█████╗   ╚███╔╝ ╚██╔═██╔╝ █████╔╝███████╗╚██║ █████╔╝
██   ██║██╔══╝  ██╔══██╗██║██║     ██║   ██║██╔══╝   ██╔██╗ ████████╗ ╚═══██╗╚════██║ ██║██╔═══╝ 
╚█████╔╝███████╗██║  ██║██║╚██████╗╚██████╔╝██║     ██╔╝ ██╗╚██╔═██╔╝██████╔╝███████║ ██║███████╗
 ╚════╝ ╚══════╝╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═════╝ ╚═╝     ╚═╝  ╚═╝ ╚═╝ ╚═╝ ╚═════╝ ╚══════╝ ╚═╝╚══════╝
                                                                                                 

 ]]


local bank = 0
--[[ function setBankBalance (value)
      bank = value
      SendNUIMessage({event = 'updateBankbalance', banking = bank})
end ]]

local societyMoney = 0
function setSocietyBalance (value)
    print("Called! 9")
      societyMoney = value
      SendNUIMessage({event = 'updateSocietyBalance', society = societyMoney})
end

local name = ""
function setPlayerName (value)
      name = value
      SendNUIMessage({event = 'updatePlayerName', name = name})
end

RegisterNetEvent('crew:getPlayerBank')
AddEventHandler('crew:getPlayerBank', function(playerData, playerName)
    print("Called! 21")
    setPlayerName(playerName)
    setBankBalance(playerData)
end)


--[[ RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
        setBankBalance(account)
end) ]]

RegisterNetEvent("es:addedBank")
AddEventHandler("es:addedBank", function(m)
    setBankBalance(bank + m)
end)

RegisterNetEvent("es:removedBank")
AddEventHandler("es:removedBank", function(m)
    setBankBalance(bank - m)
end)

RegisterNetEvent('es:displayBank')
AddEventHandler('es:displayBank', function(bank)
    setBankBalance(bank)
end)

RegisterNetEvent('crew-phone:updata-transfer')
AddEventHandler('crew-phone:updata-transfer', function()
    SendNUIMessage({event = 'updateBankbalance', banking = bank})
end)

RegisterNUICallback('transfer', function(data)
  
    TriggerServerEvent('gcPhone:transfer', data.to, data.amount)
end)

RegisterNUICallback('checkBank', function()
    RSCore.Functions.TriggerCallback('crew-phone:check-bank', function(cb)
        SendNUIMessage({event = 'updateBankHistory', history = cb})
    end)
end)

function setBankBalance (value)
    bank = value
    SendNUIMessage({event = 'updateBankbalance', banking = bank})
end