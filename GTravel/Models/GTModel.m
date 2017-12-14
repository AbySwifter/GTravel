//
//  GTModel.m
//  GTravel
//
//  Created by Raynay Yue on 5/4/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTModel.h"
#import "RYCommon.h"
#import "DTWeChat.h"
#import "GTNetworkUnit.h"
#import "GTCacheUnit.h"
#import "GTravelUserItem.h"
#import "GTravelImageItem.h"
#import "GTravelToolItem.h"
#import "GTravelCityItem.h"
#import "GTravelTownItem.h"
#import "GTravelRouteItem.h"
#import "DTLocationUnit.h"
#import "GTCategory.h"
#import "GTFilter.h"
#import "GTPoint.h"

typedef NS_ENUM(NSInteger, GTUserLocation) {
    GTUserLocationUnkown,
    GTUserLocationInGermany,
    GTUserLocationNotInGermany
};

NSString *const kGTravelUserHeadImageDidUpdate = @"kGTravelUserHeadImageDidUpdate";

#define kHasNavigateToInGermanyView @"kHasNavigateToInGermanyView"
#define kWelcomeMessage @"kWelcomeMessage"

@interface GTModel () <DTWeChatManagerDelegate> {
    GTUserLocation userLocationStatus;
}
@property (nonatomic, readonly) DTWeChatManager *weChatManager;
@property (nonatomic, readonly) GTNetworkUnit *networkUnit;
@property (nonatomic, readonly) GTCacheUnit *cacheUnit;
@property (nonatomic, strong) NSMutableArray *cateList;

- (void)initializedModel;
- (void)startToRegisterWithWeChatUserProfile:(DTWeChatUserProfile *)profile;
- (void)startDownloadImageWithURL:(NSURL *)url completion:(void (^)(NSError *error, NSString *mimeType, NSData *data))handler;

- (void)startUserLocationObsever;
- (void)userLocationDidUpdate:(NSNotification *)notification;
- (void)stopUserLocationObsever;

- (void)uploadUserLocation;
- (void)reverseLocation:(CLLocation *)location completionHandler:(CLGeocodeCompletionHandler)handler;

- (GTCityBase *)getCityWithName:(NSString *)cityName;

@end

@implementation GTModel
#pragma mark - Property Methods

- (BOOL)bNeedWeChatAuthentication
{
    return !RYIsValidString(self.cacheUnit.userID);
}


- (DTWeChatManager *)weChatManager
{
    return [DTWeChatManager sharedManager];
}

- (GTNetworkUnit *)networkUnit
{
    return [GTNetworkUnit sharedNetworkUnit];
}

- (GTCacheUnit *)cacheUnit
{
    return [GTCacheUnit sharedCache];
}

- (NSString *)welcomeMessage
{
    return [self.cacheUnit valueInUserDefaultsForKey:kWelcomeMessage];
}

- (void)setWelcomeMessage:(NSString *)welcomeMessage
{
    [self.cacheUnit saveValueToUserDefaults:welcomeMessage forKey:kWelcomeMessage];
}

- (BOOL)bShouldDisplayInGermanyView
{
    NSNumber *num = [self.cacheUnit objectInUserDefaultsForKey:kHasNavigateToInGermanyView];
    BOOL bShould = NO;
    bShould = [num boolValue] && userLocationStatus == GTUserLocationInGermany;
    return bShould;
}

- (void)setBShouldDisplayInGermanyView:(BOOL)bShouldDisplayInGermanyView
{
    [self.cacheUnit saveObjectToUserDefaults:@(bShouldDisplayInGermanyView) forKey:kHasNavigateToInGermanyView];
}

- (NSArray *)categories
{
    return self.cateList;
}

#pragma mark - Non-Public Methods
- (void)initializedModel
{
    self.weChatManager.delegate = self;
    userLocationStatus = GTUserLocationUnkown;
    [self startUserLocationObsever];
    self.bShouldDisplayInGermanyView = YES;
}

- (void)dealloc
{
    [self stopUserLocationObsever];
}

/**
 *  根据微信返回的用户信息开始注册
 */
- (void)startToRegisterWithWeChatUserProfile:(DTWeChatUserProfile *)profile
{
    NSLog(@"%@", profile);
    [self.networkUnit registerUserWithUnionID:profile.unionID
                                     nickName:profile.nickName
                                 headImageURL:profile.headImageURL
                                     province:profile.province
                                         city:profile.city
                                          sex:profile.sex == DTSexMale ? GTravelUserSexMale : GTravelUserSexFemale
                                   completion:^(NSError *error, NSString *userID) {
                                     if (error) {
                                         if (RYDelegateCanResponseToSelector(self.delegate, @selector(model:operationDidFailedWithError:))) {
                                             [self.delegate model:self operationDidFailedWithError:error];
                                         }
                                     }
                                     else {
                                         self.cacheUnit.userID = userID;
                                         [self startToLogin];
                                     }
                                   }];
}

- (void)startDownloadImageWithURL:(NSURL *)url completion:(void (^)(NSError *error, NSString *mimeType, NSData *data))handler
{
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
//    [NSURLConnection sendAsynchronousRequest:request
//                                       queue:[NSOperationQueue mainQueue]
//                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//                             if ([response.MIMEType rangeOfString:@"image"].location != NSNotFound) {
//                                 handler(nil, response.MIMEType, data);
//                             }
//                             else {
//                                 handler([NSError errorWithDomain:@"response mimetype is not an image!" code:-1 userInfo:nil], response.MIMEType, data);
//                             }
//                           }];
	NSURLSessionDataTask* task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable connectionError) {
		dispatch_async(dispatch_get_main_queue(), ^{
			if ([response.MIMEType rangeOfString:@"image"].location != NSNotFound) {
				handler(nil, response.MIMEType, data);
			}
			else {
				handler([NSError errorWithDomain:@"response mimetype is not an image!" code:-1 userInfo:nil], response.MIMEType, data);
			}
		});
	}];
	[task resume];
	
}

- (void)startUserLocationObsever
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLocationDidUpdate:) name:kDTNotificationDidUpdateUserLocation object:nil];
}

- (void)userLocationDidUpdate:(NSNotification *)notification
{
    CLLocation *location = [notification object];
    self.userLocation = location;
    [self performSelector:@selector(uploadUserLocation) withObject:nil afterDelay:10.0];
}

- (void)stopUserLocationObsever
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDTNotificationDidUpdateUserLocation object:nil];
}

- (void)uploadUserLocation
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(uploadUserLocation) object:nil];
    if (self.userLocation) {
        CLLocation *location = self.userLocation;
        RYCONDITIONLOG(DEBUG, @"lat:%f,lon:%f", location.coordinate.latitude, location.coordinate.longitude);
        [self reverseLocation:location
            completionHandler:^(NSArray *placemarks, NSError *error) {
              if (RYIsValidArray(placemarks)) {
                  CLPlacemark *mark = [placemarks firstObject];
                  self.currentPlaceMark = mark;
                  NSString *cityName = mark.locality;
                  GTCityBase *cityBase = [self getCityWithName:cityName];
                  if (RYIsValidString(cityBase.welcomeMessage)) {
                      self.welcomeMessage = cityBase.welcomeMessage;
                  }

                  if (RYIsValidString(self.cacheUnit.userID)) {
                      NSString *cityID = cityBase == nil ? @"0" : [cityBase.cityID description];
                      [self.networkUnit sendLocationToUser:self.cacheUnit.userID
                                                    cityID:cityID
                                                  latitude:location.coordinate.latitude
                                                 longitude:location.coordinate.longitude
                                                completion:^(NSError *error) {
                                                  if (error) {
                                                      RYCONDITIONLOG(DEBUG, @"%@", error);
                                                  }
                                                }];
                  }
              }
              else
                  self.currentPlaceMark = nil;
            }];
    }
}

- (void)reverseLocation:(CLLocation *)location completionHandler:(CLGeocodeCompletionHandler)handler
{
    //    RYCONDITIONLOG(DEBUG, @"%@-%@",[NSLocale systemLocale].localeIdentifier,[NSLocale ISOCountryCodes]);
    NSMutableArray *defaultLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] setObject:@[ @"zh-hans" ] forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    CLGeocoder *coder = [[CLGeocoder alloc] init];
    [coder reverseGeocodeLocation:location
                completionHandler:^(NSArray *placemarks, NSError *error) {
                  [[NSUserDefaults standardUserDefaults] setObject:defaultLanguages forKey:@"AppleLanguages"];
                  [[NSUserDefaults standardUserDefaults] synchronize];
                  CLPlacemark *mark = [placemarks firstObject];
                  RYCONDITIONLOG(DEBUG, @"\n%d-Country code :%@,Country:%@,Locality:%@", (int)placemarks.count, mark.ISOcountryCode, mark.country, mark.locality);

                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"DIDRECIEVELOCATION" object:nil];
                  });


                  if ([mark.ISOcountryCode isEqualToString:@"DE"] || [mark.country isEqualToString:@"德国"]) {
                      userLocationStatus = GTUserLocationInGermany;
                  }
                  handler(placemarks, error);
                }];
}

- (GTCityBase *)getCityWithName:(NSString *)cityName
{
    return [self.cacheUnit getCityIDofCityName:cityName];
}

#pragma mark - Public Methods
- (instancetype)init
{
    if (self = [super init]) {
        [self initializedModel];
    }
    return self;
}

static GTModel *sharedInstance = nil;
+ (GTModel *)sharedModel
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

/**
 *  开始微信授权登录
 */
- (void)startWeChatAuthentication
{
    [self.weChatManager startWeChatLogin];
}

/**
 *  开始用户名,密码认证登录
 */
- (void)startNormalLoginWithReviewWithParams:(NSDictionary *)params
{
    // 调用普通登录接口
    [self.networkUnit loginWithUserNickName:params[@"nick_name"]
                                   passWord:params[@"pwd"]
                                 completion:^(NSError *error, GTravelUserItem *userItem) {
                                   if (error) {
                                       if (RYDelegateCanResponseToSelector(self.delegate, @selector(model:operationDidFailedWithError:))) {
                                           [self.delegate model:self operationDidFailedWithError:error];
                                       }
                                   }
                                   else {
                                       self.userItem = userItem;
                                       if (RYDelegateCanResponseToSelector(self.delegate, @selector(model:didLoginWithUserItem:))) {
                                           [self.delegate model:self didLoginWithUserItem:userItem];
                                       }
                                       if (RYIsValidString([userItem.routeBase.lineID description])) {
                                           self.cacheUnit.lineID = [self.userItem.routeBase.lineID description];
                                       }
                                       else {
                                           self.cacheUnit.lineID = nil;
                                       }
                                       if (RYIsValidString(userItem.userID)) {
                                           self.cacheUnit.userID = userItem.userID;
                                       }
                                       else {
                                           self.cacheUnit.userID = nil;
                                       }
                                       if (RYIsValidString(params[@"nick_name"])) {
                                           self.cacheUnit.userNickName = params[@"nick_name"];
                                       }
                                       else {
                                           self.cacheUnit.userNickName = nil;
                                       }
                                       if (RYIsValidString(params[@"pwd"])) {
                                           self.cacheUnit.passWord = params[@"pwd"];
                                       }
                                       else {
                                           self.cacheUnit.passWord = nil;
                                       }
                                   }
                                 }];
}

// 根据存储的用户名和密码进行普通用户的自动登录
- (void)startNormalAutoLogin
{
    //    [self.weChatManager startNormalLogin];
    [self.networkUnit loginWithUserNickName:self.cacheUnit.userNickName
                                   passWord:self.cacheUnit.passWord
                                 completion:^(NSError *error, GTravelUserItem *userItem) {

                                   if (error) {
                                       if (RYDelegateCanResponseToSelector(self.delegate, @selector(model:operationDidFailedWithError:))) {
                                           [self.delegate model:self operationDidFailedWithError:error];
                                       }
                                   }
                                   else {
                                       self.userItem = userItem;
                                       if (RYIsValidString(userItem.userID)) {
                                           self.cacheUnit.userID = userItem.userID;
                                       }
                                       //            if (RYIsValidString(userItem.nickName)) {
                                       //                self.cacheUnit.userNickName = userItem.nickName;
                                       //            }

                                       if (RYDelegateCanResponseToSelector(self.delegate, @selector(model:didLoginWithUserItem:))) {
                                           [self.delegate model:self didLoginWithUserItem:userItem];
                                       }

                                       if (RYIsValidString([userItem.routeBase.lineID description])) {
                                           self.cacheUnit.lineID = [self.userItem.routeBase.lineID description];
                                       }
                                       else
                                           self.cacheUnit.lineID = nil;

                                       [self downloadUserItem:userItem
                                                   completion:^(NSError *error, NSData *data) {
                                                     if (!error) {
                                                         [[NSNotificationCenter defaultCenter] postNotificationName:kGTravelUserHeadImageDidUpdate object:data];
                                                     }
                                                     else
                                                         RYCONDITIONLOG(DEBUG, @"%@", error);
                                                   }];
                                   }

                                 }];
}

// 根据存储的userid，进行微信用户自动登录
- (void)startToLogin
{
    [self.networkUnit loginWithUserID:self.cacheUnit.userID
                          deviceToken:self.cacheUnit.deviceToken
                           completion:^(NSError *error, GTravelUserItem *userItem) {
                             if (error) {
                                 if (RYDelegateCanResponseToSelector(self.delegate, @selector(model:operationDidFailedWithError:))) {
                                     [self.delegate model:self operationDidFailedWithError:error];
                                 }
                             }
                             else {
                                 self.userItem = userItem;
                                 if (RYIsValidString(userItem.nickName)) {
                                     self.cacheUnit.userNickName = userItem.nickName;
                                 }

                                 if (RYDelegateCanResponseToSelector(self.delegate, @selector(model:didLoginWithUserItem:))) {
                                     [self.delegate model:self didLoginWithUserItem:userItem];
                                 }

                                 if (RYIsValidString([userItem.routeBase.lineID description])) {
                                     self.cacheUnit.lineID = [self.userItem.routeBase.lineID description];
                                 }
                                 else
                                     self.cacheUnit.lineID = nil;

                                 [self downloadUserItem:userItem
                                             completion:^(NSError *error, NSData *data) {
                                               if (!error) {
                                                   [[NSNotificationCenter defaultCenter] postNotificationName:kGTravelUserHeadImageDidUpdate object:data];
                                               }
                                               else
                                                   RYCONDITIONLOG(DEBUG, @"%@", error);
                                             }];
                             }
                           }];
}

- (void)loginout
{
    [self.weChatManager logout];
    self.cacheUnit.userID = nil;
    self.cacheUnit.lineID = nil;
    self.cacheUnit.userNickName = nil;
    self.cacheUnit.passWord = nil;
}

- (NSString *)getCurrentUserAddress
{
    return self.currentPlaceMark.name;
}

- (void)downloadUserItem:(GTravelUserItem *)userItem completion:(GTImageDownloadCompletion)handler
{
    if (RYIsValidString(userItem.headImageURL)) {
        [self startDownloadImageWithURL:[NSURL URLWithString:userItem.headImageURL]
                             completion:^(NSError *error, NSString *mimeType, NSData *data) {
                               if (error) {
                                   handler(error, nil);
                               }
                               else {
                                   [self.cacheUnit saveImageData:data forUserItem:userItem];
                               }
                               handler(error, data);
                             }];
    }
    else
        handler([NSError errorWithDomain:@"User head image url is nil!" code:-1 userInfo:nil], nil);
}

- (void)requestLaunchImagesWithCompletion:(void (^)(NSArray *images))handler
{
    [self.networkUnit requestLaunchImagesWithCompletion:^(NSError *error, NSString *version, NSArray *images) {
      if (error) {
          RYCONDITIONLOG(DEBUG, @"%@", error);
      }
      else
          [self.cacheUnit updateLaunchImages:images version:version];
      handler(self.cacheUnit.launchImages);
    }];
}

- (void)requestBannersWithCompletion:(void (^)(NSArray *images))handler
{
    [self.networkUnit requestBannersWithCompletion:^(NSError *error, NSString *version, NSArray *banners) {
      if (error) {
          RYCONDITIONLOG(DEBUG, @"%@", error);
      }
      else
          [self.cacheUnit updateBanners:banners version:version];
      handler(self.cacheUnit.banners);
    }];
}

- (void)requestToolsWithCompletion:(void (^)(NSArray *items))handler
{
    [self.networkUnit requestToolListWithCompletion:^(NSError *error, NSString *version, NSArray *tools) {
      if (error) {
          RYCONDITIONLOG(DEBUG, @"%@", error);
      }
      else
          [self.cacheUnit updateTips:tools version:version];
      handler(self.cacheUnit.tipItems);
    }];
}

- (void)downloadToolItem:(GTravelToolItem *)item completion:(GTImageDownloadCompletion)handler
{
    if (RYIsValidString(item.imageURL)) {
        [self startDownloadImageWithURL:[NSURL URLWithString:item.imageURL]
                             completion:^(NSError *error, NSString *mimeType, NSData *data) {
                               if (error) {
                                   RYCONDITIONLOG(DEBUG, @"%@", error);
                               }
                               else {
                                   [self.cacheUnit saveImageData:data forToolItem:item];
                               }
                               handler(error, data);
                             }];
    }
    else
        handler([NSError errorWithDomain:@"Image URL is nil!" code:-1 userInfo:nil], nil);
}

- (void)downloadToolItemThumbnail:(GTravelToolItem *)item completion:(GTImageDownloadCompletion)handler
{
    if (RYIsValidString(item.thumbnailURL)) {
        [self startDownloadImageWithURL:[NSURL URLWithString:item.thumbnailURL]
                             completion:^(NSError *error, NSString *mimeType, NSData *data) {
                               if (error) {
                                   RYCONDITIONLOG(DEBUG, @"%@", error);
                               }
                               else {
                                   [self.cacheUnit saveThumbnail:data forTipsItem:item];
                               }
                               handler(error, data);
                             }];
    }
    else
        handler([NSError errorWithDomain:@"Thumbnail URL is nil!" code:-1 userInfo:nil], nil);
}

- (void)requestCityListAtIndex:(NSInteger)index count:(NSInteger)count completion:(void (^)(NSError *error, NSString *title, NSArray *cities))handler
{
    [self.networkUnit requestCityListWithIndex:index
                                         count:count
                                    completion:^(NSError *error, NSString *title, NSArray *cities) {
                                      if (error) {
                                          RYCONDITIONLOG(DEBUG, @"%@", error);
                                      }
                                      else {
                                          [self.cacheUnit updateCityListWithTitle:title cities:cities atIndex:index];
                                      }
                                      handler(error, title, cities);
                                    }];
}

- (void)downloadCityItem:(GTravelCityItem *)item completion:(GTImageDownloadCompletion)handler
{
    if (RYIsValidString(item.thumbnailURL)) {
        [self startDownloadImageWithURL:[NSURL URLWithString:item.thumbnailURL]
                             completion:^(NSError *error, NSString *mimeType, NSData *data) {
                               if (error) {
                                   RYCONDITIONLOG(DEBUG, @"%@", error);
                                   handler(error, nil);
                               }
                               else {
                                   [self.cacheUnit saveImageData:data forCityItem:item];
                               }
                               handler(error, data);
                             }];
    }
    else
        handler([NSError errorWithDomain:@"City's thumbnail url is nil!" code:-1 userInfo:nil], nil);
}

- (void)requestRouteListAtIndex:(NSInteger)index count:(NSInteger)count completion:(void (^)(NSError *error, NSString *title, NSArray *routes))handler
{
    [self.networkUnit requestLineListWithIndex:index
                                         count:count
                                    completion:^(NSError *error, NSString *title, NSArray *routes) {
                                      if (error) {
                                          RYCONDITIONLOG(DEBUG, @"%@", error);
                                      }
                                      else {
                                          [self.cacheUnit updateRouteListWithTitle:title routes:routes atIndex:index];
                                      }
                                      handler(error, title, routes);
                                    }];
}

- (void)downloadRouteItem:(GTravelRouteItem *)item completion:(GTImageDownloadCompletion)handler
{
    if (RYIsValidString(item.thumnail)) {
        [self startDownloadImageWithURL:[NSURL URLWithString:item.thumnail]
                             completion:^(NSError *error, NSString *mimeType, NSData *data) {
                               if (error) {
                                   RYCONDITIONLOG(DEBUG, @"%@", error);
                               }
                               else {
                                   [self.cacheUnit saveImageData:data forRouteItem:item];
                               }
                               handler(error, data);
                             }];
    }
    else
        handler([NSError errorWithDomain:@"City's thumbnail url is nil!" code:-1 userInfo:nil], nil);
}

- (void)downloadRouteUserItem:(GTUserBase *)userItem completion:(GTImageDownloadCompletion)handler
{
    if (RYIsValidString(userItem.headImageURL)) {
        [self startDownloadImageWithURL:[NSURL URLWithString:userItem.headImageURL]
                             completion:^(NSError *error, NSString *mimeType, NSData *data) {
                               if (error) {
                                   RYCONDITIONLOG(DEBUG, @"%@", error);
                               }
                               else {
                                   [self.cacheUnit saveImageData:data forRouteUserItem:userItem];
                               }
                               handler(error, data);
                             }];
    }
    else
        handler([NSError errorWithDomain:@"User head image url is nil!" code:-1 userInfo:nil], nil);
}

- (void)requestCityIDs
{
    [self.networkUnit requestCityIDsWithCompletion:^(NSError *error, NSArray *cityIDs) {
      if (error) {
          RYCONDITIONLOG(DEBUG, @"%@", error);
      }
      else {

          [self.cacheUnit updateCityIDs:cityIDs];
      }
    }];
}

- (void)requestRecentUsersWithCompletion:(void (^)(NSError *error, NSArray *users))handler
{
    if (self.userLocation) {
        [self reverseLocation:self.userLocation
            completionHandler:^(NSArray *placemarks, NSError *error) {
              if (RYIsValidArray(placemarks)) {
                  CLPlacemark *mark = [placemarks firstObject];
                  NSString *cityName = mark.locality;
                  NSLog(@"%@", cityName);
                  //#if DEBUG
                  //                cityName = @"柏林";
                  //#endif
                  GTCityBase *city = [self.cacheUnit getCityIDofCityName:cityName];
                  if (city) {
                      [self.networkUnit requestRecentUsersOfCity:[city.cityID description]
                                                      completion:^(NSError *error, NSArray *users) {
                                                        if (error) {
                                                            RYCONDITIONLOG(DEBUG, @"%@", error);
                                                        }
                                                        else {
                                                            [self.cacheUnit updateRecentUsers:users];
                                                        }
                                                        handler(error, users);
                                                      }];
                  }
              }
              else
                  RYCONDITIONLOG(DEBUG, @"%@", error);
            }];
    }
    else
        handler([NSError errorWithDomain:@"User location is nil!" code:0 userInfo:nil], nil);
}

- (void)downloadRecentUser:(GTUserBase *)item completion:(GTImageDownloadCompletion)handler
{
    if (RYIsValidString(item.headImageURL)) {
        [self startDownloadImageWithURL:[NSURL URLWithString:item.headImageURL]
                             completion:^(NSError *error, NSString *mimeType, NSData *data) {
                               if (error) {
                                   RYCONDITIONLOG(DEBUG, @"%@", error);
                               }
                               else {
                                   [self.cacheUnit saveImageData:data forRecentUser:item];
                               }
                               handler(error, data);
                             }];
    }
    else {
        handler([NSError errorWithDomain:@"User image URL is invalid!" code:0 userInfo:nil], nil);
    }
}

- (void)requestCategoryWithCompletion:(void (^)(NSError *error, NSArray *items))handler
{
    [self.networkUnit requestCategoryListWithCompletion:^(NSError *error, NSArray *categories, NSArray *filters) {
      self.filters = filters;
      self.cateList = [NSMutableArray arrayWithArray:categories];
      handler(error, self.cateList);
    }];
}

// 四个集合

- (void)requestFourSetsWithCompletion:(void (^)(NSError *error, NSArray *fourSets))handler
{
    [self.networkUnit requestFourSetsListWithCompletion:^(NSError *error, NSArray *fourSets) {

      self.fourSets = [NSMutableArray arrayWithArray:fourSets];
      handler(error, self.fourSets);
    }];
}

- (void)downloadCategory:(GTCategory *)item completion:(GTImageDownloadCompletion)handler
{
    if (RYIsValidString(item.thumbnail)) {
        [self startDownloadImageWithURL:[NSURL URLWithString:item.thumbnail]
                             completion:^(NSError *error, NSString *mimeType, NSData *data) {
                               if (error) {
                                   RYCONDITIONLOG(DEBUG, @"%@", error);
                               }
                               handler(error, data);
                             }];
    }
    else {
        handler([NSError errorWithDomain:@"Image url is invalid!" code:0 userInfo:nil], nil);
    }
}

- (void)uploadImageData:(NSData *)data description:(NSString *)description category:(GTCategory *)category completion:(void (^)(NSError *error, BOOL success))handler uploadProgressBlock:(void (^)(float fProgress))block
{
    GTCityBase *city = [self getCityWithName:self.currentPlaceMark.locality];
    [self.networkUnit uploadImageData:data
        description:description
        byUser:self.userItem.userID
        toLine:[self.userItem.routeBase.lineID description]
        latitude:self.userLocation.coordinate.latitude
        longitude:self.userLocation.coordinate.longitude
        city:city == nil ? 0 : [city.cityID integerValue]
        category:category == nil ? 0 : [category.categoryID integerValue]
        completion:^(NSError *error, BOOL success) {
          handler(error, success);
        }
        uploadProgressBlock:^(float progress) {
          block(progress);
        }];
}

- (void)createLine:(NSString *)title description:(NSString *)desc completion:(void (^)(NSError *error))handler
{
    [self.networkUnit addLineTitle:title
                       description:desc
                            toUser:self.cacheUnit.userID
                        completion:^(NSError *error, GTRouteBase *line) {
                          handler(error);
                          if (!error) {
                              self.cacheUnit.lineID = [line.lineID description];
                              self.userItem.routeBase = line;
                          }
                        }];
}

- (void)createTagWithTitle:(NSString *)title completion:(void (^)(NSError *error, GTCategory *category))handler
{
    [self.networkUnit addCategoryByUser:self.userItem.userID
                                  title:title
                             completion:^(NSError *error, GTCategory *category) {
                               handler(error, category);
                               if (!error)
                                   [self.cateList addObject:category];
                             }];
}

- (void)requestAroundUsersWithFiler:(GTFilter *)filter sex:(GTFilterSex)sex completion:(void (^)(NSError *error, NSArray *users))handler
{
    [self.networkUnit requestAroundUsersByUser:self.userItem.userID
                                      filterID:filter == nil ? @"0" : filter.filterID
                                           sex:sex
                                      latitude:self.userLocation.coordinate.latitude
                                     longitude:self.userLocation.coordinate.longitude
                                    completion:^(NSError *error, NSArray *users) {
                                      handler(error, users);
                                    }];
}

- (void)requestAroundPointsWithFilter:(GTFilter *)filter category:(GTCategory *)category pointType:(GTFilterPointType)type atIndex:(NSInteger)index count:(NSInteger)count completion:(void (^)(NSError *error, NSArray *points))handler
{
    [self.networkUnit requestAroundPointsByUser:self.userItem.userID
                                       filterID:filter == nil ? @"0" : filter.filterID
                                     categoryID:category == nil ? @"0" : [category.categoryID description]
                                           type:[@(type) description]
                                       latitude:self.userLocation.coordinate.latitude
                                      longitude:self.userLocation.coordinate.longitude
                                        atIndex:index
                                          count:count
                                     completion:^(NSError *error, NSArray *points) {
                                       handler(error, points);
                                     }];
}

- (void)requestUserPointsWithDictionary:(NSDictionary *)param completion:(void (^)(NSError *error, NSArray *points))handler
{
    [self.networkUnit requestUserPointsByParam:param
                                    completion:^(NSError *error, NSArray *points) {
                                      handler(error, points);
                                    }];
}

#pragma mark--- 废弃
- (void)requestPointsOfCity:(NSString *)cityID category:(GTCategory *)category filter:(GTFilter *)filter pointType:(GTFilterPointType)type atIndex:(NSInteger)index count:(NSInteger)count completion:(void (^)(NSError *error, NSArray *points))handler
{
    [self.networkUnit requestPointsOfCity:cityID
                                   byUser:self.userItem.userID
                                     type:type
                               categoryID:category == nil ? 0 : [category.categoryID longLongValue]
                                  atIndex:index
                                    count:count
                               completion:^(NSError *error, NSArray *points) {
                                 handler(error, points);
                               }];
}

#pragma mark--- copy
- (void)requestPointsWithTownOrCity:(NSString *)cityOrTownID category:(GTCategory *)category latitude:(double)latitude longitude:(double)longitude completion:(void (^)(NSError *error, NSArray *points))handler
{
    [self.networkUnit requestPointsWithTownOrCity:cityOrTownID
                                           byUser:self.userItem.userID
                                       categoryID:category == nil ? 0 : [category.categoryID longLongValue]
                                         latitude:latitude
                                        longitude:longitude
                                       completion:^(NSError *error, NSArray *points) {
                                         handler(error, points);
                                       }];
}


- (void)changeFavorteStateOfPoint:(GTPoint *)point completion:(void (^)(NSError *error))handler
{
    NSString *poiID = point.pointID;
    BOOL isUGC = YES;
    if ([[point class] isSubclassOfClass:[GTRecommendPoint class]]) {
        GTRecommendPoint *poi = (GTRecommendPoint *)point;
        poiID = poi.wpPostID;
        isUGC = NO;
    }
    [self.networkUnit changeFavoriteOfPointID:poiID
                                        isUGC:isUGC
                                         user:self.userItem.userID
                                   completion:^(NSError *error) {
                                     handler(error);
                                   }];
}

- (void)requestPartnerListWithCompletion:(void (^)(NSError *error, NSArray *partners))handler
{
    [self.networkUnit requestPartnersWithCompletionHandler:^(NSError *error, NSArray *partners) {
      handler(error, partners);
    }];
}

- (NSString *)distanceDisplayStringOfValue:(double)distance
{
    NSString *distanceString = nil;
    if (distance < 1000) {
        distanceString = [NSString stringWithFormat:@"%dm", (int)distance];
    }
    else if (distance < 5000) {
        distanceString = [NSString stringWithFormat:@"%.1fkm", distance / 5000];
    }
    else
        distanceString = @"大于5km";
    return distanceString;
}

#pragma mark - DTWeChatManagerDelegate
/**
 *  当用户登录成功后调用
 */
- (void)weChatManager:(DTWeChatManager *)manager didGetWeChatUserProfile:(DTWeChatUserProfile *)profile
{
    if (RYDelegateCanResponseToSelector(self.delegate, @selector(weChatAuthenticationDidSucceedWithModel:))) {
        [self.delegate weChatAuthenticationDidSucceedWithModel:self];
    }
    [self startToRegisterWithWeChatUserProfile:profile];
}

- (void)weChatManager:(DTWeChatManager *)manager operationDidFailWithError:(NSError *)error
{
    if (RYDelegateCanResponseToSelector(self.delegate, @selector(model:operationDidFailedWithError:))) {
        [self.delegate model:self operationDidFailedWithError:error];
    }
}

#pragma mark--- copy
- (void)requestTownListAtIndex:(NSInteger)index count:(NSInteger)count completion:(void (^)(NSError *error, NSString *title, NSArray *towns))handler
{
    [self.networkUnit requestTownListWithIndex:index
                                         count:count
                                    completion:^(NSError *error, NSString *title, NSArray *towns) {
                                      if (error) {
                                          RYCONDITIONLOG(DEBUG, @"%@", error);
                                      }
                                      else {
                                          [self.cacheUnit updateCityListWithTitle:title cities:towns atIndex:index];
                                      }
                                      handler(error, title, towns);
                                    }];
}


- (void)downloadTownItem:(GTravelTownItem *)item completion:(GTImageDownloadCompletion)handler
{
    if (RYIsValidString(item.thumbnailURL)) {
        [self startDownloadImageWithURL:[NSURL URLWithString:item.thumbnailURL]
                             completion:^(NSError *error, NSString *mimeType, NSData *data) {
                               if (error) {
                                   RYCONDITIONLOG(DEBUG, @"%@", error);
                                   handler(error, nil);
                               }
                               else {
                                   [self.cacheUnit saveImageData:data forTownItem:item];
                               }
                               handler(error, data);
                             }];
    }
    else
        handler([NSError errorWithDomain:@"City's thumbnail url is nil!" code:-1 userInfo:nil], nil);
}

@end
