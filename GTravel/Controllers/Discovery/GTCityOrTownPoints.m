//
//  GTCityOrTownPoints.m
//  GTravel
//
//  Created by QisMSoM on 15/8/6.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTCityOrTownPoints.h"

@implementation GTCityOrTownPoints

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {

        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)cityOrTownPointsWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

@end
