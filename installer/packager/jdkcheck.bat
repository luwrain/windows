@echo off
rem check link to jdk exists
if exist C:\luwrain.packager\jdk.%ARCH%\bin\javac.exe goto :skip
if not exist C:\luwrain.packager\jdk.%ARCH%\bin\javac.exe del C:\luwrain.packager\jdk.%ARCH%

if '%ARCH%'=='x64' ( cd "C:\Program Files\" ) else ( cd "C:\Program Files (x86)\" )
goto :jcp_go
:jcp_loop
  rem echo * %1
  if '%JCP%'=='' (
    set JCP=%1
  )
goto :eof
:jcp_go
set JCP=
FOR /F "usebackq delims==" %%i IN (`cmd /c dir /s /b javac.exe`) DO call :jcp_loop "%%i"
:next
set JCD=%JCP:\bin\javac.exe=%
echo found path to jdk: %JCD%
mklink /d C:\luwrain.packager\jdk.%ARCH% %JCD%
:skip
cd C:\luwrain.packager\
