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
 
     setPlayerName(playerName)
     setBankBalance(playerData)
 end)


 RegisterNetEvent('crew-phone:updata-transfer')
 AddEventHandler('crew-phone:updata-transfer', function()
     SendNUIMessage({event = 'updateBankbalance', banking = bank})
 end)
 
 RegisterNUICallback('transfer', function(data)
   
     TriggerServerEvent('gcPhone:transfer', data.to, data.amount)
 end)
 
 RegisterNUICallback('checkBank', function()
     FXCore.Functions.TriggerCallback('crew-phone:check-bank', function(cb)
         SendNUIMessage({event = 'updateBankHistory', history = cb})
     end)
 end)
 
 function setBankBalance (value)
     bank = value
     SendNUIMessage({event = 'updateBankbalance', banking = bank})
 end
 
 RegisterNetEvent('crew:getPlayerBank1')
 AddEventHandler('crew:getPlayerBank1', function(playerData)

     setBankBalance(playerData)
 end)
