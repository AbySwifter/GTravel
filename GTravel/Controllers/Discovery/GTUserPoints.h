//
//  GTUserPoints.h
//  GTravel
//
//  Created by QisMSoM on 15/8/5.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTUserPoints : NSObject

/**
 *  点名称
 */
@property (nonatomic, copy) NSString *title;
/**
 *  纬度
 */
@property (nonatomic, copy) NSString *latitude;
/**
 *  经度
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
 *  用户是否收藏
 */
@property (nonatomic, assign) BOOL favorite;
/**
 *  头像路径
 */
@property (nonatomic, copy) NSString *head_image;
/**
 *  ?
 */
@property (nonatomic, copy) NSString *postid;


- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)userPointsWithDict:(NSDictionary *)dict;

@end
