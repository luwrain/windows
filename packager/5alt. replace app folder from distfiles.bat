@echo off
call environment.bat %1
rem clean app folder and copy new content
rd -sq Luwrain\app
xcopy datafiles\luwrain-windows-nightly Luwrain\app /E /C /I /H /R /Y /Q > nul
