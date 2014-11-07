@echo off
if not exist target mkdir target
if not exist target\classes mkdir target\classes


echo compile classes
javac -nowarn -d target\classes -sourcepath jvm -cp "c:\users\alexander\debiansync\github\windows\bridge\lib\jni4net.j-0.8.8.0.jar"; "jvm\luwrainwindows\WinSpeechBackend.java" 
IF %ERRORLEVEL% NEQ 0 goto end


echo LuwrainWindows.j4n.jar 
jar cvf LuwrainWindows.j4n.jar  -C target\classes "luwrainwindows\WinSpeechBackend.class"  > nul 
IF %ERRORLEVEL% NEQ 0 goto end


echo LuwrainWindows.j4n.dll 
csc /nologo /warn:0 /t:library /out:LuwrainWindows.j4n.dll /recurse:clr\*.cs  /reference:"c:\Users\Alexander\DebianSync\Github\windows\bridge\building\LuwrainWindows.dll" /reference:"c:\Users\Alexander\DebianSync\Github\windows\bridge\lib\jni4net.n-0.8.8.0.dll"
IF %ERRORLEVEL% NEQ 0 goto end


:end
