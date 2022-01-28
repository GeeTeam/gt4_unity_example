using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Runtime.InteropServices;

public class GT4iOSUnityHandler : MonoBehaviour
{

    // 导入定义在 .m 文件中的C函数
    [DllImport("__Internal")]
    private static extern void __iOSGT4SDKInit(string captchaId);
    [DllImport("__Internal")]
    private static extern void __iOSVerify(string callBackObjectName, string rejectCallBackName, string resolveCallBackName);
    [DllImport("__Internal")]
    private static extern void __iOSCancelCaptcha();

    // Start is called before the first frame update
    void Start()
    {
        // Your CaptchaId for GeeTest
        __iOSGT4SDKInit("7f24c87a7c9057ecdc9c501a6fcc3f1c");
    }

    // Update is called once per frame
    void Update()
    {

    }

    public void click() // 提供给 unity 触发验证的函数
    {
        //参数一：消息接受的对象名称
        //参数二：gt4 产生错误的消息名称
        //参数三：gt4 接受到验证结果的回调的消息名称
        __iOSVerify("GT4Handler", "gt4ErrorHandler", "gt4SuccessHandler");
    }

    // 处理错误的回调函数
    void gt4ErrorHandler(string str)
    {
        // TO-DO: 错误处理
        print("\nError: \n");
        print(str);
        print("\n");
    }
    
    // 处理成功数据的回调函数
    void gt4SuccessHandler(string str)
    {
        // TO-DO: 成功处理
        print("\nSuccess: \n");
        print(str);
        print("\n");
    }
}