//
//  NewRouteViewController.h
//  GTravel
//
//  Created by Raynay Yue on 5/29/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTRootViewController.h"

@protocol NewRouteViewControllerDelegate;
@interface NewRouteViewController : DTRootViewController
@property (nonatomic, weak) id<NewRouteViewControllerDelegate> delegate;
@end

@protocol NewRouteViewControllerDelegate <NSObject>

- (void)newRouteViewControllerDidCreateNewRoute:(NewRouteViewController *)controller;

@end