//
//  GTPoint.h
//  GTravel
//
//  Created by Raynay Yue on 6/3/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTPoint : NSObject
@property (nonatomic, assign) BOOL isUGC;
@property (nonatomic, copy) NSString *pointID;
@property (nonatomic, copy) NSString *catID;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, assign) BOOL isFavorite;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) double latitude;
@property (nonatomic, copy) NSString *detailURL;
@property (nonatomic, copy) NSString *localImageURL;
@property (nonatomic, assign) double distance;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

@interface GTRecommendPoint : GTPoint
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *wpPostID;

+ (GTRecommendPoint *)recommendPointFromDictionary:(NSDictionary *)dict;

@end

@class GTUserBase;
@interface GTUGCPoint : GTPoint
@property (nonatomic, copy) NSString *ctime;
@property (nonatomic, strong) GTUserBase *user;

+ (GTUGCPoint *)ugcPointFromDictionary:(NSDictionary *)dict;

@end