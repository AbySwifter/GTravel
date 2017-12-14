//
//  GTravelCityItem.h
//  GTravel
//
//  Created by Raynay Yue on 5/15/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTCityBase : NSObject
@property (nonatomic, strong) NSNumber *cityID;
@property (nonatomic, copy) NSString *nameCN;
@property (nonatomic, copy) NSString *welcomeMessage;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (GTCityBase *)cityFromDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionary;

@end

@interface GTravelCityItem : GTCityBase
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *detailURL;
@property (nonatomic, copy) NSString *thumbnailURL;
@property (nonatomic, copy) NSString *localThumbnail;

+ (GTravelCityItem *)cityItemFromDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryFormat;

@end
