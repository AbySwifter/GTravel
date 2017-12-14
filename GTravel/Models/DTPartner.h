//
//  DTPartner.h
//  GTravel
//
//  Created by Ray Yueh on 7/5/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTPartner : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *linkUrl;

+ (DTPartner *)partnerWithDictionary:(NSDictionary *)dictionary;

@end
