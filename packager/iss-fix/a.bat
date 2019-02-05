@echo off

cd C:\luwrain.packager\iss-fix\Luwrain\app

set CLASS_PATH=
rem collect *.jar files from lib and jar to CLASS_PATH
goto :go
:loop
  set CLASS_PATH=%CLASS_PATH%%1;
goto :eof
:go
for %%a in (jar\*.jar;lib\*.jar) do call :loop %%a

cd C:\luwrain.packager\iss-fix\

echo %CLASS_PATH:\=/% > fix.Luwrain.cfg.b

copy /b fix.Luwrain.cfg.a+fix.Luwrain.cfg.b+fix.Luwrain.cfg.c Luwrain.cfg > nul
