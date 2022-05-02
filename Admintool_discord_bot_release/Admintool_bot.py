Version = "Admintool bot created by: TheSoliderror, v1.3"
# do not touch these imports!
import multiprocessing
import os
import re
import socket
import struct
from ipaddress import ip_address
from discord.ext import commands
from disnake.ext import commands
import disnake
import discord
from pyrcon import RCON

# ADD YOUR DISCORD BOT TOKEN HERE IN THE ""
TOKEN = "OTQ5NzIzNzM2MzMwODg3MTY4.YiOhJw.QjveY8gIBLqhgR7FNx7b2hh91Vg"

# THIS BOT DOES NOT USE THIS BUT KEEP IT!
bot = commands.Bot(command_prefix="!")

#DO NOT TOUCH THIS
@bot.event
async def on_ready():
    print(f'{bot.user} succesfully logged in! ')
    print(Version)
    
#   ADD YOUR SERVER STUFF HERE 

# users folder for admintool, change it to you servers scripts/admintool/users
userpath = r'C:\Users\server1\admintool\users'
userpath2 = r'C:\Users\server2\admintool\users' # only use this path for your other server

#ban folder for admintool, scripts/admintool/bans
banpath = r'C:\Users\server1\admintool\bans'
banpath2 = r'C:\Users\server2\admintool\bans' # only use this path for your other server

#admin folder for admintool, scripts/admintool/admins
adminpath = r'C:\Users\server1\admintool\admins'
adminpath2 = r'C:\Users\server2\admintool\admins' # only use this path for your other server

#this defines the servers, add more as needed or rename them as you like
#if you want only one server to be managed remove one option expl: "Extinction", then scroll and look for other comments telling you what to remove
Server = commands.option_enum(["Extinction", "Multiplayer"]) 

# Change this for your servers port
# if using one server, remove the port variable you do not need
Extinction_port = 27016 

Multiplayer_6x_port = 27018

# Change this for your servers RCON password(I use the same RCON pass for both servers! (change "password")
RCON_Password = "password" 
# Change this for your servers local or public Ip, depends on where your bot is hosted.
Server_ip = "192.168.1.1"



# Say 
@bot.slash_command(name="say",description="sends a message to a servers")
async def say(inter: disnake.ApplicationCommandInteraction, server: Server, message: str):
    if server == "Multiplayer":
        await inter.response.send_message("You said "+message+" in the Multiplayer server")
        rcon = RCON(Server_ip, RCON_Password, port=Multiplayer_6x_port)
        rcon.send_command("say " + message)
    # for one server remove one if statment and change the other as needed
    if server == "Extinction":
        await inter.response.send_message("You said "+message+" in the Extinction server")
        rcon = RCON(Server_ip, RCON_Password, port=Extinction_port)
        rcon.send_command("say " + message)

# Send RCON
@bot.slash_command(name="CMD",description="This sends a custom command to a server")
async def CMD(inter: disnake.ApplicationCommandInteraction, server: Server,command: str):

    if server == "Multiplayer":
        await inter.response.send_message("CMD "+command+" was sent to the Multiplayer server")
        rcon = RCON(Server_ip, RCON_Password, port=Multiplayer_6x_port)
        rcon.send_command(command)
    # for one server remove one if statment and change the other as needed
    if server == "Extinction":
        await inter.response.send_message("CMD "+command+" was sent to the Extinction server")
        rcon = RCON(Server_ip, RCON_Password, port=Extinction_port)
        rcon.send_command(command)


#This is to create map choices
Maps = commands.option_enum(["Point of Contact", "Nightfall","Mayday","Awakening","Exodus"]) 
# Change Extinction Server Map (if you do not have a Extinction server, this entire function can be removed
@bot.slash_command(name="ChangeMap",description="This changes the map on the Solids Iw6x Extinction Server")
async def Changemap(inter: disnake.ApplicationCommandInteraction, maps: Maps):

    await inter.response.send_message("The map was changed to "+maps)
    rcon = RCON(Server_ip, RCON_Password, port=Extinction_port)
    #create the change map string for better proformace
    if maps == "Point of Contact":
        mapname = "mp_alien_town"
    elif maps == "Nightfall":
        mapname = "mp_alien_armory"
    elif maps == "Mayday":
        mapname = "mp_alien_beacon"
    elif maps == "Awakening":
        mapname = "mp_alien_dlc3"
    elif maps == "Exodus":
        mapname = "mp_alien_last"
    change = "map " + mapname
    
    rcon.send_command(change)
    
#muli map change (this will be added later!)


# Ban
@bot.slash_command(name="Banplayer",description="This allows you to ban a player on a server.")
async def Banplayer(inter: disnake.ApplicationCommandInteraction, server: Server, name: str, reason : str):

# Server 1/ Multi server
    if server == "Multiplayer":
        for filename in os.listdir(userpath):
            cur_path = os.path.join(userpath, filename)
            if os.path.isfile(cur_path):
                with open(cur_path, 'r') as file:
                    if name in file.read():
                        await inter.response.send_message("User "+name+" was banned! Reason : "+reason)
                        ban_id = filename
                        with open(os.path.join(banpath, ban_id), 'w') as fp:
                            fp.write(reason)
                            fp.close()
                        kick_player = filename
                        if server == "Multiplayer":
                            rcon = RCON(Server_ip, RCON_Password, port=Multiplayer_6x_port)
                            rcon.send_command("clientkick " + name)
                            break
                            
    # for one server remove one if statment and change the other as needed
    
# Server 2/ Extinction server
    if server == "Extinction":
        for filename in os.listdir(userpath2):
            cur_path = os.path.join(userpath2, filename)
            if os.path.isfile(cur_path):
                with open(cur_path, 'r') as file:
                    if name in file.read():
                        await inter.response.send_message("User "+name+" was banned! Reason : "+reason)
                        ban_id = filename
                        with open(os.path.join(banpath2, ban_id), 'w') as fp:
                            fp.write(reason)
                            fp.close()
                        kick_player = filename
                        if server == "Extinction":
                            rcon = RCON(Server_ip, RCON_Password, port=Extinction_port)
                            rcon.send_command("clientkick " + name)
                            break
    
# Kick
@bot.slash_command(name="Kickplayer",description="This allows you to Kick a player on a server")
async def Kickplayer(inter: disnake.ApplicationCommandInteraction, server: Server, name: str, reason : str):

    if server == "Multiplayer":
        for filename in os.listdir(userpath):
            cur_path = os.path.join(userpath, filename)
            if os.path.isfile(cur_path):
                with open(cur_path, 'r') as file:
                    if name in file.read():
                        await inter.response.send_message("User "+name+" was kicked! Reason : "+reason)
                        kick_player = filename
                        if server == "Multiplayer":
                            rcon = RCON(Server_ip, RCON_Password, port=Multiplayer_6x_port)
                            rcon.send_command("clientkick " + name)
                            print(kick_player)
                            break                    
                            
    # for one server remove one if statment and change the other as needed
                            
    if server == "Extinction":
        for filename in os.listdir(userpath2):
            cur_path = os.path.join(userpath2, filename)
            if os.path.isfile(cur_path):
                with open(cur_path, 'r') as file:
                    if name in file.read():
                        await inter.response.send_message("User "+name+" was kicked! Reason : "+reason)
                        kick_player = filename                     
                        if server == "Extinction":
                            rcon = RCON(Server_ip, RCON_Password, port=Extinction_port)
                            rcon.send_command("clientkick " + name)
                            print(kick_player)
                            break

# Fast_Restart
Fast_restart = commands.option_enum(["Restart"])
@bot.slash_command(name="Restart",description="Restarts the server")
async def Restart(inter: disnake.ApplicationCommandInteraction, server: Server, fast_restart: Fast_restart):
    if server == "Multiplayer":
        await inter.response.send_message("The server has been restarted")
        rcon = RCON(Server_ip, RCON_Password, port=Multiplayer_6x_port)
        rcon.send_command("fast_restart")
        
    # for one server remove one if statment and change the other as needed
        
    if server == "Extinction":
        await inter.response.send_message("The server has been restarted")
        rcon = RCON(Server_ip, RCON_Password, port=Extinction_port)
        rcon.send_command("fast_restart")

    
# Promote
@bot.slash_command(name="Promote",description="This allows you to promote a player to admin on a server.")
async def Promote(inter: disnake.ApplicationCommandInteraction, server: Server, name: str):

    if server == "Multiplayer":
        for filename in os.listdir(userpath):
            cur_path = os.path.join(userpath, filename)
            if os.path.isfile(cur_path):
                with open(cur_path, 'r') as file:
                    if name in file.read():
                        await inter.response.send_message("User "+name+" was Promoted!")
                        ban_id = filename
                        with open(os.path.join(adminpath, ban_id), 'w') as fp:
                            fp.write("admin")
                            fp.close()
                        break

    # for one server remove one if statment and change the other as needed

    if server == "Extinction":
        for filename in os.listdir(userpath2):
            cur_path = os.path.join(userpath2, filename)
            if os.path.isfile(cur_path):
                with open(cur_path, 'r') as file:
                    if name in file.read():
                        await inter.response.send_message("User "+name+" was Promoted!")
                        ban_id = filename
                        with open(os.path.join(adminpath2, ban_id), 'w') as fp:
                            fp.write("admin")
                            fp.close()
                        break                   
    
bot.run(TOKEN)