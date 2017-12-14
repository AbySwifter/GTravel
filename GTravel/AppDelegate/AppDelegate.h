//
//  AppDelegate.h
//  GTravel
//
//  Created by Raynay Yue on 4/29/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@class GTravelImageItem;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;

- (void)showLoginViewAnimated:(BOOL)animated;
- (void)hiddenLoginViewAnimated:(BOOL)animated;
- (void)openDetailViewOfImageItem:(GTravelImageItem *)item;

@end
