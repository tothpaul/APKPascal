# APKPascal

APKPascal is a work in progress project by Excute SARL (Paul TOTH)

the purpose is to build a Pascal compiler for the Android Dalvik Virtual Machine.

Contrary to Delphi that produce ARM native code embedded in a Dalvik Stub, APKPascal produce only Dalvik code. APKPascal is written with Delphi by the way :)

Note that Dalvik is not replaced by ART. Before Kitkat, the Dalvik code was interpreted by a JIT compiler on Android; with ART the application is compiled at install time to ARM native code (or whatever CPU the device has)...so the last Android Studio applications stills produce Dalvik code.

With Android Studio you write Java code that is compiled to Java Byte Code then translated to Dalvik Byte Code, the classes.dex file is put in an APK, aligned, signed etc.

APKPascal directly translate Pascal code to Dalvik Byte Code. It is also able to create and sign the APK file, and even install and start the application through ADB. And it DO NOT NEED the Android SDK nor NDK to do that (except for ADB, but you still can deploy the APK manually).

There's no "visual" design at this time, no "DFM" nor Layout, just inline Pascal code translated to what the Java equivalent code would produce. Extactly the same ? No because APKPascal use it's own compiler build from scratch with some nice optimisations (for the few code it can compile at this time).

You can use [jadx](https://github.com/skylot/jadx) for instance to explore the provided APK on this repository.

all the code (not public for now...not sure if it will be public) is mine, except for [BigIntegers](https://github.com/rvelthuis/DelphiBigNumbers), an excellent library by Rudy Velthuis, that is used to Sign the APK.

This repository presents the first steps in this project

1. [Demo1](Demo1) is the first "Hello World" application I've made.
2. [glDemo1](glDemo1) is the second one.

Paul TOTH
June 10, 2019