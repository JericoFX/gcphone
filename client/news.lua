local PlayerData = {}
local wait = 1000
local newsMenu = Config.newsBlip
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


RegisterNetEvent('jerico:news')
AddEventHandler('jerico:news', function()
    if PlayerJob.name == Config.newsJobName then
        OpenMenu()
    else
        FXCore.Functions.Notify("You don`t have the job")

    end
end)


OpenMenu = function()

    local assert = assert
    local MenuV = assert(MenuV)
    local menu = MenuV:CreateMenu("FX NEWS", 'News Menu', 'topleft', 255, 0, 0, 'size-125')

    menu.Theme = "native"
    menu.Position = "topright"
    menu.Color = {R=255,G=255,B=255}
    MenuV:OpenMenu(menu)

    local button = menu:AddButton({ icon = '😃', label = 'Post News', value = 10, description = 'Send the news to the phone' })
    local button1 = menu:AddButton({ icon = '😃', label = 'Erase News', value = 10, description = 'Erase News' })
    button:On("select",function()

        newNews()

    end)
    button1:On("select",function()


        newsDelete()

    end)

end

function newNews()

    local dialog
    local dialog1
    local dialog2
    local dialog3
    local dialog4

    local assert = assert
    local MenuV = assert(MenuV)
    local menu = MenuV:CreateMenu("FX NEWS", 'News Menu', 'topleft', 255, 0, 0, 'size-125')
    MenuV:OpenMenu(menu)
    menu.Theme = "Native"
    local checkbox = menu:AddCheckbox({ icon = '💡', label = "Title", value = 'n' })
    local checkbox1 = menu:AddCheckbox({ icon = '💡', label = "Content", value = 'n', disabled = false })
    local checkbox2 = menu:AddCheckbox({ icon = '💡', label ="IMG", value = 'n' , disabled = false })
    local button = menu:AddButton({ icon = '😃', label = 'Send News', value = 10, description = 'Send the news to the phone' })
    checkbox:On("check",function()
        -- dialog1 = LocalInput("news",30, "Titulo")
        TriggerEvent("Input:Open","Title","FXCore",function(p)
            local price = (p and tostring(p) and tostring(p) == "" )

            dialog1 = p

        end)


    end)
    checkbox1:On("check",function()
        TriggerEvent("Input:Open","Contenido","FXCore",function(p)
            local price = (p and tostring(p) and tostring(p) == "")

            dialog2 = p

        end)


    end)
    checkbox2:On("check",function()


        exports['screenshot-basic']:requestScreenshotUpload(Config.Discord, "files[]", function(data)
            local image = json.decode(data)
            DestroyMobilePhone()
            CellCamActivate(false, false)
           -- cb(json.encode({ url = image.attachments[1].proxy_url }))
            dialog3 = image.attachments[1].proxy_url
          end)

        -- TriggerEvent("Input:Open","URL IMAGE","FXCore",function(p)
        --     local price = (p and tostring(p) and tostring(p) == "")

            



      --  end)
    end)

    button:On("select",function()
        TriggerServerEvent("crew-phone:new-news", dialog1, dialog2, dialog3, "")
        MenuV:CloseMenu(menu)
    end)
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
function newsDelete()

    FXCore.Functions.TriggerCallback('crew-phone:get-news', function(news)
        local elements = {}
        for i=1, #news, 1 do
            table.insert(elements, {label = json.decode(news[i].alldata).name, value = json.decode(news[i].id)})
        end
        local assert = assert
        local MenuV = assert(MenuV)
        local menu = MenuV:CreateMenu("FX NEWS", 'Delete Menu', 'topleft', 255, 0, 0, 'size-125')
        MenuV:OpenMenu(menu)
        menu.Theme = "native"
        menu.Position = "topright"
        for k,v in ipairs(elements) do
            local button = menu:AddButton({ icon = '😃', label = v.label, value = v , description = v.label ,select = function(btn)
                local value = btn.Value
                menu.Title = "Delete News"..btn.Value.value
                if value.value == tonumber(value.value) then
                    FXCore.Functions.Notify("News Deleted")
                    TriggerServerEvent("crew-phone:delete-news", value.value)
                    MenuV:CloseMenu(menu)
                else
                    FXCore.Functions.Notify("News Not Deleted")
                end

            end})
        end

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

