@echo off
echo 1/4 installing luwrain for getting files
start /min /wait ..\luwrain\dist\bundles\Luwrain-1.0.exe /silent
echo 2/4 copy installed files
mkdir Luwrain
xcopy "%USERPROFILE%\AppData\Local\Luwrain\app" Luwrain\app /E /C /I /H /R /Y /Q > nul
xcopy "%USERPROFILE%\AppData\Local\Luwrain\runtime" Luwrain\runtime /E /C /I /H /R /Y /Q > nul
copy "%USERPROFILE%\AppData\Local\Luwrain\Luwrain.*" Luwrain\ > nul
copy "%USERPROFILE%\AppData\Local\Luwrain\*.dll" Luwrain\ > nul
echo 3/4 uninstall luwrain and replace java cfg file
start /min /wait C:\Users\rpman\AppData\Local\luwrain\unins000.exe /silent
copy fix.Luwrain.cfg Luwrain\app\Luwrain.cfg > nul
echo 4/4 invoking inno setup compiler
iscc Luwrain.iss > iscc.log
copy