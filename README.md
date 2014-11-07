Implementation of Luwrain speech backend for Windows (MSP)
================

This project allows to implement access to MSP.

## Requirements

If you want to build this source code, you'll need the next:
* Visual Studio 2013 for C#
* JDK 1.7 or higher (I used <a href="http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html" target="_blank">Oracle JDK</a> for development process)

Please, don't forget to set JAVA_HOME environment variable and put bin folder of jdk to PATH.

## How to build

```
./gradlew clean build buildPackage
```

After, you can take zip package from build/distributions folder.

## TODO

* add checkout of existing files for BAT
* add support of pitch
