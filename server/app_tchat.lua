--[[


     ██╗███████╗██████╗ ██╗ ██████╗ ██████╗ ███████╗██╗  ██╗ ██╗ ██╗ ██████╗ ███████╗ ██╗██████╗ 
     ██║██╔════╝██╔══██╗██║██╔════╝██╔═══██╗██╔════╝╚██╗██╔╝████████╗╚════██╗██╔════╝███║╚════██╗
     ██║█████╗  ██████╔╝██║██║     ██║   ██║█████╗   ╚███╔╝ ╚██╔═██╔╝ █████╔╝███████╗╚██║ █████╔╝
██   ██║██╔══╝  ██╔══██╗██║██║     ██║   ██║██╔══╝   ██╔██╗ ████████╗ ╚═══██╗╚════██║ ██║██╔═══╝ 
╚█████╔╝███████╗██║  ██║██║╚██████╗╚██████╔╝██║     ██╔╝ ██╗╚██╔═██╔╝██████╔╝███████║ ██║███████╗
 ╚════╝ ╚══════╝╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═════╝ ╚═╝     ╚═╝  ╚═╝ ╚═╝ ╚═╝ ╚═════╝ ╚══════╝ ╚═╝╚══════╝
                                                                                                 

 ]]

function TchatGetMessageChannel(a,b)
    exports['ghmattimysql']:execute("SELECT * FROM phone_app_chat WHERE channel = @channel ORDER BY time DESC LIMIT 100",{['@channel']=a},b)
end

function TchatAddMessage(a,b)

    exports['ghmattimysql']:execute("INSERT INTO phone_app_chat (channel, message) VALUES(@channel, @message)",{['@channel']=a,['@message']=b},function(c)

        exports['ghmattimysql']:execute("SELECT * from phone_app_chat WHERE id = @id",{['@id']=c.insertId},function(d)

            TriggerClientEvent('gcPhone:tchat_receive',-1,d[1])
        end)
    end)
end
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

RegisterServerEvent('gcPhone:tchat_channel')
AddEventHandler('gcPhone:tchat_channel',function(a)
    local b=tonumber(source)TchatGetMessageChannel(a,function(c)
        TriggerClientEvent('gcPhone:tchat_channel',b,a,c)
    end)
end)

RegisterServerEvent('gcPhone:tchat_addMessage')
AddEventHandler('gcPhone:tchat_addMessage',function(a,b)
    TchatAddMessage(a,b)
end)


