local PlayerData = {}
local wait = 1000
local newsMenu = Config.newsBlip
PlayerJob = {}

RegisterNetEvent('FXCore:Client:OnPlayerLoaded')
AddEventHandler('FXCore:Client:OnPlayerLoaded', function()

    PlayerJob = FXCore.Functions.GetPlayerData().job
  

    
end)

RegisterNetEvent('FXCore:Client:OnJobUpdate')
AddEventHandler('FXCore:Client:OnJobUpdate', function(JobInfo)

    PlayerJob = JobInfo

end)


RegisterNetEvent('newsmenu:new')
AddEventHandler('newsmenu:new', function()
    newNews()
end)

Citizen.CreateThread(function()

    local blip = AddBlipForCoord(newsMenu)
    SetBlipSprite (blip, 135)
    SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 0.7)
    SetBlipColour (blip, 49)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Weazel News")
    EndTextCommandSetBlipName(blip)
	
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(wait)
        if PlayerData.job and PlayerData.job.name == Config.newsJobName then 
            local playerPed = GetPlayerPed(-1)
            local playerPedCords = GetEntityCoords(playerPed)
            local distance = #(playerPedCords - newsMenu)
            if distance < 5.0 then
                wait = 10
                DrawMarker(20, newsMenu, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 0,0, 100, false, true, 2, false, false, false, false)
                if distance < 2.0 then
                    DrawText3D(newsMenu.x, newsMenu.y, newsMenu.z+0.60, "[E] Weazel News", 0.45)
                    if IsControlJustPressed(1, 38) then
                        
                        local elements = {}
                        table.insert(elements, {label = _U('publish_news'), value = "new_news"})	
                        table.insert(elements, {label = _U('delete_news'), value = "news_delete"})	
                        if PlayerData.job.grade == 1 then
                            table.insert(elements, {label = _U('news_boss_action'), value = "boss"})	
                        end
                        FXCore.UI.Menu.CloseAll()
                        FXCore.UI.Menu.Open('default', GetCurrentResourceName(), 'news_menu',
                        {
                            title    = 'Weazel News',
                            align    = 'top-right',
                            elements = elements,
                        }, function(data, menu)
                            menu.close()
                            if data.current.value == "new_news" then
                               newNews()
                            elseif data.current.value == "news_delete" then
                                newsDelete()
                            elseif data.current.value == "boss" then
                                TriggerEvent('FXCore_society:openBossMenu', 'news', function(data, menu)
                                    menu.close()
                                    CurrentAction     = 'menu_boss_actions'
                                    CurrentActionMsg  = _U('open_bossmenu')
                                    CurrentActionData = {}
                                end, { wash = false })
                            end
                            
                        end, function(data, menu)
                            menu.close()
                        end)

                    end
                end
            else
                wait = 1000
            end
        end
    end
end)


function newNews()
  --[[   local assert = assert
    local MenuV = assert(MenuV)
    local menu = MenuV:CreateMenu(false, 'Welcome to MenuV', 'topleft', 255, 0, 0, 'size-125')

    local checkbox = menu:AddCheckbox({ icon = '💡', label = _U('news_title'), value = 'n' })
    local checkbox1 = menu:AddCheckbox({ icon = '💡', label = _U('news_content'), value = 'n', disabled = true })
    local checkbox2 = menu:AddCheckbox({ icon = '💡', label =_U('news_img'), value = 'n' , disabled = true })
    local checkbox3 = menu:AddCheckbox({ icon = '💡', label = _U('news_video'), value = 'n', disabled = true  })

    checkbox:On("check",function()
        local dialog1 = LocalInput("news",30, _U('news_title'))
      
         checkbox1:On("check",function()
            if dialog1 ~= nil or dialog1 ~= "" or diaglo1 ~= 0 then
                local dialog2 = LocalInput("news",60, _U('news_content'))
                

            end
        
         end)
    end) ]]
--[[     checkbox:On("change",function()
        checkbox1 = menu:AddCheckbox({ icon = '💡', label = _U('news_content'), value = 'n', disabled = false })
    
    
    end) ]]


--[[ 


    if dialog2 ~= nil or dialog2 ~= "" or diaglo2 ~= 0 then
        local dialog3 = LocalInput("news",30, _U('news_img'))
        if dialog3 ~= nil or dialog3 ~= "" or diaglo3 ~= 0 then
            local dialog4 = LocalInput("news",30, _U('news_video'))
        if dialog4 ~= nil or dialog4 ~= "" or dialog4 ~= 0 then
            TriggerServerEvent("crew-phone:new-news", dialog1, dialog2, dialog3, dialog4)
        else
            TriggerServerEvent("crew-phone:new-news", dialog1, dialog2, dialog3, "")
        end
    end
    end
end ]]

    --[[ FXCore.UI.Menu.Open('dialog', GetCurrentResourceName(), 'news_name',
    {
        title = _U('news_title')
    },
    function(data, menu)
        menu.close()
        if data.value then
            FXCore.UI.Menu.Open('dialog', GetCurrentResourceName(), 'news_content',
            {
                title = _U('news_content')
            },
            function(data2, menu2)
                menu2.close()
                if data2.value then
                    FXCore.UI.Menu.Open('dialog', GetCurrentResourceName(), 'news_img',
                    {
                        title = _U('news_img')
                    },
                    function(data3, menu3)
                        menu3.close()
                        if data3.value then
                            FXCore.UI.Menu.Open('dialog', GetCurrentResourceName(), 'news_video',
                            {
                                title = _U('news_video')
                            },
                            function(data4, menu4)
                                menu4.close()
                                if data4.value then
                                    TriggerServerEvent("crew-phone:new-news", data.value, data2.value, data3.value, data4.value)
                                else
                                    TriggerServerEvent("crew-phone:new-news", data.value, data2.value, data3.value, "")
                                end
                            end, function(data4, menu4)
                                menu4.close()
                            end)   
                        else
                            FXCore.Functions.Notify(_U('news_no_image')) 
                        end
                    end, function(data3, menu3)
                        menu3.close()
                    end)
                else
                    FXCore.Functions.Notify(_U('news_no_content'))
                end
            end, function(data2, menu2)
                menu2.close()
            end)
        else
            FXCore.Functions.Notify(_U('news_no_title'))
        end
    end, function(data, menu)
        menu.close()
    end) ]]
end
function LocalInput(text, numeros, windoes) --SHOW ON SCREEN KEYBOARD FOR THE PRICE AND NAME
    DisplayOnscreenKeyboard(1, text or "FMMC_MPM_NA", "", windoes or "", "", "", "", numeros or 30)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0)
        Wait(0)
    end
    if (GetOnscreenKeyboardResult()) then
        local result = GetOnscreenKeyboardResult()
        return result
    end
end
function LocalInputInt(text, numeros, windoes) --SHOW ON SCREEN KEYBOARD FOR THE PRICE AND NAME BUT RETURN A NUMBER
   DisplayOnscreenKeyboard(1, text or "FMMC_MPM_NA", "", windoes or "", "", "", "", numeros or 30)
   while (UpdateOnscreenKeyboard() == 0) do
       DisableAllControlActions(0)
       Wait(0)
   end
   if (GetOnscreenKeyboardResult()) then
       local result = GetOnscreenKeyboardResult()
       return tonumber(result)
   end
end

--[[ Citizen.CreateThread(function()

    
       
    
	local assert = assert
	local menu = assert(MenuV)



	Manage = MenuV:CreateMenu('MenuV', 'Welcome to MenuV', 'topleft', 255, 0, 0, 'size-125', 'example', 'menuv', 'example_namespace', 'native')
	MenuV:OpenMenu(Manage, function()
	end)
    button = Manage:AddButton({ icon = "🧑‍🔧 ", "New News", value = 1 })
    button1 = Manage:AddButton({ icon = "🧑‍🔧 ", "Erase News", value = 1 })
    button:On("select",function()
    
        newNews()
    
    end)
    button1:On("select",function()
    
        newsDelete()
    
    end)




    Manage:OpenWith('keyboard', 'F6')

end) ]]

function newsDelete()
    FXCore.Functions.TriggerCallback('crew-phone:get-news', function(news)
        local elements = {}
        for i=1, #news, 1 do
            table.insert(elements, {label = json.decode(news[i].alldata).name, value = json.decode(news[i].id)})
        end

        FXCore.UI.Menu.Open('default', GetCurrentResourceName(), 'get_news', {
            title    = "Seçilen Haberi Sil",
            align    = 'top-left',
            elements = elements,
        }, function(data, menu)
            menu.close()
            if data.current.value then
                FXCore.UI.Menu.Open('dialog', GetCurrentResourceName(), 'news_video',
                {
                    title = _U('news_delete_message') .. data.current.value
                },
                function(data2, menu2)
                    menu2.close()
                    if data.current.value == tonumber(data2.value) then
                        FXCore.Functions.Notify(_U('news_deleted'))
                        TriggerServerEvent("crew-phone:delete-news", data.current.value)
                    else
                        FXCore.Functions.Notify(_U('news_not_deleted'))
                    end
                end, function(data2, menu2)
                    menu2.close()
                end)    
            end
        end, function(data, menu)
            menu.close()
        end)
    end)
end

function DrawText3D(x, y, z, text, scale)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local pX, pY, pZ = table.unpack(GetGameplayCamCoords())

	SetTextScale(scale, scale)
	SetTextFont(4)

	SetTextEntry("STRING")
	SetTextCentre(1)
	SetTextColour(255, 255, 255, 215)

	AddTextComponentString(text)
	DrawText(_x, _y)

	local factor = (string.len(text)) / 180
	DrawRect(_x, _y + 0.0150, 0.0 + factor, 0.035, 41, 11, 41, 100)
end

RegisterNUICallback('crew-phone:getNews', function(data, cb)
    FXCore.Functions.TriggerCallback('crew-phone:get-news', function(news)
        SendNUIMessage({event = 'news_updateNews', news = news})
    end)
end)

RegisterNUICallback('crewPhone:getWanted', function(data, cb)
    FXCore.Functions.TriggerCallback('crewPhone:getWanted', function(wanted)
        SendNUIMessage({event = 'updateWanted', wanted = wanted})
    end)
end)

