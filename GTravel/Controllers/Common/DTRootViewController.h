//
//  DTRootViewController.h
//  GTravel
//
//  Created by Raynay Yue on 5/5/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTModel.h"
#import "GTNetworkUnit.h"
#import "GTCacheUnit.h"
#import "SRRefreshView.h"

@interface DTRootViewController : UIViewController <SRRefreshDelegate, UIScrollViewDelegate>
@property (nonatomic, readonly) GTModel *model;
@property (nonatomic, readonly) GTNetworkUnit *networkUnit;
@property (nonatomic, readonly) GTCacheUnit *cacheUnit;
@property (nonatomic, strong) SRRefreshView *refreshView;

- (void)showLoginView:(BOOL)show animated:(BOOL)animated;
- (CGFloat)heightForRouteImageSizeRatio:(CGFloat)ratio footerHeight:(CGFloat)footer margin:(CGFloat)margin;

- (void)startUserHeadImageUpdateObsever;
- (void)userHeadImageDidUpdateNotification:(NSNotification *)notification;
- (void)stopUserHeadImageUpdateObsever;

- (void)openWebDetailViewOfURL:(NSString *)strURL;
- (void)openCityDetailOfCityItem:(GTravelCityItem *)cityItem;
- (void)openTownDetailOfTownItem:(GTravelTownItem *)townItem;
- (void)openRouteDetailOfRouteItem:(GTravelRouteItem *)routeItem;
- (void)openTipDetailOfTipItem:(GTravelToolItem *)tipItem;

- (void)initializedRefreshViewForView:(UIView *)view;

@end
