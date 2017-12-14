//
//  GTUserRouteViewController.m
//  GTravel
//
//  Created by QisMSoM on 15/8/6.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTUserRouteViewController.h"
#import "UserRouteMapViewController.h"
#import "RYCommon.h"

@interface GTUserRouteViewController ()

@end

@implementation GTUserRouteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldStartLoadWithReqeust:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (RYIsValidString(request.URL.absoluteString) && [request.URL.absoluteString rangeOfString:@"locationmap://?res="].length > 0) {
        NSString *absoluteString = request.URL.absoluteString;
        NSUInteger index = [request.URL.absoluteString rangeOfString:@"="].location + 1;
        NSString *line_user_id = [absoluteString substringFromIndex:index];

        [self gotoMapWithLineUserId:line_user_id];
        return NO;
    }

    return [super shouldStartLoadWithReqeust:request navigationType:navigationType];
}


- (void)gotoMapWithLineUserId:(NSString *)lineUserId
{
    UserRouteMapViewController *vc = [[UserRouteMapViewController alloc] init];
    vc.line_user_id = lineUserId;
    [self.navigationController pushViewController:vc animated:YES];
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
