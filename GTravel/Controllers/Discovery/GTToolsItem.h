//
//  GTToolsItem.h
//  GTravel
//
//  Created by QisMSoM on 15/7/15.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTToolsItem : NSObject

@property (nonatomic, copy) NSString *isindex;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *thumbnail;
@property (nonatomic, copy) NSString *title;

+ (instancetype)toolsItemWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)itemMore;

@end
