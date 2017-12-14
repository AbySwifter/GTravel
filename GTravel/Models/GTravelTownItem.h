//
//  GTravelTownItem.h
//  GTravel
//
//  Created by QisMSoM on 15/7/14.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTTownBase : NSObject
@property (nonatomic, strong) NSNumber *townID;
@property (nonatomic, copy) NSString *nameCN;
@property (nonatomic, copy) NSString *welcomeMessage;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (GTTownBase *)townFromDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionary;

@end

@interface GTravelTownItem : GTTownBase

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *detailURL;
@property (nonatomic, copy) NSString *thumbnailURL;
@property (nonatomic, copy) NSString *localThumbnail;

+ (GTravelTownItem *)townItemFromDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryFormat;

@end
