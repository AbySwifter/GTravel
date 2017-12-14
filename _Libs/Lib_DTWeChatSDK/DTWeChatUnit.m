//
//  DTWeChatUnit.m
//
//  Created by Raynay Yue on 5/6/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "DTWeChatUnit.h"
#import "DTWeChatDefinitions.h"
#import "RYCommon.h"
#import "DTWeChatLog.h"
#import "DTWeChatUserProfile.h"

#define kDTWeChatUnitAppID @"kDTWeChatUnitAppID"
#define kDTWeChatUnitAppSecret @"kDTWeChatUnitAppSecret"
#define kDTWeChatUnitAccessToken @"kDTWeChatUnitAccessToken"
#define kDTWeChatUnitRefreshToken @"kDTWeChatUnitRefreshToken"
#define kDTWeChatUnitOpenID @"kDTWeChatUnitOpenID"

#define kDTWeChatUnitAccessTokenExpireDate @"kDTWeChatUnitAccessTokenExpireDate"
#define kDTWeChatUnitRefreshTokenExpireDate @"kDTWeChatUnitRefreshTokenExpireDate"

#define TimeintervalRefreshToken 3600 * 24 * 30

#define DTDateFormatString @"yyyy-MM-dd HH:mm:ss"

#define RequestTimeOut 30

typedef void (^DTWeChatAuthResponseBlock)(NSError *error, NSDictionary *dict);

@interface DTWeChatUnit ()

@property (nonatomic, readonly) NSUserDefaults *userDefaults;

@property (nonatomic, weak) NSString *appID;
@property (nonatomic, weak) NSString *appSecret;
@property (nonatomic, weak) NSString *accessToken;
@property (nonatomic, weak) NSString *refreshToken;
@property (nonatomic, weak) NSString *openID;
@property (nonatomic, weak) NSDate *accessTokenExpireDate;
@property (nonatomic, weak) NSDate *refreshTokenExpireDate;

- (void)saveValue:(NSString *)value forKey:(NSString *)key;

- (BOOL)isAccessTokenExpired;
- (void)startToGetUserInfo;

- (void)saveAccessTokenByDictionary:(NSDictionary *)dict;
- (void)saveRefreshTokenByDictionary:(NSDictionary *)dict;

- (void)getWeChatAccessTokenWithCode:(NSString *)code CompletionBlock:(DTWeChatAuthResponseBlock)block;
- (void)refreshWeChatAccessTokenCompletionBlock:(DTWeChatAuthResponseBlock)block;
- (void)checkWeChatAccessTokenAvailableCompletionBlock:(void (^)(NSError *err))block;
- (void)getUserInfoCompletionBlock:(DTWeChatAuthResponseBlock)block;

@end

@implementation DTWeChatUnit
#pragma mark - Property Methods
- (NSUserDefaults *)userDefaults
{
    return [NSUserDefaults standardUserDefaults];
}

- (NSString *)appID
{
    NSString *str = [self.userDefaults valueForKey:kDTWeChatUnitAppID];
    return str;
}

- (void)setAppID:(NSString *)appID
{
    [self saveValue:appID forKey:kDTWeChatUnitAppID];
}

- (NSString *)appSecret
{
    return [self.userDefaults valueForKey:kDTWeChatUnitAppSecret];
}

- (void)setAppSecret:(NSString *)appSecret
{
    [self saveValue:appSecret forKey:kDTWeChatUnitAppSecret];
}

- (NSString *)accessToken
{
    return [self.userDefaults valueForKey:kDTWeChatUnitAccessToken];
}

- (void)setAccessToken:(NSString *)accessToken
{
    [self saveValue:accessToken forKey:kDTWeChatUnitAccessToken];
}

- (NSString *)refreshToken
{
    return [self.userDefaults valueForKey:kDTWeChatUnitRefreshToken];
}

- (void)setRefreshToken:(NSString *)refreshToken
{
    [self saveValue:refreshToken forKey:kDTWeChatUnitRefreshToken];
}

- (NSString *)openID
{
    return [self.userDefaults valueForKey:kDTWeChatUnitOpenID];
}

- (void)setOpenID:(NSString *)openID
{
    [self saveValue:openID forKey:kDTWeChatUnitOpenID];
}

- (NSDate *)accessTokenExpireDate
{
    NSDate *date = nil;
    NSString *strDate = [self.userDefaults valueForKey:kDTWeChatUnitAccessTokenExpireDate];
    if (RYIsValidString(strDate)) {
        date = RYDate(strDate, DTDateFormatString);
    }
    return date;
}

- (void)setAccessTokenExpireDate:(NSDate *)accessTokenExpireDate
{
    NSString *dateStr = RYDateString(accessTokenExpireDate, DTDateFormatString);
    [self saveValue:dateStr forKey:kDTWeChatUnitAccessTokenExpireDate];
}

- (NSDate *)refreshTokenExpireDate
{
    NSDate *date = nil;
    NSString *strDate = [self.userDefaults valueForKey:kDTWeChatUnitRefreshTokenExpireDate];
    if (RYIsValidString(strDate)) {
        date = RYDate(strDate, DTDateFormatString);
    }
    return date;
}

- (void)setRefreshTokenExpireDate:(NSDate *)refreshTokenExpireDate
{
    NSString *dateStr = RYDateString(refreshTokenExpireDate, DTDateFormatString);
    [self saveValue:dateStr forKey:kDTWeChatUnitRefreshTokenExpireDate];
}

#pragma mark - Non-Public Methods
- (void)saveValue:(NSString *)value forKey:(NSString *)key
{
    NSString *valueSaved = RYIsValidString(value) ? value : @"";
    [self.userDefaults setValue:valueSaved forKey:key];
    [self.userDefaults synchronize];
}

- (BOOL)isAccessTokenExpired
{
    BOOL isExpired = NO;
    if (self.accessTokenExpireDate) {
        isExpired = [[NSDate date] timeIntervalSinceDate:self.accessTokenExpireDate] > 0;
    }
    return isExpired;
}

- (void)startToGetUserInfo
{
    [self getUserInfoCompletionBlock:^(NSError *error, NSDictionary *dict) {
      if (error) {
          dispatch_async(dispatch_get_main_queue(), ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(weChatUnit:operationDidFailWithError:)]) {
                [self.delegate weChatUnit:self operationDidFailWithError:error];
            }
          });
      }
      else {
          DTWeChatUserProfile *profile = [DTWeChatUserProfile weChatUserProfileWithDictionary:dict];
          dispatch_async(dispatch_get_main_queue(), ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(weChatUnit:didGetUserProfile:)]) {
                [self.delegate weChatUnit:self didGetUserProfile:profile];
            }
          });
      }
    }];
}

- (void)saveAccessTokenByDictionary:(NSDictionary *)dict
{
    NSString *accessToken = dict[kResAccessToken];
    NSString *expiresIn = dict[kResExpiresIn];
    self.accessToken = accessToken;
    NSDate *accessTokenExpireDate = [[NSDate date] dateByAddingTimeInterval:[expiresIn floatValue]];
    self.accessTokenExpireDate = accessTokenExpireDate;
}

- (void)saveRefreshTokenByDictionary:(NSDictionary *)dict
{
    NSString *refreshToken = dict[kResRefreshToken];
    NSString *openID = dict[kResOpenID];

    self.refreshToken = refreshToken;

    NSDate *refreshTokenExpireDate = [[NSDate date] dateByAddingTimeInterval:TimeintervalRefreshToken];
    self.refreshTokenExpireDate = refreshTokenExpireDate;

    self.openID = openID;
}

- (void)getWeChatAccessTokenWithCode:(NSString *)code CompletionBlock:(DTWeChatAuthResponseBlock)block
{
	__weak DTWeChatUnit* weakSelf = self;
    NSString *strURL = [NSString stringWithFormat:URLFormatGetAccessToken, self.appID, self.appSecret, code];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:RequestTimeOut];
	NSURLSessionDataTask* task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable connectionError) {
		dispatch_async(dispatch_get_main_queue(), ^{
			if (connectionError) {
				RYCONDITIONLOG(DTLogFlagsError, @"%@", connectionError);
				if (block) {
					block(connectionError, nil);
				}
			}
			else {
				NSError *err = NULL;
				NSJSONSerialization *jsonSerialization = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&err];
				if (err) {
					if (block) {
						block(err, nil);
					}
				}
				else {
					if ([[jsonSerialization class] isSubclassOfClass:[NSDictionary class]]) {
						NSDictionary *dict = (NSDictionary *)jsonSerialization;
						if ([[dict allKeys] containsObject:kResErrCode]) {
							if (block) {
								block([NSError errorWithDomain:dict[kResErrMsg] code:[dict[kResErrCode] integerValue] userInfo:nil], nil);
							}
						}
						else {
							[weakSelf saveAccessTokenByDictionary:dict];
							[weakSelf saveRefreshTokenByDictionary:dict];
							if (block) {
								block(nil, dict);
							}
						}
					}
					else {
						if (block) {
							block([NSError errorWithDomain:@"Json string parser error!" code:100 userInfo:nil], nil);
						}
					}
				}
			}
		});
	}];
	[task resume];
//    [NSURLConnection sendAsynchronousRequest:request
//                                       queue:[NSOperationQueue mainQueue]
//                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//                             if (connectionError) {
//                                 RYCONDITIONLOG(DTLogFlagsError, @"%@", connectionError);
//                                 if (block) {
//                                     block(connectionError, nil);
//                                 }
//                             }
//                             else {
//                                 NSError *err = NULL;
//                                 NSJSONSerialization *jsonSerialization = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&err];
//                                 if (err) {
//                                     if (block) {
//                                         block(err, nil);
//                                     }
//                                 }
//                                 else {
//                                     if ([[jsonSerialization class] isSubclassOfClass:[NSDictionary class]]) {
//                                         NSDictionary *dict = (NSDictionary *)jsonSerialization;
//                                         if ([[dict allKeys] containsObject:kResErrCode]) {
//                                             if (block) {
//                                                 block([NSError errorWithDomain:dict[kResErrMsg] code:[dict[kResErrCode] integerValue] userInfo:nil], nil);
//                                             }
//                                         }
//                                         else {
//                                             [self saveAccessTokenByDictionary:dict];
//                                             [self saveRefreshTokenByDictionary:dict];
//                                             if (block) {
//                                                 block(nil, dict);
//                                             }
//                                         }
//                                     }
//                                     else {
//                                         if (block) {
//                                             block([NSError errorWithDomain:@"Json string parser error!" code:100 userInfo:nil], nil);
//                                         }
//                                     }
//                                 }
//                             }
//                           }];
}

- (void)refreshWeChatAccessTokenCompletionBlock:(DTWeChatAuthResponseBlock)block
{
    NSString *strURL = [NSString stringWithFormat:URLFormatRefreshToken, self.appID, self.refreshToken];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:RequestTimeOut];
	NSURLSessionDataTask* task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable connectionError) {
		dispatch_async(dispatch_get_main_queue(), ^{
			if (connectionError) {
				RYCONDITIONLOG(DTLogFlagsError, @"%@", connectionError);
				if (block) {
					block(connectionError, nil);
				}
			}
			else {
				NSError *err = NULL;
				NSJSONSerialization *jsonSerialization = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&err];
				if (err) {
					if (block) {
						block(err, nil);
					}
				}
				else {
					if ([[jsonSerialization class] isSubclassOfClass:[NSDictionary class]]) {
						NSDictionary *dict = (NSDictionary *)jsonSerialization;
						if ([[dict allKeys] containsObject:kResErrCode]) {
							NSInteger errCode = [dict[kResErrCode] integerValue];
							self.accessToken = nil;
							self.refreshToken = nil;
							if (block) {
								block([NSError errorWithDomain:dict[kResErrMsg] code:errCode userInfo:nil], nil);
							}
						}
						else {
							[self saveAccessTokenByDictionary:dict];
							if (block) {
								block(nil, dict);
							}
						}
					}
					else {
						if (block) {
							block([NSError errorWithDomain:@"Json string parser error!" code:100 userInfo:nil], nil);
						}
					}
				}
			}
		});
	}];
	[task resume];
//    [NSURLConnection sendAsynchronousRequest:request
//                                       queue:[NSOperationQueue mainQueue]
//                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//                             if (connectionError) {
//                                 RYCONDITIONLOG(DTLogFlagsError, @"%@", connectionError);
//                                 if (block) {
//                                     block(connectionError, nil);
//                                 }
//                             }
//                             else {
//                                 NSError *err = NULL;
//                                 NSJSONSerialization *jsonSerialization = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&err];
//                                 if (err) {
//                                     if (block) {
//                                         block(err, nil);
//                                     }
//                                 }
//                                 else {
//                                     if ([[jsonSerialization class] isSubclassOfClass:[NSDictionary class]]) {
//                                         NSDictionary *dict = (NSDictionary *)jsonSerialization;
//                                         if ([[dict allKeys] containsObject:kResErrCode]) {
//                                             NSInteger errCode = [dict[kResErrCode] integerValue];
//                                             self.accessToken = nil;
//                                             self.refreshToken = nil;
//                                             if (block) {
//                                                 block([NSError errorWithDomain:dict[kResErrMsg] code:errCode userInfo:nil], nil);
//                                             }
//                                         }
//                                         else {
//                                             [self saveAccessTokenByDictionary:dict];
//                                             if (block) {
//                                                 block(nil, dict);
//                                             }
//                                         }
//                                     }
//                                     else {
//                                         if (block) {
//                                             block([NSError errorWithDomain:@"Json string parser error!" code:100 userInfo:nil], nil);
//                                         }
//                                     }
//                                 }
//                             }
//                           }];
}

- (void)checkWeChatAccessTokenAvailableCompletionBlock:(void (^)(NSError *err))block
{
    NSString *strURL = [NSString stringWithFormat:URLFormatCheckToken, self.accessToken, self.openID];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:RequestTimeOut];
	NSURLSessionDataTask* task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable connectionError) {
		dispatch_async(dispatch_get_main_queue(), ^{
			if (connectionError) {
				RYCONDITIONLOG(DTLogFlagsError, @"%@", connectionError);
				if (block) {
					block(connectionError);
				}
			}
			else {
				NSError *err = NULL;
				NSJSONSerialization *jsonSerialization = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&err];
				if (err) {
					if (block) {
						block(err);
					}
				}
				else {
					if ([[jsonSerialization class] isSubclassOfClass:[NSDictionary class]]) {
						NSDictionary *dict = (NSDictionary *)jsonSerialization;
						if ([[dict allKeys] containsObject:kResErrCode]) {
							NSInteger errCode = [dict[kResErrCode] integerValue];
							if (block) {
								block([NSError errorWithDomain:dict[kResErrMsg] code:errCode userInfo:nil]);
							}
						}
						else {
							if (block) {
								block(nil);
							}
						}
					}
					else {
						if (block) {
							block([NSError errorWithDomain:@"Json string parser error!" code:100 userInfo:nil]);
						}
					}
				}
			}
		});
	}];
	[task resume];
//    [NSURLConnection sendAsynchronousRequest:request
//                                       queue:[NSOperationQueue mainQueue]
//                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//                             if (connectionError) {
//                                 RYCONDITIONLOG(DTLogFlagsError, @"%@", connectionError);
//                                 if (block) {
//                                     block(connectionError);
//                                 }
//                             }
//                             else {
//                                 NSError *err = NULL;
//                                 NSJSONSerialization *jsonSerialization = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&err];
//                                 if (err) {
//                                     if (block) {
//                                         block(err);
//                                     }
//                                 }
//                                 else {
//                                     if ([[jsonSerialization class] isSubclassOfClass:[NSDictionary class]]) {
//                                         NSDictionary *dict = (NSDictionary *)jsonSerialization;
//                                         if ([[dict allKeys] containsObject:kResErrCode]) {
//                                             NSInteger errCode = [dict[kResErrCode] integerValue];
//                                             if (block) {
//                                                 block([NSError errorWithDomain:dict[kResErrMsg] code:errCode userInfo:nil]);
//                                             }
//                                         }
//                                         else {
//                                             if (block) {
//                                                 block(nil);
//                                             }
//                                         }
//                                     }
//                                     else {
//                                         if (block) {
//                                             block([NSError errorWithDomain:@"Json string parser error!" code:100 userInfo:nil]);
//                                         }
//                                     }
//                                 }
//                             }
//                           }];
}

- (void)getUserInfoCompletionBlock:(DTWeChatAuthResponseBlock)block
{
    NSString *strURL = [NSString stringWithFormat:URLFormatGetUserInfo, self.accessToken, self.openID];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:RequestTimeOut];
	NSURLSessionDataTask* task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable connectionError) {
		dispatch_async(dispatch_get_main_queue(), ^{
			if (connectionError) {
				if (block) {
					block(connectionError, nil);
				}
			}
			else {
				NSError *err = NULL;
				NSJSONSerialization *jsonSerialization = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&err];
				if (err) {
					if (block) {
						block(err, nil);
					}
				}
				else {
					if ([[jsonSerialization class] isSubclassOfClass:[NSDictionary class]]) {
						NSDictionary *dict = (NSDictionary *)jsonSerialization;
						NSString *errCode = [dict[kResErrCode] description];
						if (RYIsValidString(errCode)) {
							self.accessToken = nil;
							self.accessTokenExpireDate = nil;
							if (block) {
								block([NSError errorWithDomain:dict[kResErrMsg] code:[errCode integerValue] userInfo:dict], nil);
							}
						}
						else {
							if (block) {
								block(nil, dict);
							}
						}
					}
					else {
						if (block) {
							block([NSError errorWithDomain:@"Json string parser error!" code:100 userInfo:nil], nil);
						}
					}
				}
			}
		});
	}];
	[task resume];
//    [NSURLConnection sendAsynchronousRequest:request
//                                       queue:[NSOperationQueue mainQueue]
//                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//                             if (connectionError) {
//                                 if (block) {
//                                     block(connectionError, nil);
//                                 }
//                             }
//                             else {
//                                 NSError *err = NULL;
//                                 NSJSONSerialization *jsonSerialization = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&err];
//                                 if (err) {
//                                     if (block) {
//                                         block(err, nil);
//                                     }
//                                 }
//                                 else {
//                                     if ([[jsonSerialization class] isSubclassOfClass:[NSDictionary class]]) {
//                                         NSDictionary *dict = (NSDictionary *)jsonSerialization;
//                                         NSString *errCode = [dict[kResErrCode] description];
//                                         if (RYIsValidString(errCode)) {
//                                             self.accessToken = nil;
//                                             self.accessTokenExpireDate = nil;
//                                             if (block) {
//                                                 block([NSError errorWithDomain:dict[kResErrMsg] code:[errCode integerValue] userInfo:dict], nil);
//                                             }
//                                         }
//                                         else {
//                                             if (block) {
//                                                 block(nil, dict);
//                                             }
//                                         }
//                                     }
//                                     else {
//                                         if (block) {
//                                             block([NSError errorWithDomain:@"Json string parser error!" code:100 userInfo:nil], nil);
//                                         }
//                                     }
//                                 }
//                             }
//                           }];
}

#pragma mark - Public Methods
+ (BOOL)weChatAuthTokensIsAvailable
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *strAccessToken = [userDefaults valueForKey:kDTWeChatUnitAccessToken];
    NSString *strRefreshToken = [userDefaults valueForKey:kDTWeChatUnitRefreshToken];
    NSString *strAccessTokenExpireDate = [userDefaults valueForKey:kDTWeChatUnitAccessTokenExpireDate];
    NSString *strRefreshTokenExpireDate = [userDefaults valueForKey:kDTWeChatUnitRefreshTokenExpireDate];
    BOOL isAvailable = NO;
    if (RYIsValidString(strAccessToken) && RYIsValidString(strRefreshToken) && RYIsValidString(strAccessTokenExpireDate) && RYIsValidString(strRefreshTokenExpireDate)) {
        NSDate *accessTokenExpireDate = RYDate(strAccessTokenExpireDate, DTDateFormatString);
        NSDate *refreshTokenExpireDate = RYDate(strRefreshTokenExpireDate, DTDateFormatString);
        isAvailable = [[NSDate date] timeIntervalSinceDate:accessTokenExpireDate] < 0 || [[NSDate date] timeIntervalSinceDate:refreshTokenExpireDate] < 0;
    }
    return isAvailable;
}

+ (DTWeChatUnit *)authUnitWithExistTokens
{
    DTWeChatUnit *authUnit = [[DTWeChatUnit alloc] init];
    return authUnit;
}

- (instancetype)initWithAppID:(NSString *)appID secret:(NSString *)appSecret
{
    if (self = [super init]) {
        RYCONDITIONLOG(DTLogFlagsError, @"AppID:%@,AppSecret:%@", appID, appSecret);
        self.appID = appID;
        self.appSecret = appSecret;
    }
    return self;
}

- (void)startAuthProgressWithCode:(NSString *)code
{
    RYCONDITIONLOG(DTLogFlagsInfo, @"Auth progress start...");
    if (!RYIsValidString(self.accessToken)) {
        [self getWeChatAccessTokenWithCode:code
                           CompletionBlock:^(NSError *error, NSDictionary *dict) {
                             if (error) {
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                   if (self.delegate && [self.delegate respondsToSelector:@selector(weChatUnit:operationDidFailWithError:)]) {
                                       [self.delegate weChatUnit:self operationDidFailWithError:error];
                                   }
                                 });
                             }
                             else {
                                 [self startToGetUserInfo];
                             }
                           }];
    }
    else if ([self isAccessTokenExpired]) {
        [self refreshWeChatAccessTokenCompletionBlock:^(NSError *error, NSDictionary *dict) {
          if (error) {
              dispatch_async(dispatch_get_main_queue(), ^{
                if (self.delegate && [self.delegate respondsToSelector:@selector(weChatUnit:operationDidFailWithError:)]) {
                    [self.delegate weChatUnit:self operationDidFailWithError:error];
                }
              });
          }
          else {
              [self startToGetUserInfo];
          }
        }];
    }
    else {
        [self startToGetUserInfo];
    }
}

- (void)logout
{
    self.accessToken = nil;
    self.refreshToken = nil;
    self.accessTokenExpireDate = nil;
    self.refreshTokenExpireDate = nil;
    self.openID = nil;
}
@end
