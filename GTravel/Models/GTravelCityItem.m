//
//  GTravelCityItem.m
//  GTravel
//
//  Created by Raynay Yue on 5/15/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTravelCityItem.h"
#import "GTravelNetDefinitions.h"
#import "RYCommon.h"

@implementation GTCityBase
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.cityID = dict[kCityID];
        self.nameCN = [dict nonNilStringValueForKey:kCityNameCN];
        self.welcomeMessage = [dict nonNilStringValueForKey:kCityWelcomeMessage];
    }
    return self;
}

+ (GTCityBase *)cityFromDictionary:(NSDictionary *)dict
{
    GTCityBase *city = [[GTCityBase alloc] initWithDictionary:dict];
    return city;
}

- (NSDictionary *)dictionary
{
    NSDictionary *dict = @{kCityID : self.cityID,
                           kCityNameCN : self.nameCN,
                           kCityWelcomeMessage : self.welcomeMessage};
    return dict;
}

@end

@implementation GTravelCityItem

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super initWithDictionary:dict]) {
        self.name = [dict nonNilStringValueForKey:kCityName];
        self.detailURL = [dict nonNilStringValueForKey:kDetailURL];
        self.thumbnailURL = [dict nonNilStringValueForKey:kThumbnail];
        self.localThumbnail = [dict nonNilStringValueForKey:kLocalImagePath];
    }
    return self;
}

+ (GTravelCityItem *)cityItemFromDictionary:(NSDictionary *)dict
{
    GTravelCityItem *item = [[GTravelCityItem alloc] initWithDictionary:dict];
    return item;
}

- (NSDictionary *)dictionaryFormat
{
    NSDictionary *dict = @{kCityID : self.cityID,
                           kCityName : self.name,
                           kDetailURL : self.detailURL,
                           kThumbnail : self.thumbnailURL,
                           kLocalImagePath : self.localThumbnail};
    return dict;
}

@end
