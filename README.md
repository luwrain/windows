Implementation of Luwrain speech backend for Windows (MSP)
================

This project allows to implement access to MSP.

## Requirements

If you want to build this source code, you'll need the next:
* Visual Studio 2013 for C#
* JDK 1.7 or higher (I used <a href="http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html" target="_blank">Oracle JDK</a> for development process)
* jni4net (https://github.com/jni4net/jni4net/releases/download/0.8.8.0/jni4net-0.8.8.0-bin.zip)

Please, don't forget to set JAVA_HOME environment variable and put bin folder of jdk to PATH.

## Preparing

First of all, you need to create folder "bridge" at root folder. After, you need
download https://github.com/jni4net/jni4net/releases/download/0.8.8.0/jni4net-0.8.8.0-bin.zip and
extract jni4net-0.8.8.0.zip to bridge folder.

As the result, you'll get the next structure:

```
bridge\
   bin\
   lib\
```

## How to build

```
./gradlew clean build buildPackage
```

After, you can take zip package from build/distributions folder.

## TODO

* add checkout of existing files for BAT
* add support of pitch
