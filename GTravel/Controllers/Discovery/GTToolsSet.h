//
//  GTToolsSet.h
//  GTravel
//
//  Created by QisMSoM on 15/7/15.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTToolsSet : NSObject

@property (nonatomic, copy) NSString *tools_id;
@property (nonatomic, copy) NSString *tools_title;
@property (nonatomic, copy) NSString *tools_image;
@property (nonatomic, copy) NSString *tools_thumbnail;
@property (nonatomic, strong) NSMutableArray *toolsItemsArray;

+ (instancetype)toolsSetWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
