@echo off
call environment.bat %1
cd C:\luwrain.packager\iss-fix\
rem fix for jvm.dll, x64 java have no client mode but javafxpackager copy x32 library
rem if '%ARCH%'=='x64' (
rem   copy C:\luwrain.packager\jdk.x64\jre\bin\server\* Luwrain\runtime\bin\client\ > nul
rem )

cd C:\luwrain.packager\iss-fix\
copy Luwrain.cfg Luwrain\app\Luwrain.cfg > nul

echo 8/8 invoking inno setup compiler
iscc Luwrain.%ARCH%.iss > iscc.log
if not ERRORLEVEL == 0 (
  echo iss FIX error
  goto :onerror
)
