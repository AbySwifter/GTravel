//
//  DTLogoViewController.m
//  GTravel
//
//  Created by QisMSoM on 15/7/14.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "DTLogoViewController.h"

@interface DTLogoViewController ()

@end

@implementation DTLogoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.strURL = self.url;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.setBar) {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"titlebarbg01_ios"]];
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:3 / 255.0 green:34 / 255.0 blue:95 / 255.0 alpha:1.0]];
        NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
        textAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:3 / 255.0 green:34 / 255.0 blue:95 / 255.0 alpha:1.0];
        [self.navigationController.navigationBar setTitleTextAttributes:textAttrs];
    }
    [super viewWillDisappear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.setBar) {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:204 / 255.0 green:3 / 255.0 blue:3 / 255.0 alpha:1.0];
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
        textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
        [self.navigationController.navigationBar setTitleTextAttributes:textAttrs];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
