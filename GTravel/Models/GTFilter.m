//
//  GTFilter.m
//  GTravel
//
//  Created by Raynay Yue on 6/3/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTFilter.h"
#import "GTravelNetDefinitions.h"
#import "RYCommon.h"

@implementation GTFilter
+ (GTFilter *)filterFromDictionary:(NSDictionary *)dict
{
    GTFilter *filter = [[GTFilter alloc] init];
    filter.title = [dict nonNilStringValueForKey:kTitle];
    filter.filterID = [dict[kFilterID] description];
    return filter;
}
@end
