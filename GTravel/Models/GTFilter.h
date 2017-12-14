//
//  GTFilter.h
//  GTravel
//
//  Created by Raynay Yue on 6/3/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTFilter : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *filterID;

+ (GTFilter *)filterFromDictionary:(NSDictionary *)dict;

@end
