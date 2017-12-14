//
//  GTravelTownItem.m
//  GTravel
//
//  Created by QisMSoM on 15/7/14.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTravelTownItem.h"
#import "GTravelNetDefinitions.h"
#import "RYCommon.h"

@implementation GTTownBase
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.townID = dict[kTownID];
        //        self.nameCN = [dict nonNilStringValueForKey:kCityNameCN];
        //        self.welcomeMessage = [dict nonNilStringValueForKey:kCityWelcomeMessage];
    }
    return self;
}

+ (GTTownBase *)townFromDictionary:(NSDictionary *)dict
{
    GTTownBase *town = [[GTTownBase alloc] initWithDictionary:dict];
    return town;
}

- (NSDictionary *)dictionary
{
    NSDictionary *dict = @{
        kTownID : self.townID
        //                           kCityNameCN : self.nameCN,
        //                           kCityWelcomeMessage : self.welcomeMessage
    };
    return dict;
}

@end

@implementation GTravelTownItem

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super initWithDictionary:dict]) {
        self.name = [dict nonNilStringValueForKey:kTownName];
        self.detailURL = [dict nonNilStringValueForKey:kDetailURL];
        self.thumbnailURL = [dict nonNilStringValueForKey:kThumbnail];
        self.localThumbnail = [dict nonNilStringValueForKey:kLocalImagePath];
    }
    return self;
}

+ (GTravelTownItem *)townItemFromDictionary:(NSDictionary *)dict
{
    GTravelTownItem *item = [[GTravelTownItem alloc] initWithDictionary:dict];
    return item;
}

- (NSDictionary *)dictionaryFormat
{
    NSDictionary *dict = @{kTownID : self.townID,
                           kTownName : self.name,
                           kDetailURL : self.detailURL,
                           kThumbnail : self.thumbnailURL,
                           kLocalImagePath : self.localThumbnail};
    return dict;
}
@end
