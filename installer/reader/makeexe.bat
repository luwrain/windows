@echo off
call environment.bat %1

cd C:\luwrain.packager\iss-fix\
copy Luwrain.cfg %ARCH%\Luwrain\app\Luwrain.cfg > nul
copy Luwrain-setup-icon.bmp %ARCH%\ > nul
copy Luwrain.%ARCH%.iss %ARCH%\Luwrain.iss > nul

echo invoking inno setup compiler
cd %ARCH%
iscc Luwrain.iss > iscc.log
if not ERRORLEVEL == 0 (
  echo iss FIX error
)
cd ..
