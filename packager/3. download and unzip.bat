@echo off
call environment.bat %1
rem first step - download and extract latest luwrain build
cd C:\luwrain.packager\datafiles\
echo 2/8 download luwrain latest
rem wget -nc -c http://download.luwrain.org/nightly/latest/luwrain-windows-nightly-2016-10-26.zip -O C:\luwrain.packager\datafiles\luwrain-windows-nightly.zip
rem  C:\luwrain.packager\mingw\wget -q -N -m -np -e robots=off -R "*=*" -X "*=*" --no-parent "*=*" -A "luwrain-windows-nojre-nightly*.zip" http://download.luwrain.org/nightly/latest/
rem move C:\luwrain.packager\datafiles\download.luwrain.org\nightly\latest\luwrain-windows-nojre-nightly-2016-12-26.zip C:\luwrain.packager\datafiles\luwrain.zip > nul
C:\luwrain.packager\mingw\wget -q http://download.luwrain.org/nightly/latest/luwrain-windows-nightly.zip -O luwrain.zip
echo 3/8 unzip luwrain
C:\luwrain.packager\mingw\unzip -q -o -UU luwrain.zip
cmd /c dir /b /w luwrain-*
C:\luwrain.packager\mingw\mv.exe luwrain-windows-nojre-nightly-* luwrain-windows-nightly
rem second step - generate package via javafxpackager library for ant
