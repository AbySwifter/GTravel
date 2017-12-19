//
//  GTNavigationController.m
//  GTravel
//
//  Created by Raynay Yue on 6/4/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTNavigationController.h"
#import "RYCommon.h"
#import "AroundViewController.h"
#import "AroundMapViewController.h"
// Swift类
#import "GTravel-Swift.h"

NSString *const kGTNotificationNavigationControllerWillPopViewController = @"kGTNotificationNavigationControllerWillPopViewController";
//NSString *const kGTNotificationNavigationControllerWillPushViewController = @"kGTNotificationNavigationControllerWillPushViewController";

NSString *const kGTNotificationViewController = @"kGTNotificationViewController";


@interface GTNavigationController ()

@end

@implementation GTNavigationController
#pragma mark - Public Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UIViewController *controller = [super popViewControllerAnimated:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:kGTNotificationNavigationControllerWillPopViewController object:self userInfo:@{kGTNotificationViewController : controller}];
    return controller;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //    [[NSNotificationCenter defaultCenter] postNotificationName:kGTNotificationNavigationControllerWillPushViewController object:self userInfo:@{kGTNotificationViewController : viewController}];
    [super pushViewController:viewController animated:animated];
}

@end
