//
//  DTRootViewController.m
//  GTravel
//
//  Created by Raynay Yue on 5/5/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "DTRootViewController.h"
#import "RYCommon.h"
#import "DTWebViewController.h"
#import "AppDelegate.h"
#import "CityDetailViewController.h"
#import "RouteDetailViewController.h"
#import "TipDetailViewController.h"
#import "TownsDetailViewController.h"
#import "GTTablePartnerFoot.h"

@interface DTRootViewController ()

@end

@implementation DTRootViewController
#pragma mark - Property Methods
- (GTModel *)model
{
    return [GTModel sharedModel];
}

- (GTNetworkUnit *)networkUnit
{
    return [GTNetworkUnit sharedNetworkUnit];
}

- (GTCacheUnit *)cacheUnit
{
    return [GTCacheUnit sharedCache];
}

#pragma mark - Public Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showLoginView:(BOOL)show animated:(BOOL)animated
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    if (show) {
        [delegate showLoginViewAnimated:animated];
    }
    else {
        [delegate hiddenLoginViewAnimated:animated];
    }
}

- (CGFloat)heightForRouteImageSizeRatio:(CGFloat)ratio footerHeight:(CGFloat)footer margin:(CGFloat)margin
{
    return RYWinRect().size.width / ratio + footer + margin;
}

- (void)startUserHeadImageUpdateObsever
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userHeadImageDidUpdateNotification:) name:kGTravelUserHeadImageDidUpdate object:nil];
}

- (void)userHeadImageDidUpdateNotification:(NSNotification *)notification
{
    RYCONDITIONLOG(DEBUG, @"");
}

- (void)stopUserHeadImageUpdateObsever
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kGTravelUserHeadImageDidUpdate object:nil];
}

- (void)openWebDetailViewOfURL:(NSString *)strURL
{
    DTWebViewController *webViewController = [[DTWebViewController alloc] init];
    webViewController.strURL = strURL;
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)openCityDetailOfCityItem:(GTravelCityItem *)cityItem
{
    CityDetailViewController *detailViewController = [[CityDetailViewController alloc] init];
    detailViewController.cityItem = cityItem;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)openTownDetailOfTownItem:(GTravelTownItem *)townItem
{
    TownsDetailViewController *detailViewController = [[TownsDetailViewController alloc] init];
    detailViewController.townItem = townItem;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)openRouteDetailOfRouteItem:(GTravelRouteItem *)routeItem
{
    RouteDetailViewController *detailViewController = [[RouteDetailViewController alloc] init];
    detailViewController.routeItem = (GTRouteBase *)routeItem;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)openTipDetailOfTipItem:(GTravelToolItem *)tipItem
{
    TipDetailViewController *controller = [[TipDetailViewController alloc] init];
    controller.tipItem = tipItem;
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 *  初始化刷新视图
 */
- (void)initializedRefreshViewForView:(UIView *)view
{
    SRRefreshView *refreshView = [[SRRefreshView alloc] initWithFrame:CGRectMake(0, -44, RYWinRect().size.width, 44)];
    refreshView.delegate = self;
    refreshView.slimeMissWhenGoingBack = YES;
    [view addSubview:refreshView];
    self.refreshView = refreshView;
}

@end
