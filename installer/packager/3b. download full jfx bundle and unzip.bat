@echo off
call environment.bat %1
rem first step - download and extract latest luwrain build
cd C:\luwrain.packager\datafiles\
echo 2/8 download jfx bundle latest
wget -q %FULL_JFX_LINK% -o luwrain-jfx.zip
echo 3/8 unzip
unzip -q -o -UU luwrain-jfx.zip
rem ----------------
for /d %%a in (luwrain-win*) do rename %%a luwrain-jfx
mkdir bundle.%ARCH% 2> nul
mv.exe luwrain-jfx/* bundle.%ARCH%/
rd /s/q luwrain-jfx
rem second step - generate package via javafxpackager library for ant
