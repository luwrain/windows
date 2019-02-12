@echo off
call environment.bat %1
rem clean up
echo 1/8 clean up
rd /s/q C:\luwrain.packager\iss-fix\%ARCH% 2> nul
mkdir C:\luwrain.packager\iss-fix\%ARCH%
del		C:\luwrain.packager\iss-fix\%ARCH%.iscc.log 2> nul
del		C:\luwrain.packager\luwrain\%ARCH%\ant.log 2> nul
del		C:\luwrain.packager\luwrain\%ARCH%\ant.err 2> nul
del		C:\luwrain.packager\luwrain\%ARCH%\build.xml 2> nul
rd /s/q C:\luwrain.packager\luwrain\%ARCH%\dist 2> nul
mkdir C:\luwrain.packager\luwrain\%ARCH%\dist
