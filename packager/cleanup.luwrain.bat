@echo off
rd /s/q %APPDATA%\luwrain
for %%a in (%LOCALAPPDATA%\luwrain\unins*.exe) do start /min /wait %%a /silent
rd /s/q %LOCALAPPDATA%\luwrain
