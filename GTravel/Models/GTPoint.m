//
//  GTPoint.m
//  GTravel
//
//  Created by Raynay Yue on 6/3/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTPoint.h"
#import "GTravelNetDefinitions.h"
#import "RYCommon.h"
#import "GTravelUserItem.h"

@implementation GTPoint

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.isUGC = [dict[kIsUGC] integerValue] != 0;
        self.pointID = [dict[kPointID] description];
        self.catID = [dict[kCategoryID] description];
        self.desc = [dict nonNilStringValueForKey:kDescription];
        self.imageURL = [dict nonNilStringValueForKey:kImageURL];
        self.isFavorite = [dict[kFavorite] integerValue] != 0;
        self.longitude = [dict[kLongitude] doubleValue];
        self.latitude = [dict[kLatitude] doubleValue];
        self.detailURL = [dict nonNilStringValueForKey:kDetailURL];
        self.localImageURL = [dict nonNilStringValueForKey:kLocalImagePath];
        if ([[dict allKeys] containsObject:kDistance])
            self.distance = [dict[kDistance] doubleValue];
    }
    return self;
}

@end

@implementation GTRecommendPoint
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super initWithDictionary:dict]) {
        self.address = [dict nonNilStringValueForKey:kAddress];
        self.wpPostID = [dict[kWPPostID] description];

        //
        //        NSMutableString *string = [NSMutableString stringWithString:self.desc];
        NSString *str1 = [self.desc stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
        NSString *str2 = [str1 stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
        self.desc = str2;
    }
    return self;
}

+ (GTRecommendPoint *)recommendPointFromDictionary:(NSDictionary *)dict
{
    GTRecommendPoint *point = [[GTRecommendPoint alloc] initWithDictionary:dict];
    return point;
}

@end

@implementation GTUGCPoint
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super initWithDictionary:dict]) {
        self.ctime = [dict nonNilStringValueForKey:kCreateTime];
        self.user = [GTUserBase userFromDictionary:dict[kUser]];
    }
    return self;
}

+ (GTUGCPoint *)ugcPointFromDictionary:(NSDictionary *)dict;
{
    GTUGCPoint *point = [[GTUGCPoint alloc] initWithDictionary:dict];
    return point;
}

@end