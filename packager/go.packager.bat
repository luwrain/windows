@echo off
c:
cd C:\luwrain.packager\
rem select arch to x64 or x32 from command line argument
set ARCH=x32
if '%1'=='x64' set ARCH=x64
call jdkcheck.bat
rem setup local installation of java
set JAVAC_PATH=C:\luwrain.packager\jdk.%ARCH%\bin\javac.exe
set JAVA_HOME=C:\luwrain.packager\jdk.%ARCH%
set JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF8
rem setup minimalistic PATH env
set Path=%JAVA_HOME%\bin;C:\luwrain.packager\Inno Setup 5\;C:\luwrain.packager\WiX Toolset v3.10\bin\;C:\luwrain.packager\mingw\;C:\Program Files\Common Files\Microsoft Shared\Windows Live;C:\Program Files (x86)\Common Files\Microsoft Shared\Windows Live;C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\luwrain.packager\apache-ant-1.9.5\bin\;C:\Program Files (x86)\Windows Live\Shared;

rem ****************************
rem cd C:\luwrain.packager\iss-fix\
rem rd /s/q C:\luwrain.packager\iss-fix\Luwrain\app\*.*
rem xcopy C:\luwrain.packager\datafiles\luwrain-windows-nightly\*.* C:\luwrain.packager\iss-fix\Luwrain\app\ /E /C /I /H /R /Y /Q >nul
if '%2'=='skipunzip' goto :skipunzip
if '%2'=='skipall' goto :skipall
rem ****************************

rem clean up
echo 1/8 clean up
rd /s/q C:\luwrain.packager\iss-fix\Luwrain 2> nul
rd /s/q C:\luwrain.packager\iss-fix\Output 2> nul
del		C:\luwrain.packager\iss-fix\iscc.log 2> nul
del		C:\luwrain.packager\luwrain\ant.log 2> nul
del		C:\luwrain.packager\luwrain\err.log 2> nul
rd /s/q C:\luwrain.packager\luwrain\dist 2> nul
rd /s/q C:\luwrain.packager\datafiles\download.luwrain.org 2> nul
C:\luwrain.packager\mingw\rm.exe -rf datafiles/luwrain-windows-nightly* datafiles/luwrain.zip
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

if '%2'=='onlyunzip' goto :eof
:skipunzip


cd C:\luwrain.packager\luwrain\
echo 4/8 first try, make exe package
call ant > ant.log 2> ant.err
if not ERRORLEVEL == 0 (
  echo ANT error
  goto :onerror
)


cd C:\luwrain.packager\iss-fix\

echo 5/8 install luwrain for getting files
start /min /wait ..\luwrain\dist\bundles\Luwrain-1.0.exe /silent
echo 6/8 copy installed files
mkdir Luwrain 2> nul
xcopy "%USERPROFILE%\AppData\Local\Luwrain\app" Luwrain\app /E /C /I /H /R /Y /Q > nul
xcopy "%USERPROFILE%\AppData\Local\Luwrain\runtime" Luwrain\runtime /E /C /I /H /R /Y /Q > nul
copy "%USERPROFILE%\AppData\Local\Luwrain\Luwrain.*" Luwrain\ > nul
copy "%USERPROFILE%\AppData\Local\Luwrain\*.dll" Luwrain\ > nul
echo 7/8 uninstall luwrain and replace java cfg file
for %%a in (%LOCALAPPDATA%\luwrain\unins*.exe) do start /min /wait %%a /silent

:skipall

cd C:\luwrain.packager\iss-fix\
rem fix for jvm.dll, x64 java have no client mode but javafxpackager copy x32 library
if '%ARCH%'=='x64' (
  copy C:\luwrain.packager\jdk.x64\jre\bin\server\* Luwrain\runtime\bin\client\ > nul
)

cd C:\luwrain.packager\iss-fix\
copy Luwrain.cfg Luwrain\app\Luwrain.cfg > nul

echo 8/8 invoking inno setup compiler
iscc Luwrain.%ARCH%.iss > iscc.log
if not ERRORLEVEL == 0 (
  echo iss FIX error
  goto :onerror
)

rem move resulting file to 
cd C:\luwrain.packager\
if exist Luwrain-1.0.%ARCH%.exe del Luwrain-1.0.%ARCH%.exe
move C:\luwrain.packager\iss-fix\Output\Luwrain-1.0.exe C:\luwrain.packager\Luwrain-1.0.%ARCH%.exe > nul
echo ALL OK: result package is C:\luwrain.packager\Luwrain-1.0.%ARCH%.exe
pause
goto :eof
:onerror
cd C:\luwrain.packager\
echo log files: luwrain\ant.log luwrain\ant.erriss-fix\iscc.log
pause