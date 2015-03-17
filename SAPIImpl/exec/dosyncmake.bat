@echo off
cd ..
call dosyncmake.bat
cd exec

"C:\Program Files (x86)\Java\jre1.8.0_31\bin\java.exe" -jar SAPIImplTest.jar 