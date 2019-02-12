@echo off
call environment.bat x64
call jdkcheck.bat
call environment.bat x32
call jdkcheck.bat
