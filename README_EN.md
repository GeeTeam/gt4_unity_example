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
│   │   │   ├── geetest_captcha_android_v*.aar // Android SDK （download the latest version from GeeTest dashboard）
│   │   │   ├── gt4-captcha-plugin-release.aar // Unity calls aar plugin
│   │   │   ├── kotlin-stdlib-*.jar // Android SDK relies on kotlin 
│   │   │   └── GT4AndroidUnityHandler.cs // The script called by Unity Android
│   │   └── iOS
│   │       ├── GTCaptcha4.bundle // GeeTest iOS SDK bundle docs（download the latest version from GeeTest dashboard）
│   │       ├── GTCaptcha4.framework // GeeTest iOS SDK （download the latest version from GeeTest dashboard）
│   │       ├── GTCaptcha4UnityBridge.h // Bridge header file
│   │       ├── GTCaptcha4UnityBridge.m // Bridge implemention file
│   │       └── GT4iOSUnityHandler.cs // The script called by Unity iOS
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

Download the latest iOS Android SDK from GeeTest dashboard, and import SDK according to the project catalog above to run.  

> **The sample is developed by Unity 2020**

## iOS Platform

### Implemention steps

1. Import `GTCaptcha4.framework`, `GTCaptcha4.bundle` (download from GeeTest dashboard) to `Assets/Plugins/iOS/` of the project. Import `GTCaptcha4UnityBridge.h`, `GTCaptcha4UnityBridge.m`, and `GT4iOSUnityHandler.cs` and to **Assets** of the project.
2. Refer to the association of Unity component object, `GT4iOSUnityHandler.cs` and `SampleScene.unity`, call CAPTCHA module.  
3. Open `File - Build Settings` and check iOS in the platform and check the relevant scenes in iOS. 
4. Check `Player Settings - Other Settings` in the bottom left and validate the information of Xcode project. Use Device SDK in real device and Simulator SDK for monitors. 
5. Check "Build Settings" in the bottom right of "Build" or "Build And Run". If it's the first time, you will need to specify the output route and file name.  
6. When new Xcode project is built, add `-ObjC` in  **TARGETS - UnityFramework - Build Settings - Other Linker Flags**  of the project and add  `GTCaptcha4.bundle` in  **TARGETS - Unity-iPhone - Copy Bundle Resources**. 
7. Run Xcode project. 

### Custom implementation guidelines 

You are able to encapsulate a customized Native iOS SDK as a plugin on the Unity platform if you prefer. Below is information for your reference:

* Bridge file `GTCaptcha4UnityBridge.m`、C# file `GT4iOSUnityHandler.cs`
* [GeeTest iOS official developer docs](https://docs.geetest.com/BehaviorVerification/deploy/client/ios) and offical Xcode Project sample，to gain better understanding of native use method of iOS SDK 。

## Android Platform

### Implemention steps

1. Import `geetest_captcha_android_v*.aar`(download from GeeTest dashboard) to `Assets/Plugins/Android/` of the project. Import `kotlin-stdlib-*.aar`, `gt4-captcha-plugin-release.aar`, and `GT4AndroidUnityHandler.cs` to **Assets** of the project.  
2. Refer to the association of Unity component object, `GT4AndroidUnityHandler.cs `and `SampleScene.unity`, call CAPTCHA module.  
3. Open `File - Build Settings` and check Android in the platform and check the relavant scenes. 
4. Check `Player Settings - Other Settings` in the bottom left and validate the information related with Android project. 
5. Check Build or Build And Run in the right botton of Build Settings. If it's the first time, you will need to specify the output route and file name. Implement the result in the cellphone as apk package. 

### Custom implementation guidelines 

You are able to encapsulate a customized Native Android SDK as a plugin on the Unity platform if you prefer. Below is information for your reference:

1. Create a new Android studio project and create a module. [GeeTest Android  official developer docs](https://docs.geetest.com/BehaviorVerification/deploy/client/android) 
2. Refer to  `MainActivity.java` for necessary verification method and implementation steps. 
3. After fulfill the custom requirements, package the module as a new  `gt4-captcha-plugin-release.aar` file. 

`MainActivity.java` Example：

```java
public class MainActivity extends UnityPlayerActivity {

    // CaptchaId
    private String captchaId;
    private int webViewTimeout = 10000;
    private String language = null;
    private GTCaptcha4Client gtCaptcha4Client;

    public void initWithCaptchaId(String captchaId) {
        this.captchaId = captchaId;
        gtCaptcha4Client = GTCaptcha4Client.getClient(this);
    }

    public void setWebViewTimeout(int webViewTimeout) {
        this.webViewTimeout = webViewTimeout;
    }

    public void setLanguage(String language) {
        this.language = language;
    }

    public void startGT4Captcha(final PluginCallback callback) {
        UnityPlayer.currentActivity.runOnUiThread(new Runnable() {
            public void run() {
                verify(callback);
            }
        });
    }

    public void verify(final PluginCallback callback) {
        GTCaptcha4Config gtCaptcha4Config = new GTCaptcha4Config.Builder()
                .setTimeOut(webViewTimeout)
                .setLanguage(language)
                .build();
        gtCaptcha4Client.init(captchaId, gtCaptcha4Config)
                .addOnSuccessListener(new GTCaptcha4Client.OnSuccessListener() {
                    @Override
                    public void onSuccess(boolean status, String response) {
                        if (callback != null) {
                            callback.gt4SuccessHandler(status, response);
                        }
                    }
                })
                .addOnFailureListener(new GTCaptcha4Client.OnFailureListener() {
                    @Override
                    public void onFailure(String error) {
                        if (callback != null) {
                            callback.gt4ErrorHandler(error);
                        }
                    }
                })
                .verifyWithCaptcha();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        // TODO You have to add it.
        if (gtCaptcha4Client != null) {
            gtCaptcha4Client.destroy();
        }
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        if (gtCaptcha4Client != null) {
            gtCaptcha4Client.configurationChanged(newConfig);
        }
    }

}


public interface PluginCallback {
    void gt4ErrorHandler(String error);

    void gt4SuccessHandler(boolean status, String response);
}
```

