//
//  GTToolsItem.m
//  GTravel
//
//  Created by QisMSoM on 15/7/15.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTToolsItem.h"

@interface GTToolsItem ()
@end

@implementation GTToolsItem

+ (instancetype)toolsItemWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}
- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+ (instancetype)itemMore
{
    return [[self alloc] initMore];
}

- (instancetype)initMore
{
    if (self = [super init]) {
        self.isindex = @"7";
        self.title = @"更多";
    }
    return self;
}

@end
