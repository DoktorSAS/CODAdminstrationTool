@echo off
::IF YOU INSALLED PYTHON FROM THE WEBSITE AND NOT THE WINDOWS STORE, FIND THE site-packages FOLDER THAT IT USES AND REPLACE IT WITH YOURS!!

pip install py3rcon

pip install discord

pip install disnake


					:: CHANGE THIS IF YOU HAVE THE WEBSITE INSTALL!!! IDK IF ITS THE SAME!!
set FOLDER_INSTALL = %localappdata%\packages\pythonsoftwarefoundation.python.3.9_qbz5n2kfra8p0\localcache\local-packages\python39\site-packages


echo Installing Solids Custom RCON
xcopy /i /s "%cd%\dependencies\pyrcon.py" %FOLDER_INSTALL% /y

pause