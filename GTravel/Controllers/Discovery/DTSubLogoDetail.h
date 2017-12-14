//
//  DTSubLogoDetail.h
//  GTravel
//
//  Created by QisMSoM on 15/7/14.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//  用来描述合作商的模型

#import <Foundation/Foundation.h>

@interface DTSubLogoDetail : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *link_url;

+ (instancetype)subLogoDetailWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
