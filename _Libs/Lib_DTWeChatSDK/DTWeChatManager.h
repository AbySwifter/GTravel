//
//  DTWeChatManager.h
//
//  Created by Raynay Yue on 5/6/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WXApi.h"

/*通知消息名称.当DTWeChatManager向微信App发送消息时,会同时发送该通知消息.*/
extern NSString *const DTWeChatManagerWillSendMessageToWeChatApp;

/**
 * @brief 微信分享消息的回调block.
 * @param bSuccess 发送成功与否.
 * @param error 若发送失败,则会返回一个NSError对象,包含错误的原因及错误代码.
 */
typedef void (^DTWeChatShareCompletionBlock)(BOOL bSuccess, NSError *error);

@class DTWeChatShareMessage;
@class DTWeChatUserProfile;
@protocol DTWeChatManagerDelegate;

/*与微信SDK通讯的类,负责处理与微信SDK相关的逻辑.*/
@interface DTWeChatManager : NSObject

/*该类的代理.*/
@property (nonatomic, weak) id<DTWeChatManagerDelegate> delegate;

@property (nonatomic, strong) BaseResp *resp;

/*返回该类的单例对象.*/
+ (DTWeChatManager *)sharedManager;

/**
 * @brief 判断用户手机上是否已安装微信App.
 * @retrun 已安装返回YES,否则返回NO.
 */
+ (BOOL)isWeChatAppInstalled;

/*跳转到手机的App Store中,并打开微信App的安装页面.*/
+ (void)goToInstallWeChatApp;

/**
 * @brief 向微信SDK注册.
 * @param key 注册所需的key.
 * @param sec 注册所需的secret
 * @retrun 注册成功返回YES,失败返回NO.
 */
- (BOOL)registerAppToWeChat:(NSString *)key secret:(NSString *)sec;

/*开始微信登陆认证.*/
- (void)startWeChatLogin;

- (void)processWeChatAppAuthResp:(SendAuthResp *)response;

- (void)processWeChatAppShareResp:(SendMessageToWXResp *)response;

/*登出*/
- (void)logout;

/**
 * @brief 分享一条DTWeChatShareMessage到微信,如果用户已安装微信App,则打开微信App进行分享.否则,则返回错误.
 * @param message 分享的DTWeChatShareMessage对象.
 * @param handler 分享结果的回调block.
 */
- (void)shareMessage:(DTWeChatShareMessage *)message withCompletionHandler:(DTWeChatShareCompletionBlock)handler;

@end

@protocol DTWeChatManagerDelegate <NSObject>

/**
 * @brief 当登陆成功时,该方法被调用.
 * @param manager DTWeChatManager对象.
 * @param profile 用户的profile对象,具体参见DTWeChatUserProfile的定义.
 */
- (void)weChatManager:(DTWeChatManager *)manager didGetWeChatUserProfile:(DTWeChatUserProfile *)profile;

/**
 * @brief 登陆失败时,该方法被调用.
 * @param manager DTWeChatManager对象.
 * @param error NSError对象,包含错误的原因及错误代码.
 */
- (void)weChatManager:(DTWeChatManager *)manager operationDidFailWithError:(NSError *)error;
@end