@echo off
call environment.bat %1
cd C:\luwrain.packager\iss-fix\
rem fix for jvm.dll, x64 java have no client mode but javafxpackager copy x32 library
if '%ARCH%'=='x64' (
  copy C:\luwrain.packager\jdk.x64\jre\bin\server\* %ARCH%\Luwrain\runtime\bin\client\ > nul
)

cd C:\luwrain.packager\iss-fix\
copy Luwrain.cfg %ARCH%\Luwrain\app\Luwrain.cfg > nul
copy Luwrain-setup-icon.bmp %ARCH%\ > nul
copy Luwrain.%ARCH%.iss %ARCH%\Luwrain.iss > nul

echo 8/8 invoking inno setup compiler
cd %ARCH%
iscc Luwrain.iss > iscc.log
if not ERRORLEVEL == 0 (
  echo iss FIX error
)
cd ..
