@echo off

set ARCH=x64
if '%1'=='x32' set ARCH=x32
set Path=C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\luwrain.packager\InnoSetup\;C:\luwrain.packager\mingw\;C:\luwrain.packager\apache-ant\bin\;

echo Creating installer for %ARCH%

cd C:\luwrain.packager\iss-fix\
copy Luwrain-setup-icon.bmp %ARCH%\ > nul
cd %ARCH%
iscc Luwrain.iss > iscc.log
if not ERRORLEVEL == 0 (
  echo iss FIX error
)
cd ..
