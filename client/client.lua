
--[[


     ██╗███████╗██████╗ ██╗ ██████╗ ██████╗ ███████╗██╗  ██╗ ██╗ ██╗ ██████╗ ███████╗ ██╗██████╗ 
     ██║██╔════╝██╔══██╗██║██╔════╝██╔═══██╗██╔════╝╚██╗██╔╝████████╗╚════██╗██╔════╝███║╚════██╗
     ██║█████╗  ██████╔╝██║██║     ██║   ██║█████╗   ╚███╔╝ ╚██╔═██╔╝ █████╔╝███████╗╚██║ █████╔╝
██   ██║██╔══╝  ██╔══██╗██║██║     ██║   ██║██╔══╝   ██╔██╗ ████████╗ ╚═══██╗╚════██║ ██║██╔═══╝ 
╚█████╔╝███████╗██║  ██║██║╚██████╗╚██████╔╝██║     ██╔╝ ██╗╚██╔═██╔╝██████╔╝███████║ ██║███████╗
 ╚════╝ ╚══════╝╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═════╝ ╚═╝     ╚═╝  ╚═╝ ╚═╝ ╚═╝ ╚═════╝ ╚══════╝ ╚═╝╚══════╝
                                                                                                 

 ]]
-- Configuration
local KeyToucheCloseEvent = {
  { code = 172, event = 'ArrowUp' },
  { code = 173, event = 'ArrowDown' },
  { code = 174, event = 'ArrowLeft' },
  { code = 175, event = 'ArrowRight' },
  { code = 191, event = 'Enter' },
  { code = 194, event = 'Backspace' },
}

local KeyOpenClose = 288 -- F1
local KeyTakeCall = 38 -- E
local menuIsOpen = false
local contacts = {}
local messages = {}
local myPhoneNumber = ''
local isDead = false
local USE_RTC = false
local useMouse = false
local ignoreFocus = false
local takePhoto = false
local hasFocus = false

local PhoneInCall = {}
local currentPlaySound = false
local soundDistanceMax = 8.0
local TokoVoipID = nil
local telType = "white_phone"
local test = ""

FXCore = nil

Citizen.CreateThread(function()
	while FXCore == nil do
		TriggerEvent(Config.Core, function(obj) FXCore = obj end)
		Citizen.Wait(200)
  end
end)
--#Joe Szymkowicz

Citizen.CreateThread(function()
  while true do
      GLOBAL_PED = PlayerPedId()
      GLOBAL_PLYID = PlayerId()
      GLOBAL_SRVID = GetPlayerServerId(GLOBAL_PLYID)
      Wait(5000)
  end
end)


RegisterNUICallback('getAccessToken', function(data, cb)
  TriggerServerEvent("crew:getPlayerBank")
  FXCore.Functions.TriggerCallback('crewPhone:getAccessToken', function(token)
	test = token
    SendNUIMessage({event = "updateAccesToken", token = token})
    cb()
  end)


end)

RegisterNetEvent('crewPhone:refreshToken')
AddEventHandler('crewPhone:refreshToken', function(token)
  SendNUIMessage({event = "updateAccesToken", token = token})
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if takePhoto ~= true then
      if IsControlJustPressed(1, KeyOpenClose) then
        TooglePhone()
      end
      if menuIsOpen == true then
        for _, value in pairs(KeyToucheCloseEvent) do
          if IsControlJustPressed(1, value.code) then
            SendNUIMessage({keyUp = value.event})
          end
        end
        if hasFocus == ignoreFocus then

          local nuiFocus = not hasFocus
          SetNuiFocus(nuiFocus, nuiFocus)
          hasFocus = nuiFocus
        end
        if useMouse == false and hasFocus == true then

         SetNuiFocus(false, false)
          hasFocus = false
        end
      else
        if hasFocus == true then

          SetNuiFocus(false, false)
          hasFocus = false
        end
      end
    end
  end
end)


Citizen.CreateThread(function()
  local playerPed = PlayerPedId()
  while true do
    Citizen.Wait(10)
    if menuIsOpen then

      DisablePlayerFiring(GLOBAL_PED, true)
      SetPedCanPlayGestureAnims(GLOBAL_PED, false)

      DisableControlAction(0, 24, true) -- Attack
      DisableControlAction(0, 257, true) -- Attack 2
      DisableControlAction(0, 25, true) -- Aim
      DisableControlAction(0, 263, true) -- Melee Attack 1
      DisableControlAction(0, 56, true) -- F9

      DisableControlAction(0, 45, true) -- Reload
      DisableControlAction(0, 22, true) -- Jump
      DisableControlAction(0, 44, true) -- Cover
      DisableControlAction(0, 37, true) -- Select Weapon

      DisableControlAction(0, 289, true) -- F2
      DisableControlAction(0, 170, true) -- F3
      DisableControlAction(0, 167, true) -- F6

      DisableControlAction(0, 0, true) -- Disable changing view
      DisableControlAction(0, 26, true) -- Disable looking behind
      DisableControlAction(0, 73, true) -- Disable clearing animation
      DisableControlAction(2, 199, true) -- Disable pause screen
    end
  end
end)  

--====================================================================================
--  Active ou Deactive une application (appName => config.json)
--====================================================================================
RegisterNetEvent('gcPhone:setEnableApp')
AddEventHandler('gcPhone:setEnableApp', function(appName, enable)
  SendNUIMessage({event = 'setEnableApp', appName = appName, enable = enable })
end)

--====================================================================================
--  Gestion des appels fixe
--====================================================================================
function startFixeCall (fixeNumber)
  local number = ''
  DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 10)
  while (UpdateOnscreenKeyboard() == 0) do
    DisableAllControlActions(0);
    Wait(0);
  end
  if (GetOnscreenKeyboardResult()) then
    number =  GetOnscreenKeyboardResult()
  end
  if number ~= '' then
    TriggerEvent('gcphone:autoCall', number, {
      useNumber = fixeNumber
    })
    PhonePlayCall(true)
  end
end

function TakeAppel (infoCall)
  TriggerEvent('gcphone:autoAcceptCall', infoCall)
end

RegisterNetEvent("gcPhone:notifyFixePhoneChange")
AddEventHandler("gcPhone:notifyFixePhoneChange", function(_PhoneInCall)
  PhoneInCall = _PhoneInCall
end)

RegisterNetEvent("gcPhone:TgiannSes")
AddEventHandler("gcPhone:TgiannSes", function(phoneId)
  if GLOBAL_SRVID == tonumber(phoneId) then
--[[     FXCore.Functions.TriggerCallback('crew-phone:phone-check', function(durum)
      if durum ~= nil then ]]
        exports["xsound"]:Cal("iphonex.mp3", true)
        FXCore.Functions.Notify(_U('phone_ring'))
  --[[     end
    end) ]]
  end
end)

RegisterNetEvent("gcPhone:stop-call-sound")
AddEventHandler("gcPhone:stop-call-sound", function(phoneId)
   exports["xsound"]:Durdur()
end)

function PlaySoundJS (sound, volume)
  SendNUIMessage({ event = 'playSound', sound = sound, volume = volume })
end

function SetSoundVolumeJS (sound, volume)
  SendNUIMessage({ event = 'setSoundVolume', sound = sound, volume = volume})
end

function StopSoundJS (sound)
  SendNUIMessage({ event = 'stopSound', sound = sound})
end

RegisterNetEvent("gcPhone:forceOpenPhone")
AddEventHandler("gcPhone:forceOpenPhone", function(_myPhoneNumber)
  if menuIsOpen == false then
    TooglePhone()
  end
end)
 
--====================================================================================
--  Events
--====================================================================================

RegisterNetEvent('crew:updatePhone1')
AddEventHandler('crew:updatePhone1', function(source)

  local PlayerData = FXCore.Functions.GetPlayerData()
  FXCore.Functions.TriggerCallback("crew-phone:phone-number",function(number)
    myPhoneNumber = number
    if number ~= nil or number or number ~= 0 then
      SendNUIMessage({event = 'updateMyPhoneNumber', myPhoneNumber = myPhoneNumber})

    end
  
  
  end,PlayerData.citizenid)

  FXCore.Functions.TriggerCallback("crew-phone:phone-contacts",function(_contacts)
    contacts = _contacts
   
    
      SendNUIMessage({event = 'updateContacts', contacts = contacts})

    
  
  
  end,PlayerData)
  FXCore.Functions.TriggerCallback("crew-phone:phone-messages",function(allmessages)
    messages = allmessages
   
      
      SendNUIMessage({event = 'updateMessages', messages = messages})


  
  
  end,PlayerData)



end)

  

RegisterNetEvent("gcPhone:contactList")
AddEventHandler("gcPhone:contactList", function(_contacts)

  SendNUIMessage({event = 'updateContacts', contacts = _contacts})
  contacts = _contacts
end)

RegisterNetEvent("gcPhone:allMessage")
AddEventHandler("gcPhone:allMessage", function(allmessages)
  SendNUIMessage({event = 'updateMessages', messages = allmessages})
  messages = allmessages
end)

RegisterNetEvent("gcPhone:getBourse")
AddEventHandler("gcPhone:getBourse", function(bourse)
  SendNUIMessage({event = 'updateBourse', bourse = bourse})
end)



RegisterNetEvent("gcPhone:receiveMessage")
AddEventHandler("gcPhone:receiveMessage", function(message)
  SendNUIMessage({event = 'newMessage', message = message})
  table.insert(messages, message)
  print(message.owner)
  if message.owner == 0 then
   --[[  FXCore.Functions.TriggerCallback('crew-phone:phone-check', function(durum)
      if durum ~= nil then ]]
        local text = _U('new_one_message')
        if ShowNumberNotification == true then

          if message.transmitter == "police" or message.transmitter == "ambulance" then
            text = message.transmitter.. _U('new_message_hotline')
          else
            text = message.transmitter.. _U('new_message_normal')
          end
          for _,contact in pairs(contacts) do
            if contact.number == message.transmitter then
              text = contact.display .. _U('new_message_normal')
              break
            end
          end
        end

        FXCore.Functions.Notify(text,"success",5000)
        PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
        Citizen.Wait(300)
        PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
        Citizen.Wait(300)
        PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
   --[[    end
    end) ]]
  end
end)

--====================================================================================
--  Function client | Contacts
--====================================================================================
function addContact(display, num) 
    TriggerServerEvent('gcPhone:addContact', display, num)
end

function deleteContact(num) 
    TriggerServerEvent('gcPhone:deleteContact', num)
end
--====================================================================================
--  Function client | Messages
--====================================================================================
function sendMessage(num, message)
    TriggerServerEvent('gcPhone:sendMessage', num, message)
end

function deleteMessage(msgId)
  TriggerServerEvent('gcPhone:deleteMessage', msgId)
  for k, v in ipairs(messages) do 
    if v.id == msgId then
      table.remove(messages, k)
      SendNUIMessage({event = 'updateMessages', messages = messages})
      return
    end
  end
end

function deleteMessageContact(num)
  TriggerServerEvent('gcPhone:deleteMessageNumber', num)
end

function deleteAllMessage()
  TriggerServerEvent('gcPhone:deleteAllMessage')
end

function setReadMessageNumber(num)
  TriggerServerEvent('gcPhone:setReadMessageNumber', num)
  for k, v in ipairs(messages) do 
    if v.transmitter == num then
      v.isRead = 1
    end
  end
end

function requestAllMessages()
  TriggerServerEvent('gcPhone:requestAllMessages')
end

function requestAllContact()
  TriggerServerEvent('gcPhone:requestAllContact')
end

--====================================================================================
--  Function client | Appels
--====================================================================================
local aminCall = false
local inCall = false

RegisterNetEvent("gcPhone:waitingCall")
AddEventHandler("gcPhone:waitingCall", function(infoCall, initiator)
--[[   FXCore.Functions.TriggerCallback('crew-phone:phone-check', function(durum)
    if durum ~= nil then ]]
      SendNUIMessage({event = 'waitingCall', infoCall = infoCall, initiator = initiator})
      if initiator == true then
        PhonePlayCall()
        if menuIsOpen == false then
          TooglePhone()
        end
      end
 --[[    end
  end) ]]
end)

RegisterNetEvent("gcPhone:acceptCall")
AddEventHandler("gcPhone:acceptCall", function(infoCall, initiator)
  if inCall == false and USE_RTC == false then
    inCall = true
    if Config.UsingToko   then
      Config.UsingMumble = false
    exports['tokovoip_script']:setPlayerData(GetPlayerName(GLOBAL_PLYID), "call:channel", infoCall.id + 1120.00, true)
	  exports.tokovoip_script:addPlayerToRadio(infoCall.id + 1120.00)
    TokoVoipID = infoCall.id + 1120.00
  
    end
    if Config.UsingMumble then
    Config.UsingToko = false
    exports["mumble-voip"]:SetCallChannel(infoCall.id+1)

    end
  end
  if menuIsOpen == false then
    TooglePhone()
  end
  PhonePlayCall()
  SendNUIMessage({event = 'acceptCall', infoCall = infoCall, initiator = initiator})
end)

RegisterNetEvent("gcPhone:rejectCall")
AddEventHandler("gcPhone:rejectCall", function(infoCall)
  if inCall == true then
    inCall = false
   if Config.UsingToko   then
    Config.UsingMumble = false
    exports['tokovoip_script']:setPlayerData(GetPlayerName(GLOBAL_PLYID), "call:channel", 'nil', true)
  	exports.tokovoip_script:removePlayerFromRadio(TokoVoipID)
    TokoVoipID = nil
   end
    if Config.UsingMumble then
      Config.UsingToko = false
    exports["mumble-voip"]:SetCallChannel(0)
  end
  end
  PhonePlayText()
  SendNUIMessage({event = 'rejectCall', infoCall = infoCall})
end)

RegisterNetEvent("gcPhone:historiqueCall")
AddEventHandler("gcPhone:historiqueCall", function(historique)
  SendNUIMessage({event = 'historiqueCall', historique = historique})
end)

function startCall (phone_number, rtcOffer, extraData)
  TriggerServerEvent('gcPhone:startCall', phone_number, rtcOffer, extraData)
end

function acceptCall (infoCall, rtcAnswer)
  TriggerServerEvent('gcPhone:acceptCall', infoCall, rtcAnswer)
end

function rejectCall(infoCall)
  TriggerServerEvent('gcPhone:rejectCall', infoCall)
end

function ignoreCall(infoCall)
  TriggerServerEvent('gcPhone:ignoreCall', infoCall)
end

function requestHistoriqueCall() 
  TriggerServerEvent('gcPhone:getHistoriqueCall')
end

function appelsDeleteHistorique (num)
  TriggerServerEvent('gcPhone:appelsDeleteHistorique', num)
end

function appelsDeleteAllHistorique ()
  TriggerServerEvent('gcPhone:appelsDeleteAllHistorique')
end
  
--====================================================================================
--  Event NUI - Appels
--====================================================================================

RegisterNUICallback('startCall', function (data, cb)
  startCall(data.numero, data.rtcOffer, data.extraData)
  cb()
end)

RegisterNUICallback('acceptCall', function (data, cb)
  acceptCall(data.infoCall, data.rtcAnswer)
  cb()
end)

RegisterNUICallback('rejectCall', function (data, cb)
  rejectCall(data.infoCall)
  cb()
end)

RegisterNUICallback('ignoreCall', function (data, cb)
  ignoreCall(data.infoCall)
  cb()
end)

RegisterNUICallback('notififyUseRTC', function (use, cb)
  USE_RTC = use
  if USE_RTC == true and inCall == true then
    inCall = false
    --Citizen.InvokeNative(0xE036A705F989E049)
    exports['tokovoip_script']:setPlayerData(GetPlayerName(GLOBAL_PLYID), "call:channel", 'nil', true)
  	exports.tokovoip_script:removePlayerFromRadio(TokoVoipID)
	  TokoVoipID = nil
  end
  cb()
end)

RegisterNUICallback('onCandidates', function (data, cb)
  TriggerServerEvent('gcPhone:candidates', data.id, data.candidates)
  cb()
end)

RegisterNetEvent("gcPhone:candidates")
AddEventHandler("gcPhone:candidates", function(candidates)
  SendNUIMessage({event = 'candidatesAvailable', candidates = candidates})
end)

RegisterNetEvent('gcphone:autoCall')
AddEventHandler('gcphone:autoCall', function(number, extraData)
  if number ~= nil then
    SendNUIMessage({ event = "autoStartCall", number = number, extraData = extraData})
  end
end)

RegisterNetEvent('gcphone:autoCallNumber')
AddEventHandler('gcphone:autoCallNumber', function(data)
  TriggerEvent('gcphone:autoCall', data.number)
end)

RegisterNetEvent('gcphone:autoAcceptCall')
AddEventHandler('gcphone:autoAcceptCall', function(infoCall)
  SendNUIMessage({ event = "autoAcceptCall", infoCall = infoCall})
end)


RegisterNetEvent('gcphone:FixOnLoad')
AddEventHandler('gcphone:FixOnLoad', function()
  TriggerServerEvent('gcphone:AddJobSource', GLOBAL_SRVID)
  TriggerServerEvent('gcphone:onPlayerLoaded', GLOBAL_SRVID)

end)

--====================================================================================
--  Gestion des evenements NUI
--==================================================================================== 
RegisterNUICallback('log', function(data, cb)

  cb()
end)

RegisterNUICallback('focus', function(data, cb)
  cb()
end)

RegisterNUICallback('blur', function(data, cb)
  cb()
end)

RegisterNUICallback('reponseText', function(data, cb)
  local limit = data.limit or 255
  local title = data.title or ''
  local text = data.text or ''
  
  AddTextEntry('FMMC_KEY_TIP8', title)
  DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", text, "", "", "", limit)
  while (UpdateOnscreenKeyboard() == 0) do
      DisableAllControlActions(0);
      Wait(0);
  end
  if (GetOnscreenKeyboardResult()) then
      text = GetOnscreenKeyboardResult()
  end
  cb(json.encode({text = text}))
end)
--====================================================================================
--  Event - Messages
--====================================================================================
RegisterNUICallback('getMessages', function(data, cb)
  cb(json.encode(messages))
end)

RegisterNUICallback('sendMessage', function(data, cb)
  local player = PlayerPedId()
  local myPos = GetEntityCoords(player)
  if data.message == '%pos%' then

    data.message = 'GPS: ' .. myPos.x .. ', ' .. myPos.y
  end
if Config.CoreDispatch then
  exports['core_dispach']:addMessage(data.message,vector3(myPos),tostring(data.phoneNumber), 3000, 11, 5 )
end
  TriggerServerEvent('gcPhone:sendMessage', data.phoneNumber, data.message)

end)

RegisterNUICallback('deleteMessage', function(data, cb)
  deleteMessage(data.id)
  cb()
end)

RegisterNUICallback('deleteMessageNumber', function (data, cb)
  deleteMessageContact(data.number)
  cb()
end)

RegisterNUICallback('deleteAllMessage', function (data, cb)
  deleteAllMessage()
  cb()
end)

RegisterNUICallback('setReadMessageNumber', function (data, cb)
  setReadMessageNumber(data.number)
  cb()
end)
--====================================================================================
--  Event - Contacts
--====================================================================================
RegisterNUICallback('addContact', function(data, cb) 
  TriggerServerEvent('gcPhone:addContact', data.display, data.phoneNumber)
end)
RegisterNUICallback('updateContact', function(data, cb)
  TriggerServerEvent('gcPhone:updateContact', data.id, data.display, data.phoneNumber)
end)
RegisterNUICallback('deleteContact', function(data, cb)
  TriggerServerEvent('gcPhone:deleteContact', data.id)
end)
RegisterNUICallback('getContacts', function(data, cb)
  cb(json.encode(data.contact))
end)
RegisterNUICallback('setGPS', function(data, cb)
  SetNewWaypoint(tonumber(data.x), tonumber(data.y))
  cb()
end)

-- Add security for event (leuit#0100)
RegisterNUICallback('callEvent', function(data, cb)
  local eventName = data.eventName or ''
  if string.match(eventName, 'gcphone') then
    if data.data ~= nil then 
      TriggerEvent(data.eventName, data.data)
    else
      TriggerEvent(data.eventName)
    end
  else
    print('Event not allowed')
  end
  cb()
end)
RegisterNUICallback('useMouse', function(um, cb)
  useMouse = um
end)
RegisterNUICallback('deleteALL', function(data, cb)
  TriggerServerEvent('gcPhone:deleteALL')
  cb()
end)

function TooglePhone()
      changePhoneType(durum)
      menuIsOpen = not menuIsOpen
      SendNUIMessage({show = menuIsOpen})
      if menuIsOpen == true then 
        PhonePlayIn()
      else
        PhonePlayOut()
      end

  
end

RegisterNUICallback('faketakePhoto', function(data, cb)
  menuIsOpen = false
  SendNUIMessage({show = false})
  cb()
  TriggerEvent('camera:open')
end)

RegisterNUICallback('closePhone', function(data, cb)
  menuIsOpen = false
  SendNUIMessage({show = false})
  PhonePlayOut()
  cb()
end)

----------------------------------
---------- GESTION APPEL ---------
----------------------------------
RegisterNUICallback('appelsDeleteHistorique', function (data, cb)
  appelsDeleteHistorique(data.numero)
  cb()
end)
RegisterNUICallback('appelsDeleteAllHistorique', function (data, cb)
  appelsDeleteAllHistorique(data.infoCall)
  cb()
end)


----------------------------------
---------- GESTION VIA WEBRTC ----
----------------------------------
 AddEventHandler('onResourceStart', function(resource)
  if resource == GetCurrentResourceName() then
    NetworkSetTalkerProximity(0) --# RESET THE VOICE TO 0 SO YOU CAN´T HEAR EVERYONE IN THE SERVER
  end
end)

RegisterNUICallback('setIgnoreFocus', function (data, cb)
  ignoreFocus = data.ignoreFocus
  cb()
end)
RegisterNetEvent("SENDMESSAGE")
AddEventHandler("SENDMESSAGE",function()
  TriggerServerEvent('gcPhone:sendMessage', "555641", "misteeeeer!!!!!")
end)
RegisterNUICallback('takePhoto', function(data, cb)
	CreateMobilePhone(1)
  CellCamActivate(true, true)
  takePhoto = true
  Citizen.Wait(0)
  if hasFocus == true then
    SetNuiFocus(false, false)
    hasFocus = false
  end
	while takePhoto do
    Citizen.Wait(0)

		if IsControlJustPressed(1, 27) then -- Toogle Mode
			frontCam = not frontCam
			CellFrontCamActivate(frontCam)
    elseif IsControlJustPressed(1, 177) then -- CANCEL
      DestroyMobilePhone()
      CellCamActivate(false, false)
      cb(json.encode({ url = nil }))
      takePhoto = false
      break
    elseif IsControlJustPressed(1, 176) then -- TAKE.. PIC
          if Config.Discord == nil or Config.Discord and Config.Discord == "" then
            print("YOU NEED TO PUT THE WEBHOOK IN THE CONFIG NOW!")
            return
          else
            exports['screenshot-basic']:requestScreenshotUpload(Config.Discord, "files[]", function(data)
              local image = json.decode(data)
              DestroyMobilePhone()
              CellCamActivate(false, false)
              cb(json.encode({ url = image.attachments[1].proxy_url }))
            end)
          end
      takePhoto = false
		end
		HideHudComponentThisFrame(7)
		HideHudComponentThisFrame(8)
		HideHudComponentThisFrame(9)
		HideHudComponentThisFrame(6)
		HideHudComponentThisFrame(19)
    HideHudAndRadarThisFrame()
  end
  Citizen.Wait(1000)
  PhonePlayAnim('text', false, true)
end)