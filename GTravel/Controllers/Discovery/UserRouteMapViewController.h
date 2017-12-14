//
//  UserRouteMapViewController.h
//  GTravel
//
//  Created by QisMSoM on 15/8/3.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "DTRootViewController.h"
@class GTCategory;
@class GTFilter;
@interface UserRouteMapViewController : DTRootViewController

@property (nonatomic, copy) NSString *line_user_id;


@property (nonatomic, strong) GTCategory *category;
@property (nonatomic, strong) GTFilter *filter;

@end
