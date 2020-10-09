@echo off

set ARCH=xLUWRAIN_INSTALLER_ARCH
set Path=C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\luwrain.packager\InnoSetup\;C:\luwrain.packager\mingw\;C:\luwrain.packager\apache-ant\bin\;

echo Creating installer for %ARCH%

cd C:\luwrain.packager\iss-fix\
copy setup-icon.bmp %ARCH%\ > nul
cd %ARCH%
iscc Luwrain.iss > iscc.log
if not ERRORLEVEL == 0 (
  echo iss FIX error
)
cd ..
