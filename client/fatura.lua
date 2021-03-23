PlayerJob = {}
RegisterNetEvent('FXCore:Client:OnPlayerLoaded')
AddEventHandler('FXCore:Client:OnPlayerLoaded', function()

    PlayerJob = FXCore.Functions.GetPlayerData().job
  --  NetworkSetTalkerProximity(0)

    
end)

RegisterNetEvent('FXCore:Client:OnJobUpdate')
AddEventHandler('FXCore:Client:OnJobUpdate', function(JobInfo)

    PlayerJob = JobInfo

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
  

RegisterNetEvent('gcPhone:updateFaturalar')
AddEventHandler('gcPhone:updateFaturalar', function()
  FXCore.Functions.TriggerCallback('crew:getBills', function(bills)

   
      setFaturalar(bills)
  end)
end)

RegisterNetEvent('crewPhone:updateHistory')
AddEventHandler('crewPhone:updateHistory', function(bank)
    FXCore.Functions.TriggerCallback('crew-phone:check-bank', function(cb)
       
        SendNUIMessage({event = 'updateBankHistory', history = cb})
    end)
end)

RegisterNUICallback('faturapayBill', function (data, cb)
    print(data)
  TriggerServerEvent('gcPhone:faturapayBill', data)
  cb()
end)

RegisterNUICallback('getFaturalar', function (data, cb)
    tprint(data)
  TriggerEvent('gcPhone:updateFaturalar')
  cb()
end)


function setFaturalar(faturalar)
   
  SendNUIMessage({event = 'updateFaturalar', faturalar = faturalar})
end


RegisterNetEvent('jerico:factura')
AddEventHandler('jerico:factura', function()
 for k,v in ipairs(Config.BillJobs) do
         if PlayerJob.name == v then
            OpenMenu1()
         else
            FXCore.Functions.Notify("You don`t have the job")

       end

     end
end)

OpenMenu1 = function()

    local assert    = assert
    local MenuV     = assert(MenuV)
    local jerico    = MenuV:CreateMenu("BILLING MENU", 'News Menu', 'topleft', 255, 0, 0, 'size-125')

    jerico.Theme    = "native"
    jerico.Position = "topright"
    jerico.Color    = { R = 255, G = 255, B = 255 }
    MenuV:OpenMenu(jerico)

    local button = jerico:AddButton({ icon = '💰', label = 'Create Bill', value = 10, description = 'Send Bill to the player' })
    button:On("select", function()

        newNews1()

    end)
    if PlayerJob.name == "police" then
        local button1 = jerico:AddButton({ icon = '💰', label = 'Get Bills from Player', value = 10, description = 'Get the Bills from a Player' })

        button1:On("select", function()

            GetBills()

        end)
    end

end

function newNews1()

    local dialog
    local dialog1
    local dialog2
    local dialog3
 

    local assert   = assert
    local MenuV    = assert(MenuV)
    local menu1    = MenuV:CreateMenu("Bill", 'Bill Menu', 'topleft', 255, 0, 0, 'size-125')
    menu1.Theme    = "native"
    menu1.Position = "topright"
    MenuV:OpenMenu(menu1)

    local checkbox  = menu1:AddCheckbox({ icon = '💡', label = "Player ID", value = 'n' })
    local checkbox1 = menu1:AddCheckbox({ icon = '💡', label = "Content", value = 'n', disabled = false })
    local checkbox2 = menu1:AddCheckbox({ icon = '💡', label = "Amount", value = 'n', disabled = false })
   -- local checkbox3 = menu1:AddCheckbox({ icon = '💡', label = "Type", value = 'n', disabled = false })
    local button    = menu1:AddButton({ icon = '💰', label = 'Send Bill', value = 10, description = 'Send Bill to the Player' })
    checkbox:On("check", function()
        TriggerEvent("Input:Open", "Player ID", "FXCore", function(p)
            local price = tonumber(p)

            dialog1     = price

        end)


    end)
    checkbox1:On("check", function()
        TriggerEvent("Input:Open", "Information", "FXCore", function(p)
            local price = (p and tostring(p) and tostring(p) == "")

            dialog2     = p

        end)


    end)
    checkbox2:On("check", function()
        TriggerEvent("Input:Open", "Amount", "FXCore", function(p)
            local price = tonumber(p)

            dialog3     = price


        end)
    end)



    button:On("select", function()
        TriggerServerEvent("gcPhone_billing:sendBill", dialog1, dialog2, dialog3)
        MenuV:CloseMenu(menu1)
    end)
end

function GetBills()

    local dialog3
    local assert   = assert
    local MenuV    = assert(MenuV)
    local menu2    = MenuV:CreateMenu("Bill", 'Bill Menu', 'topleft', 255, 0, 0, 'size-125')
    menu2.Theme    = "native"
    menu2.Position = "topright"
    MenuV:OpenMenu(menu2)

    local button4 = menu2:AddButton({ icon = '💰', label = 'Get Bills by Player ID', value = 10, description = 'Check Bills' })

    button4:On("select", function()

        TriggerEvent("Input:Open", "Player ID", "FXCore", function(p)
            local price = tonumber(p)

            dialog3     = price
            if dialog3 ~= nil then
                Wait(200)
                local menu3    = MenuV:CreateMenu("|Bills", 'Bill Menu', 'topleft', 255, 0, 0, 'size-125')
                menu3.Theme    = "native"
                menu3.Position = "topright"
                FXCore.Functions.TriggerCallback("crew:getBillsByPlayer", function(values)
                    MenuV:OpenMenu(menu3)
                    if values ~= nil then
                        for k, v in ipairs(values) do
                            local button = menu3:AddButton({ icon = '💰', label = v.label .. "   |   By the value of $" .. v.amount, value = v, description = 'Check Bills' })


                        end

                    end
                    local button1 = menu3:AddButton({ icon = '💰', label = "<<<<", value = menu2, description = 'Back' })
                end, dialog3)

            end
        end)


    end)


end