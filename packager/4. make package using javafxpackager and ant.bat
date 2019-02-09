@echo off
call environment.bat %1
cd C:\luwrain.packager\luwrain\
echo 4/8 first try, make exe package
call ant > ant.log 2> ant.err
if not ERRORLEVEL == 0 (
  echo ANT error
  goto :onerror
)
