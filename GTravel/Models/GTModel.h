//
//  GTModel.h
//  GTravel
//
//  Created by Raynay Yue on 5/4/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

extern NSString *const kGTravelUserHeadImageDidUpdate;

@class GTUserBase;
@class GTravelUserItem;
@class GTLaunchImage;
@class GTBannerImage;
@class GTravelToolItem;
@class GTravelCityItem;
@class GTravelRouteItem;
@class GTCategory;
@class GTFilter;
@class GTPoint;
@class GTravelTownItem;

typedef void (^GTImageDownloadCompletion)(NSError *error, NSData *data);

typedef NS_ENUM(NSInteger, GTFilterSex) {
    GTFilterSexAll,
    GTFilterSexMaleOnly,
    GTFilterSexFemaleOnly
};

typedef NS_ENUM(NSInteger, GTFilterPointType) {
    GTFilterPointTypeAll,
    GTFilterPointTypeFavoriteOnly,
    GTFilterPointTypeUGCOnly
};

@protocol GTModelDelegate;
@interface GTModel : NSObject
@property (nonatomic, weak) id<GTModelDelegate> delegate;
@property (nonatomic, readonly) BOOL bNeedWeChatAuthentication;
//@property(nonatomic,readonly)BOOL               beNeedRegister;
@property (nonatomic, strong) GTravelUserItem *userItem;
@property (nonatomic, copy) NSString *welcomeMessage;
@property (nonatomic, assign) BOOL bShouldDisplayInGermanyView;
@property (nonatomic, readonly) NSArray *categories;
@property (nonatomic, strong) NSArray *filters;

@property (nonatomic, strong) CLLocation *userLocation;
@property (nonatomic, strong) CLPlacemark *currentPlaceMark;


@property (nonatomic, strong) NSArray *fourSets;

+ (GTModel *)sharedModel;

- (void)startWeChatAuthentication;
// 正常登录
- (void)startNormalAutoLogin;
- (void)startNormalLoginWithReviewWithParams:(NSDictionary *)params;
- (void)startToLogin;
- (void)loginout;
- (NSString *)getCurrentUserAddress;

- (void)downloadUserItem:(GTravelUserItem *)userItem completion:(GTImageDownloadCompletion)handler;

- (void)requestLaunchImagesWithCompletion:(void (^)(NSArray *images))handler;
- (void)requestBannersWithCompletion:(void (^)(NSArray *images))handler;

- (void)requestToolsWithCompletion:(void (^)(NSArray *items))handler;
- (void)downloadToolItem:(GTravelToolItem *)item completion:(GTImageDownloadCompletion)handler;
- (void)downloadToolItemThumbnail:(GTravelToolItem *)item completion:(GTImageDownloadCompletion)handler;

- (void)requestCityListAtIndex:(NSInteger)index count:(NSInteger)count completion:(void (^)(NSError *error, NSString *title, NSArray *cities))handler;
- (void)downloadCityItem:(GTravelCityItem *)item completion:(GTImageDownloadCompletion)handler;

- (void)requestTownListAtIndex:(NSInteger)index count:(NSInteger)count completion:(void (^)(NSError *error, NSString *title, NSArray *towns))handler;
- (void)downloadTownItem:(GTravelTownItem *)item completion:(GTImageDownloadCompletion)handler;

- (void)requestRouteListAtIndex:(NSInteger)index count:(NSInteger)count completion:(void (^)(NSError *error, NSString *title, NSArray *routes))handler;
- (void)downloadRouteItem:(GTravelRouteItem *)item completion:(GTImageDownloadCompletion)handler;
- (void)downloadRouteUserItem:(GTUserBase *)userItem completion:(GTImageDownloadCompletion)handler;

- (void)requestCityIDs;
- (void)requestRecentUsersWithCompletion:(void (^)(NSError *error, NSArray *users))handler;
- (void)downloadRecentUser:(GTUserBase *)item completion:(GTImageDownloadCompletion)handler;

- (void)requestCategoryWithCompletion:(void (^)(NSError *error, NSArray *items))handler;
- (void)downloadCategory:(GTCategory *)item completion:(GTImageDownloadCompletion)handler;

- (void)requestFourSetsWithCompletion:(void (^)(NSError *error, NSArray *fourSets))handler;
//-(void)downloadFourSets:(GTCategory*)item completion:(GTImageDownloadCompletion)handler;

- (void)uploadImageData:(NSData *)data description:(NSString *)description category:(GTCategory *)category completion:(void (^)(NSError *error, BOOL success))handler uploadProgressBlock:(void (^)(float fProgress))block;

- (void)createLine:(NSString *)title description:(NSString *)desc completion:(void (^)(NSError *error))handler;
- (void)createTagWithTitle:(NSString *)title completion:(void (^)(NSError *error, GTCategory *category))handler;

- (void)requestAroundUsersWithFiler:(GTFilter *)filter sex:(GTFilterSex)sex completion:(void (^)(NSError *error, NSArray *users))handler;


- (void)requestAroundPointsWithFilter:(GTFilter *)filter category:(GTCategory *)category pointType:(GTFilterPointType)type atIndex:(NSInteger)index count:(NSInteger)count completion:(void (^)(NSError *error, NSArray *points))handler;

#pragma mark--- 废弃
- (void)requestPointsOfCity:(NSString *)cityID category:(GTCategory *)category filter:(GTFilter *)filter pointType:(GTFilterPointType)type atIndex:(NSInteger)index count:(NSInteger)count completion:(void (^)(NSError *error, NSArray *points))handler;

#pragma mark--- copy
- (void)requestPointsWithTownOrCity:(NSString *)cityOrTownID category:(GTCategory *)category latitude:(double)latitude longitude:(double)longitude completion:(void (^)(NSError *error, NSArray *points))handler;

- (void)changeFavorteStateOfPoint:(GTPoint *)point completion:(void (^)(NSError *error))handler;

- (void)requestPartnerListWithCompletion:(void (^)(NSError *error, NSArray *partners))handler;

- (NSString *)distanceDisplayStringOfValue:(double)distance;

- (void)requestUserPointsWithDictionary:(NSDictionary *)param completion:(void (^)(NSError *error, NSArray *points))handler;


@end

@protocol GTModelDelegate <NSObject>

- (void)weChatAuthenticationDidSucceedWithModel:(GTModel *)model;
- (void)model:(GTModel *)model didLoginWithUserItem:(GTravelUserItem *)userItem;
- (void)model:(GTModel *)model operationDidFailedWithError:(NSError *)error;

@end