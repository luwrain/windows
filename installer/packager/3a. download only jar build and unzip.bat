@echo off
call environment.bat %1
rem first step - download and extract latest luwrain build
cd C:\luwrain.packager\datafiles\
echo 2/8 download luwrain java latest
wget -q LUWRAIN_LATEST_LINK -o luwrain.zip
echo 3/8 unzip
unzip -q -o -UU luwrain.zip
rem ----------------
for /d %%a in (luwrain-win*) do rename %%a luwrain
mkdir bundle.%ARCH% 2> nul
rd /s/q bundle.%ARCH%\app 2> nul
mkdir bundle.%ARCH%\app 2> nul
mv.exe luwrain/* bundle.%ARCH%/app
rd /s/q luwrain
rem second step - generate package via javafxpackager library for ant
