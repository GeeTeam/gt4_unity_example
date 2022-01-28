# gt4-unity-example

## Table Of Project Content 

```
.
├── Assembly-CSharp-firstpass.csproj
├── Assembly-CSharp.csproj
├── Assets
│   ├── Plugins
│   │   ├── Android
│   │   │   ├── AndroidManifest.xml // Android Manifest
│   │   │   ├── geetest_captcha_android_v*.aar // Android SDK （Log into the dashboard for the latest SDK）
│   │   │   ├── gt4-captcha-plugin-release.aar // Unity call aar plugin
│   │   │   ├── kotlin-stdlib-*.jar // Android SDK rely on kotlin 
│   │   │   └── GT4AndroidUnityHandler.cs // Unity Android call script
│   │   └── iOS
│   │       ├── GTCaptcha4.bundle // GeeTest iOS SDK bundle docs（Log into the dashboard for the latest SDK）
│   │       ├── GTCaptcha4.framework // GeeTest iOS SDK （Log into the dashboard for the latest SDK）
│   │       ├── GTCaptcha4UnityBridge.h // Bridge header file
│   │       ├── GTCaptcha4UnityBridge.m // Bridge implemention file
│   │       └── GT4iOSUnityHandler.cs // Unity iOS call script
│   └── Scenes
│       ├── SampleSceneAndroid.unity // Android unity  sample scene file.
│       └── SampleSceneiOS.unity // iOS unity sample scene file.
├── Builds // Output file folder
├── GTCaptcha4UnityExample.sln
├── Library
├── Logs
├── Packages
├── ProjectSettings
├── README.md
├── Temp
├── UserSettings
└── obj
```

## Run 

Log into the dashboard, obtain the latest iOS, Android SDK and import SDK according to the project catalog above and run. 

> **Sample of develop project use in Unity 2020**

## iOS Platform

### Implemention steps

1. Import the SDK related doc including `GTCaptcha4.framework`、`GTCaptcha4.bundle` （obtain from dashboard) to the project route `Assets/Plugins/iOS/` during the implementation of the SDK. At the same time, related bridge docs including `GTCaptcha4UnityBridge.h`、`GTCaptcha4UnityBridge.m` called by the SDK  , `GT4iOSUnityHandler.cs` Called by C# should all be imported to the project catalog **Assets**  
2. Associate the events of Unity component object by refering to `GT4iOSUnityHandler.cs` and `SampleScene.unity`. Call CAPTCHA module. 
3. Open `File - Build Settings` and check iOS in the platform and check the relavant scenes. 
4. Check `Player Settings - Other Settings` in the left bottom and validate the information related with Xcode project. Use Device SDK in real machine and Simulator SDK for monitors. 
5. Check Build or Build And Run in the right botton of Build Settings. If it's for the first time, you will need to specify on the output route and file name. 
6. When new Xcode project is built, add `-ObjC` in  **TARGETS - UnityFramework - Build Settings - Other Linker Flags**  of the project and add  `GTCaptcha4.bundle` in  **TARGETS - Unity-iPhone - Copy Bundle Resources**. 
7. Run Xcode project. 

### Custom implementation guidelines 

If you need to implement iOS SDK in custom way，below information will be useful:

* Bridge file `GTCaptcha4UnityBridge.m`、C# file `GT4iOSUnityHandler.cs`
* [GeeTest iOS official developer docs](https://docs.geetest.com/BehaviorVerification/deploy/client/ios) and offical Xcode Project sample，to gain better understanding of native use method of iOS SDK 。

## Android Platform

### Implemention steps


1. Import the SDK related doc including `geetest_captcha_android_v*.aar`（obtain from dashboard) to the project route `Assets/Plugins/Android/`  during the implementation of the SDK. At the same time,  `kotlin-stdlib-*.aar`, related bridge docs including `gt4-captcha-plugin-release.aar` called by SDK. `GT4AndroidUnityHandler.cs` called by C# should all be imported to the project catalog **Assets** 
2. Associate the events of Unity component object by refering to  `GT4AndroidUnityHandler.cs` and `SampleScene.unity` . Call CAPTCHA module. 
3. Open `File - Build Settings` and check Android in the platform and check the relavant scenes. 
4. Check `Player Settings - Other Settings` in the left bottom and validate the information related with Android project. 
5. Check Build or Build And Run in the right botton of Build Settings. If it's for the first time, you will need to specify on the output route and file name. Implement the result in the cellphone as apk package. 

### Custom implementation guidelines 

If you need to implement Android SDK in custom way，below information will be useful:

1. Create a new Android studio project and create a module. [GeeTest Android  official developer docs](https://docs.geetest.com/BehaviorVerification/deploy/client/android) 
2. Refer to  `MainActivity.java` for necessary verification method and implementation steps. 
3. After fulfill the custom requirements, package the module as a new  `gt4-captcha-plugin-release.aar` file. 