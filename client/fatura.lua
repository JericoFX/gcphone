RegisterNetEvent('gcPhone:updateFaturalar')
AddEventHandler('gcPhone:updateFaturalar', function()
  RSCore.Functions.TriggerCallback('crew:getBills', function(bills)
      setFaturalar(bills)
  end)
end)

RegisterNetEvent('crewPhone:updateHistory')
AddEventHandler('crewPhone:updateHistory', function(bank)
    RSCore.Functions.TriggerCallback('crew-phone:check-bank', function(cb)
        SendNUIMessage({event = 'updateBankHistory', history = cb})
    end)
end)

RegisterNUICallback('faturapayBill', function (data, cb)
  TriggerServerEvent('gcPhone:faturapayBill', data)
  cb()
end)

RegisterNUICallback('getFaturalar', function (data, cb)
  TriggerEvent('gcPhone:updateFaturalar')
  cb()
end)


function setFaturalar(faturalar)
  SendNUIMessage({event = 'updateFaturalar', faturalar = faturalar})
end
