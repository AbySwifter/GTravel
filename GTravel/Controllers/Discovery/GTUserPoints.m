//
//  GTUserPoints.m
//  GTravel
//
//  Created by QisMSoM on 15/8/5.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTUserPoints.h"

@implementation GTUserPoints

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {

        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)userPointsWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}


@end
