//
//  DTWeChatUnit.h
//
//  Created by Raynay Yue on 5/6/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DTWeChatUserProfile;
@protocol DTWeChatUnitDelegate;
@interface DTWeChatUnit : NSObject
@property (nonatomic, weak) id<DTWeChatUnitDelegate> delegate;

+ (BOOL)weChatAuthTokensIsAvailable;
+ (DTWeChatUnit *)authUnitWithExistTokens;
- (instancetype)initWithAppID:(NSString *)appID secret:(NSString *)appSecret;

- (void)startAuthProgressWithCode:(NSString *)code;
- (void)logout;
@end

@protocol DTWeChatUnitDelegate <NSObject>

- (void)weChatUnit:(DTWeChatUnit *)authUnit didGetUserProfile:(DTWeChatUserProfile *)userProfile;
- (void)weChatUnit:(DTWeChatUnit *)authUnit operationDidFailWithError:(NSError *)error;

@end