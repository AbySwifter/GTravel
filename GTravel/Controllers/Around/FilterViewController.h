//
//  FilterViewController.h
//  GTravel
//
//  Created by Raynay Yue on 6/4/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "DTRootViewController.h"

@class GTFilter;

@protocol FilterViewControllerDelegate;
@interface FilterViewController : DTRootViewController
@property (nonatomic, strong) GTFilter *filter;
@property (nonatomic, weak) id<FilterViewControllerDelegate> delegate;
@end

@protocol FilterViewControllerDelegate <NSObject>

- (void)filterViewController:(FilterViewController *)controller didSelectFilter:(GTFilter *)filter;

@end