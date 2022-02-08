# gt4-unity-example

[English README](./README_EN.md)

## 工程目录说明 (Table Of Project Content )

```
.
├── Assembly-CSharp-firstpass.csproj
├── Assembly-CSharp.csproj
├── Assets
│   ├── Plugins
│   │   ├── Android
│   │   │   ├── AndroidManifest.xml // Android 清单文件
│   │   │   ├── geetest_captcha_android_v*.aar // Android SDK 文件（登录后台获取最新版本的 SDK）
│   │   │   ├── gt4-captcha-plugin-release.aar // Unity 调用 aar 插件
│   │   │   ├── kotlin-stdlib-*.jar // Android SDK 依赖 kotlin 文件
│   │   │   └── GT4AndroidUnityHandler.cs // Unity Android 调调用 script
│   │   └── iOS
│   │       ├── GTCaptcha4.bundle // 极验 iOS SDK bundle 文件（登录后台获取最新版本的 SDK）
│   │       ├── GTCaptcha4.framework // 极验 iOS SDK 文件（登录后台获取最新版本的 SDK）
│   │       ├── GTCaptcha4UnityBridge.h // 桥文件 .h
│   │       ├── GTCaptcha4UnityBridge.m // 桥文件 .m
│   │       └── GT4iOSUnityHandler.cs // Unity iOS 调用 script
│   └── Scenes
│       ├── SampleSceneAndroid.unity // Android 示例的 scene 文件
│       └── SampleSceneiOS.unity // iOS 示例的 scene 文件
├── Builds // 输出文件夹
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

## 如何运行 (Run)

从登录产品后台，获取最新的 iOS、Android SDK 按照上面的工程目录说明导入 SDK，即可运行。

> **示例工程使用 Unity 2020 开发**

## iOS 使用指南 (iOS Platform)

### 集成说明

1. 集成极验 iOS SDK 需要把 SDK 相关的文件 `GTCaptcha4.framework`、`GTCaptcha4.bundle` （登录产品后台获取）导入到工程的 `Assets/Plugins/iOS/` 路径下，此外 SDK 调用相关的桥文件 `GTCaptcha4UnityBridge.h`、`GTCaptcha4UnityBridge.m` ，C# 调用文件 `GT4iOSUnityHandler.cs` 导入到工程中的 **Assets** 目录下。
2. 参考 `GT4iOSUnityHandler.cs` 和 `SampleScene.unity` 关联 Unity 组件对象的事件，调用验证码模块。
3. 打开 `File - Build Settings`，并在平台中选择 iOS，场景中勾选 iOS 相应的场景。
4. 选择左下角的 `Player Settings - Other Settings`，确认 Xcode 工程相关的信息。真机使用 Device SDK，模拟器使用 Simulator SDK。
5. 选择 Build Settings 右下角的 Build 或 Build And Run，首次需要指定输出路径及文件夹名称。
6. 构建新的 Xcode 工程后，需要在项目的 **TARGETS - UnityFramework - Build Settings - Other Linker Flags** 中添加 `-ObjC`,  并在 **TARGETS - Unity-iPhone - Copy Bundle Resources** 添加 `GTCaptcha4.bundle`。
7. 运行 Xcode 工程。

### 自定义封装说明

如需更一步的封装极验 iOS SDK，您可能需要仔细阅读下列资料:

* 桥文件 `GTCaptcha4UnityBridge.m`、C# 调用文件 `GT4iOSUnityHandler.cs` ，以更进一步了解极验 iOS SDK 的 Unity 封装。
* [极验 iOS 官方文档](https://docs.geetest.com/gt4/deploy/client/ios) 和官方 Xcode Project 示例，以了解极验 iOS SDK 的原生使用方式。

## Android 使用指南 (Android Platform)

### 集成说明

1. 集成极验 Android SDK 需要把 SDK 相关的文件 `geetest_captcha_android_v*.aar` （登录产品后台获取） 导入到工程的 `Assets/Plugins/Android/` 路径下，此外 `kotlin-stdlib-*.aar` 、SDK 调用相关的桥文件 `gt4-captcha-plugin-release.aar`、C# 调用文件 `GT4AndroidUnityHandler.cs` 均需要导入到工程中的 **Assets** 目录下。
2. 参考 `GT4AndroidUnityHandler.cs` 和 `SampleScene.unity` 关联 Unity 组件对象的事件，调用验证码模块。
3. 打开 `File - Build Settings`，并在平台中选择 Android，场景中勾选 Android 相应的场景。
4. 选择左下角的 `Player Settings - Other Settings`，确认 Android 工程相关的信息。
5. 选择 Build Settings 右下角的 Build 或 Build And Run，首次需要指定输出路径及文件夹名称，运行结果将以apk包形式安装到手机。

### 自定义封装说明

如需更一步的封装极验 Android SDK，您可能需要仔细阅读下列资料:

1. 创建一个新的 Android studio 工程，新建一个 module，[极验 Android 官方文档](https://docs.geetest.com/gt4/deploy/client/android)。
2. 必要的验证方法以及验证流程封装可参考 `MainActivity.java` 文件。 
3. 完成自定义需求后，将 module 打包为新的 `gt4-captcha-plugin-release.aar` 文件。

`MainActivity.java` 示例 

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

