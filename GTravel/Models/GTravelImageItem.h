//
//  GTravelImageItem.h
//  GTravel
//
//  Created by Raynay Yue on 5/8/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTravelImageItem : NSObject
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, copy) NSString *detailURL;
@property (nonatomic, copy) NSString *localImagePath;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (GTravelImageItem *)imageItemFromDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryFormat;

@end

@interface GTLaunchImage : GTravelImageItem

+ (GTLaunchImage *)launchImageFromDictionary:(NSDictionary *)dict;

@end

@interface GTBannerImage : GTravelImageItem

+ (GTBannerImage *)bannerImageFromDictionary:(NSDictionary *)dict;

@end