//
//  GTravelRouteItem.h
//  GTravel
//
//  Created by Raynay Yue on 5/15/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTRouteBase : NSObject
@property (nonatomic, strong) NSNumber *lineID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *detail;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (GTRouteBase *)routeBaseFromDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionary;

@end

typedef NS_ENUM(NSInteger, GTravelRouteType) {
    GTravelRouteTypeRecommend = 0,
    GTRavelRouteTypeUGC = 1
};

@class GTUserBase;
@interface GTravelRouteItem : GTRouteBase
@property (nonatomic, assign) GTravelRouteType type;
@property (nonatomic, strong) NSNumber *days;
@property (nonatomic, copy) NSString *thumnail;
@property (nonatomic, copy) NSString *localThumbnail;
@property (nonatomic, strong) NSNumber *photos;
@property (nonatomic, strong) GTUserBase *userItem;

+ (GTravelRouteItem *)itemFromDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionary;

@end
