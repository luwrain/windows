@echo off

rem set LUWRAIN_HOME to current dir
for /f %%i in ("%0") do set LUWRAIN_HOME=%%~dpi

set LUWRAIN_LANG=ru
set LUWRAIN_MAIN_CLASS=org.luwrain.core.Init
set LUWRAIN_SPEECH_CLASS=org.luwrain.windows.speech.SAPI

set LUWRAIN_USER_HOME_DIR=%USERPROFILE%\Documents
set LUWRAIN_DATA_DIR=%LUWRAIN_HOME%data
set LUWRAIN_REGISTRY_DIR=%LUWRAIN_HOME%registry

set CLASS_PATH=
rem collect *.jar files from lib and jar to CLASS_PATH
goto :go
:loop
  set CLASS_PATH=%CLASS_PATH%%1;
goto :eof
:go
for %%a in (jar\*.jar;lib\*.jar) do call :loop %%a

rem let's go
java -cp %CLASS_PATH% %LUWRAIN_MAIN_CLASS% --registry-dir="%LUWRAIN_REGISTRY_DIR%" --lang=%LUWRAIN_LANG% --os=org.luwrain.windows.Windows --speech=%LUWRAIN_SPEECH_CLASS% --data-dir="%LUWRAIN_DATA_DIR%" --user-home-dir="%LUWRAIN_USER_HOME_DIR%"
