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

if not exist %LOCALAPPDATA%\luwrain\app\SAPIImpl.32.dll goto :onerror
cd %LOCALAPPDATA%\luwrain\app

set LUWRAIN_HOME=%LOCALAPPDATA%\luwrain\app

set LUWRAIN_LANG=ru
set LUWRAIN_MAIN_CLASS=org.luwrain.core.Init

set LUWRAIN_USER_DATA_DIR=%APPDATA%\luwrain
set LUWRAIN_USER_HOME_DIR=%USERPROFILE%\Documents
set LUWRAIN_DATA_DIR=%LUWRAIN_HOME%\data
set LUWRAIN_REGISTRY_DIR=%APPDATA%\luwrain\registry

set LUWRAIN_JAVA_OPTS=-server

rem check if user data dir not exist and init it
if not exist "%LUWRAIN_USER_DATA_DIR%" (
  xcopy sqlite "%LUWRAIN_USER_DATA_DIR%\sqlite" /E /C /I /H /R /Y /Q > nul
  xcopy registry "%LUWRAIN_USER_DATA_DIR%\registry" /E /C /I /H /R /Y /Q > nul
)

set CLASS_PATH=jar\luwrain.jar;jar\luwrain-base.jar

rem let's go
cd %APPDATA%\luwrain\app
java %LUWRAIN_JAVA_OPTS% -cp %CLASS_PATH% %LUWRAIN_MAIN_CLASS% --consolo-log
rem --registry-dir="%LUWRAIN_REGISTRY_DIR%" --lang=%LUWRAIN_LANG% --os=org.luwrain.windows.Windows --data-dir="%LUWRAIN_DATA_DIR%" --user-home-dir="%LUWRAIN_USER_HOME_DIR%" --user-data-dir="%LUWRAIN_USER_DATA_DIR%"
pause
goto :eof
:onerror
echo luwrain not installed?
pause