//
//  AroundMapViewController.h
//  GTravel
//
//  Created by Raynay Yue on 6/4/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "DTRootViewController.h"

@class GTCategory;
@class GTFilter;
@interface AroundMapViewController : DTRootViewController
@property (nonatomic, strong) GTCategory *category;
@property (nonatomic, strong) GTFilter *filter;
@end
