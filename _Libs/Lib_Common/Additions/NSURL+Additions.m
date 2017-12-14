//
//  NSURL+Additions.m
//
//  Created by Raynay Yue on 01/22/2015.
//  Copyright (c) 2015 Raynay Studio. All rights reserved.
//

#import "NSURL+Additions.h"

@implementation NSURL (Additions)
- (NSDictionary *)queryDictionary
{
    NSMutableDictionary *dictParsed = [NSMutableDictionary dictionary];
    NSArray *arrayFragments = [self.query componentsSeparatedByString:@"&"];
    for (NSString *fragment in arrayFragments) {
        NSArray *arr = [fragment componentsSeparatedByString:@"="];
        if (arr.count == 2) {
            NSString *key = [arr[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *value = [arr[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [dictParsed setValue:value forKey:key];
        }
    }
    return dictParsed;
}
@end