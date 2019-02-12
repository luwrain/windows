@echo off
call environment.bat %1
cd C:\luwrain.packager\
rem -------------------
SETLOCAL EnableDelayedExpansion
SETLOCAL EnableExtensions
wget http://download.luwrain.org/nightly/latest/version.txt -O datafiles\version.txt -o nul
rem for /f %%a in ('wget -O con http://download.luwrain.org/nightly/latest/version.txt -o nul') do (
for /f %%a in (datafiles\version.txt) do set VERSION=%%a
echo Version: '%VERSION%'
rem -------------------
if exist Luwrain.%VERSION%.%ARCH%.exe del Luwrain.%VERSION%.%ARCH%.exe 2> nul
move iss-fix\%ARCH%\Output\Luwrain-1.0.exe  C:\luwrain.packager\Luwrain.%VERSION%.%ARCH%.exe > nul
