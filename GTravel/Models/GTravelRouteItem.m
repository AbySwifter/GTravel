//
//  GTravelRouteItem.m
//  GTravel
//
//  Created by Raynay Yue on 5/15/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTravelRouteItem.h"
#import "GTravelNetDefinitions.h"
#import "RYCommon.h"
#import "GTravelUserItem.h"

@implementation GTRouteBase
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        if ([[dict class] isSubclassOfClass:[NSDictionary class]]) {
            //            NSLog(@"%@",dict);
            self.lineID = dict[kLineID];
            self.title = [dict nonNilStringValueForKey:kTitle];
            self.detail = [dict nonNilStringValueForKey:kDetailURL];
            self.desc = [dict nonNilStringValueForKey:kDescription];
        }
    }
    return self;
}

+ (GTRouteBase *)routeBaseFromDictionary:(NSDictionary *)dictionary
{
    GTRouteBase *route = [[GTRouteBase alloc] initWithDictionary:dictionary];
    return route;
}

- (NSDictionary *)dictionary
{
    NSDictionary *dict = @{kLineID : self.lineID,
                           kTitle : self.title,
                           kDetailURL : self.detail,
                           kDescription : self.desc};
    return dict;
}

@end

@implementation GTravelRouteItem
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super initWithDictionary:dict]) {
        self.type = [dict[kLineType] integerValue];
        self.days = dict[kLineDays];
        self.thumnail = [dict nonNilStringValueForKey:kThumbnail];
        self.photos = dict[kPhotos];
        self.localThumbnail = [dict nonNilStringValueForKey:kLocalImagePath];
        if ([[dict allKeys] containsObject:kUser])
            self.userItem = [GTUserBase userFromDictionary:dict[kUser]];
    }
    return self;
}

+ (GTravelRouteItem *)itemFromDictionary:(NSDictionary *)dictionary
{
    GTravelRouteItem *item = [[GTravelRouteItem alloc] initWithDictionary:dictionary];
    return item;
}

- (NSDictionary *)dictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(self.type) forKey:kLineType];
    [dict setValue:self.lineID forKey:kLineID];
    [dict setValue:RYIsValidString(self.title) ? self.title : @"" forKey:kTitle];
    [dict setValue:RYIsValidString(self.desc) ? self.desc : @"" forKey:kDescription];
    [dict setObject:self.days forKey:kLineDays];
    [dict setValue:RYIsValidString(self.thumnail) ? self.thumnail : @"" forKey:kThumbnail];
    [dict setValue:RYIsValidString(self.detail) ? self.detail : @"" forKey:kDetailURL];
    [dict setValue:RYIsValidString(self.localThumbnail) ? self.localThumbnail : @"" forKey:kLocalImagePath];
    if (self.photos) {
        [dict setObject:self.photos forKey:kPhotos];
    }
    if (self.userItem) {
        [dict setObject:[self.userItem dictionary] forKey:kUser];
    }
    return dict;
}

@end
