//
//  GTToolsSet.m
//  GTravel
//
//  Created by QisMSoM on 15/7/15.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTToolsSet.h"
#import "GTravelNetDefinitions.h"
#import "GTToolsItem.h"

@interface GTToolsSet ()

@end

@implementation GTToolsSet

- (NSMutableArray *)toolsItemsArray
{
    if (!_toolsItemsArray) {
        _toolsItemsArray = [NSMutableArray array];
    }
    return _toolsItemsArray;
}

+ (instancetype)toolsSetWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}
- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.tools_id = [dict objectForKey:kTools_id];
        self.tools_title = [dict objectForKey:kTools_title];
        self.tools_image = [dict objectForKey:kTools_image];
        self.tools_thumbnail = [dict objectForKey:kTools_thumbnail];
        NSMutableArray *array = [dict objectForKey:kTools_item];
        for (NSDictionary *dictionary in array) {
            GTToolsItem *toolsItem = [GTToolsItem toolsItemWithDict:dictionary];
            [self.toolsItemsArray addObject:toolsItem];
        }
    }
    return self;
}


@end
