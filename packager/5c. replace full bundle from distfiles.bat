@echo off
call environment.bat %1
cd C:\luwrain.packager\iss-fix\
rem clean app folder and copy new content
rd /s /q %ARCH%\Luwrain 2> nul
rd /s /q %ARCH%\Output 2> nul
xcopy ..\datafiles\bundle.%ARCH%\* %ARCH%\Luwrain\ /E /C /I /H /R /Y /Q > nul
