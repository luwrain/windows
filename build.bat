:: remove old files
IF EXIST "libs\jni4net.j-0.8.8.0.jar" (
  del libs\jni4net.j-0.8.8.0.jar
)

IF EXIST "libs\jni4net.n-0.8.8.0.dll" (
  del libs\jni4net.n-0.8.8.0.dll
)

IF EXIST "libs\jni4net.n.w32.v40-0.8.8.0.dll" (
  del libs\jni4net.n.w32.v40-0.8.8.0.dll
)

IF EXIST "libs\jni4net.n.w64.v40-0.8.8.0.dll" (
  del libs\jni4net.n.w64.v40-0.8.8.0.dll
)

IF EXIST "libs\LuwrainWindows.dll" (
  del libs\LuwrainWindows.dll
)

IF EXIST "libs\LuwrainWindows.j4n.dll" (
  del libs\LuwrainWindows.j4n.dll
)

IF EXIST "libs\LuwrainWindows.j4n.jar" (
  del libs\LuwrainWindows.j4n.jar
)

:: preparing building directory
rmdir /Q /S bridge\building
mkdir bridge\building

:: run building process
MSBuild.exe windows\LuwrainWindows\LuwrainWindows.sln

:: copy building result
copy windows\LuwrainWindows\LuwrainWindows\bin\Debug\LuwrainWindows.dll bridge\building

:: run building proxy
cd bridge\building
..\bin\proxygen.exe LuwrainWindows.dll -wd .
cmd /c build.cmd
