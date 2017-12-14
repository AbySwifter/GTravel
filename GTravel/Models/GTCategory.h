//
//  GTCategory.h
//  GTravel
//
//  Created by Raynay Yue on 5/27/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTCategory : NSObject
@property (nonatomic, strong) NSNumber *categoryID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *thumbnail;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *localImage;

+ (GTCategory *)categoryFromDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionary;

@end
