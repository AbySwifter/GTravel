//
//  GTravelUserItem.h
//  GTravel
//
//  Created by Raynay Yue on 5/8/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, GTravelUserSex) {
    GTravelUserSexUnkown = 0,
    GTravelUserSexMale = 1,
    GTravelUserSexFemale = 2
};

@interface GTUserBase : NSObject
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *headImageURL;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *localImageURL;
@property (nonatomic, assign) GTravelUserSex sex;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (GTUserBase *)userFromDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionary;

@end

@class GTRouteBase;
@interface GTravelUserItem : GTUserBase
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *unionID;
@property (nonatomic, copy) NSString *weChatID;
@property (nonatomic, strong) GTRouteBase *routeBase;

+ (GTravelUserItem *)userItemFromDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryFormat;

@end

@interface GTDistanceUser : GTUserBase
@property (nonatomic, assign) double distance;

+ (GTDistanceUser *)distanceUserFromDictionary:(NSDictionary *)dict;

@end