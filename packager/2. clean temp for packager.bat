@echo off
call environment.bat %1
rem clean up
echo 1/8 clean up
rd /s/q C:\luwrain.packager\iss-fix\Luwrain 2> nul
rd /s/q C:\luwrain.packager\iss-fix\Output 2> nul
del		C:\luwrain.packager\iss-fix\iscc.log 2> nul
del		C:\luwrain.packager\luwrain\ant.log 2> nul
del		C:\luwrain.packager\luwrain\err.log 2> nul
rd /s/q C:\luwrain.packager\luwrain\dist 2> nul
rd /s/q C:\luwrain.packager\datafiles\download.luwrain.org 2> nul
C:\luwrain.packager\mingw\rm.exe -rf datafiles/luwrain-windows-nightly* datafiles/luwrain.zip
