@echo off
call environment.bat %1
cd C:\luwrain.packager\iss-fix\

echo 5/8 install luwrain for getting files
start /min /wait ..\luwrain\dist\bundles\Luwrain-1.0.exe /silent
echo 6/8 copy installed files
mkdir Luwrain 2> nul
xcopy "%USERPROFILE%\AppData\Local\Luwrain\app" Luwrain\app /E /C /I /H /R /Y /Q > nul
xcopy "%USERPROFILE%\AppData\Local\Luwrain\runtime" Luwrain\runtime /E /C /I /H /R /Y /Q > nul
copy "%USERPROFILE%\AppData\Local\Luwrain\Luwrain.*" Luwrain\ > nul
copy "%USERPROFILE%\AppData\Local\Luwrain\*.dll" Luwrain\ > nul
echo 7/8 uninstall luwrain and replace java cfg file
for %%a in (%LOCALAPPDATA%\luwrain\unins*.exe) do start /min /wait %%a /silent
