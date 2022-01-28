#import "GTCaptcha4UnityBridge.h"
#import <GTCaptcha4/GTCaptcha4.h>

#if defined(__cplusplus)
extern "C"{
#endif
    // 桥接函数
    extern void __iOSGT4SDKInit(const char *captchaId);
    extern void __iOSVerify(const char *callBackObjectName, const char *rejectCallBackName, char *resolveCallBackName);
    extern void __iOSCancelCaptcha();
#if defined(__cplusplus)
}
#endif

@interface GTCaptcha4UnityBridge () <GTCaptcha4SessionTaskDelegate>

@property (strong, nonatomic) GTCaptcha4Session *captchaSession;

// 回调对象监听的名字
@property (copy, nonatomic) NSString *callBackObjectName;
// 行为验证SDK抛出错误的回调方法名
@property (copy, nonatomic) NSString *rejectCallBackName;
// 收到验证结果的回调方法名
@property (copy, nonatomic) NSString *resolveCallBackName;


@end

static GTCaptcha4UnityBridge *mySDK = nil;

@implementation GTCaptcha4UnityBridge

// 以单例形式创建
+(instancetype)sharedBridge {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mySDK = [[GTCaptcha4UnityBridge alloc] init];
    });
    return mySDK;
}

- (void)initSessionWithCaptchaId:(NSString *)captchaId {
    if (!_captchaSession) {
        GTCaptcha4SessionConfiguration *config = [GTCaptcha4SessionConfiguration defaultConfiguration];
        // TO-DO
        // config.language = ...
        // config.timeout = ...
        _captchaSession = [GTCaptcha4Session sessionWithCaptchaID:captchaId configuration:config];
        _captchaSession.delegate = self;
        
    }
}

// 开始验证
- (void)verify {
    [self.captchaSession verify];
}

// 取消当前验证
- (void)cancel {
    [self.captchaSession cancel];
}

#pragma mark -- iOS to Unity   iOS调用Unity方法

+ (void)sendU3dMessage:(NSString *)messageName withParam:(NSDictionary *)dict {
    if (messageName) {
        NSString *param = @"";
        if ( nil != dict ) {
            for (NSString *key in dict) {
                if ([param length] == 0) {
                    param = [param stringByAppendingFormat:@"%@=%@", key, [dict valueForKey:key]];
                }
                else {
                    param = [param stringByAppendingFormat:@"&%@=%@", key, [dict valueForKey:key]];
                }
            }
        }
        if (mySDK.callBackObjectName) {
            UnitySendMessage([mySDK.callBackObjectName UTF8String], [messageName UTF8String], [param UTF8String]);
        }
    }
}

#pragma mark -- GTCaptcha4SessionTaskDelegate

- (void)gtCaptchaSessionWillShow:(GTCaptcha4Session *)captchaSession {
    // TO-DO
    // 图形验证将要展示的时候，会通过该入口进行通知
    NSLog(@"Captcha will show UI.");
}

- (void)gtCaptchaSession:(GTCaptcha4Session *)captchaSession didReceive:(NSString *)code result:(NSDictionary *)result {
    NSLog(@"result: %@", result);
    if ([@"1" isEqualToString:code]) {
        // 成功获得二次校验结果
        [GTCaptcha4UnityBridge sendU3dMessage:self.resolveCallBackName withParam:result];
    }
    else {
        NSLog(@"Try agian");
    }
}

- (void)gtCaptchaSession:(GTCaptcha4Session *)captchaSession didReceiveError:(GTC4Error *)error {
  NSLog(@"error: %@", error.desc);
  // 详细错误码，请对照错误码清单
  [GTCaptcha4UnityBridge sendU3dMessage:self.rejectCallBackName withParam:error.desc];
}


#if defined(__cplusplus)
extern "C"{
#endif
    
#pragma mark -- Func for Unity   供u3d调用的c函数
    
    //初始化
    void __iOSGT4SDKInit(const char *captchaId) {
        [[GTCaptcha4UnityBridge sharedBridge] initSessionWithCaptchaId:[NSString stringWithUTF8String:captchaId]]; // default timeout 5.0s
    }
    
    //开启验证
    void __iOSVerify(const char *callBackObjectName, const char *rejectCallBackName, char *resolveCallBackName) {
        if(mySDK == NULL || mySDK == nil) {
            return;
        }
        mySDK.callBackObjectName = [NSString stringWithUTF8String:callBackObjectName];
        mySDK.rejectCallBackName = [NSString stringWithUTF8String:rejectCallBackName];
        mySDK.resolveCallBackName = [NSString stringWithUTF8String:resolveCallBackName];
        [mySDK verify];
    }
    
    //关闭验证界面
    void __iOSCancelCaptcha() {
        [mySDK cancel];
    }
    
#if defined(__cplusplus)
}
#endif

@end
