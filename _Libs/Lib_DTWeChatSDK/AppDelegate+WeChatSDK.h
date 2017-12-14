//
//  AppDelegate+WeChatSDK.h
//
//  Created by Raynay Yue on 5/6/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import "WeiboSDK.h"

@interface AppDelegate (WeChatSDK) <WeiboSDKDelegate, WXApiDelegate>
- (BOOL)registerAppToWeChat:(NSString *)appID secret:(NSString *)sec;
@end
