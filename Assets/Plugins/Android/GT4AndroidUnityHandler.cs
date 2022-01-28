using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class GT4AndroidUnityHandler : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        Button btn = this.GetComponent<Button>();
        btn.onClick.AddListener(OnClick);
    }

    public void OnClick()
    {
        AndroidJavaClass jc = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
        AndroidJavaObject jo = jc.GetStatic<AndroidJavaObject>("currentActivity");
        // init
        jo.Call("initWithCaptchaId", "Your captcha id.");
        // WebView Timeout
        jo.Call("setWebViewTimeout", 10000);
        // language
        jo.Call("setLanguage", "en");
        // start
        jo.Call("startGT4Captcha", new PluginCallback());
    }

    class PluginCallback : AndroidJavaProxy
    {
        public PluginCallback() : base("com.geetest.captcha.unity.PluginCallback") { }

        public void gt4SuccessHandler(bool status, string response)
        {
            Debug.Log("GT4Captcha callback onSuccess status: " + status + ", response" + response);
        }
        public void gt4ErrorHandler(string error)
        {
            Debug.Log("GT4Captcha callback onFailed: " + error);
        }
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
