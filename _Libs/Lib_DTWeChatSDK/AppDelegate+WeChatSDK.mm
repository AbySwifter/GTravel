//
//  AppDelegate+WeChatSDK.m
//
//  Created by Raynay Yue on 5/6/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "AppDelegate+WeChatSDK.h"
#import "DTWeChatManager.h"


@implementation AppDelegate (WeChatSDK)


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    //    return [ShareSDK handleOpenURL:url wxDelegate:self];

    NSString *string = url.absoluteString;
    NSLog(@"%@", string);
    BOOL l;

    if ([string hasPrefix:@"wx"]) {
        l = [WXApi handleOpenURL:url delegate:self];
    }
    else if ([string hasPrefix:@"wb"]) {
        l = [ShareSDK handleOpenURL:url wxDelegate:self];
    }
    return l;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSString *string = url.absoluteString;
    BOOL l;
    if ([string hasPrefix:@"wx"]) {
        l = [WXApi handleOpenURL:url delegate:self];
    }
    else if ([string hasPrefix:@"wb"]) {
        l = [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:self];
    }
    return l;
}

#pragma mark - Public Methods
- (BOOL)registerAppToWeChat:(NSString *)appID secret:(NSString *)sec
{
    return [[DTWeChatManager sharedManager] registerAppToWeChat:appID secret:sec];
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
}

- (void)onResp:(BaseResp *)resp
{
    /*
     ErrCode ERR_OK = 0(用户同意)
     ERR_AUTH_DENIED = -4（用户拒绝授权）
     ERR_USER_CANCEL = -2（用户取消）
     code 用户换取access_token的code，仅在ErrCode为0时有效
     state 第三方程序发送时用来标识其请求的唯一性的标志，由第三方程序调用sendReq时传入，由微信终端回传，state字符串长度不能超过1K
     lang 微信客户端当前语言
     country 微信用户当前国家信息
     */
    SendAuthResp *aresp = (SendAuthResp *)resp;
    if (aresp.errCode == 0) {
        //        NSString *code = aresp.code;


        if ([[resp class] isSubclassOfClass:[SendAuthResp class]]) {
            [[DTWeChatManager sharedManager] processWeChatAppAuthResp:aresp];
        }
        else if ([[resp class] isSubclassOfClass:[SendMessageToWXResp class]]) {
            [[DTWeChatManager sharedManager] processWeChatAppShareResp:(SendMessageToWXResp *)resp];
        }


        //        NSLog(@"%@",code);

        //        NSDictionary *dic = @{@"code" :code};
    }
    else if (aresp.errCode == -4) {
        NSLog(@"用户拒绝");
    }
    else if (aresp.errCode == -2) {
        NSLog(@"用户取消");
    }


    //
    //        if([[resp class] isSubclassOfClass:[SendAuthResp class]])
    //        {
    ////            NSLog(@"%@")
    ////            DTWeChatManager *manager = [DTWeChatManager sharedManager];
    ////            manager.resp = resp;
    ////            [[NSNotificationCenter defaultCenter] postNotificationName:@"didSendAuthResp" object:nil];
    ////            [manager processWeChatAppAuthResp:(SendAuthResp*)resp];
    //        }
    //        else if([[resp class] isSubclassOfClass:[SendMessageToWXResp class]])
    //        {
    //
    ////            DTWeChatManager *manager = [DTWeChatManager sharedManager];
    ////            manager.resp = resp;
    ////            [[NSNotificationCenter defaultCenter] postNotificationName:@"didSendMessageToWXResp" object:nil];
    ////            [DTWeChatManager processWeChatAppShareResp:(SendMessageToWXResp*)resp];
    //        }
}

@end
