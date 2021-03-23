--[[


     ██╗███████╗██████╗ ██╗ ██████╗ ██████╗ ███████╗██╗  ██╗ ██╗ ██╗ ██████╗ ███████╗ ██╗██████╗ 
     ██║██╔════╝██╔══██╗██║██╔════╝██╔═══██╗██╔════╝╚██╗██╔╝████████╗╚════██╗██╔════╝███║╚════██╗
     ██║█████╗  ██████╔╝██║██║     ██║   ██║█████╗   ╚███╔╝ ╚██╔═██╔╝ █████╔╝███████╗╚██║ █████╔╝
██   ██║██╔══╝  ██╔══██╗██║██║     ██║   ██║██╔══╝   ██╔██╗ ████████╗ ╚═══██╗╚════██║ ██║██╔═══╝ 
╚█████╔╝███████╗██║  ██║██║╚██████╗╚██████╔╝██║     ██╔╝ ██╗╚██╔═██╔╝██████╔╝███████║ ██║███████╗
 ╚════╝ ╚══════╝╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═════╝ ╚═╝     ╚═╝  ╚═╝ ╚═╝ ╚═╝ ╚═════╝ ╚══════╝ ╚═╝╚══════╝
                                                                                                 

 ]]


function YellowPagesGetPosts(a, b)
    exports['ghmattimysql']:execute([===[SELECT yellowpages_posts.*, twitter_accounts.username as author, twitter_accounts.avatar_url as authorIcon, players.name as firstname FROM yellowpages_posts LEFT JOIN twitter_accounts ON yellowpages_posts.authorId = twitter_accounts.id LEFT JOIN players ON yellowpages_posts.realUser = players.steam ORDER BY time DESC LIMIT 30]===], {}, b)
end
function YellowPagesPostIlan(a, b, c, d, e)
   -- print(d)
   -- local player1 = FXCore.Functions.GetPlayer(d)
    getUserYellow(d, function(f)
      --  exports['ghmattimysql']:execute("SELECT * FROM players WHERE citizenid = @realUser", {["@realUser"] = player1}, function(g)
            
            
          
            local player = FXCore.Functions.GetPlayerByCitizenId(d)
           -- tprint(player)
           tprint(player)
            exports['ghmattimysql']:execute("INSERT INTO yellowpages_posts (`authorId`, `message`, `image`, `realUser`, `phone`) VALUES(@authorId, @message, @image, @realUser, @phone);", {
                ["@authorId"] = f.id,
                 ["@message"] = a,
                  ["@image"] = b,
                   ["@realUser"] = d,
                    ["@phone"] = player.PlayerData.charinfo.phone}, function(h)
            post = {}
            post["authorId"] = f.id;
            post["message"] = a;
            post["image"] = b;
            post["realUser"] = d;
            post["time"] = os.date()
            post["author"] = f.author;
            post["authorIcon"] = f.authorIcon;
            Wait(500)
            TriggerClientEvent("gcPhone:yellow_newPost", -1, post)
       -- end)
        
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
function YellowGetMyPosts(accountId, cb)
    exports['ghmattimysql']:execute([===[
      SELECT yellowpages_posts.*,
        twitter_accounts.username as author,
        twitter_accounts.avatar_url as authorIcon
      FROM yellowpages_posts
        LEFT JOIN twitter_accounts
          ON twitter_accounts.identifier = @accountId
      WHERE realUser = @accountId ORDER BY TIME DESC LIMIT 30
    ]===]
        
        
        
        
        
        
        
        , {['@accountId'] = accountId}, cb)
end

function getUserYellow(identifier, cb)
    exports['ghmattimysql']:execute("SELECT id, username as author, avatar_url as authorIcon FROM twitter_accounts WHERE twitter_accounts.identifier = @identifier", {
        ['@identifier'] = identifier
    }, function(data)
        print(data[1])
        cb(data[1])
    end)
end

function YellowToogleDelete(identifier, id, sourcePlayer)
    exports['ghmattimysql']:execute('DELETE FROM yellowpages_posts WHERE id = @id', {
        ['@id'] = id,
    }, function()
        YellowGetMyPosts(identifier, function(posts)
            TriggerClientEvent('gcPhone:yellow_getMyPosts', sourcePlayer, posts)
        end)
    end)
end

function TwitterShowError(sourcePlayer, title, message)
    TriggerClientEvent('gcPhone:twitter_showError', sourcePlayer, message)
end

RegisterServerEvent('gcPhone:yellow_getPosts')
AddEventHandler('gcPhone:yellow_getPosts', function()
    local sourcePlayer = tonumber(source)
    YellowPagesGetPosts(nil, function(posts)
        TriggerClientEvent('gcPhone:yellow_getPosts', sourcePlayer, posts)
    end)
end)

RegisterServerEvent('gcPhone:yellow_getMyPosts')
AddEventHandler('gcPhone:yellow_getMyPosts', function()
    local sourcePlayer = tonumber(source)
    local srcIdentifier = getPlayerID(source)
    YellowGetMyPosts(srcIdentifier.PlayerData.citizenid, function(posts)
        TriggerClientEvent('gcPhone:yellow_getMyPosts', sourcePlayer, posts)
    end)
end)

RegisterServerEvent('gcPhone:yellow_toggleDeletePost')
AddEventHandler('gcPhone:yellow_toggleDeletePost', function(id)
    local sourcePlayer = tonumber(source)
    local srcIdentifier = getPlayerID(source)
    YellowToogleDelete(srcIdentifier.PlayerData.citizenid, id, sourcePlayer)
end)

RegisterServerEvent('gcPhone:yellow_postIlan')
AddEventHandler('gcPhone:yellow_postIlan', function(message, image)
    local sourcePlayer = tonumber(source)
    local srcIdentifier = getPlayerID(source)
    YellowPagesPostIlan(message, image, sourcePlayer, srcIdentifier.PlayerData.citizenid)
end)

function sendDiscordYellow(post)
    local discord_webhook = GetConvar('yellow_discord_webhook', '')
    if discord_webhook == '' then
        return
    end
    local headers = {
        ['Content-Type'] = 'application/json'
    }
    local data = {
        ["username"] = post.author,
        ["embeds"] = {{
            ["thumbnail"] = {
                ["url"] = post.authorIcon
            },
            ["color"] = 1942002
        }}
    }
    if post.image ~= "" then
        data['embeds'][1]['image'] = {['url'] = post.image}
    end
    post.message = post.message:gsub("{{{", ":")
    post.message = post.message:gsub("}}}", ":")
    data['embeds'][1]['description'] = post.message
    PerformHttpRequest(discord_webhook, function(err, text, headers) end, 'POST', json.encode(data), headers)
end
