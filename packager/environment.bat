@echo off
rem select arch to x64 or x32 from command line argument
set ARCH=x32
if '%1'=='x64' set ARCH=x64
rem setup local installation of java
set JAVAC_PATH=C:\luwrain.packager\jdk.%ARCH%\bin\javac.exe
set JAVA_HOME=C:\luwrain.packager\jdk.%ARCH%
set JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF8
rem setup minimalistic PATH env
set Path=C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;%JAVA_HOME%\bin;C:\luwrain.packager\Inno Setup 5\;C:\luwrain.packager\mingw\;C:\luwrain.packager\apache-ant-1.9.5\bin\;
