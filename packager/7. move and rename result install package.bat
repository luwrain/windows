@echo off
call environment.bat %1
cd C:\luwrain.packager\
if exist Luwrain-1.0.%ARCH%.exe del Luwrain-1.0.%ARCH%.exe
move C:\luwrain.packager\iss-fix\Output\Luwrain-1.0.exe C:\luwrain.packager\Luwrain-1.0.%ARCH%.exe > nul
