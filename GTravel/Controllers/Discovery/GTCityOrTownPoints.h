//
//  GTCityOrTownPoints.h
//  GTravel
//
//  Created by QisMSoM on 15/8/6.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTCityOrTownPoints : NSObject
/**
 *  标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  经度
 */
@property (nonatomic, copy) NSString *latitude;
/**
 *  纬度
 */
@property (nonatomic, copy) NSString *longitude;
/**
 *  距离，单位为m
 */
@property (nonatomic, copy) NSString *distance;
/**
 *  详情URL
 */
@property (nonatomic, copy) NSString *detail;
/**
 *  是否为用户生成的点,0:否 1:是
 */
@property (nonatomic, assign) BOOL is_ugc;
/**
 *  该用户是否收藏,0:否 1:是
 */
@property (nonatomic, assign) BOOL favorite;
/**
 *  头像路径
 */
@property (nonatomic, copy) NSString *head_image;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)cityOrTownPointsWithDict:(NSDictionary *)dict;

@end
