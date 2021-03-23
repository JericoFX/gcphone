--[[


     ██╗███████╗██████╗ ██╗ ██████╗ ██████╗ ███████╗██╗  ██╗ ██╗ ██╗ ██████╗ ███████╗ ██╗██████╗ 
     ██║██╔════╝██╔══██╗██║██╔════╝██╔═══██╗██╔════╝╚██╗██╔╝████████╗╚════██╗██╔════╝███║╚════██╗
     ██║█████╗  ██████╔╝██║██║     ██║   ██║█████╗   ╚███╔╝ ╚██╔═██╔╝ █████╔╝███████╗╚██║ █████╔╝
██   ██║██╔══╝  ██╔══██╗██║██║     ██║   ██║██╔══╝   ██╔██╗ ████████╗ ╚═══██╗╚════██║ ██║██╔═══╝ 
╚█████╔╝███████╗██║  ██║██║╚██████╗╚██████╔╝██║     ██╔╝ ██╗╚██╔═██╔╝██████╔╝███████║ ██║███████╗
 ╚════╝ ╚══════╝╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═════╝ ╚═╝     ╚═╝  ╚═╝ ╚═╝ ╚═╝ ╚═════╝ ╚══════╝ ╚═╝╚══════╝
                                                                                                 

 ]]
FXCore = nil

TriggerEvent(Config.Core, function(obj) FXCore = obj end)
math.randomseed(os.time())
local JobPlayer = {}
FXCore.Functions.CreateCallback("crewPhone:getAccessToken",function(a,b)
    b(________)
end)

RegisterServerEvent("gcphone:onPlayerLoaded")
AddEventHandler("gcphone:onPlayerLoaded",function(source)
    
    local b=tonumber(source)
    local c=getPlayerID(b)
  --  print(c.PlayerData.charinfo.phone)
   TriggerClientEvent("crew:updatePhone1",source)
Wait(2000)

   getUserTwitterAccount(b,c)

end)
RegisterServerEvent("gcphone:AddJobSource")
AddEventHandler("gcphone:AddJobSource",function(source)

    local b=tonumber(source)
    local c=getPlayerID(b)
    table.insert(JobPlayer,{name = c,job = c.PlayerData.job.name})


end)



FXCore.Functions.CreateCallback('crew-phone:phone-contacts', function(source, cb)
    local xPlayer = FXCore.Functions.GetPlayer(source)
    if not xPlayer then return; end
    exports['ghmattimysql']:execute("SELECT * FROM phone_users_contacts WHERE identifier = @identifier", {
        ['@identifier'] = xPlayer.PlayerData.citizenid
    },function(result)
        cb(result)
    end)
 
end)
FXCore.Functions.CreateCallback('crew-phone:phone-sendHistoriqueCall', function(source, cb)
    local xPlayer = FXCore.Functions.GetPlayer(source)
    if not xPlayer then return; end
    
    cb(sendHistoriqueCall(source,xPlayer.PlayerData.citizenid))
end)
FXCore.Functions.CreateCallback('crew-phone:phone-messages', function(source, cb)
    local xPlayer = FXCore.Functions.GetPlayer(source)
    if not xPlayer then return; end
     exports['ghmattimysql']:execute("SELECT phone_messages_crew.*, '"..xPlayer.PlayerData.charinfo.phone.."' FROM phone_messages_crew LEFT JOIN players ON players.steam = @identifier WHERE phone_messages_crew.receiver = '"..xPlayer.PlayerData.charinfo.phone.."'", {
        ['@identifier'] = xPlayer.PlayerData.citizenid
   },function(result)

cb(result)

    end)
end)
     
FXCore.Functions.CreateCallback('crew-phone:phone-number', function(source, cb)
        local xPlayer = FXCore.Functions.GetPlayer(source)
        if not xPlayer then return; end
        
        cb(xPlayer.PlayerData.charinfo.phone)
end)

Citizen.CreateThread(function()

        exports['ghmattimysql']:execute('DELETE FROM phone_messages_crew WHERE transmitter = \'police\'')
        exports['ghmattimysql']:execute('DELETE FROM phone_messages_crew WHERE transmitter = \'ambulance\'')
        exports['ghmattimysql']:execute('DELETE FROM phone_messages_crew WHERE transmitter = \'news\'')
        exports['ghmattimysql']:execute('DELETE FROM phone_messages_crew WHERE transmitter = \'tow\'')


end)




--- Phone Number Style Config.lua FourDigit = true then generate 4 number else generate ####### number
function getPhoneRandomNumber()
    if Config.FourDigit then
        local numBase = math.random(1000,9999)
        num = string.format("%04d", numBase )
    else
        local numBase = math.random(1000000,9999999)
        num = string.format("%07d", numBase)
    end
	return num
end

--====================================================================================
--  Utils
--====================================================================================+
function GetJob(identifier, cb)
    local xPlayers = FXCore.Functions.GetPlayers()

    for k, user in pairs(xPlayers) do
        local jugador = FXCore.Functions.GetPlayer(user)
        if jugador.PlayerData.job.name == identifier.PlayerData.job.name then
            cb(user)
            return
        end
    end
    cb(nil)
end
function getSourceFromIdentifier(identifier, cb)
    local xPlayers = FXCore.Functions.GetPlayers()
    for k, user in pairs(xPlayers) do
        if FXCore.Functions.GetPlayer(user).PlayerData.citizenid == identifier.PlayerData.citizenid then
            cb(user)
            return
        end
    end
    cb(nil)
end

function getIdentifierByPhoneNumber(phone_number) 
 
    local player = FXCore.Functions.GetPlayerByPhone(phone_number)
    if player ~= nil then
    return player
    else
        return nil
    end
end

function getUserTwitterAccount(source, _identifier)
    local _source = source
    local identifier = _identifier
    local xPlayer = FXCore.Functions.GetPlayer(_source)
    print(identifier,identifier.PlayerData.citizenid)
    --exports['ghmattimysql']:execute("SELECT * FROM players WHERE citizenid = @identifier", {
       -- ['@identifier'] = identifier.PlayerData.citizenid
  --  }, function(result2)
      --  print(result2[1].citizenid)
      --  local user = result2[1]
      --  local player = FXCore.Functions.GetPlayer(user).PlayerData.citizenid

        if identifier == nil then 
            karakteribekle(xPlayer.PlayerData.source, identifier.PlayerData.citizenid)
        else
            local FirstLastName = identifier.PlayerData.charinfo['firstname'] .. ' ' .. identifier.PlayerData.charinfo['lastname']
            TriggerClientEvent('crew:getPlayerBank', _source, xPlayer.PlayerData.money.bank, FirstLastName)
            exports['ghmattimysql']:execute("SELECT * FROM twitter_accounts WHERE identifier = @identifier", {
                ['@identifier'] = identifier.PlayerData.citizenid
            }, function(result)
                if #result == 0  then
                    exports['ghmattimysql']:execute("INSERT INTO twitter_accounts (identifier, username) VALUES (@identifier, @username)", { 
                        ['@identifier'] = identifier.PlayerData.citizenid,
                        ['@username'] = FirstLastName
                    }, function()

                        TriggerEvent('gcPhone:twitter_login', _source, identifier.PlayerData.citizenid)
                    end)
                else

                    TriggerEvent('gcPhone:twitter_login', _source, result[1].identifier)

                end
            end)
        end
  --  end)
end

function karakteribekle(source, identifier)
    Citizen.Wait(60000)
    local _source = source
    local xidentifier = identifier
    getUserTwitterAccount(_source, xidentifier)
end

function getPlayerID(source)
    local xPlayer = FXCore.Functions.GetPlayer(source)
    return xPlayer
end

function getOrGeneratePhoneNumber (sourcePlayer, identifier, cb)
    local sourcePlayer = sourcePlayer
    local identifier = identifier

    local myPhoneNumber = identifier.PlayerData.charinfo.phone
    cb(myPhoneNumber)
end

--====================================================================================
--  Contacts
--====================================================================================
function getContacts(identifier,cb)

    exports['ghmattimysql']:execute("SELECT * FROM phone_users_contacts WHERE identifier = @identifier", {
        ['@identifier'] = identifier
    },function(result)
        return result
    end)

end


function addContact(source, identifier, number, display)
    local sourcePlayer = tonumber(source)
    exports['ghmattimysql']:execute("INSERT INTO phone_users_contacts (`identifier`, `number`,`display`) VALUES(@identifier, @number, @display)", {
        ['@identifier'] = identifier,
        ['@number'] = number,
        ['@display'] = display,
    },function()
        notifyContactChange(sourcePlayer, identifier)
    end)
end

function updateContact(source, identifier, id, number, display)
    local sourcePlayer = tonumber(source)
    exports['ghmattimysql']:execute("UPDATE phone_users_contacts SET number = @number, display = @display WHERE id = @id", { 
        ['@number'] = number,
        ['@display'] = display,
        ['@id'] = id,
    },function()
        notifyContactChange(sourcePlayer, identifier)
    end)
end

function deleteContact(source, identifier, id)

    local sourcePlayer = tonumber(source)
    exports['ghmattimysql']:execute("DELETE FROM phone_users_contacts WHERE `identifier` = @identifier AND `id` = @id", {
        ['@identifier'] = identifier,
        ['@id'] = id,
    })
    notifyContactChange(sourcePlayer, identifier)
end

function deleteAllContact(identifier)
    exports['ghmattimysql']:execute("DELETE FROM phone_users_contacts WHERE `identifier` = @identifier", {
        ['@identifier'] = identifier
    })
end

function notifyContactChange(source, identifier)
   
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(identifier)
    exports['ghmattimysql']:execute("SELECT * FROM phone_users_contacts WHERE identifier = @identifier", {
        ['@identifier'] = identifier.PlayerData.citizenid
    },function(result)
        TriggerClientEvent("gcPhone:contactList", sourcePlayer, result)
    end)

        

end

FXCore.Functions.CreateCallback('crew-phone:phone-check', function(source, cb)
    local xPlayer = FXCore.Functions.GetPlayer(source)
    if not xPlayer then return; end
    for k, v in pairs(Config.Phones) do
        local items = xPlayer.Functions.GetItemByName(v)
        if items.amount > 0 then
            cb(v)
            return
        end
	end
    cb(nil)
end)

FXCore.Functions.CreateCallback('crew-phone:item-check', function(source, cb, data)
    local xPlayer = FXCore.Functions.GetPlayer(source)
    if not xPlayer then return; end
    local items = xPlayer.Functions.GetItemByName(data)
    cb(items.amount)
end)

RegisterServerEvent('gcPhone:addContact')
AddEventHandler('gcPhone:addContact', function(display, phoneNumber)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(sourcePlayer)
    addContact(sourcePlayer, identifier.PlayerData.citizenid, phoneNumber, display)
end)

RegisterServerEvent('gcPhone:updateContact')
AddEventHandler('gcPhone:updateContact', function(id, display, phoneNumber)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(sourcePlayer)
    updateContact(sourcePlayer, identifier.PlayerData.citizenid, id, phoneNumber, display)
end)

RegisterServerEvent('gcPhone:deleteContact')
AddEventHandler('gcPhone:deleteContact', function(id)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(sourcePlayer)
    deleteContact(sourcePlayer, identifier.PlayerData.citizenid, id)
end)

--====================================================================================
--  Messages
--====================================================================================
function getMessages(identifier)
    local result = exports['ghmattimysql']:execute("SELECT phone_messages_crew.*, '"..identifier.PlayerData.charinfo.phone.."' FROM phone_messages_crew LEFT JOIN players ON players.steam = @identifier WHERE phone_messages_crew.receiver = '"..identifier.PlayerData.charinfo.phone.."'", {
         ['@identifier'] = identifier.PlayerData.citizenid
    })
    return result
end

RegisterServerEvent('gcPhone:_internalAddMessage')
AddEventHandler('gcPhone:_internalAddMessage', function(transmitter, receiver, message, owner, cb)
    cb(_internalAddMessage(transmitter, receiver, message, owner))
end)

function _internalAddMessage(transmitter, receiver, message, owner)

    exports['ghmattimysql']:execute("INSERT INTO phone_messages_crew (`transmitter`, `receiver`,`message`, `isRead`,`owner`) VALUES(@transmitter, @receiver, @message, @isRead, @owner)", {
        ['@transmitter'] = transmitter,
        ['@receiver'] = receiver,
        ['@message'] = message,
        ['@isRead'] = owner,
        ['@owner'] = owner
    })
    local data = {message = message, time = tonumber(os.time().."000.0"), receiver = receiver, transmitter = transmitter, owner = owner, isRead = owner}
    return data
end

function addMessage(source, identifier, phone_number, message)
   
    --local Player = FXCore.Functions.GetPlayer(source)
	local sourcePlayer    = tonumber(source)
	local otherIdentifier = getIdentifierByPhoneNumber(phone_number)
	local myPhone         = identifier.PlayerData.charinfo.phone
    if not Config.CoreDispatch then -- Thanks to TechnoBehemoth to help me fixing this stuff
	xPlayers              = FXCore.Functions.GetPlayers()
	for k, v in ipairs(xPlayers) do
		local Player = FXCore.Functions.GetPlayer(v)
		for j, l in ipairs(Config.SMSJobs) do
			if phone_number == l then
				if Player.PlayerData.job.name == l then
					local tomess = _internalAddMessage(myPhone, phone_number, message, 0)
					TriggerClientEvent("gcPhone:receiveMessage", Player.PlayerData.source, tomess)
				end
				local memess = _internalAddMessage(phone_number, myPhone, message, 1)
				TriggerClientEvent("gcPhone:receiveMessage", sourcePlayer, memess)
                 
            end
        end
    end
end
if otherIdentifier ~= nil then --if is a player run this
             
    local tomess = _internalAddMessage(myPhone, phone_number, message, 0)
    getSourceFromIdentifier(otherIdentifier, function (osou)
        if tonumber(osou) ~= nil then
            TriggerClientEvent("gcPhone:receiveMessage", tonumber(osou), tomess)
        end
     end)
   
    local memess = _internalAddMessage(phone_number, myPhone, message, 1)
    TriggerClientEvent("gcPhone:receiveMessage", sourcePlayer, memess)
   
    elseif phone_number == "Anonymous" then --here you can put anything, ex: if "anonymous send a message you will recive it like that"
    local tomess = _internalAddMessage(myPhone, "Anonymouse", message, 0)
    TriggerClientEvent("gcPhone:receiveMessage", sourcePlayer, tomess)
  
    else
            local tomess = _internalAddMessage(myPhone, phone_number, message, 0) -- no ID 
            TriggerClientEvent("gcPhone:receiveMessage", sourcePlayer, tomess)
    end
  
    
end

function setReadMessageNumber(identifier, num)
    local mePhoneNumber = identifier.PlayerData.charinfo.phone
    exports['ghmattimysql']:execute("UPDATE phone_messages_crew SET phone_messages_crew.isRead = 1 WHERE phone_messages_crew.receiver = @receiver AND phone_messages_crew.transmitter = @transmitter", { 
        ['@receiver'] = mePhoneNumber,
        ['@transmitter'] = num
    })
end

function deleteMessage(msgId)
    exports['ghmattimysql']:execute("DELETE FROM phone_messages_crew WHERE `id` = @id", {
        ['@id'] = msgId
    })
end

function deleteAllMessageFromPhoneNumber(source, identifier, phone_number)
    local source = source
    local identifier = identifier
    local mePhoneNumber = identifier.PlayerData.charinfo.phone
    exports['ghmattimysql']:execute("DELETE FROM phone_messages_crew WHERE `receiver` = @mePhoneNumber and `transmitter` = @phone_number", {
        ['@mePhoneNumber'] = mePhoneNumber,['@phone_number'] = phone_number
    })
end

function deleteAllMessage(identifier)
    local player = FXCore.Functions.GetPlayer(identifier)
    local mePhoneNumber = player.PlayerData.charinfo.phone
    exports['ghmattimysql']:execute("DELETE FROM phone_messages_crew WHERE `receiver` = @mePhoneNumber", {
        ['@mePhoneNumber'] = mePhoneNumber
    })
end

RegisterServerEvent('gcPhone:sendMessage')
AddEventHandler('gcPhone:sendMessage', function(phoneNumber, message)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(sourcePlayer)
    addMessage(sourcePlayer, identifier, phoneNumber, message)
end)

RegisterServerEvent('gcPhone:deleteMessage')
AddEventHandler('gcPhone:deleteMessage', function(msgId)
    deleteMessage(msgId)
end)

RegisterServerEvent('gcPhone:deleteMessageNumber')
AddEventHandler('gcPhone:deleteMessageNumber', function(number)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(sourcePlayer)
    deleteAllMessageFromPhoneNumber(sourcePlayer,identifier.PlayerData.citizenid, number)
end)

RegisterServerEvent('gcPhone:deleteAllMessage')
AddEventHandler('gcPhone:deleteAllMessage', function()
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(sourcePlayer)
    deleteAllMessage(identifier.PlayerData.citizenid)
end)

RegisterServerEvent('gcPhone:setReadMessageNumber')
AddEventHandler('gcPhone:setReadMessageNumber', function(num)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(sourcePlayer)
    setReadMessageNumber(identifier, num)
end)

RegisterServerEvent('gcPhone:deleteALL')
AddEventHandler('gcPhone:deleteALL', function()
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(sourcePlayer)
    deleteAllMessage(identifier.PlayerData.citizenid)
    deleteAllContact(identifier.PlayerData.citizenid)
    appelsDeleteAllHistorique(identifier.PlayerData.citizenid)
    TriggerClientEvent("gcPhone:contactList", sourcePlayer, {})
    TriggerClientEvent("gcPhone:allMessage", sourcePlayer, {})
    TriggerClientEvent("appelsDeleteAllHistorique", sourcePlayer, {})
end)

--====================================================================================
--  Gestion des appels
--====================================================================================
local AppelsEnCours = {}
local PhoneFixeInfo = {}
local lastIndexCall = 10

function getHistoriqueCall(num)
    local result = exports['ghmattimysql']:execute("SELECT * FROM phone_calls WHERE phone_calls.owner = @num ORDER BY time DESC LIMIT 30", {
        ['@num'] = num
    })
    return result
end

function sendHistoriqueCall(src, num) 
    local histo = getHistoriqueCall(num)
    TriggerClientEvent('gcPhone:historiqueCall', src, histo)
end

function saveAppels (appelInfo)
    if appelInfo.extraData == nil or appelInfo.extraData.useNumber == nil then
        exports['ghmattimysql']:execute("INSERT INTO phone_calls (`owner`, `num`,`incoming`, `accepts`) VALUES(@owner, @num, @incoming, @accepts)", {
            ['@owner'] = appelInfo.transmitter_num,
            ['@num'] = appelInfo.receiver_num,
            ['@incoming'] = 1,
            ['@accepts'] = appelInfo.is_accepts
        }, function()
            notifyNewAppelsHisto(appelInfo.transmitter_src, appelInfo.transmitter_num)
        end)
    end
    if appelInfo.is_valid == true then
        local num = appelInfo.transmitter_num
        if appelInfo.hidden == true then
            mun = "#######"
        end
        exports['ghmattimysql']:execute("INSERT INTO phone_calls (`owner`, `num`,`incoming`, `accepts`) VALUES(@owner, @num, @incoming, @accepts)", {
            ['@owner'] = appelInfo.receiver_num,
            ['@num'] = num,
            ['@incoming'] = 0,
            ['@accepts'] = appelInfo.is_accepts
        }, function()
            if appelInfo.receiver_src ~= nil then
                notifyNewAppelsHisto(appelInfo.receiver_src, appelInfo.receiver_num)
            end
        end)
    end
end

function notifyNewAppelsHisto (src, num) 
    sendHistoriqueCall(src, num)
end

RegisterServerEvent('gcPhone:getHistoriqueCall')
AddEventHandler('gcPhone:getHistoriqueCall', function()
    local sourcePlayer = tonumber(source)
    local srcIdentifier = getPlayerID(sourcePlayer)
    local srcPhone = srcIdentifier.PlayerData.charinfo.phone
    sendHistoriqueCall(sourcePlayer, num)
end)

RegisterServerEvent('gcPhone:internal_startCall')
AddEventHandler('gcPhone:internal_startCall', function(source, phone_number, rtcOffer, extraData)
    if FixePhone[phone_number] ~= nil then
        onCallFixePhone(source, phone_number, rtcOffer, extraData)
        return
    end
    
    local rtcOffer = rtcOffer
    if phone_number == nil or phone_number == '' then 

        return
    end

    local hidden = string.sub(phone_number, 1, 1) == '#'
    if hidden == true then
        phone_number = string.sub(phone_number, 2)
    end

    local indexCall = lastIndexCall
    lastIndexCall = lastIndexCall + 1

    local sourcePlayer = tonumber(source)
    local srcIdentifier = getPlayerID(sourcePlayer)

    local srcPhone = ''
    if extraData ~= nil and extraData.useNumber ~= nil then
        srcPhone = extraData.useNumber
    else
        srcPhone = srcIdentifier.PlayerData.charinfo.phone
    end
    local destPlayer = getIdentifierByPhoneNumber(phone_number)
    local is_valid = destPlayer ~= nil and destPlayer ~= srcIdentifier.PlayerData.citizenid
    AppelsEnCours[indexCall] = {
        id = indexCall,
        transmitter_src = sourcePlayer,
        transmitter_num = srcPhone,
        receiver_src = nil,
        receiver_num = phone_number,
        is_valid = destPlayer ~= nil,
        is_accepts = false,
        hidden = hidden,
        rtcOffer = rtcOffer,
        extraData = extraData
    }
    
    if is_valid == true then
        getSourceFromIdentifier(destPlayer, function (srcTo)
            if srcTo ~= nil then
                AppelsEnCours[indexCall].receiver_src = srcTo
                TriggerClientEvent('gcPhone:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
                TriggerClientEvent('gcPhone:waitingCall', srcTo, AppelsEnCours[indexCall], false) -- karşı oyuncuyu arama
                TriggerClientEvent('gcPhone:TgiannSes', -1, srcTo)
            else
                TriggerClientEvent('gcPhone:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
            end
        end)
    else
        TriggerClientEvent('gcPhone:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
    end
end)

RegisterServerEvent('gcPhone:startCall')
AddEventHandler('gcPhone:startCall', function(phone_number, rtcOffer, extraData)
    TriggerEvent('gcPhone:internal_startCall', source, phone_number, rtcOffer, extraData)
end)

RegisterServerEvent('gcPhone:candidates')
AddEventHandler('gcPhone:candidates', function (callId, candidates)
    if AppelsEnCours[callId] ~= nil then
        local source = source
        local to = AppelsEnCours[callId].transmitter_src
        if source == to then 
            to = AppelsEnCours[callId].receiver_src
        end
        TriggerClientEvent('gcPhone:candidates', to, candidates)
    end
end)

RegisterServerEvent('gcPhone:acceptCall')
AddEventHandler('gcPhone:acceptCall', function(infoCall, rtcAnswer)
    local id = infoCall.id
    if AppelsEnCours[id] ~= nil then
        if PhoneFixeInfo[id] ~= nil then
            onAcceptFixePhone(source, infoCall, rtcAnswer)
            return
        end
        AppelsEnCours[id].receiver_src = infoCall.receiver_src or AppelsEnCours[id].receiver_src
        if AppelsEnCours[id].transmitter_src ~= nil and AppelsEnCours[id].receiver_src ~= nil then
            AppelsEnCours[id].is_accepts = true
            AppelsEnCours[id].rtcAnswer = rtcAnswer
            TriggerClientEvent('gcPhone:acceptCall', AppelsEnCours[id].transmitter_src, AppelsEnCours[id], true)
            SetTimeout(1000, function()
                if AppelsEnCours[id].receiver_src ~= nil and AppelsEnCours[id] ~= nil then
                    TriggerClientEvent('gcPhone:acceptCall', AppelsEnCours[id].receiver_src, AppelsEnCours[id], false)
                end
            end)
            TriggerClientEvent("gcPhone:stop-call-sound", -1, AppelsEnCours[id].receiver_src)
            saveAppels(AppelsEnCours[id])
        end
    end
end)

RegisterServerEvent('gcPhone:rejectCall')
AddEventHandler('gcPhone:rejectCall', function (infoCall)
    local id = infoCall.id
    if AppelsEnCours[id] ~= nil then
        if PhoneFixeInfo[id] ~= nil then
            onRejectFixePhone(source, infoCall)
            return
        end
        if AppelsEnCours[id].transmitter_src ~= nil then
            TriggerClientEvent('gcPhone:rejectCall', AppelsEnCours[id].transmitter_src)
        end
        if AppelsEnCours[id].receiver_src ~= nil then
            TriggerClientEvent('gcPhone:rejectCall', AppelsEnCours[id].receiver_src)
        end

        if AppelsEnCours[id].is_accepts == false then 
            saveAppels(AppelsEnCours[id])
        end
        TriggerClientEvent("gcPhone:stop-call-sound", -1, AppelsEnCours[id].receiver_src)
        TriggerEvent('gcPhone:removeCall', AppelsEnCours)
        AppelsEnCours[id] = nil
    end
end)

RegisterServerEvent('gcPhone:appelsDeleteHistorique')
AddEventHandler('gcPhone:appelsDeleteHistorique', function (numero)
    local sourcePlayer = tonumber(source)
    local srcIdentifier = getPlayerID(sourcePlayer)
    local srcPhone = srcIdentifier.PlayerData.charinfo.phone
    exports['ghmattimysql']:execute("DELETE FROM phone_calls WHERE `owner` = @owner AND `num` = @num", {
        ['@owner'] = srcPhone,
        ['@num'] = numero
    })
end)

function appelsDeleteAllHistorique(srcIdentifier)
    local player = FXCore.Functions.GetPlayer(srcIdentifier)
    local srcPhone = player.PlayerData.charinfo.phone
    exports['ghmattimysql']:execute("DELETE FROM phone_calls WHERE `owner` = @owner", {
        ['@owner'] = srcPhone
    })
end

RegisterServerEvent('gcPhone:appelsDeleteAllHistorique')
AddEventHandler('gcPhone:appelsDeleteAllHistorique', function ()
    local sourcePlayer = tonumber(source)
    local srcIdentifier = getPlayerID(sourcePlayer)
    appelsDeleteAllHistorique(srcIdentifier.PlayerData.citizenid)
end)



--====================================================================================
--  OnLoad
--====================================================================================

RegisterCommand('telfix', function(source)
    TriggerClientEvent('gcphone:FixOnLoad', source)
end)
RegisterCommand('MessageTest', function(source)
    TriggerClientEvent("SENDMESSAGE",source)
end)



function onCallFixePhone (source, phone_number, rtcOffer, extraData)
    local indexCall = lastIndexCall
    lastIndexCall = lastIndexCall + 1

    local hidden = string.sub(phone_number, 1, 1) == '#'
    if hidden == true then
        phone_number = string.sub(phone_number, 2)
    end
    local sourcePlayer = tonumber(source)
    local srcIdentifier = getPlayerID(source)

    local srcPhone = ''
    if extraData ~= nil and extraData.useNumber ~= nil then
        srcPhone = extraData.useNumber
    else
        srcPhone = srcIdentifier.PlayerData.charinfo.phone
    end

    AppelsEnCours[indexCall] = {
        id = indexCall,
        transmitter_src = sourcePlayer,
        transmitter_num = srcPhone,
        receiver_src = nil,
        receiver_num = phone_number,
        is_valid = false,
        is_accepts = false,
        hidden = hidden,
        rtcOffer = rtcOffer,
        extraData = extraData,
        coords = FixePhone[phone_number].coords
    }
    
    PhoneFixeInfo[indexCall] = AppelsEnCours[indexCall]

    TriggerClientEvent('gcPhone:notifyFixePhoneChange', -1, PhoneFixeInfo)
    TriggerClientEvent('gcPhone:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
end



function onAcceptFixePhone(source, infoCall, rtcAnswer)
    local id = infoCall.id
    
    AppelsEnCours[id].receiver_src = source
    if AppelsEnCours[id].transmitter_src ~= nil and AppelsEnCours[id].receiver_src~= nil then
        AppelsEnCours[id].is_accepts = true
        AppelsEnCours[id].forceSaveAfter = true
        AppelsEnCours[id].rtcAnswer = rtcAnswer
        PhoneFixeInfo[id] = nil
        TriggerClientEvent('gcPhone:notifyFixePhoneChange', -1, PhoneFixeInfo)
        TriggerClientEvent('gcPhone:acceptCall', AppelsEnCours[id].transmitter_src, AppelsEnCours[id], true)
	SetTimeout(1000, function() -- change to +1000, if necessary.
       		TriggerClientEvent('gcPhone:acceptCall', AppelsEnCours[id].receiver_src, AppelsEnCours[id], false)
	end)
        saveAppels(AppelsEnCours[id])
    end
end

function onRejectFixePhone(source, infoCall, rtcAnswer)
    local id = infoCall.id
    PhoneFixeInfo[id] = nil
    TriggerClientEvent('gcPhone:notifyFixePhoneChange', -1, PhoneFixeInfo)
    TriggerClientEvent('gcPhone:rejectCall', AppelsEnCours[id].transmitter_src)
    if AppelsEnCours[id].is_accepts == false then
        saveAppels(AppelsEnCours[id])
    end
    AppelsEnCours[id] = nil
    
end
