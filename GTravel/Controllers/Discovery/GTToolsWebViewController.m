//
//  GTToolsWebViewController.m
//  GTravel
//
//  Created by QisMSoM on 15/7/16.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTToolsWebViewController.h"
#import "RYCommon.h"
#import "GTravelNetDefinitions.h"

@interface GTToolsWebViewController ()

@end

@implementation GTToolsWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.strURL = self.detail;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldStartLoadWithReqeust:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%@", request.URL.absoluteString);

    if (RYIsValidString(request.URL.absoluteString) && [request.URL.absoluteString isEqualToString:@"download://?url=/upload/2015/06/002-600x300.jpg"]) {


        NSString *str = @"download://?url=/upload/2015/06/002-600x300.jpg";
        NSString *imageURL = GetAPIUrl(str);

        NSLog(@"%@", imageURL);
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
        UIImage *image = [UIImage imageWithData:data];

        UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);

        return YES;
    }

    if (RYIsValidString(request.URL.absoluteString) && [request.URL.absoluteString isEqualToString:@"http://germany.dragontrail.com/partner/lufthansagroup"]) {
        [self setBarChange];
    }

    if (![request.URL.absoluteString isEqualToString:@"http://germany.dragontrail.com/partner/lufthansagroup"] && ![request.URL.absoluteString isEqualToString:@"http://germany.dragontrail.com/tools/itinerary_list/14"]) {
        [self setBarNormal];
    }

    return YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self setBarNormal];
    [super viewWillDisappear:animated];
}


- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"呵呵";
    if (!error) {
        message = @"成功保存到相册";
    }
    else {
        message = [error description];
    }
    NSLog(@"message is %@", message);
}

- (void)setBarChange
{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"titlebarbg01_ios"]];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:3 / 255.0 green:34 / 255.0 blue:95 / 255.0 alpha:1.0]];
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:3 / 255.0 green:34 / 255.0 blue:95 / 255.0 alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:textAttrs];
}

- (void)setBarNormal
{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:204 / 255.0 green:3 / 255.0 blue:3 / 255.0 alpha:1.0];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:textAttrs];
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
