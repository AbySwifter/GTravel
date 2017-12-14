//
//  NSDictionary+Additions.m
//
//  Created by Raynay Yue on 01/22/2015.
//  Copyright (c) 2015 Raynay Studio. All rights reserved.
//

#import "NSDictionary+Additions.h"
#import "RYCommonFunctions.h"

@implementation NSDictionary (Additions)
- (NSString *)nonNilStringValueForKey:(NSString *)key
{
    return RYIsValidString(self[key]) ? self[key] : @"";
}
@end
