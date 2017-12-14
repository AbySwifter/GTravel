//
//  GTravelImageItem.m
//  GTravel
//
//  Created by Raynay Yue on 5/8/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTravelImageItem.h"
#import "GTravelNetDefinitions.h"
#import "RYCommon.h"

@implementation GTravelImageItem
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.imageURL = [dict nonNilStringValueForKey:kImageURL];
        self.detailURL = [dict nonNilStringValueForKey:kDetailURL];
        self.localImagePath = [dict nonNilStringValueForKey:kLocalImagePath];
    }
    return self;
}

+ (GTravelImageItem *)imageItemFromDictionary:(NSDictionary *)dict
{
    GTravelImageItem *item = [[GTravelImageItem alloc] initWithDictionary:dict];
    return item;
}

- (NSDictionary *)dictionaryFormat
{
    NSDictionary *dict = @{kImageURL : self.imageURL,
                           kDetailURL : self.detailURL,
                           kLocalImagePath : self.localImagePath};
    return dict;
}
@end

@implementation GTLaunchImage
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

+ (GTLaunchImage *)launchImageFromDictionary:(NSDictionary *)dict
{
    return [[GTLaunchImage alloc] initWithDictionary:dict];
}
@end

@implementation GTBannerImage
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

+ (GTBannerImage *)bannerImageFromDictionary:(NSDictionary *)dict
{
    return [[GTBannerImage alloc] initWithDictionary:dict];
}
@end