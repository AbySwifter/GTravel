//
//  GTNetworkUnit.m
//  GTravel
//
//  Created by Raynay Yue on 5/22/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTNetworkUnit.h"
#import "RYCommon.h"
#import "DTNetworkUnit.h"
#import "GTravelNetDefinitions.h"
#import "GTravelUserItem.h"
#import "GTravelToolItem.h"
#import "GTravelCityItem.h"
#import "GTravelTownItem.h"
#import "GTravelRouteItem.h"
#import "GTravelImageItem.h"
#import "GTCategory.h"
#import "GTFilter.h"
#import "GTPoint.h"
#import "AFNetworking.h"
#import "DTPartner.h"
#import "GTToolsSet.h"
#import "GTToolsItem.h"
#import "GTUserPoints.h"
#import "GTCityOrTownPoints.h"

typedef void (^DTResposneDictionaryErrorProcessor)(NSError *error, NSDictionary *responseDict);

@interface GTNetworkUnit ()
@property (nonatomic, strong) DTNetworkUnit *networkUnit;
- (void)processNetworkUnitResposneObject:(id)responseObject withCompletionBlock:(DTResposneDictionaryErrorProcessor)block;
@end

@implementation GTNetworkUnit
#pragma mark - Non-Public Methods
- (instancetype)init
{
    if (self = [super init]) {
        DTNetworkUnit *networkUnit = [[DTNetworkUnit alloc] init];
        self.networkUnit = networkUnit;
    }
    return self;
}

- (void)dealloc
{
    self.networkUnit = nil;
}

- (void)processNetworkUnitResposneObject:(id)responseObject withCompletionBlock:(DTResposneDictionaryErrorProcessor)block
{
    if ([[responseObject class] isSubclassOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        if ([dict[kResult] integerValue] == RESPONSE_OK) {
            block(nil, dict);
        }
        else {
            if (dict[kErrorMessage]) {
                block([NSError errorWithDomain:dict[kErrorMessage] code:0 userInfo:nil], nil);
            }
            else {
                block(nil, nil);
            }
        }
    }
    else {
        block([NSError errorWithDomain:@"Response data format error!" code:-1 userInfo:nil], nil);
    }
}

#pragma mark - Public Methods
static GTNetworkUnit *sharedInstance = nil;
+ (GTNetworkUnit *)sharedNetworkUnit
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
            sharedInstance = [[self alloc] init];
        return sharedInstance;
    }
    return nil;
}

- (void)requestLaunchImagesWithCompletion:(void (^)(NSError *error, NSString *version, NSArray *images))handler
{
    NSString *strURL = GetAPIUrl(API_LauchImages);
    [self.networkUnit sendParams:@{ kSize : @(0) }
                           toURL:[NSURL URLWithString:strURL]
                         timeout:NetworkTimeOut
                      completion:^(NSError *error, id responseObject) {
                        if (error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                              handler(error, nil, nil);
                            });
                        }
                        else {
                            [self processNetworkUnitResposneObject:responseObject
                                               withCompletionBlock:^(NSError *error, NSDictionary *responseDict) {
                                                 if (error) {
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                       handler(error, nil, nil);
                                                     });
                                                 }
                                                 else {
                                                     @try {
                                                         NSString *version = responseDict[kVersion];
                                                         NSArray *arr = responseDict[kImages];
                                                         NSMutableArray *arrItems = [NSMutableArray array];
                                                         for (int i = 0; i < arr.count; i++) {
                                                             GTLaunchImage *item = [GTLaunchImage launchImageFromDictionary:arr[i]];
                                                             [arrItems addObject:item];
                                                         }
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                           handler(nil, version, arrItems);
                                                         });
                                                     }
                                                     @catch (NSException *exception) {
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                           handler([NSError errorWithDomain:exception.reason code:-1 userInfo:exception.userInfo], nil, nil);
                                                         });
                                                     }
                                                 }
                                               }];
                        }
                      }];
}

- (void)requestBannersWithCompletion:(void (^)(NSError *error, NSString *version, NSArray *images))handler
{
    NSString *strURL = GetAPIUrl(API_BannerList);
    [self.networkUnit requestToURL:[NSURL URLWithString:strURL]
                           timeout:NetworkTimeOut
                        completion:^(NSError *error, id responseObject) {
                          if (error) {
                              handler(error, nil, nil);
                          }
                          else {
                              [self processNetworkUnitResposneObject:responseObject
                                                 withCompletionBlock:^(NSError *error, NSDictionary *responseDict) {
                                                   if (error) {
                                                       handler(error, nil, nil);
                                                   }
                                                   else {
                                                       @try {
                                                           NSString *version = responseDict[kVersion];
                                                           NSArray *arr = responseDict[kBanners];
                                                           NSMutableArray *arrItems = [NSMutableArray array];
                                                           for (int i = 0; i < arr.count; i++) {
                                                               GTBannerImage *item = [GTBannerImage bannerImageFromDictionary:arr[i]];
                                                               [arrItems addObject:item];
                                                           }
                                                           handler(nil, version, arrItems);
                                                       }
                                                       @catch (NSException *exception) {
                                                           handler([NSError errorWithDomain:exception.reason code:-1 userInfo:exception.userInfo], nil, nil);
                                                       }
                                                   }
                                                 }];
                          }
                        }];
}

/**
 *  用户注册,根据微信返回的唯一标示
 */
- (void)registerUserWithUnionID:(NSString *)unionID
                       nickName:(NSString *)nickName
                   headImageURL:(NSString *)imageURL
                       province:(NSString *)province
                           city:(NSString *)city
                            sex:(GTravelUserSex)sex
                     completion:(void (^)(NSError *error, NSString *userID))handler
{
    if (RYIsValidString(unionID)) {
        NSString *strURL = GetAPIUrl(API_Register);
        NSDictionary *dictParams = @{ kUnionID : unionID,
                                      kNickName : (RYIsValidString(nickName) ? nickName : @""),
                                      kHeadImageURL : (RYIsValidString(imageURL) ? imageURL : @""),
                                      kProvince : (RYIsValidString(province) ? province : @""),
                                      kCity : (RYIsValidString(city) ? city : @""),
                                      kSex : sex == GTravelUserSexMale ? @(SEX_MALE) : @(SEX_FEMALE)
        };
        [self.networkUnit sendParams:dictParams
                               toURL:[NSURL URLWithString:strURL]
                             timeout:NetworkTimeOut
                          completion:^(NSError *error, id responseObject) {
                            if (error) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                  handler(error, nil);
                                });
                            }
                            else {
                                [self processNetworkUnitResposneObject:responseObject
                                                   withCompletionBlock:^(NSError *error, NSDictionary *responseDict) {
                                                     if (error) {
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                           handler(error, nil);
                                                         });
                                                     }
                                                     else {
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                           handler(nil, [responseDict[kUserID] stringValue]);
                                                         });
                                                     }
                                                   }];
                            }
                          }];
    }
    else {
        handler([NSError errorWithDomain:@"Union ID can't be nil!" code:-1 userInfo:nil], nil);
    }
}

//普通注册
// 普通注册
- (void)registerUserWithNickName:(NSString *)userNickName
                        passWord:(NSString *)passWord
                             sex:(NSUInteger)sex
                      completion:(void (^)(NSError *error, id responseObject))handler
{
    NSString *strURL = GetAPIUrl(API_myregister);
    NSDictionary *params = @{ kUserNickName : userNickName,
                              kPassWord : passWord,
                              kSex : @(sex)
    };

    [self.networkUnit sendParams:params
                           toURL:[NSURL URLWithString:strURL]
                         timeout:NetworkTimeOut
                      completion:^(NSError *error, id responseObject) {
                        if (error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                              handler(error, nil);
                            });
                        }
                        else {
                            [self processNetworkUnitResposneObject:responseObject
                                               withCompletionBlock:^(NSError *error, NSDictionary *responseDict) {
                                                 if (error) {
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                       handler(error, nil);
                                                     });
                                                 }
                                                 else {
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                       handler(nil, responseObject);
                                                     });
                                                 }
                                               }];
                        }

                      }];
}

// 普通登录
- (void)loginWithUserNickName:(NSString *)userNickName passWord:(NSString *)passWord completion:(void (^)(NSError *error, GTravelUserItem *userItem))handler
{
    NSString *strURL = GetAPIUrl(API_myLogin);
    NSDictionary *params = @{kUserNickName : userNickName,
                             kPassWord : passWord};
    [self.networkUnit sendParams:params
                           toURL:[NSURL URLWithString:strURL]
                         timeout:NetworkTimeOut
                      completion:^(NSError *error, id responseObject) {
                        if (error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                              handler(error, nil);
                            });
                        }
                        else {

                            [self processNetworkUnitResposneObject:responseObject
                                               withCompletionBlock:^(NSError *error, NSDictionary *responseDict) {
                                                 if (error) {
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                       handler(error, nil);
                                                     });
                                                 }
                                                 else {
                                                     GTravelUserItem *userItem = [GTravelUserItem userItemFromDictionary:responseObject];
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                       handler(nil, userItem);
                                                     });
                                                 }
                                               }];
                        }
                      }];
}

- (void)loginWithUserID:(NSString *)userID
            deviceToken:(NSString *)token
             completion:(void (^)(NSError *error, GTravelUserItem *userItem))handler
{
    NSString *strURL = GetAPIUrl(API_Login);
    NSDictionary *params = @{ kUserID : @([userID longLongValue]),
                              kDeviceToken : RYIsValidString(token) ? token : @""
    };
    [self.networkUnit sendParams:params
                           toURL:[NSURL URLWithString:strURL]
                         timeout:NetworkTimeOut
                      completion:^(NSError *error, id responseObject) {
                        if (error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                              handler(error, nil);
                            });
                        }
                        else {
                            [self processNetworkUnitResposneObject:responseObject
                                               withCompletionBlock:^(NSError *error, NSDictionary *responseDict) {
                                                 if (error) {
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                       handler(error, nil);
                                                     });
                                                 }
                                                 else {
                                                     GTravelUserItem *userItem = [GTravelUserItem userItemFromDictionary:responseObject];
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                       handler(nil, userItem);
                                                     });
                                                 }
                                               }];
                        }
                      }];
}


- (void)logoutUser:(NSString *)userID completionWithHandler:(void (^)(NSError *error))handler
{
    NSString *strURL = GetAPIUrl(API_Logout);
    NSDictionary *params = @{ kUserID : @([userID longLongValue])
    };
    [self.networkUnit sendParams:params
                           toURL:[NSURL URLWithString:strURL]
                         timeout:NetworkTimeOut
                      completion:^(NSError *error, id responseObject) {
                        if (error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                              handler(error);
                            });
                        }
                        else {
                            [self processNetworkUnitResposneObject:responseObject
                                               withCompletionBlock:^(NSError *error, NSDictionary *responseDict) {
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                   handler(error);
                                                 });
                                               }];
                        }
                      }];
}

- (void)requestToolListWithCompletion:(void (^)(NSError *error, NSString *version, NSArray *tools))handler
{
    NSString *strURL = GetAPIUrl(API_Tools);
    [self.networkUnit requestToURL:[NSURL URLWithString:strURL]
                           timeout:NetworkTimeOut
                        completion:^(NSError *error, id responseObject) {
                          if (error) {
                              dispatch_async(dispatch_get_main_queue(), ^{
                                handler(error, nil, nil);
                              });
                          }
                          else {
                              [self processNetworkUnitResposneObject:responseObject
                                                 withCompletionBlock:^(NSError *error, NSDictionary *responseDict) {
                                                   if (error) {
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                         handler(error, nil, nil);
                                                       });
                                                   }
                                                   else {
                                                       @try {
                                                           NSString *version = responseDict[kVersion];
                                                           NSArray *arr = responseDict[kTools];
                                                           NSMutableArray *array = [NSMutableArray array];
                                                           //                          for(int i=0;i<arr.count;i++)
                                                           //                          {
                                                           //                              NSArray *arrItems = arr[i];
                                                           //                              NSMutableArray *items = [NSMutableArray array];
                                                           //                              for(int ii=0;ii<arrItems.count;ii++)
                                                           //                              {
                                                           //                                  GTravelToolItem *item = [GTravelToolItem toolItemFromDictionary:arrItems[ii]];
                                                           //                                  [items addObject:item];
                                                           //                              }
                                                           //                              if(RYIsValidArray(items))
                                                           //                              {
                                                           //                                  [array addObject:items];
                                                           //                              }
                                                           //                          }
                                                           for (int i = 0; i < arr.count; i++) {
                                                               NSMutableDictionary *dict = arr[i];
                                                               GTravelToolItem *items = [GTravelToolItem toolItemFromDictionary:dict];
                                                               [array addObject:items];
                                                           }
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                             handler(nil, version, array);
                                                           });
                                                       }
                                                       @catch (NSException *exception) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                             handler([NSError errorWithDomain:exception.reason code:-1 userInfo:exception.userInfo], nil, nil);
                                                           });
                                                       }
                                                   }
                                                 }];
                          }
                        }];
}

- (void)requestCityListWithIndex:(NSInteger)index
                           count:(NSInteger)count
                      completion:(void (^)(NSError *error, NSString *title, NSArray *cities))handler
{
    NSString *strURL = GetAPIUrl(API_Cities);
    NSDictionary *dictParams = @{ kIndex : @(index),
                                  kCount : @(count)
    };
    [self.networkUnit sendParams:dictParams
                           toURL:[NSURL URLWithString:strURL]
                         timeout:NetworkTimeOut
                      completion:^(NSError *error, id responseObject) {
                        if (error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                              handler(error, nil, nil);
                            });
                        }
                        else {
                            [self processNetworkUnitResposneObject:responseObject
                                               withCompletionBlock:^(NSError *error, NSDictionary *responseDict) {
                                                 if (error) {
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                       handler(error, nil, nil);
                                                     });
                                                 }
                                                 else {
                                                     @try {
                                                         NSString *title = responseDict[kTitle];
                                                         NSMutableArray *items = [NSMutableArray array];
                                                         NSArray *arr = responseDict[kCities];
                                                         if (RYIsValidArray(arr)) {
                                                             for (NSDictionary *dict in arr) {
                                                                 GTravelCityItem *item = [GTravelCityItem cityItemFromDictionary:dict];
                                                                 [items addObject:item];
                                                             }
                                                         }
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                           handler(nil, title, items);
                                                         });
                                                     }
                                                     @catch (NSException *exception) {
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                           handler([NSError errorWithDomain:exception.reason code:-1 userInfo:exception.userInfo], nil, nil);
                                                         });
                                                     }
                                                 }
                                               }];
                        }
                      }];
}

- (void)requestLineListWithIndex:(NSInteger)index
                           count:(NSInteger)count
                      completion:(void (^)(NSError *error, NSString *title, NSArray *routes))handler
{
    NSString *strURL = GetAPIUrl(API_Lines);
    NSDictionary *dictParams = @{ kIndex : @(index),
                                  kCount : @(count)
    };
    [self.networkUnit sendParams:dictParams
                           toURL:[NSURL URLWithString:strURL]
                         timeout:NetworkTimeOut
                      completion:^(NSError *error, id responseObject) {
                        if (error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                              handler(error, nil, nil);
                            });
                        }
                        else {
                            [self processNetworkUnitResposneObject:responseObject
                                               withCompletionBlock:^(NSError *error, NSDictionary *responseDict) {
                                                 if (error) {
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                       handler(error, nil, nil);
                                                     });
                                                 }
                                                 else {
                                                     @try {
                                                         NSString *title = responseDict[kTitle];
                                                         NSMutableArray *items = [NSMutableArray array];
                                                         NSArray *arr = responseDict[kLines];
                                                         if (RYIsValidArray(arr)) {
                                                             for (NSDictionary *dict in arr) {
                                                                 GTravelRouteItem *item = [GTravelRouteItem itemFromDictionary:dict];
                                                                 [items addObject:item];
                                                             }
                                                         }
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                           handler(nil, title, items);
                                                         });
                                                     }
                                                     @catch (NSException *exception) {
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                           handler([NSError errorWithDomain:exception.reason code:-1 userInfo:exception.userInfo], nil, nil);
                                                         });
                                                     }
                                                 }
                                               }];
                        }
                      }];
}

- (void)requestCategoryListWithCompletion:(void (^)(NSError *error, NSArray *categories, NSArray *filters))handler
{
    NSString *strURL = GetAPIUrl(API_Tags);
    [self.networkUnit requestToURL:[NSURL URLWithString:strURL]
                           timeout:NetworkTimeOut
                        completion:^(NSError *error, id responseObject) {
                          if (error) {
                              dispatch_async(dispatch_get_main_queue(), ^{
                                handler(error, nil, nil);
                              });
                          }
                          else {
                              [self processNetworkUnitResposneObject:responseObject
                                                 withCompletionBlock:^(NSError *error, NSDictionary *responseDict) {
                                                   if (error) {
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                         handler(error, nil, nil);
                                                       });
                                                   }
                                                   else {
                                                       @try {
                                                           NSArray *arr = responseDict[kTags];
                                                           NSMutableArray *cats = [NSMutableArray array];
                                                           for (NSDictionary *dict in arr) {
                                                               GTCategory *item = [GTCategory categoryFromDictionary:dict];
                                                               [cats addObject:item];
                                                           }

                                                           NSMutableArray *arrFilters = [NSMutableArray array];
                                                           for (NSDictionary *dict in responseDict[kFilters]) {
                                                               GTFilter *filter = [GTFilter filterFromDictionary:dict];
                                                               [arrFilters addObject:filter];
                                                           }
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                             handler(nil, cats, arrFilters);
                                                           });
                                                       }
                                                       @catch (NSException *exception) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                             handler([NSError errorWithDomain:exception.reason code:-1 userInfo:exception.userInfo], nil, nil);
                                                           });
                                                       }
                                                   }
                                                 }];
                          }
                        }];
}

- (void)requestFourSetsListWithCompletion:(void (^)(NSError *error, NSArray *fourSets))handler
{
    NSString *strURL = GetAPIUrl(API_Tools);
    [self.networkUnit requestToURL:[NSURL URLWithString:strURL]
                           timeout:NetworkTimeOut
                        completion:^(NSError *error, id responseObject) {
                          if (error) {
                              dispatch_async(dispatch_get_main_queue(), ^{
                                handler(error, nil);
                              });
                          }
                          else {
                              [self processNetworkUnitResposneObject:responseObject
                                                 withCompletionBlock:^(NSError *error, NSDictionary *responseDict) {
                                                   if (error) {
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                         handler(error, nil);
                                                       });
                                                   }
                                                   else {
                                                       @try {
                                                           NSArray *toolsSetArray = responseDict[kTools];
                                                           NSMutableArray *fourSetArray = [NSMutableArray array];
                                                           for (NSDictionary *toolsSetDict in toolsSetArray) {

                                                               GTToolsSet *toolsSet = [GTToolsSet toolsSetWithDict:toolsSetDict];
                                                               [fourSetArray addObject:toolsSet];
                                                           }

                                                           //                          NSMutableArray *eightTool = [NSMutableArray array];
                                                           //                          for (GTToolsSet *toolsSet in fourSetArray) {
                                                           //                              NSArray *toolsItemArray = toolsSet.toolsItemsArray;
                                                           //
                                                           //                              for (gt in toolsItemArray) {
                                                           //
                                                           //                              }
                                                           //                          }
                                                           //                          NSMutableArray *array = [NSMutableArray array];
                                                           //                          for(NSDictionary *dict in toolsSetArray)
                                                           //                          {
                                                           //                              GTCategory *item = [GTCategory categoryFromDictionary:dict];
                                                           //                              [cats addObject:item];
                                                           //                          }
                                                           //
                                                           //                          NSMutableArray *arrFilters = [NSMutableArray array];
                                                           //                          for(NSDictionary *dict in responseDict[kFilters])
                                                           //                          {
                                                           //                              GTFilter *filter = [GTFilter filterFromDictionary:dict];
                                                           //                              [arrFilters addObject:filter];
                                                           //                          }
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                             handler(nil, fourSetArray);
                                                           });
                                                       }
                                                       @catch (NSException *exception) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                             handler([NSError errorWithDomain:exception.reason code:-1 userInfo:exception.userInfo], nil);
                                                           });
                                                       }
                                                   }
                                                 }];
                          }
                        }];
}


- (void)addCategoryByUser:(NSString *)userID
                    title:(NSString *)title
               completion:(void (^)(NSError *error, GTCategory *category))handler
{
    NSString *strURL = GetAPIUrl(API_AddTags);
    NSDictionary *params = @{ kUserID : @([userID longLongValue]),
                              kTitle : title
    };
    [self.networkUnit sendParams:params
                           toURL:[NSURL URLWithString:strURL]
                         timeout:NetworkTimeOut
                      completion:^(NSError *error, id responseObject) {
                        if (error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                              handler(error, nil);
                            });
                        }
                        else {
                            [self processNetworkUnitResposneObject:responseObject
                                               withCompletionBlock:^(NSError *error, NSDictionary *responseDict) {
                                                 if (error) {
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                       handler(error, nil);
                                                     });
                                                 }
                                                 else {
                                                     NSDictionary *dict = responseDict[kTag];
                                                     GTCategory *category = [GTCategory categoryFromDictionary:dict];
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                       handler(nil, category);
                                                     });
                                                 }
                                               }];
                        }
                      }];
}

- (void)requestAroundUsersByUser:(NSString *)userID
                        filterID:(NSString *)filterID
                             sex:(NSInteger)sex
                        latitude:(double)latitude
                       longitude:(double)longitude
                      completion:(void (^)(NSError *error, NSArray *users))handler
{
    NSString *strURL = GetAPIUrl(API_Users);
    NSDictionary *params = @{ kUserID : @([userID longLongValue]),
                              kFilterID : @([filterID longLongValue]),
                              kSex : @(sex),
                              kLatitude : @(latitude),
                              kLongitude : @(longitude)
    };
    [self.networkUnit sendParams:params
                           toURL:[NSURL URLWithString:strURL]
                         timeout:NetworkTimeOut
                      completion:^(NSError *error, id responseObject) {
                        if (error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                              handler(error, nil);
                            });
                        }
                        else {
                            [self processNetworkUnitResposneObject:responseObject
                                               withCompletionBlock:^(NSError *error, NSDictionary *responseDict) {
                                                 if (error) {
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                       handler(error, nil);
                                                     });
                                                 }
                                                 else {
                                                     NSArray *arr = responseDict[kUsers];
                                                     NSMutableArray *users = [NSMutableArray array];
                                                     for (NSDictionary *dict in arr) {
                                                         GTDistanceUser *user = [GTDistanceUser distanceUserFromDictionary:dict];
                                                         [users addObject:user];
                                                     }
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                       handler(nil, users);
                                                     });
                                                 }
                                               }];
                        }
                      }];
}

- (void)requestUserPointsByParam:(NSDictionary *)param completion:(void (^)(NSError *error, NSArray *points))handler
{
    NSString *strURL = GetAPIUrl(API_UserPoints);
    [self.networkUnit sendParams:param
                           toURL:[NSURL URLWithString:strURL]
                         timeout:NetworkTimeOut
                      completion:^(NSError *error, id responseObject) {
                        if (error) {

                            dispatch_async(dispatch_get_main_queue(), ^{
                              handler(error, nil);
                            });
                            //            NSLog(@"请求出错:%@",error);
                        }
                        else {
                            [self processNetworkUnitResposneObject:responseObject
                                               withCompletionBlock:^(NSError *error, NSDictionary *responseDict) {
                                                 if (error) {
                                                     NSLog(@"失败:%@", error);
                                                 }
                                                 else {
                                                     NSLog(@"%@", responseObject);

                                                     NSArray *array = responseObject[kLists];
                                                     NSMutableArray *pointsArray = [NSMutableArray array];
                                                     if (RYIsValidArray(array)) {

                                                         for (NSDictionary *dict in array) {

                                                             GTUserPoints *points = [GTUserPoints userPointsWithDict:dict];
                                                             [pointsArray addObject:points];
                                                         }
                                                     }

                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                       handler(nil, pointsArray);
                                                     });
                                                 }
                                               }];
                        }
                      }];
}

- (void)requestAroundPointsByUser:(NSString *)userID
                         filterID:(NSString *)filterID
                       categoryID:(NSString *)catID
                             type:(NSString *)type
                         latitude:(double)latitude
                        longitude:(double)longitude
                          atIndex:(NSInteger)index
                            count:(NSInteger)count
                       completion:(void (^)(NSError *error, NSArray *points))handler
{
    NSString *strURL = GetAPIUrl(API_Points);
    NSDictionary *params = @{ kUserID : @([userID longLongValue]),
                              kFilterID : @([filterID longLongValue]),
                              kCategoryID : @([catID longLongValue]),
                              kType : @(0),
                              kLatitude : @(latitude),
                              kLongitude : @(longitude),
                              kIndex : @(index),
                              kCount : @(count)
    };
    [self.networkUnit sendParams:params
                           toURL:[NSURL URLWithString:strURL]
                         timeout:NetworkTimeOut
                      completion:^(NSError *error, id responseObject) {
                        if (error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                              handler(error, nil);
                            });
                        }
                        else {
                            [self processNetworkUnitResposneObject:responseObject
                                               withCompletionBlock:^(NSError *error, NSDictionary *responseDict) {
                                                 if (error) {
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                       handler(error, nil);
                                                     });
                                                 }
                                                 else {
                                                     NSArray *arr = responseDict[kPoints];
                                                     NSMutableArray *points = [NSMutableArray array];
                                                     if (RYIsValidArray(arr)) {
                                                         for (NSDictionary *dict in arr) {
                                                             if ([dict[kIsUGC] integerValue] == 0) {
                                                                 [points addObject:[GTRecommendPoint recommendPointFromDictionary:dict]];
                                                             }
                                                             else {
                                                                 [points addObject:[GTUGCPoint ugcPointFromDictionary:dict]];
                                                             }
                                                         }
                                                     }
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                       handler(nil, points);
                                                     });
                                                 }
                                               }];
                        }
                      }];
}

- (void)sendCommentByUser:(NSString *)userID
                  toPoint:(NSString *)pointID
                  comment:(NSString *)comment
               completion:(void (^)(NSError *error))handler
{
    NSString *strURL = GetAPIUrl(API_Comments);
    NSDictionary *dictParams = @{ kUserID : @([userID longLongValue]),
                                  kPointID : @([pointID longLongValue]),
                                  kComment : comment
    };
    [self.networkUnit sendParams:dictParams
                           toURL:[NSURL URLWithString:strURL]
                         timeout:NetworkTimeOut
                      completion:^(NSError *error, id responseObject) {
                        if (error) {
                            handler(error);
                        }
                        else {
                            [self processNetworkUnitResposneObject:responseObject
                                               withCompletionBlock:^(NSError *error, NSDictionary *responseDict) {
                                                 handler(error);
                                               }];
                        }
                      }];
}

- (void)sendLocationToUser:(NSString *)userID
                    cityID:(NSString *)cityID
                  latitude:(double)latitude
                 longitude:(double)longitude
                completion:(void (^)(NSError *error))handler
{
    NSString *strURL = GetAPIUrl(API_UserLocation);
    NSDictionary *dictParams = @{ kUserID : @([userID longLongValue]),
                                  kLatitude : @(latitude),
                                  kLongitude : @(longitude),
                                  kCityID : @([cityID longLongValue])
    };
    [self.networkUnit sendParams:dictParams
                           toURL:[NSURL URLWithString:strURL]
                         timeout:NetworkTimeOut
                      completion:^(NSError *error, id responseObject) {
                        if (error) {
                            handler(error);
                        }
                        else {
                            [self processNetworkUnitResposneObject:responseObject
                                               withCompletionBlock:^(NSError *error, NSDictionary *responseDict) {
                                                 handler(error);
                                               }];
                        }
                      }];
}

// FIXME: 修改AFNteworking
- (void)uploadImageData:(NSData *)data
            description:(NSString *)description
                 byUser:(NSString *)userID
                 toLine:(NSString *)lineID
               latitude:(double)latitude
              longitude:(double)longitude
                   city:(NSInteger)cityID
               category:(NSInteger)catID
             completion:(void (^)(NSError *error, BOOL success))hander
    uploadProgressBlock:(void (^)(float progress))block
{
    NSString *strURL = GetAPIUrl(API_UploadImage);
    NSDictionary *params = @{ kDescription : RYIsValidString(description) ? description : @"",
                              kUserID : @([userID longLongValue]),
                              kLineID : @([lineID longLongValue]),
                              kLatitude : @(latitude),
                              kLongitude : @(longitude),
                              kCityID : @(cityID),
                              kCategoryID : @(catID)
    };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    AFHTTPRequestOperation *operation = [manager POST:strURL
        parameters:params
        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
          [formData appendPartWithFileData:data name:@"image" fileName:@"image.png" mimeType:@"image/png"];
        }
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
          hander(nil, YES);
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          hander(error, NO);
        }];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
      block(totalBytesWritten * 1.0 / totalBytesExpectedToWrite);
    }];
}

- (void)requestRecentUsersOfCity:(NSString *)cityID completion:(void (^)(NSError *error, NSArray *users))handler
{
    NSString *strURL = GetAPIUrl(API_CityUsers);
    NSDictionary *params = @{ kCityID : @([cityID longLongValue]) };
    [self.networkUnit sendParams:params
                           toURL:[NSURL URLWithString:strURL]
                         timeout:NetworkTimeOut
                      completion:^(NSError *error, id responseObject) {
                        if (error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                              handler(error, nil);
                            });
                        }
                        else {
                            [self processNetworkUnitResposneObject:responseObject
                                               withCompletionBlock:^(NSError *error, NSDictionary *responseDict) {
                                                 if (error) {
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                       handler(error, nil);
                                                     });
                                                 }
                                                 else {
                                                     @try {
                                                         NSArray *arr = responseDict[kUsers];
                                                         NSMutableArray *array = [NSMutableArray array];
                                                         for (NSDictionary *dict in arr) {
                                                             GTDistanceUser *user = [GTDistanceUser distanceUserFromDictionary:dict];
                                                             [array addObject:user];
                                                         }
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                           handler(nil, array);
                                                         });
                                                     }
                                                     @catch (NSException *exception) {
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                           handler([NSError errorWithDomain:@"Response data format is incorrect!" code:-1 userInfo:responseDict], nil);
                                                         });
                                                     }
                                                 }
                                               }];
                        }
                      }];
}

- (void)requestPointsWithTownOrCity:(NSString *)cityOrTownID
                             byUser:(NSString *)userID
                         categoryID:(long long)catID
                           latitude:(double)latitude
                          longitude:(double)longitude
                         completion:(void (^)(NSError *error, NSArray *points))handler
{
    NSString *strURL = GetAPIUrl(API_TownOrCityPoints);
    NSDictionary *params = @{
        kUserID : @([userID longLongValue]),
        kArea_id : @([cityOrTownID longLongValue]),
        kCategoryID : @(catID),
        kLatitude : @(latitude),
        kLongitude : @(longitude),
    };
    [self.networkUnit sendParams:params
                           toURL:[NSURL URLWithString:strURL]
                         timeout:NetworkTimeOut
                      completion:^(NSError *error, id responseObject) {
                        if (error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                              handler(error, nil);
                            });
                        }
                        else {
                            [self processNetworkUnitResposneObject:responseObject
                                               withCompletionBlock:^(NSError *error, NSDictionary *responseDict) {
                                                 if (error) {
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                       handler(error, nil);
                                                     });
                                                 }
                                                 else {
                                                     NSArray *array = responseDict[kLists];
                                                     NSMutableArray *pointsArray = [NSMutableArray array];
                                                     if (RYIsValidArray(array)) {
                                                         for (NSDictionary *dict in array) {
                                                             GTCityOrTownPoints *point = [GTCityOrTownPoints cityOrTownPointsWithDict:dict];
                                                             [pointsArray addObject:point];
                                                         }
                                                     }
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                       handler(nil, pointsArray);
                                                     });
                                                 }
                                               }];
                        }
                      }];
}

#pragma mark--- 废弃
- (void)requestPointsOfCity:(NSString *)cityID
                     byUser:(NSString *)userID
                       type:(NSInteger)type
                 categoryID:(long long)catID
                    atIndex:(NSInteger)index
                      count:(NSInteger)count
                 completion:(void (^)(NSError *error, NSArray *points))handler
{
    NSString *strURL = GetAPIUrl(API_CityPoints);
    NSDictionary *params = @{ kUserID : @([userID longLongValue]),
                              kCityID : @([cityID longLongValue]),
                              kType : @(type),
                              kCategoryID : @(catID),
                              kIndex : @(index),
                              kCount : @(count)
    };
    [self.networkUnit sendParams:params
                           toURL:[NSURL URLWithString:strURL]
                         timeout:NetworkTimeOut
                      completion:^(NSError *error, id responseObject) {
                        if (error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                              handler(error, nil);
                            });
                        }
                        else {
                            [self processNetworkUnitResposneObject:responseObject
                                               withCompletionBlock:^(NSError *error, NSDictionary *responseDict) {
                                                 if (error) {
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                       handler(error, nil);
                                                     });
                                                 }
                                                 else {

                                                     NSLog(@"%@", responseDict);
                                                     NSArray *arr = responseDict[kPoints];
                                                     NSMutableArray *points = [NSMutableArray array];
                                                     if (RYIsValidArray(arr)) {
                                                         for (NSDictionary *dict in arr) {
                                                             if ([dict[kIsUGC] integerValue] == 0) {
                                                                 [points addObject:[GTRecommendPoint recommendPointFromDictionary:dict]];
                                                             }
                                                             else {
                                                                 [points addObject:[GTUGCPoint ugcPointFromDictionary:dict]];
                                                             }
                                                         }
                                                     }
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                       handler(nil, points);
                                                     });
                                                 }
                                               }];
                        }
                      }];
}

- (void)requestCityIDsWithCompletion:(void (^)(NSError *error, NSArray *cityIDs))handler
{
    NSString *strURL = GetAPIUrl(API_CityIDs);
    [self.networkUnit requestToURL:[NSURL URLWithString:strURL]
                           timeout:NetworkTimeOut
                        completion:^(NSError *error, id responseObject) {
                          if (error) {
                              dispatch_async(dispatch_get_main_queue(), ^{
                                handler(error, nil);
                              });
                          }
                          else {
                              [self processNetworkUnitResposneObject:responseObject
                                                 withCompletionBlock:^(NSError *error, NSDictionary *responseDict) {
                                                   if (error) {
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                         handler(error, nil);
                                                       });
                                                   }
                                                   else {
                                                       @try {
                                                           NSArray *arr = responseDict[kCityList];
                                                           NSMutableArray *array = [NSMutableArray array];
                                                           for (NSDictionary *dict in arr) {
                                                               GTCityBase *city = [GTCityBase cityFromDictionary:dict];
                                                               [array addObject:city];
                                                           }
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                             handler(nil, array);
                                                           });
                                                       }
                                                       @catch (NSException *exception) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                             handler([NSError errorWithDomain:@"Response data format is incorrect!" code:-1 userInfo:responseDict], nil);
                                                           });
                                                       }
                                                   }
                                                 }];
                          }
                        }];
}

- (void)addLineTitle:(NSString *)title
         description:(NSString *)desc
              toUser:(NSString *)userID
          completion:(void (^)(NSError *error, GTRouteBase *line))handler
{
    NSString *strURL = GetAPIUrl(API_AddLine);
    NSDictionary *params = @{ kUserID : @([userID longLongValue]),
                              kTitle : title,
                              kDescription : RYIsValidString(desc) ? desc : @""
    };
    [self.networkUnit sendParams:params
                           toURL:[NSURL URLWithString:strURL]
                         timeout:NetworkTimeOut
                      completion:^(NSError *error, id responseObject) {
                        if (error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                              handler(error, nil);
                            });
                        }
                        else {
                            [self processNetworkUnitResposneObject:responseObject
                                               withCompletionBlock:^(NSError *error, NSDictionary *responseDict) {
                                                 if (error) {
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                       handler(error, nil);
                                                     });
                                                 }
                                                 else {
                                                     GTRouteBase *route = [GTRouteBase routeBaseFromDictionary:responseDict[kLine]];
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                       handler(error, route);
                                                     });
                                                 }
                                               }];
                        }
                      }];
}

- (void)changeFavoriteOfPointID:(NSString *)pointID
                          isUGC:(BOOL)isUGC
                           user:(NSString *)userID
                     completion:(void (^)(NSError *error))handler
{
    NSString *strURL = GetAPIUrl(API_ChangeFavorite);
    NSDictionary *params = @{ kUserID : @([userID longLongValue]),
                              kType : isUGC ? @(TYPE_UGC) : @(TYPE_SYS),
                              kPointID : pointID
    };
    [self.networkUnit sendParams:params
                           toURL:[NSURL URLWithString:strURL]
                         timeout:NetworkTimeOut
                      completion:^(NSError *error, id responseObject) {
                        if (error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                              handler(error);
                            });
                        }
                        else {
                            [self processNetworkUnitResposneObject:responseObject
                                               withCompletionBlock:^(NSError *error, NSDictionary *responseDict) {
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                   handler(error);
                                                 });
                                               }];
                        }
                      }];
}

- (void)requestPartnersWithCompletionHandler:(void (^)(NSError *error, NSArray *partners))handler
{
    NSString *strURL = GetAPIUrl(API_Partners);
    [self.networkUnit requestToURL:[NSURL URLWithString:strURL]
                           timeout:NetworkTimeOut
                        completion:^(NSError *error, id responseObject) {
                          if (error) {
                              dispatch_async(dispatch_get_main_queue(), ^{
                                handler(error, nil);
                              });
                          }
                          else {
                              [self processNetworkUnitResposneObject:responseObject
                                                 withCompletionBlock:^(NSError *error, NSDictionary *responseDict) {
                                                   if (error) {
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                         handler(error, nil);
                                                       });
                                                   }
                                                   else {
                                                       NSArray *list = responseDict[kPartnerList];
                                                       NSMutableArray *partners = [NSMutableArray array];
                                                       for (NSDictionary *dict in list) {
                                                           [partners addObject:[DTPartner partnerWithDictionary:dict]];
                                                       }
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                         handler(nil, partners);
                                                       });
                                                   }
                                                 }];
                          }
                        }];
}


#pragma mark--- copy
- (void)requestTownListWithIndex:(NSInteger)index
                           count:(NSInteger)count
                      completion:(void (^)(NSError *error, NSString *title, NSArray *towns))handler
{
    NSString *strURL = GetAPIUrl(API_Towns);
    NSDictionary *dictParams = @{ kIndex : @(index),
                                  kCount : @(count)
    };
    [self.networkUnit sendParams:dictParams
                           toURL:[NSURL URLWithString:strURL]
                         timeout:NetworkTimeOut
                      completion:^(NSError *error, id responseObject) {
                        if (error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                              handler(error, nil, nil);
                            });
                        }
                        else {
                            [self processNetworkUnitResposneObject:responseObject
                                               withCompletionBlock:^(NSError *error, NSDictionary *responseDict) {
                                                 if (error) {
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                       handler(error, nil, nil);
                                                     });
                                                 }
                                                 else {
                                                     @try {
                                                         NSString *title = responseDict[kTitle];
                                                         NSMutableArray *items = [NSMutableArray array];
                                                         NSArray *arr = responseDict[kLists];
                                                         if (RYIsValidArray(arr)) {
                                                             for (NSDictionary *dict in arr) {
                                                                 GTravelTownItem *item = [GTravelTownItem townItemFromDictionary:dict];
                                                                 [items addObject:item];
                                                             }
                                                         }
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                           handler(nil, title, items);
                                                           NSLog(@"%@", title);
                                                         });
                                                     }
                                                     @catch (NSException *exception) {
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                           handler([NSError errorWithDomain:exception.reason code:-1 userInfo:exception.userInfo], nil, nil);
                                                         });
                                                     }
                                                 }
                                               }];
                        }
                      }];
}

@end
