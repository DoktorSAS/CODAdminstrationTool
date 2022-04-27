

local path = {}
path.scripts = "C:\\Users\\Utente\\AppData\\Local\\xlabs\\data\\iw6x\\data\\scripts\\admintool\\"
path.bans = path.scripts .. "bans\\"
path.users = path.scripts .. "users\\"
path.admins = path.scripts .. "admins\\"
path.logs = path.scripts .. "log\\"

local maps = {}
maps["mp_warhawk"] = "Warhawk"
maps["mp_hashima"] = "Siege"
maps["mp_fahrenheit"] = "Stormfront"
maps["mp_snow"] = "Whiteout"
maps["mp_frag"] = "Freight"
maps["mp_lonestar"] = "Tremor"
maps["mp_dart"] = "Octane"
maps["mp_prisonbreak"] = "Prision Break"
maps["mp_descent_new"] = "Free Fall"
maps["mp_strikezone"] = "Strikezone"
maps["mp_flooded"] = "Flooded"
maps["mp_chasm"] = "Chasm"
maps["mp_skeleton"] = "Stonehaven"
maps["mp_zebra"] = "Overload"
maps["mp_ca_impact"] = "Collision"
maps["mp_dome_ns"] = "Unearthed"
maps["mp_dig"] = "Ruins"
maps["mp_sovereign"] = "Sovereign"
maps["mp_dig"] = "Ruins"
maps["mp_ca_behemoth"] = "Behemoth"
maps["mp_ca_impact"] = "Collision"
maps["mp_dome_ns"] = "Unearthed"
maps["mp_dig"] = "Pharaoh"
maps["mp_favela_iw6"] = "Favela"
maps["mp_pirate"] = "Mutiny"
maps["mp_zulu"] = "Departed"
maps["mp_zerosub"] = "Subzero"
maps["mp_shipment_ns"] = "Showtime"
maps["mp_mine"] = "Goldrush"
maps["mp_conflict"] = "Dynasty"
maps["mp_swamp"] = "Fog"
maps["mp_ca_rumble"] = "Bayview"
maps["mp_ca_red_river"] = "Containment"
maps["mp_boneyard_ns"] = "Ignition"

--[[ Players list management ]]--
local players = {}

function tablefind(tab,el)
	for index, value in pairs(tab) do
		if value == el then
			return index
		end
	end

	return nil
end

function removePlayer(player)
	local index = tablefind(players, player)
	if index ~= nil then
		table.remove(players, index)
	end
    if not player:isentityabot() then
        --logline(player.name .. "(".. player:getguid() ..") disconnected to the server")
        logline("\\disconnected\\"..player.name.."\\".. player:getguid())
    end
end

--[[ Commands ]]--

--[[
    List of commands
    Users have access to:
        !admins or !a to show all admins in the server
    
    Admins have access to:
        !ban or !b to permantly ban a client
        !unban or !ub to unban a user
        !kick or !k to kick a client
        !fastrestart or !fr to restart the map
        !promote or !p to promote a user to admin
        !demote or !d to demote a admin to user
]]--
local onPlayerSay = function (player, msg)
    msg = string.lower(msg);
    logline("\\say\\"..player.name.."\\".. player:getguid() .."\\" .. msg)
    if msg == "!a" or msg == "!admins" then
        print("Admins command executing")
        for index, p in pairs(players) do
            if string.match(p.role,"admin") then
                game:executecommand("say [^6Admin^7] " .. p.name )
            end
        end
    end

    -- Admins Commands
    if string.match(player.role,"admin") then
        args = split(msg, " ")

        -- BAN
        if args[1] == "!ban" or args[1] == "!b" then
            if #args > 2 then
                print( "Ban command executing")
                local player_to_ban = nil
                if string.find(args[2], "_") then
                    for index, p in pairs(players) do
                        if string.find(string.lower(p.name),string.lower(args[2])) then
                            player_to_ban = p
                        end
                    end
                end 

                if player_to_ban == nil then
                    name = string.gsub(args[2], "_", " ")
                    for index, p in pairs(players) do
                        if string.find(string.lower(p.name),string.lower(args[2])) then
                            player_to_ban = p
                        end
                    end
                end
                
                if player_to_ban == nil then
                    game:executecommand("tellraw " .. player:getentitynumber() .. " Player not found")
                else
                    reason = ""
                    for i = 3, #args, 1 do
                        reason = reason .. args[i] .. " "
                    end
                    banuser( player_to_ban:getguid(), reason)
                    game:executecommand("clientkick " .. player_to_ban:getentitynumber() .. " " .. reason);
                    --logline( player.name .. "(".. player:getguid() ..") banned " .. player_to_ban.name .. "("..player_to_ban:getguid()..")")
                    logline("\\ban\\"..player.name.."\\".. player:getguid() .. "\\".. player_to_ban.name .. "\\".. player_to_ban:getguid() .."\\" .. reason)
                end
            else
                game:executecommand("tellraw " .. player:getentitynumber() .. " Missing arguments (!ban name reason)")
            end
        end

        -- KICK
        if args[1] == "!kick" or args[1] == "!k" then
            if #args > 2 then
                print( "Kick command executing")
                local player_to_kick = nil
                if string.find(args[2], "_") then
                    print("Check if there player with spaces")
                    for index, p in pairs(players) do
                        if string.find(string.lower(p.name),string.lower(args[2])) then
                            player_to_kick = p
                        end
                    end
                end 

                if player_to_kick == nil then
                    name = string.gsub(args[2], "_", " ")
                    for index, p in pairs(players) do
                        if string.find(string.lower(p.name),string.lower(args[2])) then
                            player_to_kick = p
                        end
                    end
                end
                
                if player_to_kick == nil then
                    game:executecommand("tellraw " .. player:getentitynumber() .. " Player not found")
                else
                    reason = ""
                    for i = 3, #args, 1 do
                        reason = reason .. args[i] .. " "
                    end
                    --logline( player.name .. "(".. player:getguid() ..") kicked " .. player_to_kick.name .. "("..player_to_kick:getguid()..")")
                    logline("\\kick\\"..player.name.."\\".. player:getguid() .. "\\".. player_to_kick.name .. "\\".. player_to_kick:getguid() .."\\" .. reason)
                    game:executecommand("clientkick " .. player_to_kick:getentitynumber() .. " " .. reason);
                end
            else
                game:executecommand("tellraw " .. player:getentitynumber() .. " Missing arguments (!kick name reason)")
            end
        end

        -- Unban
        if args[1] == "!unban" or args[1] == "!ub" then
            if #args > 1 then
                if file_exists( path.bans .. args[2]) then
                    os.remove( path.bans .. args[2] )
                    game:executecommand("tellraw " .. player:getentitynumber() .. " " .. args[2] .. " player unbanned")
                    --logline( player.name .. "(".. player:getguid() ..") unbanned " .. args[2])
                    logline("\\unban\\"..player.name.."\\".. player:getguid() .. "\\".. args[2])
                end
            else
                game:executecommand("tellraw " .. player:getentitynumber() .. " Missing arguments (!unban guid)")
            end
        end

        -- FASTRESTART
        if args[1] == "!fastrestart" or args[1] == "!fr" then
            --logline( player.name .. "(".. player:getguid() ..") executed fast_restart")
            logline("\\fastrestart\\"..player.name.."\\".. player:getguid())
            game:executecommand("fast_restart")
        end

        if args[1] == "!promote" or args[1] == "!p" then
            if #args > 1 then
                fname = path.admins .. args[2]
                dir = fname:gsub("%/", "\\"):match("(.*[\\])")
                os.execute("if not exist " .. dir .. " mkdir " .. dir)
                file = io.open(fname, "w")
                file:write( player.name )
                file:close()
                --logline( args[2] .. " player promoted by " .. player.name .. "(".. player:getguid() ..")")
                logline("\\promote\\"..player.name.."\\".. player:getguid() .."\\".. args[2])
                game:executecommand("tellraw " .. player:getentitynumber() .. " " .. args[2] .. " player promoted")
                for index, p in pairs(players) do
                    if string.find(string.lower( p:getguid() ), string.lower( args[2] )) then
                        p.role = "admin"
                    end
                end
            else
                game:executecommand("tellraw " .. player:getentitynumber() .. " Missing arguments (!promote guid)")
            end
        end

        if args[1] == "!demote" or args[1] == "!d" then
            if #args > 1 then
                if file_exists( path.admins .. args[2]) then
                    os.remove( path.admins .. args[2] )
                    for index, p in pairs(players) do
                        if string.find(string.lower(p:getguid()), string.lower(args[2])) then
                            p.role = "user"
                        end
                    end
                    --logline( args[2] .. " player demoted by " .. player.name .. "(".. player:getguid() ..")")
                    logline("\\demoted\\"..player.name.."\\".. player:getguid() .."\\".. args[2])
                    game:executecommand("tellraw " .. player:getentitynumber() .. " " .. args[2] .. " player demoted")
                end
            else
                game:executecommand("tellraw " .. player:getentitynumber() .. " Missing arguments (!demote guid)")
            end
        end

        if args[1] == "!map" or args[1] == "!m" then
            if #args > 1 then
                map = string.lower(args[2])
                if checkvalidmap( map ) then
                    --logline( player.name .. "(".. player:getguid() ..") changed map to " .. maps[map])
                    logline("\\map\\"..player.name.."\\".. player:getguid() .."\\".. maps[map] .. "\\".. map)
                    time = 5
                    timer = game:oninterval(function ()
                        game:executecommand("say Chaning map to [".. maps[map] .. "] in " .. time)
                        time = time - 1
                        if time <= 0 then
                            game:executecommand("map " .. map)
                            timer:clear()
                        end
                    end, 1000)

                else
                    game:executecommand("tellraw " .. player:getentitynumber() .. " Invalid map")
                end
            end
        end
    end
end


function checkvalidmap( map )
    return maps[ map ] ~= nil
end
function entity:isbanned()
    return file_exists( path.bans .. self:getguid() )
end

function playerConnected(player)
    if not player:isentityabot() then
        --logline(player.name .. "(".. player:getguid() ..") connected to the server")
        logline("\\connected\\"..player.name.."\\".. player:getguid())
    end
    player.role = "user"
    player:adduser()
    if player:isbanned() == false then
        player:onnotifyonce("disconnect", function() removePlayer(player) end)
        table.insert(players, player)
    
        player:getuserrole()
    
        local onSay = player:onnotify("say", function(msg) onPlayerSay(player, msg) end);
        local onSayTeam = player:onnotify("say_team", function(msg) onPlayerSay(player, msg) end);
    
        player:onnotifyonce("disconnect", function ()
            onSay:clear()
            onSayTeam:clear()
        end)
    else
        game:executecommand("clientkick " .. player:getentitynumber() .. " " .. player:getbanreason());
    end
end

level:onnotify("connected", playerConnected)


function entity:getbanreason()
    fname =  path.bans .. self:getguid()
    f = io.open(fname, "r")
    reason = f:read()
    f:close()
    return reason;
end
function entity:isentityabot()
	return string.find(self:getguid(), "bot")
end
function banuser( guid, reason )
    fname = path.bans .. guid
    dir = fname:gsub("%/", "\\"):match("(.*[\\])")
    os.execute("if not exist " .. dir .. " mkdir " .. dir)

    print( "Banning user " .. guid .. "\n" .. fname)
    file = io.open(fname, "w")
    file:write( reason)
    file:close()
end

function entity:adduser()
    if not self:isentityabot() and not file_exists( path.users .. self:getguid() ) then
        fname = path.users .. self:getguid()
        dir = fname:gsub("%/", "\\"):match("(.*[\\])")
        os.execute("if not exist " .. dir .. " mkdir " .. dir)

        print( "Adding user " .. self.name .. "\n" .. fname)
        file = io.open(fname, "w")
        name = self.name
        name = name:gsub("%^%d", "")
        file:write("user\n" .. name)
        file:close()
    elseif not self:isentityabot() then
        fname = path.users .. self:getguid()
        lines = lines_from(fname)

        name = self.name
        name = name:gsub("%^%d", "")

        find = false
        for i = 2, #lines, 1 do
            if lines[i] == name then
                find = true
            end
        end

        if not find then
            file = io.open(fname, "a")
            file:write("\n" .. name)
            file:close()
        end
    end
end
function entity:getuserrole()
    if not self:isentityabot() then
        filefullpath = path.admins .. self:getguid()
        if file_exists( filefullpath ) then 
            self.role = "admin"
        end
    else
        self.role = "bot"
    end
end

-- [[ Utilities ]] --
function split(pString, pPattern)
    local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
    local fpat = "(.-)" .. pPattern
    local last_end = 1
    local s, e, cap = pString:find(fpat, 1)
    while s do
       if s ~= 1 or cap ~= "" then
      table.insert(Table,cap)
       end
       last_end = e+1
       s, e, cap = pString:find(fpat, last_end)
    end
    if last_end <= #pString then
       cap = pString:sub(last_end)
       table.insert(Table, cap)
    end
    return Table
end

-- [[ Files Utilities ]] --

function file_exists(file)
    local f = io.open(file, "rb")
    if f then f:close() end
    return f ~= nil
end

function lines_from(file)
    if not file_exists(file) then return {} end
    local lines = {}
    for line in io.lines(file) do
      lines[#lines + 1] = line
    end
    io.close()
    return lines
end

function logline( line )
    logl = "\n".. os.date("%x - %X") .. line
    fname = path.logs .. "logs.log"
    file = io.open(fname, "a")
    file:write( logl )
    file:close()
end

if not file_exists(path.logs .. "logs.log") then 
    fname = path.logs .. "logs.log"
    dir = fname:gsub("%/", "\\"):match("(.*[\\])")
    os.execute("if not exist " .. dir .. " mkdir " .. dir)
    file = io.open(fname, "w")
    file:write( fname )
    file:close()
end
