//
//  DTWeChatManager.m
//
//  Created by Raynay Yue on 5/6/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "DTWeChatManager.h"
#import "DTWeChatDefinitions.h"
#import "DTWeChatUserProfile.h"
#import "DTWeChatShareMessage.h"
#import "DTWeChatUnit.h"
#import "RYCommon.h"

NSString *const DTWeChatManagerWillSendMessageToWeChatApp = @"DTWeChatManagerWillSendMessageToWeChatApp";
@interface DTWeChatManager () <DTWeChatUnitDelegate, UIAlertViewDelegate, WXApiDelegate> {
    BOOL bIsRegistered;
}
@property (nonatomic, strong) DTWeChatUnit *weChatUnit;
@property (copy) DTWeChatShareCompletionBlock shareCompletionBlock;
@property (nonatomic, strong) DTWeChatShareMessage *messageToShare;

@property (nonatomic, copy) NSString *weChatAppKey;
@property (nonatomic, copy) NSString *weChatAppSecret;

- (void)startWeChatAuthentication;
- (void)sendAuthRequest;
- (void)processWeChatAppAuthResp:(SendAuthResp *)response;
- (void)startGetUserProfileWithAuthCode:(NSString *)code;

- (void)startToDownloadImageOfMessage:(DTWeChatShareMessage *)message;
- (void)startToShareMessage:(DTWeChatShareMessage *)message;
- (void)processWeChatAppShareResp:(SendMessageToWXResp *)response;
- (void)showWeChatAppNotInstallMessage;
@end

@implementation DTWeChatManager
#pragma mark - WXApiDelegate
//-(void)onReq:(BaseReq *)req
//{
//
//}
//
//
//- (void)onResp:(BaseResp *)resp
//{
//    if([[resp class] isSubclassOfClass:[SendAuthResp class]])
//    {
//        [self processWeChatAppAuthResp:(SendAuthResp*)resp];
//    }
//    else if([[resp class] isSubclassOfClass:[SendMessageToWXResp class]])
//    {
//        [self processWeChatAppShareResp:(SendMessageToWXResp*)resp];
//    }
//}

#pragma mark - DTWeChatUnitDelegate
// 获取到微信返回的用户数据
- (void)weChatUnit:(DTWeChatUnit *)authUnit didGetUserProfile:(DTWeChatUserProfile *)userProfile
{
    dispatch_async(dispatch_get_main_queue(), ^{
      if (self.delegate && [self.delegate respondsToSelector:@selector(weChatManager:didGetWeChatUserProfile:)]) {

          [self.delegate weChatManager:self didGetWeChatUserProfile:userProfile];
      }
    });
}

- (void)weChatUnit:(DTWeChatUnit *)authUnit operationDidFailWithError:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
      if (self.delegate && [self.delegate respondsToSelector:@selector(weChatManager:operationDidFailWithError:)]) {
          [self.delegate weChatManager:self operationDidFailWithError:error];
      }
    });
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        [DTWeChatManager goToInstallWeChatApp];
    }
}

#pragma mark - Non-Public Methods

// 安装后，判断token是否可用
- (void)startWeChatAuthentication
{
    if ([DTWeChatUnit weChatAuthTokensIsAvailable]) {
        self.weChatUnit = [DTWeChatUnit authUnitWithExistTokens];
        self.weChatUnit.delegate = self;
        [self.weChatUnit startAuthProgressWithCode:nil];
    }
    else {
        [self sendAuthRequest];
    }
}

- (void)sendAuthRequest
{
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = kSAWeChatAuthScope;
    req.state = kSAWeChatAuthState;
    [[NSNotificationCenter defaultCenter] postNotificationName:DTWeChatManagerWillSendMessageToWeChatApp object:nil];
    [WXApi sendReq:req];
}

- (void)processWeChatAppAuthResp:(SendAuthResp *)response
{
    RYCONDITIONLOG(DEBUG, @"code:%@,state:%@,errcode:%d", response.code, response.state, response.errCode);
    NSError *error = nil;
    switch (response.errCode) {
        case WXSuccess: {
            [self startGetUserProfileWithAuthCode:response.code];
            break;
        }
        case WXErrCodeCommon:
            error = [NSError errorWithDomain:@"WeiXin app auth request process failed with error: Common error!" code:WXErrCodeCommon userInfo:nil];
            break;
        case WXErrCodeUserCancel:
            error = [NSError errorWithDomain:@"WeiXin app auth request process failed with error: User cancelled!" code:WXErrCodeUserCancel userInfo:nil];
            break;
        case WXErrCodeSentFail:
            error = [NSError errorWithDomain:@"WeiXin app auth request process failed with error: Send fail!" code:WXErrCodeSentFail userInfo:nil];
            break;
        case WXErrCodeAuthDeny:
            error = [NSError errorWithDomain:@"WeiXin app auth request process failed with error: Auth is denied!" code:WXErrCodeAuthDeny userInfo:nil];
            break;
        case WXErrCodeUnsupport:
            error = [NSError errorWithDomain:@"WeiXin app auth request process failed with error: Unsupport!" code:WXErrCodeUnsupport userInfo:nil];
            break;
    }
    if (error) {
        dispatch_async(dispatch_get_main_queue(), ^{
          if (self.delegate && [self.delegate respondsToSelector:@selector(weChatManager:operationDidFailWithError:)]) {
              [self.delegate weChatManager:self operationDidFailWithError:error];
          }
        });
    }
}

- (void)startGetUserProfileWithAuthCode:(NSString *)code
{
    DTWeChatUnit *authUnit = [[DTWeChatUnit alloc] initWithAppID:self.weChatAppKey secret:self.weChatAppSecret];
    authUnit.delegate = self;
    self.weChatUnit = authUnit;
    [self.weChatUnit startAuthProgressWithCode:code];
}

- (void)startToDownloadImageOfMessage:(DTWeChatShareMessage *)message
{
    if (RYIsValidString(message.imageURL)) {
        NSString *strURL = message.imageURL;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
		NSURLSessionDataTask* task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable connectionError) {
			dispatch_async(dispatch_get_main_queue(), ^{
				if (connectionError) {
					[self startToShareMessage:message];
				}
				else {
					message.imageData = data;
					[self startToShareMessage:message];
				}
			});
		}];
		[task resume];
//        [NSURLConnection sendAsynchronousRequest:request
//                                           queue:[NSOperationQueue mainQueue]
//                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//                                 if (connectionError) {
//                                     [self startToShareMessage:message];
//                                 }
//                                 else {
//                                     message.imageData = data;
//                                     [self startToShareMessage:message];
//                                 }
//                               }];
    }
    else {
        [self startToShareMessage:message];
    }
}

- (void)startToShareMessage:(DTWeChatShareMessage *)message
{
    NSString *title = message.title;
    if (title.length > MaxLengthWeiXinShareTitle) {
        title = [title substringToIndex:MaxLengthWeiXinShareTitle];
    }

    WXMediaMessage *wxMessage = [WXMediaMessage message];
    wxMessage.title = title;
    wxMessage.description = message.messageDesc;
    if (message.imageData.length > 0) {
        if (message.imageData.length > MaxLengthWeiXinShareImageData) {
            message.imageData = [NSData compressImageData:message.imageData toLength:MaxLengthWeiXinShareImageData];
        }
        wxMessage.thumbData = message.imageData;
    }

    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = message.url;

    wxMessage.mediaObject = ext;
    wxMessage.mediaTagName = @"SHAKE_WECHAT_SHARE";

    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = wxMessage;
    req.scene = message.type == DTWeChatShareTypeMoments ? WXSceneTimeline : WXSceneSession;
    [[NSNotificationCenter defaultCenter] postNotificationName:DTWeChatManagerWillSendMessageToWeChatApp object:nil];
    [WXApi sendReq:req];
}

- (void)processWeChatAppShareResp:(SendMessageToWXResp *)response
{
    RYCONDITIONLOG(DEBUG, @"errcode:%d,error:%@", response.errCode, response.errStr);
    NSString *errorMessage = nil;
    switch (response.errCode) {
        case WXSuccess:
            self.shareCompletionBlock(YES, nil);
            break;
        case WXErrCodeCommon:
            errorMessage = [NSString stringWithFormat:@"Share failed with error:%@", response.errStr];
            break;
        case WXErrCodeUserCancel:
            errorMessage = [NSString stringWithFormat:@"User cancelled sharing! error:%@", response.errStr];
            break;
        case WXErrCodeSentFail:
            errorMessage = [NSString stringWithFormat:@"Sent fail with error:%@", response.errStr];
            break;
        case WXErrCodeAuthDeny:
            errorMessage = [NSString stringWithFormat:@"Auth failed with error:%@", response.errStr];
            break;
        case WXErrCodeUnsupport:
            errorMessage = [NSString stringWithFormat:@"Unsupport with error:%@", response.errStr];
            break;
    }
    if (errorMessage) {
        NSLog(@"%@", errorMessage);
        self.shareCompletionBlock(NO, [NSError errorWithDomain:errorMessage code:response.errCode userInfo:nil]);
    }
    self.messageToShare = nil;
}

- (void)showWeChatAppNotInstallMessage
{
    dispatch_async(dispatch_get_main_queue(), ^{
      RYShowAlertView(@"Failed", @"WeChat app isn't installed!Install it now?", self, 0, @"Not now", @"Install", nil);
    });
}

#pragma mark - Public Methods
static DTWeChatManager *sharedInstance = nil;
+ (DTWeChatManager *)sharedManager
{
    @synchronized(self)
    {
        if (sharedInstance == nil) {
            sharedInstance = [[self alloc] init];
        }
        return sharedInstance;
    }
    return nil;
}

+ (BOOL)isWeChatAppInstalled
{
    return [WXApi isWXAppInstalled];
}

+ (void)goToInstallWeChatApp
{
    NSString *strUrl = [WXApi getWXAppInstallUrl];
    NSURL *url = [NSURL URLWithString:strUrl];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (BOOL)registerAppToWeChat:(NSString *)key secret:(NSString *)sec
{
    self.weChatAppKey = key;
    self.weChatAppSecret = sec;
    bIsRegistered = [WXApi registerApp:key];
    NSLog(@"%d", bIsRegistered);
    return bIsRegistered;
}

// 微信登陆
- (void)startWeChatLogin
{
    //    if([DTWeChatManager isWeChatAppInstalled])
    //    {
    if (bIsRegistered) {
        [self startWeChatAuthentication];
    }
    else {
        RYCONDITIONLOG(DEBUG, @"Haven't register to WeiXin app!");
    }
    //    }
}

- (void)logout
{
    [self.weChatUnit logout];
    self.weChatUnit = nil;
}

- (void)shareMessage:(DTWeChatShareMessage *)message withCompletionHandler:(DTWeChatShareCompletionBlock)handler
{
    if ([DTWeChatManager isWeChatAppInstalled]) {
        if (bIsRegistered) {
            self.shareCompletionBlock = [handler copy];
            self.messageToShare = message;
            [self startToDownloadImageOfMessage:message];
        }
        else {
            handler(NO, [NSError errorWithDomain:@"Haven't register to WeChat app!" code:-1 userInfo:nil]);
        }
    }
    else {
        [self showWeChatAppNotInstallMessage];
        handler(NO, [NSError errorWithDomain:@"WeChat app isn't installed!" code:-2 userInfo:nil]);
    }
}

@end
