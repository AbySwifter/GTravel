//
//  GTNetworkUnit.h
//  GTravel
//
//  Created by Raynay Yue on 5/22/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTravelUserItem.h"

@class GTCategory;
@interface GTNetworkUnit : NSObject

+ (GTNetworkUnit *)sharedNetworkUnit;

- (void)requestLaunchImagesWithCompletion:(void (^)(NSError *error, NSString *version, NSArray *images))handler;

- (void)requestBannersWithCompletion:(void (^)(NSError *error, NSString *version, NSArray *images))handler;

- (void)registerUserWithUnionID:(NSString *)unionID
                       nickName:(NSString *)nickName
                   headImageURL:(NSString *)imageURL
                       province:(NSString *)province
                           city:(NSString *)city
                            sex:(GTravelUserSex)sex
                     completion:(void (^)(NSError *error, NSString *userID))handler;
// 普通注册
- (void)registerUserWithNickName:(NSString *)userNickName
                        passWord:(NSString *)passWord
                             sex:(NSUInteger)sex
                      completion:(void (^)(NSError *error, id responseObject))handler;

// 普通登录
- (void)loginWithUserNickName:(NSString *)userNickName
                     passWord:(NSString *)passWord
                   completion:(void (^)(NSError *error, GTravelUserItem *userItem))handler;

// 微信登录
- (void)loginWithUserID:(NSString *)userID
            deviceToken:(NSString *)token
             completion:(void (^)(NSError *error, GTravelUserItem *userItem))handler;

- (void)logoutUser:(NSString *)userID completionWithHandler:(void (^)(NSError *error))handler;

- (void)requestToolListWithCompletion:(void (^)(NSError *error, NSString *version, NSArray *tools))handler;

- (void)requestCityListWithIndex:(NSInteger)index
                           count:(NSInteger)count
                      completion:(void (^)(NSError *error, NSString *title, NSArray *cities))handler;

- (void)requestTownListWithIndex:(NSInteger)index
                           count:(NSInteger)count
                      completion:(void (^)(NSError *error, NSString *title, NSArray *towns))handler;

- (void)requestLineListWithIndex:(NSInteger)index
                           count:(NSInteger)count
                      completion:(void (^)(NSError *error, NSString *title, NSArray *routes))handler;

- (void)requestCategoryListWithCompletion:(void (^)(NSError *error, NSArray *categories, NSArray *filters))handler;

- (void)requestFourSetsListWithCompletion:(void (^)(NSError *error, NSArray *fourSets))handler;

- (void)addCategoryByUser:(NSString *)userID
                    title:(NSString *)title
               completion:(void (^)(NSError *error, GTCategory *category))handler;

- (void)requestAroundUsersByUser:(NSString *)userID
                        filterID:(NSString *)filterID
                             sex:(NSInteger)sex
                        latitude:(double)latitude
                       longitude:(double)longitude
                      completion:(void (^)(NSError *error, NSArray *users))handler;

- (void)requestUserPointsByParam:(NSDictionary *)param completion:(void (^)(NSError *error, NSArray *points))handler;

- (void)requestAroundPointsByUser:(NSString *)userID
                         filterID:(NSString *)filterID
                       categoryID:(NSString *)catID
                             type:(NSString *)type
                         latitude:(double)latitude
                        longitude:(double)longitude
                          atIndex:(NSInteger)index
                            count:(NSInteger)count
                       completion:(void (^)(NSError *error, NSArray *points))handler;

- (void)sendCommentByUser:(NSString *)userID
                  toPoint:(NSString *)pointID
                  comment:(NSString *)comment
               completion:(void (^)(NSError *error))handler;

- (void)sendLocationToUser:(NSString *)userID
                    cityID:(NSString *)cityID
                  latitude:(double)latitude
                 longitude:(double)longitude
                completion:(void (^)(NSError *error))handler;

- (void)uploadImageData:(NSData *)data
            description:(NSString *)description
                 byUser:(NSString *)userID
                 toLine:(NSString *)lineID
               latitude:(double)latitude
              longitude:(double)longitude
                   city:(NSInteger)cityID
               category:(NSInteger)catID
             completion:(void (^)(NSError *error, BOOL success))hander
    uploadProgressBlock:(void (^)(float progress))block;

- (void)requestRecentUsersOfCity:(NSString *)cityID completion:(void (^)(NSError *error, NSArray *users))handler;

#pragma mark--- 废弃
- (void)requestPointsOfCity:(NSString *)cityID
                     byUser:(NSString *)userID
                       type:(NSInteger)type
                 categoryID:(long long)catID
                    atIndex:(NSInteger)index
                      count:(NSInteger)count
                 completion:(void (^)(NSError *error, NSArray *points))handler;

#pragma mark--- copy
- (void)requestPointsWithTownOrCity:(NSString *)cityOrTownID
                             byUser:(NSString *)userID
                         categoryID:(long long)catID
                           latitude:(double)latitude
                          longitude:(double)longitude
                         completion:(void (^)(NSError *error, NSArray *points))handler;

- (void)requestCityIDsWithCompletion:(void (^)(NSError *error, NSArray *cityIDs))handler;

- (void)addLineTitle:(NSString *)title
         description:(NSString *)desc
              toUser:(NSString *)userID
          completion:(void (^)(NSError *error, GTRouteBase *line))handler;

- (void)changeFavoriteOfPointID:(NSString *)pointID
                          isUGC:(BOOL)isUGC
                           user:(NSString *)userID
                     completion:(void (^)(NSError *error))handler;

- (void)requestPartnersWithCompletionHandler:(void (^)(NSError *error, NSArray *partners))handler;
@end
