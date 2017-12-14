//
//  GTCacheUnit.h
//  GTravel
//
//  Created by Raynay Yue on 5/22/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GTravelCityItem;
@class GTravelRouteItem;
@class GTravelImageItem;
@class GTravelToolItem;
@class GTUserBase;
@class GTravelUserItem;
@class GTCityBase;
@class GTCategory;
@class GTTownBase;
@class GTravelTownItem;

@interface GTCacheUnit : NSObject
@property (nonatomic, assign) NSString *userID;
@property (nonatomic, assign) NSString *userNickName;
@property (nonatomic, assign) NSString *passWord;
@property (nonatomic, assign) NSString *deviceToken;

@property (nonatomic, strong) NSMutableArray *launchImages;
@property (nonatomic, assign) NSString *launchImageVersion;

@property (nonatomic, strong) NSMutableArray *banners;
@property (nonatomic, assign) NSString *bannerImageVersion;

@property (nonatomic, strong) NSMutableArray *tipItems;
@property (nonatomic, assign) NSString *tipImageVersion;

@property (nonatomic, assign) NSString *titleOfCities;
@property (nonatomic, strong) NSMutableArray *cities;

@property (nonatomic, assign) NSString *titleOfTowns;
@property (nonatomic, strong) NSMutableArray *towns;

@property (nonatomic, assign) NSString *titleOfRoutes;
@property (nonatomic, strong) NSMutableArray *routes;

@property (nonatomic, strong) NSMutableArray *recentUsers;

@property (nonatomic, copy) NSString *lineID;

+ (GTCacheUnit *)sharedCache;

- (void)saveValueToUserDefaults:(NSString *)value forKey:(NSString *)key;
- (NSString *)valueInUserDefaultsForKey:(NSString *)key;

- (void)saveObjectToUserDefaults:(id)object forKey:(NSString *)key;
- (id)objectInUserDefaultsForKey:(NSString *)key;

- (void)saveValueToKeyChain:(NSString *)value forKey:(NSString *)key;
- (NSString *)valueInKeyChainForKey:(NSString *)key;

- (void)updateLaunchImages:(NSArray *)images version:(NSString *)version;
- (void)updateBanners:(NSArray *)banners version:(NSString *)version;
- (void)updateTips:(NSArray *)tips version:(NSString *)version;
- (void)updateCityListWithTitle:(NSString *)title cities:(NSArray *)cities atIndex:(NSInteger)index;
- (void)updateRouteListWithTitle:(NSString *)title routes:(NSArray *)routes atIndex:(NSInteger)index;

- (void)saveImageData:(NSData *)data forUserItem:(GTravelUserItem *)item;
- (void)saveImageData:(NSData *)data forImageItem:(GTravelImageItem *)item;
- (void)saveImageData:(NSData *)data forToolItem:(GTravelToolItem *)item;
- (void)saveThumbnail:(NSData *)data forTipsItem:(GTravelToolItem *)item;
- (void)saveImageData:(NSData *)data forCityItem:(GTravelCityItem *)item;
- (void)saveImageData:(NSData *)data forTownItem:(GTravelTownItem *)item;
- (void)saveImageData:(NSData *)data forRouteItem:(GTravelRouteItem *)item;
- (void)saveImageData:(NSData *)data forRouteUserItem:(GTUserBase *)item;

- (void)updateCityIDs:(NSArray *)cityIDs;
- (GTCityBase *)getCityIDofCityName:(NSString *)name;

- (void)updateRecentUsers:(NSArray *)users;
- (void)saveImageData:(NSData *)data forRecentUser:(GTUserBase *)item;

@end
