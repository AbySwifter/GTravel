//
//  GTravelUserItem.m
//  GTravel
//
//  Created by Raynay Yue on 5/8/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTravelUserItem.h"
#import "GTravelNetDefinitions.h"
#import "RYCommon.h"
#import "GTravelRouteItem.h"

@implementation GTUserBase
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.userID = [dict[kUserID] description];
        self.headImageURL = [dict nonNilStringValueForKey:kHeadImageURL];
        self.nickName = [dict nonNilStringValueForKey:kNickName];
        self.localImageURL = [dict nonNilStringValueForKey:kLocalImagePath];
        self.sex = GTravelUserSexUnkown;
        if ([dict[kSex] integerValue] == SEX_MALE)
            self.sex = GTravelUserSexMale;
        else if ([dict[kSex] integerValue] == SEX_FEMALE)
            self.sex = GTravelUserSexFemale;
    }
    return self;
}

+ (GTUserBase *)userFromDictionary:(NSDictionary *)dict
{
    GTUserBase *item = [[GTUserBase alloc] initWithDictionary:dict];
    return item;
}

- (NSDictionary *)dictionary
{
    NSDictionary *dict = @{ kUserID : RYIsValidString(self.userID) ? self.userID : @"",
                            kHeadImageURL : RYIsValidString(self.headImageURL) ? self.headImageURL : @"",
                            kNickName : RYIsValidString(self.nickName) ? self.nickName : @"",
                            kLocalImagePath : RYIsValidString(self.localImageURL) ? self.localImageURL : @"",
                            kSex : @(self.sex)
    };
    return dict;
}

@end

@implementation GTravelUserItem
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super initWithDictionary:dict]) {
        self.city = [dict nonNilStringValueForKey:kCity];
        self.province = [dict nonNilStringValueForKey:kProvince];
        self.unionID = [dict nonNilStringValueForKey:kUnionID];
        self.weChatID = [dict nonNilStringValueForKey:kWeChatID];
        self.routeBase = [GTRouteBase routeBaseFromDictionary:dict[kLine]];
    }
    return self;
}

+ (GTravelUserItem *)userItemFromDictionary:(NSDictionary *)dict
{
    GTravelUserItem *item = [[GTravelUserItem alloc] initWithDictionary:dict];
    return item;
}

- (NSDictionary *)dictionaryFormat
{
    NSDictionary *dict = @{ kUserID : RYIsValidString(self.userID) ? self.userID : @"",
                            kCity : RYIsValidString(self.city) ? self.city : @"",
                            kHeadImageURL : RYIsValidString(self.headImageURL) ? self.headImageURL : @"",
                            kNickName : RYIsValidString(self.nickName) ? self.nickName : @"",
                            kProvince : RYIsValidString(self.province) ? self.province : @"",
                            kSex : @(self.sex),
                            kUnionID : RYIsValidString(self.unionID) ? self.unionID : @"",
                            kWeChatID : RYIsValidString(self.weChatID) ? self.weChatID : @"",
                            kLocalImagePath : RYIsValidString(self.localImageURL) ? self.localImageURL : @"",
                            kLine : self.routeBase == nil ? @{} : [self.routeBase dictionary]
    };
    return dict;
}

@end

@implementation GTDistanceUser
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super initWithDictionary:dict]) {
        self.distance = [dict[kDistance] doubleValue];
    }
    return self;
}

+ (GTDistanceUser *)distanceUserFromDictionary:(NSDictionary *)dict
{
    GTDistanceUser *user = [[GTDistanceUser alloc] initWithDictionary:dict];
    return user;
}

@end